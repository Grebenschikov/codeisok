<?php
namespace CodeIsOk;

class ViewContainer
{
    protected $twig;
    protected $tpl_vars = [];

    public function __construct()
    {
        $this->twig = $this->initTwig();

        $this->assign('SCRIPT_NAME', $_SERVER['SCRIPT_NAME'] ?? $GLOBALS['HTTP_SERVER_VARS']['SCRIPT_NAME'] ?? '');
    }

    public function clear_all_assign()
    {
        $this->tpl_vars = [];
    }

    public function is_cached($tpl_file, $cache_id = null, $compile_id = null)
    {
        return false;
    }

    function clear_cache($tpl_file = null, $cache_id = null, $compile_id = null, $exp_time = null)
    {
        //
    }

    public function assign($tpl_var, $value = null)
    {
        if (is_array($tpl_var)) {
            foreach ($tpl_var as $k => $v) {
                $this->tpl_vars[$k] = $v;
            }
        } else {
            $this->tpl_vars[$tpl_var] = $value;
        }
    }

    public function fetch($resource_name, $cache_id = null, $compile_id = null, $display = false)
    {
        $value = $this->twig->render($resource_name, $this->tpl_vars);
        if ($display) {
            echo $value;
        }
        return $value;
    }

    public function display($resource_name, $cache_id = null, $compile_id = null)
    {
        return $this->fetch($resource_name, $cache_id, $compile_id, true);
    }

    private function initTwig() {
        $Loader = new \Twig\Loader\FilesystemLoader(GITPHP_TEMPLATESDIR);
        $Twig = new \Twig\Environment($Loader, [
            'cache' => false,
            'debug' => \CodeIsOk\Config::GetInstance()->GetValue('debug', false),
            'strict_variables' => true,
            'autoescape' => false,
        ]);

        $Twig->addTokenParser(new \CodeIsOk\Twig\TranslateTagTokenParser());
        $Twig->addFunction(new \Twig\TwigFunction('is_a', 'is_a'));
        $Twig->addFilter(new \Twig\TwigFilter('agestring', [$this, 'filterAgeString']));
        $Twig->addFilter(new \Twig\TwigFilter('buglink', [$this, 'filterBuglink']));
        $Twig->addFilter(new \Twig\TwigFilter('highlight', [$this, 'filterHightlight']));
        $Twig->addGlobal('scripturl', $this->getScriptUrl());

        return $Twig;
    }

    public function filterAgeString($age) {
        if ($age > 60*60*24*365*2) {

            $years = (int)($age/60/60/24/365);
            return sprintf(__n('%1$d year ago', '%1$d years ago', $years), $years);

        } else if ($age > 60*60*24*(365/12)*2) {

            $months = (int)($age/60/60/24/(365/12));
            return sprintf(__n('%1$d month ago', '%1$d months ago', $months), $months);

        } else if ($age > 60*60*24*7*2) {

            $weeks = (int)($age/60/60/24/7);
            return sprintf(__n('%1$d week ago', '%1$d weeks ago', $weeks), $weeks);

        } else if ($age > 60*60*24*2) {

            $days = (int)($age/60/60/24);
            return sprintf(__n('%1$d day ago', '%1$d days ago', $days), $days);

        } else if ($age > 60*60*2) {

            $hours = (int)($age/60/60);
            return sprintf(__n('%1$d hour ago', '%1$d hours ago', $hours), $hours);

        } else if ($age > 60*2) {

            $min = (int)($age/60);
            return sprintf(__n('%1$d min ago', '%1$d min ago', $min), $min);

        } else if ($age > 2) {

            $sec = (int)$age;
            return sprintf(__n('%1$d sec ago', '%1$d sec ago', $sec), $sec);

        }

        return __('right now');
    }

    public function filterBuglink($text, $pattern = null, $link = null)
    {
        if (empty($text) || empty($pattern) || empty($link))
            return $text;

        $fullLink = '<a href="' . $link . '">${0}</a>';

        return preg_replace($pattern, $fullLink, $text);
    }

    public function filterHightlight($haystack, $needle, $trimlen = NULL, $escape = false, $highlightclass = 'searchmatch') {
        if (false !== $offset = stripos($haystack, $needle)) {
            $regs = [$haystack, substr($haystack, 0, $offset), substr($haystack, $offset, strlen($needle)), substr($haystack, $offset + strlen($needle))];
            if (isset($trimlen) && ($trimlen > 0)) {
                $linelen = strlen($regs[0]);
                if ($linelen > $trimlen) {
                    $matchlen = strlen($regs[2]);
                    $remain = floor(($trimlen - $matchlen) / 2);
                    $leftlen = strlen($regs[1]);
                    $rightlen = strlen($regs[3]);
                    if ($leftlen > $remain) {
                        $leftremain = $remain;
                        if ($rightlen < $remain)
                            $leftremain += ($remain - $rightlen);
                        $regs[1] = "…" . substr($regs[1], ($leftlen - ($leftremain - 3)));
                    }
                    if ($rightlen > $remain) {
                        $rightremain = $remain;
                        if ($leftlen < $remain)
                            $rightremain += ($remain - $leftlen);
                        $regs[3] = substr($regs[3],0,$rightremain-3) . "…";
                    }
                }
            }
            if ($escape) {
                $regs[1] = htmlspecialchars($regs[1]);
                $regs[2] = htmlspecialchars($regs[2]);
                $regs[3] = htmlspecialchars($regs[3]);
            }
            $ret = $regs[1] . "<span";
            if ($highlightclass)
                $ret .= " class=\"" . $highlightclass . "\"";
            $ret .= ">" . $regs[2] . "</span>" . $regs[3];
            return $ret;
        }

        return $haystack;
    }

    private function getScriptUrl() {
        if (\CodeIsOk\Config::GetInstance()->HasKey('self')) {
            $selfurl = \CodeIsOk\Config::GetInstance()->GetValue('self');
            if (!empty($selfurl)) {
                if (substr($selfurl, -4) != '.php') {
                    $selfurl = \CodeIsOk\Util::AddSlash($selfurl);
                }
                return $selfurl;
            }
        }

        if (isset($_SERVER['HTTPS']) && ($_SERVER['HTTPS'] == 'on'))
            $scriptstr = 'https://';
        else
            $scriptstr = 'http://';

        $scriptstr .= $_SERVER['HTTP_HOST'] . $_SERVER['PHP_SELF'];

        return $scriptstr;
    }
}