<?php
namespace CodeIsOk\Controller;

/**
 * Feed controller class
 *
 * @package GitPHP
 * @subpackage Controller
 */
class Feed extends Base
{
    const FEED_ITEMS = 150;

    /**
     * Constants for the different feed formats
     */
    const FEED_FORMAT_RSS = 'rss';
    const FEED_FORMAT_ATOM = 'atom';

    public function __construct()
    {
        parent::__construct();
        if (!$this->project) {
            throw new \CodeIsOk\MessageException(__('Project is required'), true);
        }
    }

    /**
     * GetTemplate
     *
     * Gets the template for this controller
     *
     * @access protected
     * @return string template filename
     */
    protected function GetTemplate()
    {
        if ($this->params['format'] == self::FEED_FORMAT_RSS) {
            return 'rss.twig.tpl';
        } else if ($this->params['format'] == self::FEED_FORMAT_ATOM) {
            return 'atom.twig.tpl';
        } else {
            return null;
        }
    }

    /**
     * GetCacheKey
     *
     * Gets the cache key for this controller
     *
     * @access protected
     * @return string cache key
     */
    protected function GetCacheKey()
    {
        return '';
    }

    /**
     * GetName
     *
     * Gets the name of this controller's action
     *
     * @access public
     * @param boolean $local true if caller wants the localized action name
     * @return string action name
     */
    public function GetName($local = false)
    {
        if ($this->params['format'] == self::FEED_FORMAT_RSS) {
            if ($local) {
                return __('rss');
            } else {
                return 'rss';
            }
        } else if ($this->params['format'] == self::FEED_FORMAT_ATOM) {
            if ($local) {
                return __('atom');
            } else {
                return 'atom';
            }
        }
        return null;
    }

    /**
     * ReadQuery
     *
     * Read query into parameters
     *
     * @access protected
     */
    protected function ReadQuery()
    {
        \CodeIsOk\Log::GetInstance()->SetEnabled(false);
    }

    /**
     * LoadHeaders
     *
     * Loads headers for this template
     *
     * @access protected
     */
    protected function LoadHeaders()
    {
        if ((!isset($this->params['format'])) || empty($this->params['format'])) {
            throw new \Exception('A feed format is required');
        }

        if ($this->params['format'] == self::FEED_FORMAT_RSS) {
            $this->headers[] = "Content-type: text/xml; charset=UTF-8";
        } else if ($this->params['format'] == self::FEED_FORMAT_ATOM) {
            $this->headers[] = "Content-type: application/atom+xml; charset=UTF-8";
        }
    }

    /**
     * LoadData
     *
     * Loads data for this template
     *
     * @access protected
     */
    protected function LoadData()
    {
        $log = $this->project->GetLog('HEAD', self::FEED_ITEMS);

        $entries = count($log);

        if ($entries > 20) {
            /*
    		 * Don't show commits older than 48 hours,
    		 * but show a minimum of 20 entries
    		 */
            for ($i = 20; $i < $entries; ++$i) {
                if ((time() - $log[$i]->GetCommitterEpoch()) > 48 * 60 * 60) {
                    $log = array_slice($log, 0, $i);
                    break;
                }
            }
        }

        $this->tpl->assign('log', $log);
    }
}
