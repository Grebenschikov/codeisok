<?php

namespace CodeIsOk\Controller;
/**
 * GitPHP Controller DiffBase
 *
 * Base controller for diff-type views
 *
 * @author Christopher Han <xiphux@gmail.com>
 * @copyright Copyright (c) 2011 Christopher Han
 * @package GitPHP
 * @subpackage Controller
 */

/**
 * DiffBase controller class
 *
 * @package GitPHP
 * @subpackage Controller
 */
abstract class DiffBase extends Base
{
    /**
     * Constants for diff modes
     */
    const MODE_DIFF_UNIFIED = '1';
    const MODE_DIFF_SIDEBYSIDE = '2';

    /**
     * Constant of the diff mode cookie in the user's browser
     */
    const DIFF_MODE_COOKIE = 'GitPHPDiffMode';
    const TREEDIFF_ENABLED_COOKIE = 'GitPHPTreeDiffEnabled';

    /**
     * Diff mode cookie lifetime
     */
    const DIFF_MODE_COOKIE_LIFETIME = 60 * 60 * 24 * 365; // 1 year
    const TREEDIFF_ENABLED_COOKIE_LIFETIME = 60 * 60 * 24 * 365; // 1 year


    /**
     * ReadQuery
     *
     * Read query into parameters
     *
     * @access protected
     */
    protected function ReadQuery()
    {
        if (!isset($this->params['plain']) || $this->params['plain'] != true) {
            $diffcookie = $this->DiffMode(isset($_GET['o']) ? $_GET['o'] : '');

            if ($diffcookie === self::MODE_DIFF_SIDEBYSIDE) {
                $this->params['sidebyside'] = true;
            } else {
                $this->params['unified'] = true;
            }

            $treediffEnabled = $this->TreeDiffEnabled(isset($_GET['treediff']) ? $_GET['treediff'] : null);

            if ($treediffEnabled) {
                $this->params['treediff'] = true;
            }
        }

        $this->params['context'] = isset($_COOKIE['diff_context']) ? (int)$_COOKIE['diff_context'] : true;
        if (isset($_REQUEST['context']) && is_numeric($_REQUEST['context'])) $this->params['context'] = $_REQUEST['context'];
        if ($this->params['context'] < 0 || $this->params['context'] > 9999) {
            $this->params['context'] = 3;
        }
    }

    protected function TreeDiffEnabled($overrideMode = null) {
        $enabled = false;    // default

        /*
    	 * Check cookie
    	 */
        if (!empty($_COOKIE[self::TREEDIFF_ENABLED_COOKIE])) {
            $enabled = $_COOKIE[self::TREEDIFF_ENABLED_COOKIE] === '1';
        } else {
            /*
    		 * Create cookie to prevent browser delay
    		 */
            setcookie(self::TREEDIFF_ENABLED_COOKIE, $enabled ? '1' : '0', time() + self::TREEDIFF_ENABLED_COOKIE_LIFETIME);
        }

        if ($overrideMode !== null) {
            $enabled = $overrideMode === '1';
            setcookie(self::TREEDIFF_ENABLED_COOKIE, $overrideMode, time() + self::TREEDIFF_ENABLED_COOKIE_LIFETIME);
        }

        return $enabled;
    }

    /**
     * DiffMode
     *
     * Determines the diff mode to use
     *
     * @param string $overrideMode mode overridden by the user
     * @access protected
     * @return int
     */
    protected function DiffMode($overrideMode = '')
    {
        $mode = self::MODE_DIFF_UNIFIED;    // default

        /*
    	 * Check cookie
    	 */
        if (!empty($_COOKIE[self::DIFF_MODE_COOKIE])) {
            $mode = $_COOKIE[self::DIFF_MODE_COOKIE];
        } else {
            /*
    		 * Create cookie to prevent browser delay
    		 */
            setcookie(self::DIFF_MODE_COOKIE, $mode, time() + self::DIFF_MODE_COOKIE_LIFETIME);
        }

        if (!empty($overrideMode)) {
            /*
    		 * User is choosing a new mode
    		 */
            if ($overrideMode == 'sidebyside') {
                $mode = self::MODE_DIFF_SIDEBYSIDE;
                setcookie(self::DIFF_MODE_COOKIE, self::MODE_DIFF_SIDEBYSIDE, time() + self::DIFF_MODE_COOKIE_LIFETIME);
            }  else {
                $mode = self::MODE_DIFF_UNIFIED;
                setcookie(self::DIFF_MODE_COOKIE, self::MODE_DIFF_UNIFIED, time() + self::DIFF_MODE_COOKIE_LIFETIME);
            }
        }

        return $mode;
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
        if (isset($this->params['plain']) && ($this->params['plain'] === true)) {
            \CodeIsOk\Log::GetInstance()->SetEnabled(false);
            $this->headers[] = 'Content-type: text/plain; charset=UTF-8';
        }
    }

    protected function LoadData()
    {
        $this->tpl->assign('sidebyside', isset($this->params['sidebyside']) && ($this->params['sidebyside'] === true));
        $this->tpl->assign('unified', isset($this->params['unified']) && ($this->params['unified'] === true));
        $this->tpl->assign('treediff', isset($this->params['treediff']) && ($this->params['treediff'] === true));
        $this->tpl->assign('review', empty($this->params['review'])?'':$this->params['review']);
    }

    protected function loadReviewsLinks(\CodeIsOk\Git\Commit $co, $ticket)
    {
        if ($key = \CodeIsOk\Tracker::instance()->parseTicketFromString($ticket)) {
            $ticket = \CodeIsOk\Tracker::instance()->getReviewTicketPrefix() . $key;
        }

        $Db = \CodeIsOk\Db::getInstance();
        $reviews = $Db->getReview($ticket, $co->GetHash());

        $comments_count = $Db->getCommentsCountForReviews(array_keys($reviews), $this->Session->getUser()->getId());
        foreach ($comments_count as $review_id => $row) {
            if (empty($row['cnt']) && empty($row['cnt_draft'])) {
                unset($reviews[$review_id]);
                continue;
            }
            $reviews[$review_id]['comments_count'] = $row['cnt'];
            $reviews[$review_id]['comments_count_draft'] = $row['cnt_draft'];
            $reviews[$review_id]['ticket'] = $row['ticket'];
        }

        if (isset($reviews[$this->params['review']])) {
            unset($reviews[$this->params['review']]);
        }

        foreach ($reviews as $review_id => &$review) {
            $review['link'] = \CodeIsOk\Application::getUrl('reviews', ['review' => $review_id]);
            $review['diff_link'] = '';
            if ($review['hash_base'] && $review['hash_base'] != 'blob' && isset($this->params['branch']) && !preg_match('#^[0-9a-f]{40}$#', $this->params['branch'])) {
                $review['diff_link'] = \CodeIsOk\Application::getUrl(
                    'branchdiff',
                    [
                        'p' => $this->project->GetProject(),
                        'branch' => $this->params['branch'],
                        'base' => $review['hash_head'],
                    ]
                );
            }
        }
        $this->tpl->assign('reviews', $reviews);
    }

    protected function filterRootFolders($folders)
    {
        $allowed = [
            'UTests',
            'testlib',
            'EDL',
        ];

        return array_intersect($folders, $allowed);
    }
}
