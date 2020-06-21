<?php
namespace CodeIsOk\Twig;

class TranslateTagNode extends \Twig\Node\Node
{
    protected $params = [];

    public function __construct(array $params, \Twig\Node\Node $body, $line, $tag = null)
    {
        $this->params = array_keys($params);
        parent::__construct(['body' => $body], $params, $line, $tag);
    }

    public function compile(\Twig\Compiler $compiler)
    {
        $compiler
            ->addDebugInfo($this);

        $compiler
            ->write('ob_start();')
            ->raw(PHP_EOL)
            ->subcompile($this->getNode('body'))
            ->write('$_translate_tag_cache[] = trim(ob_get_clean());');

        $compiler->write('echo \CodeIsOk\Twig\TranslateTagNode::t([');
        foreach ($this->params as $attr) {
            $compiler->string(strpos($attr, 'param') === 0 ? substr($attr, 5) : $attr);
            $compiler->write(' => ');
            $compiler->subcompile($this->getAttribute($attr));
            $compiler->write(',');
        }
        $compiler->write('], array_pop($_translate_tag_cache), null);');
    }

    public static function strarg($str)
    {
        $tr = array();
        $p = 0;

        for ($i=1; $i < func_num_args(); $i++) {
            $arg = func_get_arg($i);

            if (is_array($arg)) {
                foreach ($arg as $aarg) {
                    $tr['%'.++$p] = $aarg;
                }
            } else {
                $tr['%'.++$p] = $arg;
            }
        }

        return strtr($str, $tr);
    }

    public static function t($params, $text)
    {
        $text = stripslashes($text);

        // set escape mode
        if (isset($params['escape'])) {
            $escape = $params['escape'];
            unset($params['escape']);
        }

        // set plural version
        if (isset($params['plural'])) {
            $plural = $params['plural'];
            unset($params['plural']);

            // set count
            if (isset($params['count'])) {
                $count = $params['count'];
                unset($params['count']);
            }
        }

        // use plural if required parameters are set
        if (isset($count) && isset($plural)) {
            $text = __n($text, $plural, $count);
        } else { // use normal
            $text = __($text);
        }

        // run strarg if there are parameters
        if (count($params)) {
            $text = self::strarg($text, $params);
        }

        if (!isset($escape) || $escape == 'html') { // html escape, default
            $text = nl2br(htmlspecialchars($text));
        } elseif (isset($escape)) {
            switch ($escape) {
                case 'javascript':
                case 'js':
                    // javascript escape
                    $text = str_replace('\'', '\\\'', stripslashes($text));
                    break;
                case 'url':
                    // url escape
                    $text = urlencode($text);
                    break;
            }
        }

        return $text;
    }
}