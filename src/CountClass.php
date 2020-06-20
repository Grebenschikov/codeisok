<?php
namespace CodeIsOk;

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