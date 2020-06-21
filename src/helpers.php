<?php
const GITPHP_BASEDIR = __DIR__ . '/../';
const GITPHP_CONFIGDIR = GITPHP_BASEDIR . '.config/';
const GITPHP_INCLUDEDIR = GITPHP_BASEDIR . '.include/';
const GITPHP_LOCALEDIR = GITPHP_BASEDIR . 'resources/locale/';
const GITPHP_TEMPLATESDIR = GITPHP_BASEDIR . 'resources/templates/';
const GITPHP_CSSDIR = GITPHP_BASEDIR . 'public/css/';
const GITPHP_JSDIR = GITPHP_BASEDIR . 'public/js/';
const GITPHP_LIBDIR = GITPHP_BASEDIR . 'public/lib/';

/**
 * Cache key for the cache contents / age map array
 */
const MEMCACHE_OBJECT_MAP = 'memcache_objectmap';

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