<?php
namespace CodeIsOk;


class Session
{
    const SESSION_REVIEW_ID = 'review_id';
    const SESSION_BASE_BRANCH = 'base_branch';
    const SESSION_AUTH_DATA = 'crowd_auth_data';
    const SESSION_CREATED = 'created';

    const FILE_DESTROY = '/tmp/gitphp_sesssion_destroy';

    /** @var \CodeIsOk\User */
    protected $User;

    /** @var \CodeIsOk\Session */
    protected static $instance;

    /**
     * @return \CodeIsOk\Session
     */
    public static function instance()
    {
        if (!isset(self::$instance)) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    protected function __construct()
    {
        $this->start();
        $this->initUser();
        $created = $this->get(self::SESSION_CREATED);
        if (!$created) {
            $created = time();
            $this->set(self::SESSION_CREATED, $created);
        }
        if (file_exists(self::FILE_DESTROY)) {
            if ($created < filemtime(self::FILE_DESTROY)) {
                $this->logout();
            }
        }
        register_shutdown_function([$this, 'shutdown']);
    }

    public function shutdown()
    {
        $this->set(self::SESSION_AUTH_DATA, $this->User->toAuthData());
    }

    public function set($var, $value)
    {
        $_SESSION[$var] = $value;
    }

    public function get($var, $default = null)
    {
        return (isset($_SESSION[$var])) ? $_SESSION[$var] : $default;
    }

    public function delete($var)
    {
        unset($_SESSION[$var]);
    }

    public function isAuthorized()
    {
        return !empty($this->User->getId());
    }

    /**
     * @return \CodeIsOk\User
     */
    public function getUser()
    {
        return $this->User;
    }

    public function setUser(\CodeIsOk\User $User)
    {
        $this->User = $User;
        $this->set(self::SESSION_AUTH_DATA, $User->toAuthData());
    }

    public function logout()
    {
        $this->User = new \CodeIsOk\User();
        $this->delete(self::SESSION_AUTH_DATA);
        $this->delete(self::SESSION_CREATED);
    }

    protected function start()
    {
        $is_started = function_exists('session_status') ? session_status() === PHP_SESSION_ACTIVE : session_id() !== '';
        if (!$is_started) session_start();
    }

    protected function initUser()
    {
        $this->User = \CodeIsOk\User::fromAuthData($this->get(self::SESSION_AUTH_DATA));
        if ($this->User->getId()) {
            $Acl = new \CodeIsOk\Acl(\CodeIsOk\Jira::instance(), \CodeIsOk\Redmine::instance());
            $this->User->setIsGitosisAdmin($Acl->isGitosisAdmin($this->User));
        }

        if (!$this->isAuthorized()) {
            $auth_token = $_GET['auth_token'] ?? false;
            if (!$auth_token) {
                return;
            }

            $user_data = \CodeIsOk\Config::GetInstance()->GetUserDataByApiToken($auth_token);
            if (empty($user_data)) {
                return;
            }

            $this->User = \CodeIsOk\User::fromAuthData($user_data);
        }
    }
}
