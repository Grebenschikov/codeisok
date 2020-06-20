<?php
namespace CodeIsOk\Twig;

class TranslateTagTokenParser extends \Twig\TokenParser\AbstractTokenParser
{
    const END_TAG = 'endt';

    public function parse(\Twig\Token $token)
    {
        $parser = $this->parser;
        $stream = $parser->getStream();

        $params = [];
        while (!$stream->test(\Twig\Token::BLOCK_END_TYPE))
        {
            $name = $stream->expect(\Twig\Token::NAME_TYPE)->getValue();
            $stream->expect(\Twig\Token::OPERATOR_TYPE, '=');
            $value = $parser->getExpressionParser()->parseExpression();
            $params[$name] = $value;
        }
        $stream->expect(\Twig\Token::BLOCK_END_TYPE);

        $body = $parser->subparse(
            function(\Twig\Token $token) {
                return $token->test([self::END_TAG]);
            }
        );

        $tag = $stream->next()->getValue();
        if ($tag != self::END_TAG) {
            throw new \Twig\Error\SyntaxError('Unexpected end of template. Expecting: ' . self::END_TAG);
        }

        $stream->expect(\Twig\Token::BLOCK_END_TYPE);

        return new TranslateTagNode($params, $body, $token->getLine(), $this->getTag());
    }

    public function getTag()
    {
        return 't';
    }
}