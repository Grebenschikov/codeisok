#!/usr/bin/env php
<?php
require_once __DIR__ . '/vendor/autoload.php';

class UpdateCache
{
    public function run()
    {
        $Gitosis = new \CodeIsOk\Model\Gitosis();

        $repositories = $Gitosis->getRepositories();
        if ($repositories === false) {
            echo date('r') . ": Cannot receive repositories from DB\n";
            return;
        }

        foreach ($repositories as $repository) {
            try {
                echo date('r') . ": Running for {$repository['project']}\n";
                $Project = new \CodeIsOk\Git\Project($repository['project']);
                $Project->UpdateUnmergedCommitsCache();
                $Project->UpdateHeadsCache();
            } catch (\Exception $e) {
                echo date('r') . ": Error: {$e->getMessage()}";
            }
        }
    }
}

$fp = fopen(__DIR__ . "/update_cache.lock", 'w+');
if (!flock($fp, LOCK_EX | LOCK_NB)) {
    exit(0);
}

$Application = new CodeIsOk\Application();
$Application->init();

$Script = new UpdateCache();
$Script->run();
