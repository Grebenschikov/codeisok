<?php

namespace CodeIsOk;

class Application
{
    const GITPHP_LOCALE_COOKIE = 'GitPHPLocale';
    const GITPHP_LOCALE_COOKIE_LIFETIME = 31536000; //60 * 60 * 24 * 365 = 1 year
    const GITPHP_FIX_LINEHEIGHT_COOKIE = 'GitPHP_fix_lineheight';
    const GITPHP_FIX_LINEHEIGHT_LIFETIME = 31536000; //60 * 60 * 24 * 365 = 1 year

    public function init()
    {
        set_error_handler(['CodeIsOk\\Error', 'errorHandler']);
        date_default_timezone_set('UTC');
        error_reporting(E_ALL);

        register_shutdown_function(
            function () {
                $err = error_get_last();
                if ($err) error_log(var_export($err, true));
            }
        );

        try {
            $this->initDebug();
            $this->initResource();
            $this->initConfiguration();
            $this->initProject();
        } catch (\Exception $e) {
            $this->showExceptionMessage($e);
        }
    }

    /**
     * Set the locale based on the user's preference
     */
    private function initResource()
    {
        if (!empty($_GET['l'])) {
            setcookie(self::GITPHP_LOCALE_COOKIE, $_GET['l'], time() + self::GITPHP_LOCALE_COOKIE_LIFETIME);
            \CodeIsOk\Resource::Instantiate($_GET['l']);
        } else if (!empty($_COOKIE[self::GITPHP_LOCALE_COOKIE])) {
            \CodeIsOk\Resource::Instantiate($_COOKIE[self::GITPHP_LOCALE_COOKIE]);
        } else {
            if (isset($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {
                if ($preferredLocale = \CodeIsOk\Resource::FindPreferredLocale($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {
                    setcookie(self::GITPHP_LOCALE_COOKIE, $preferredLocale, time() + self::GITPHP_LOCALE_COOKIE_LIFETIME);
                    \CodeIsOk\Resource::Instantiate($preferredLocale);
                }
            }
            if (!\CodeIsOk\Resource::Instantiated()) {
                setcookie(self::GITPHP_LOCALE_COOKIE, 0, time() + self::GITPHP_LOCALE_COOKIE_LIFETIME);
            }
        }

        if (!\CodeIsOk\Resource::Instantiated()) {
            \CodeIsOk\Resource::Instantiate(\CodeIsOk\Config::GetInstance()->GetValue('locale', 'en_US'));
        }

        if (isset($_GET['fix_lineheight'])) {
            setcookie(self::GITPHP_FIX_LINEHEIGHT_COOKIE, $_GET['fix_lineheight'], time() + self::GITPHP_FIX_LINEHEIGHT_LIFETIME);
            $_COOKIE[self::GITPHP_FIX_LINEHEIGHT_COOKIE] = $_GET['fix_lineheight'];
        }
    }

    public function initDebug()
    {
        if (\CodeIsOk\Config::DEBUG_ENABLED) {
            if (isset($_GET['debug_mode'])) {
                setcookie('debug_mode', $_GET['debug_mode'], (int)$_GET['debug_mode'] == 0 ? time() - 3600 : null);
                $_COOKIE['debug_mode'] = $_GET['debug_mode'];
            }
            if (isset($_GET['debug_js'])) {
                setcookie('debug_js', $_GET['debug_js'], (int)$_GET['debug_js'] == 0 ? time() - 3600 : null);
                $_COOKIE['debug_js'] = $_GET['debug_js'];
            }
            if (isset($_COOKIE['debug_mode']) && (int)$_COOKIE['debug_mode'] == 1) {
                \CodeIsOk\Config::GetInstance()->SetValue('debug', (bool)(int)$_COOKIE['debug_mode']);
                \CodeIsOk\Log::GetInstance()->SetEnabled((bool)(int)$_COOKIE['debug_mode']);
            }
            if (\CodeIsOk\Config::GetInstance()->GetValue('debug', false)) {
                ini_set('display_errors', 1);
            } else {
                ini_set('display_errors', 0);
            }
        }
    }

    private function initConfiguration()
    {
        $config = GITPHP_CONFIGDIR . 'gitphp.conf.php';
        if (isset($_SERVER['SERVER_NAME'])) {
            $tmpConfig = GITPHP_CONFIGDIR . 'gitphp.conf.' . $_SERVER['SERVER_NAME'] . '.php';
            if (file_exists($tmpConfig)) {
                $config = $tmpConfig;
            }
        }
        \CodeIsOk\Config::GetInstance()->LoadConfig($config);
    }

    private function initProject()
    {
        if (!\CodeIsOk\Config::GetInstance()->GetValue('projectroot', null)) {
            throw new \CodeIsOk\MessageException(__('A projectroot must be set in the config'), true, 500);
        }

        $exe = new \CodeIsOk\Git\GitExe(null);
        if (!$exe->Valid()) {
            throw new \CodeIsOk\MessageException(
                sprintf(
                    __('Could not run the git executable "%1$s".  You may need to set the "%2$s" config value.'),
                    $exe->GetBinary(),
                    'gitbin'
                ),
                true,
                500
            );
        }
        $exe = new \CodeIsOk\Git\DiffExe();
        if (!$exe->Valid()) {
            throw new \CodeIsOk\MessageException(
                sprintf(
                    __('Could not run the diff executable "%1$s".  You may need to set the "%2$s" config value.'),
                    $exe->GetBinary(),
                    'diffbin'
                ),
                true,
                500
            );
        }

        if (file_exists(GITPHP_CONFIGDIR . 'projects.conf.php')) {
            \CodeIsOk\Git\ProjectList::Instantiate(GITPHP_CONFIGDIR . 'projects.conf.php', false);
        }
    }

    public function run()
    {
        \CodeIsOk\Log::GetInstance()->SetStartTime(GITPHP_START_TIME);
        \CodeIsOk\Log::GetInstance()->SetStartMemory(GITPHP_START_MEM);

        try {
            \CodeIsOk\Log::GetInstance()->timerStart();

            $uri = $_SERVER['DOCUMENT_URI'] ?? "";
            $action = $_GET['a'] ?? null;
            $controller = $this->getController($uri, $action);
            \CodeIsOk\Log::GetInstance()->timerStop('getController');
            if ($controller) {
                \CodeIsOk\Log::GetInstance()->timerStart();
                $controller->Render();
                \CodeIsOk\Log::GetInstance()->timerStop('Render');
            }
        } catch (\Exception $e) {
            trigger_error($e);
            $this->showExceptionMessage($e);
        }
    }

    protected function showExceptionMessage(\Exception $e)
    {
        try {
            $controller = new \CodeIsOk\Controller\Message();
            $controller->SetParam('message', $e->getMessage());
            if ($e instanceof \CodeIsOk\MessageException) {
                $controller->SetParam('error', $e->Error);
                $controller->SetParam('statuscode', $e->StatusCode);
            } else {
                $controller->SetParam('error', true);
            }
            $controller->RenderHeaders();
            $controller->Render();
        } catch (\Exception $e) {
            if (\CodeIsOk\Config::GetInstance()->GetValue('debug', false)) throw $e;
        }
    }

    /**
     * @param $uri
     * @param $action
     * @return \CodeIsOk\Controller\ControllerInterface?
     * @throws \Exception
     */
    protected function getController($uri, $action)
    {
        $uri = array_values(array_filter(explode("/", $uri)));
        if (count($uri) == 0 || ($uri[0] ?? "") == "index.php") {
            $controller = $this->getOldController($action);
        } else {
            $controller_ns = "\\CodeIsOk\\Controller\\";
            $controller = $controller_ns . ucfirst(array_shift($uri));
            if (class_exists($controller)) {
                $controller = new $controller($uri);
            } else {
                $controller = new \CodeIsOk\Controller\ProjectList();
            }
        }

        \CodeIsOk\Log::GetInstance()->Log('controller', get_class($controller));
        \CodeIsOk\Log::GetInstance()->Log('REQUEST_URI', $_SERVER['REQUEST_URI']);
        \CodeIsOk\Log::GetInstance()->Log('REQUEST_METHOD', $_SERVER['REQUEST_METHOD']);
        \CodeIsOk\Log::GetInstance()->Log('phpversion', phpversion());
        return $controller;
    }

    public static function getUrl($controller, array $params = [])
    {
        return '/index.php?' . http_build_query(['a' => $controller] + $params);
    }

    /**
     * @param $action
     * @return \CodeIsOk\Controller\ControllerInterface?
     * @throws \Exception
     */
    protected function getOldController($action)
    {
        $controller = null;

        switch ($action) {
            case 'search':
            case 'search_json':
                $controller = new \CodeIsOk\Controller\Search();
                break;

            case 'searchtext':
                $controller = new \CodeIsOk\Controller\SearchText();
                break;

            case 'commitdiff':
            case 'commitdiff_plain':
                $controller = new \CodeIsOk\Controller\Commitdiff();
                if ($action === 'commitdiff_plain') $controller->SetParam('plain', true);
                break;

            case 'branchdiff':
            case 'branchdiff_plain':
                $controller = new \CodeIsOk\Controller\Branchdiff();
                if ($action === 'branchdiff_plain') $controller->SetParam('plain', true);
                break;

            case 'blobdiff':
            case 'blobdiff_plain':
                $controller = new \CodeIsOk\Controller\Blobdiff();
                if ($action === 'blobdiff_plain') $controller->SetParam('plain', true);
                break;

            case 'history':
                $controller = new \CodeIsOk\Controller\History();
                break;

            case 'shortlog':
            case 'log':
            case 'branchlog':
                $controller = new \CodeIsOk\Controller\Log();
                if ($action === 'shortlog') $controller->SetParam('short', true);
                if ($action === 'branchlog') {
                    $controller->SetParam('branchlog', true);
                }
                break;

            case 'snapshot':
                $controller = new \CodeIsOk\Controller\Snapshot();
                break;

            case 'tree':
                $controller = new \CodeIsOk\Controller\Tree();
                break;

            case 'tag':
                $controller = new \CodeIsOk\Controller\Tag();
                break;

            case 'tags':
                $controller = new \CodeIsOk\Controller\Tags();
                break;

            case 'heads':
                $controller = new \CodeIsOk\Controller\Heads();
                break;

            case 'blame':
                $controller = new \CodeIsOk\Controller\Blame();
                break;

            case 'blob':
            case 'blob_plain':
                $controller = new \CodeIsOk\Controller\Blob();
                if ($action === 'blob_plain') $controller->SetParam('plain', true);
                break;

            case 'atom':
            case 'rss':
                $controller = new \CodeIsOk\Controller\Feed();
                if ($action == 'rss') $controller->SetParam('format', Controller\Feed::FEED_FORMAT_RSS);
                else if ($action == 'atom') $controller->SetParam('format', Controller\Feed::FEED_FORMAT_ATOM);
                break;

            case 'commit':
                $controller = new \CodeIsOk\Controller\Commit();
                break;

            case 'summary':
                $controller = new \CodeIsOk\Controller\Project();
                break;

            case 'project_index':
                $controller = new \CodeIsOk\Controller\ProjectList();
                $controller->SetParam('txt', true);
                break;

            case 'project_create':
                $controller = new \CodeIsOk\Controller\ProjectCreate();
                break;

            case 'opml':
                $controller = new \CodeIsOk\Controller\ProjectList();
                $controller->SetParam('opml', true);
                break;

            case 'login':
                $controller = new \CodeIsOk\Controller\Login();
                break;

            case 'logout':
                $controller = new \CodeIsOk\Controller\Logout();
                break;

            case 'save_comment':
            case 'save_comment_sbs':
            case 'delete_comment':
            case 'delete_comment_sbs':
            case 'get_review':
            case 'get_comments':
            case 'get_comments_sbs':
            case 'set_review_status':
            case 'get_unfinished_review':
            case 'delete_all_draft_comments':
                $controller = new \CodeIsOk\Controller\Comment();
                break;

            case 'reviews':
                $controller = new \CodeIsOk\Controller\Review();
                break;

            case 'gitosis':
                $section = empty($_GET['section']) ? \CodeIsOk\Controller\GitosisBase::DEFAULT_SECTION : $_GET['section'];
                if (!in_array($section, \CodeIsOk\Controller\GitosisBase::getSections())) exit(1);

                $ucsection = ucfirst($section);
                $class_name = '\CodeIsOk\Controller\Gitosis' . $ucsection;
                $controller = new $class_name();
                break;

            case 'check_session':
                $controller = new \CodeIsOk\Controller\CheckSession();
                break;

            default:
                if (in_array($action, \CodeIsOk\Controller\Git::SUPPORTED_ACTIONS)) {
                    $controller = new \CodeIsOk\Controller\Git();
                } else if (isset($_GET['p'])) {
                    $controller = new \CodeIsOk\Controller\Project();
                } else {
                    $controller = new \CodeIsOk\Controller\ProjectList();
                }
        }
        return $controller;
    }
}

