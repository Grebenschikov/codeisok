<?php
require_once __DIR__ . '/vendor/autoload.php';

define('GITPHP_BASEDIR', dirname(__FILE__) . '/');
define('GITPHP_CONFIGDIR', GITPHP_BASEDIR . '.config/');
define('GITPHP_INCLUDEDIR', GITPHP_BASEDIR . '.include/');
define('GITPHP_GITOBJECTDIR', GITPHP_INCLUDEDIR . 'git/');
define('GITPHP_CONTROLLERDIR', GITPHP_INCLUDEDIR . 'controller/');
define('GITPHP_CACHEDIR', GITPHP_INCLUDEDIR . 'cache/');
define('GITPHP_LOCALEDIR', GITPHP_BASEDIR . 'resources/locale/');
define('GITPHP_TEMPLATESDIR', GITPHP_BASEDIR . 'resources/templates/');
define('GITPHP_CSSDIR', GITPHP_BASEDIR . 'public/css/');
define('GITPHP_JSDIR', GITPHP_BASEDIR . 'public/js/');
define('GITPHP_LIBDIR', GITPHP_BASEDIR . 'public/lib/');

define('GITPHP_BASE_NS', 'GitPHP');

spl_autoload_register(
    function($class) {
        static $map;
        if (!$map) {
            $map = require_once 'autoload.php';
        }

        // psr4 autoload
        $namespaces = explode('\\', $class);
        if (count($namespaces) > 1 && $namespaces[0] == GITPHP_BASE_NS) {
            $file_name = array_pop($namespaces) . ".php";
            unset($namespaces[0]);

            $file_name = GITPHP_INCLUDEDIR . join(DIRECTORY_SEPARATOR, array_map('strtolower', $namespaces)) . DIRECTORY_SEPARATOR . $file_name;
            if (file_exists($file_name)) {
                require_once $file_name;
            }
        }

        // old autoload
        if (isset($map[$class]) && file_exists($map[$class])) {
            require_once $map[$class];
        }
    }
);

class CountClass
{
    protected $name, $value;

    public function __construct($name, $value = null)
    {
        $this->name = $name;
        $this->value = $value;
        \GitPHP\Log::GetInstance()->timerStart();
    }

    public function __destruct()
    {
        \GitPHP\Log::GetInstance()->timerStop($this->name, $this->value);
    }
}

/* strlen() can be overloaded in mbstring extension, so always using mb_orig_strlen */
if (!function_exists('mb_orig_strlen')) {
    function mb_orig_strlen($str)
    {
        return strlen($str);
    }
}
if (!function_exists('mb_orig_substr')) {
    function mb_orig_substr($str, $offset, $len = null)
    {
        return isset($len) ? substr($str, $offset, $len) : substr($str, $offset);
    }
}
if (!function_exists('mb_orig_strpos')) {
    function mb_orig_strpos($haystack, $needle, $offset = 0)
    {
        return strpos($haystack, $needle, $offset);
    }
}
