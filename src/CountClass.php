<?php
namespace CodeIsOk;

class CountClass
{
    protected $name, $value;

    public function __construct($name, $value = null)
    {
        $this->name = $name;
        $this->value = $value;
        \CodeIsOk\Log::GetInstance()->timerStart();
    }

    public function __destruct()
    {
        \CodeIsOk\Log::GetInstance()->timerStop($this->name, $this->value);
    }
}