<?php
/**
 * GitPHP ProjectListArrayLegacy
 *
 * Lists all projects in a multidimensional array
 * Legacy array format
 *
 * @author Christopher Han <xiphux@gmail.com>
 * @copyright Copyright (c) 2010 Christopher Han
 * @package GitPHP
 * @subpackage Git
 */

/**
 * ProjectListArrayLegacy class
 *
 * @package GitPHP
 * @subpackage Git
 */
class GitPHP_ProjectListArrayLegacy extends GitPHP_ProjectListBase
{
    const GITPHP_NO_CATEGORY = 'none';

    /**
     * __construct
     *
     * constructor
     *
     * @param mixed $projectArray array to read
     * @throws Exception if parameter is not an array
     * @access public
     */
    public function __construct($projectArray)
    {
        if (!is_array($projectArray)) {
            throw new Exception('An array of projects is required.');
        }

        $this->projectConfig = $projectArray;

        parent::__construct();
    }

    /**
     * PopulateProjects
     *
     * Populates the internal list of projects
     *
     * @access protected
     * @throws Exception if file cannot be read
     */
    protected function PopulateProjects()
    {
        foreach ($this->projectConfig as $cat => $plist) {
            if (is_array($plist)) {
                foreach ($plist as $pname => $ppath) {
                    try {
                        $projObj = new GitPHP_Project($ppath);
                        if ($cat != self::GITPHP_NO_CATEGORY) $projObj->SetCategory($cat);
                        $this->projects[$ppath] = $projObj;
                    } catch (Exception $e) {}
                }
            }
        }
    }
}
