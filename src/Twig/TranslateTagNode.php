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

        $compiler->write('echo smarty_block_t([');
        foreach ($this->params as $attr) {
            $compiler->string($attr);
            $compiler->write(' => ');
            $compiler->subcompile($this->getAttribute($attr));
            $compiler->write(',');
        }
        $compiler->write('], array_pop($_translate_tag_cache), null);');
    }
}