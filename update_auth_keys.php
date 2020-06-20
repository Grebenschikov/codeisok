#!/usr/bin/env php
<?php
require_once __DIR__ . '/vendor/autoload.php';

class UpdateAuthKeys
{
    public function log($text = '')
    {
        $time = date("Y-m-d H:i:s");
        echo "[{$time}] {$text}\n";
    }

    public function run()
    {
        $this->log("Starting ssh keys update process...");

        $Gitosis = new \CodeIsOk\Model\Gitosis();

        $this->log("Getting users list...");
        $users = $Gitosis->getUsers();
        if ($users === false) {
            $this->log("Cannot receive users from DB");
            return;
        }
        $this->generateAuthKeys($users);

        $repositories = $Gitosis->getRepositories();
        if ($repositories === false) {
            $this->log("Cannot receive repositories from DB");
            return;
        }
        $this->createNewRepositories($repositories);
    }

    /**
     * @param array $users
     */
    public function generateAuthKeys($users)
    {
        $this->log("Generating authorized keys file...");

        $auth_keys = '# autogenerated file. Do not edit';
        foreach ($users as $user) {
            foreach (array_filter(explode("\n", $user['public_key'])) as $key) {
                $auth_keys .= PHP_EOL . \CodeIsOk\Gitosis::formatKeyString(dirname(__FILE__), $user['username'], $key);
            }
        }
        $auth_keys_path = \CodeIsOk\Gitosis::getAuthorizedKeysFile();
        $auth_keys_tmp_path = $auth_keys_path . '.tmp';
        if (false === file_put_contents($auth_keys_tmp_path, $auth_keys)) {
            $this->log("Cannot write authorized_keys file");
            return;
        }
        // on the most systems it's not allowed to have authorized_keys files with too wide permissions
        chmod($auth_keys_tmp_path, 0600);
        if (false === rename($auth_keys_tmp_path, $auth_keys_path)) {
            $this->log("Cannot rename tmp auth keys");
        }

        $this->log("\tdone.");
    }

    /**
     * @param array $repositories
     */
    public function createNewRepositories($repositories)
    {
        $this->log("Creating new repositories...");

        $root_directory = CodeIsOk\Config::GetInstance()->GetValue(CodeIsOk\Config::PROJECT_ROOT);
        foreach ($repositories as $repository) {
            $full_path = $root_directory . '/' . $repository['project'];
            if (is_dir($full_path)) {
                continue;
            }

            exec("cd " . $root_directory . "; git init --bare " . escapeshellarg($repository['project']), $out, $retval);
            if ($retval) {
                $this->log("Cannot create project {$repository['project']}:\n\t" . implode("\n\t", $out));
            }
        }

        $this->log("\tdone.");
    }
}

$Application = new CodeIsOk\Application();
$Application->init();

$Script = new UpdateAuthKeys();
$Script->run();
