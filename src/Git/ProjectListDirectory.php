<?php
namespace CodeIsOk\Git;
/**
 * GitPHP ProjectListDirectory
 *
 * Lists all projects in a given directory
 *
 * @author Christopher Han <xiphux@gmail.com>
 * @copyright Copyright (c) 2010 Christopher Han
 * @package GitPHP
 * @subpackage Git
 */

/**
 * ProjectListDirectory class
 *
 * @package GitPHP
 * @subpackage Git
 */
class ProjectListDirectory extends \CodeIsOk\Git\ProjectListBase
{
    /**
     * projectDir
     *
     * Stores projectlist directory internally
     *
     * @access protected
     */
    protected $projectDir;

    /**
     * __construct
     *
     * constructor
     *
     * @param string $projectDir directory to search
     * @throws \Exception if parameter is not a directory
     * @access public
     */
    public function __construct($projectDir)
    {
        if (!is_dir($projectDir)) {
            throw new \Exception(sprintf(__('%1$s is not a directory'), $projectDir));
        }

        $this->projectDir = \CodeIsOk\Util::AddSlash($projectDir);

        parent::__construct();
    }

    /**
     * PopulateProjects
     *
     * Populates the internal list of projects
     *
     * @access protected
     */
    protected function PopulateProjects()
    {
        $this->RecurseDir($this->projectDir);
    }

    /**
     * RecurseDir
     *
     * Recursively searches for projects
     *
     * @param string $dir directory to recurse into
     */
    private function RecurseDir($dir)
    {
        if (!is_dir($dir)) return;

        if ($dh = @opendir($dir)) {
            $trimlen = strlen($this->projectDir) + 1;
            while (($file = readdir($dh)) !== false) {
                $fullPath = $dir . '/' . $file;
                if ((strpos($file, '.') !== 0) && is_dir($fullPath)) {
                    if (is_file($fullPath . '/HEAD')) {
                        $projectPath = substr($fullPath, $trimlen);
                        try {
                            $proj = new \CodeIsOk\Git\Project($projectPath);
                            $proj->SetCategory(trim(substr($dir, strlen($this->projectDir)), '/'));
                            if ((!\CodeIsOk\Config::GetInstance()->GetValue('exportedonly', false)) || $proj->GetDaemonEnabled()) {
                                $this->projects[$projectPath] = $proj;
                            }
                        } catch (\Exception $e) {}
                    } else {
                        $this->RecurseDir($fullPath);
                    }
                }
            }
            closedir($dh);
        } else {
            \CodeIsOk\Log::GetInstance()->log('Could not open repository directory ' . $dir);
        }
    }
}
