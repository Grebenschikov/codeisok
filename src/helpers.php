<?php
define('GITPHP_BASEDIR', __DIR__ . '/../');
define('GITPHP_CONFIGDIR', GITPHP_BASEDIR . '.config/');
define('GITPHP_INCLUDEDIR', GITPHP_BASEDIR . '.include/');
define('GITPHP_GITOBJECTDIR', GITPHP_INCLUDEDIR . 'git/');
define('GITPHP_CONTROLLERDIR', GITPHP_INCLUDEDIR . 'controller/');
define('\CodeIsOk\CacheDIR', GITPHP_INCLUDEDIR . 'cache/');
define('GITPHP_LOCALEDIR', GITPHP_BASEDIR . 'resources/locale/');
define('GITPHP_TEMPLATESDIR', GITPHP_BASEDIR . 'resources/templates/');
define('GITPHP_CSSDIR', GITPHP_BASEDIR . 'public/css/');
define('GITPHP_JSDIR', GITPHP_BASEDIR . 'public/js/');
define('GITPHP_LIBDIR', GITPHP_BASEDIR . 'public/lib/');

define('GITPHP_BASE_NS', 'GitPHP');

require_once(GITPHP_BASEDIR . '/.include/lib/php-gettext/streams.php');
require_once(GITPHP_BASEDIR . '/.include/lib/php-gettext/gettext.php');

/**
 * Gettext wrapper function for readability, single string
 *
 * @param string $str string to translate
 * @return string translated string
 */
function __($str)
{
    if (\CodeIsOk\Resource::Instantiated())
        return \CodeIsOk\Resource::GetInstance()->translate($str);
    return $str;
}

/**
 * Gettext wrapper function for readability, plural form
 *
 * @param string $singular singular form of string
 * @param string $plural plural form of string
 * @param int $count number of items
 * @return string translated string
 */
function __n($singular, $plural, $count)
{
    if (\CodeIsOk\Resource::Instantiated())
        return \CodeIsOk\Resource::GetInstance()->ngettext($singular, $plural, $count);
    if ($count > 1)
        return $plural;
    return $singular;
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

/**
 * Cache key for the cache contents / age map array
 */
define('MEMCACHE_OBJECT_MAP', 'memcache_objectmap');

/**
 * memcache cache handler function
 *
 * @param string $action cache action
 * @param mixed $smarty_obj smarty object
 * @param string $cache_content content to store/load
 * @param string $tpl_file template file
 * @param string $cache_id cache id
 * @param string $compile_id compile id
 * @param int $exp_time expiration time
 */
function memcache_cache_handler($action, &$smarty_obj, &$cache_content, $tpl_file = null, $cache_id = null, $compile_id = null, $exp_time = null)
{
    $memObj = \CodeIsOk\Memcache::GetInstance();

    $namespace = getenv('SERVER_NAME') . '_gitphp_';

    $fullKey = $cache_id . '^' . $compile_id . '^' . $tpl_file;

    switch ($action) {

        case 'read':
            $cache_content = $memObj->Get($namespace . $fullKey);
            return true;
            break;

        case 'write':
            /*
             * Keep a map of keys we have stored, and
             * their expiration times
             */
            $map = $memObj->Get($namespace . MEMCACHE_OBJECT_MAP);
            if (!(isset($map) && is_array($map)))
                $map = array();

            if (!isset($exp_time))
                $exp_time = 0;
            $map[$fullKey] = time();

            $memObj->Set($namespace . $fullKey, $cache_content, $exp_time);
            $memObj->Set($namespace . MEMCACHE_OBJECT_MAP, $map);
            break;

        case 'clear':

            if (empty($cache_id) && empty($compile_id) && empty($tpl_file)) {
                /*
                 * Clear entire cache
                 */
                return $memObj->Clear();
            }


            $cachePrefix = '';
            if (!empty($cache_id))
                $cachePrefix = $cache_id;
            if (!empty($compile_id))
                $cachePrefix .= '^' . $compile_id;

            $map = $memObj->Get($namespace . MEMCACHE_OBJECT_MAP);
            if (isset($map) && is_array($map)) {
                $now = time();
                /*
                 * Search through our stored map of keys
                 */
                foreach ($map as $key => $age) {
                    if (
                        /*
                         * If we have a prefix (group),
                         * match any keys that start with
                         * this group
                         */
                        (empty($cachePrefix) || (substr($key, 0, strlen($cachePrefix)) == $cachePrefix)) &&
                        /*
                         * If we have a template, match
                         * any keys that end with this
                         * template
                         */
                        (empty($tpl_file) || (substr($key, strlen($tpl_file) * -1) == $tpl_file)) &&
                        /*
                         * If we have an expiration time,
                         * match any keys older than that
                         */
                        ((!isset($exp_time)) || (($now - $age) > $exp_time))
                    ) {
                        $memObj->Delete($namespace . $key);
                        unset($map[$key]);
                    }
                }

                /*
                 * Update the key map
                 */
                $memObj->Set($namespace . MEMCACHE_OBJECT_MAP, $map);
            }
            return true;
            break;

        default:
            $smarty_obj->trigger_error('memcache_cache_handler: unknown action "' . $action . '"');
            return false;
            break;
    }
}
