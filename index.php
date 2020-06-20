<?php

define('GITPHP_START_TIME', microtime(true));
define('GITPHP_START_MEM', memory_get_usage());

require_once __DIR__ . '/vendor/autoload.php';

$Application = new \CodeIsOk\Application();

\CodeIsOk\Log::GetInstance()->timerStart();
$Application->init();
\CodeIsOk\Log::GetInstance()->timerStop('CodeIsOk\Application::init()', 1);

\CodeIsOk\Log::GetInstance()->timerStart();
$Application->run();
\CodeIsOk\Log::GetInstance()->timerStop('CodeIsOk\Application::run()', 1);

\CodeIsOk\Log::GetInstance()->Log('debug', \CodeIsOk\Config::GetInstance()->GetValue('debug', false));

/* StatSlow ;) */
\CodeIsOk\Log::GetInstance()->printHtmlHeader();
\CodeIsOk\Log::GetInstance()->printHtml();
\CodeIsOk\Log::GetInstance()->printHtmlFooter();
