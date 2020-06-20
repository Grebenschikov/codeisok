<?php
namespace CodeIsOk\Controller;

/**
 * Blob controller class
 *
 * @package GitPHP
 * @subpackage Controller
 */
class Blob extends Base
{
    protected $code_mirror_modes = [
        // 'file_extension' => 'mode' | 'mime-type'
        \CodeIsOk\SyntaxHighlighter::TYPE_TEXT => 'text',
        \CodeIsOk\SyntaxHighlighter::TYPE_PHP => 'php',
        \CodeIsOk\SyntaxHighlighter::TYPE_JS => 'javascript',
        \CodeIsOk\SyntaxHighlighter::TYPE_CSS => 'css',
        \CodeIsOk\SyntaxHighlighter::TYPE_BASH => 'shell',
        \CodeIsOk\SyntaxHighlighter::TYPE_JAVA => 'text/x-java',
        \CodeIsOk\SyntaxHighlighter::TYPE_XML => 'xml',
        \CodeIsOk\SyntaxHighlighter::TYPE_SQL => 'sql',
        \CodeIsOk\SyntaxHighlighter::TYPE_PYTHON => 'python',
        \CodeIsOk\SyntaxHighlighter::TYPE_DIFF => 'diff',
        \CodeIsOk\SyntaxHighlighter::TYPE_CPP => 'text/x-c++src',
        // there is no applescript mode in https://github.com/marijnh/CodeMirror/tree/master/mode :(
        // \SyntaxHighlighter::TYPE_APPLE_SCRIPT => 'applescript',
        \CodeIsOk\SyntaxHighlighter::TYPE_RUBY => 'ruby',
        \CodeIsOk\SyntaxHighlighter::TYPE_CSHARP => 'text/x-csharp',
        \CodeIsOk\SyntaxHighlighter::TYPE_OBJC => 'text/x-objc',
        \CodeIsOk\SyntaxHighlighter::TYPE_KOTLIN => 'text/x-kotlin',
    ];

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
        if (isset($this->params['plain']) && $this->params['plain']) return 'blobplain.twig.tpl';
        return 'blob.tpl';
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
        return (isset($this->params['hashbase']) ? $this->params['hashbase'] : '') . '|' . (isset($this->params['hash']) ? $this->params['hash'] : '') . '|' . (isset($this->params['file']) ? sha1($this->params['file']) : '');
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
        if ($local) {
            return __('blob');
        }
        return 'blob';
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
        if (isset($_GET['hb'])) $this->params['hashbase'] = $_GET['hb'];
        else $this->params['hashbase'] = 'HEAD';

        $this->params['file'] = isset($_GET['f']) ? $_GET['f'] : null;
        if (isset($_GET['h'])) {
            $this->params['hash'] = $_GET['h'];
        }
        $this->readHighlighter();
        $this->params['hi'] = 'sexy';
        if (isset($_GET['hi']) && in_array($_GET['hi'], array('no', 'php', 'sexy'))) {
            $this->params['hi'] = $_GET['hi'];
        }
    }

    protected function readHighlighter()
    {
        $hi = 'sexy';
        if (isset($_GET['hi']) && in_array($_GET['hi'], array('no', 'php', 'sexy'))) {
            $hi = $_GET['hi'];
        }
        $this->params['hi'] = $hi;
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
        if (isset($this->params['plain']) && $this->params['plain']) {
            \CodeIsOk\Log::GetInstance()->SetEnabled(false);

    		// XXX: Nasty hack to cache headers
            if (!$this->tpl->is_cached('blobheaders.twig.tpl', $this->GetFullCacheKey())) {
                if (isset($this->params['file'])) $saveas = $this->params['file'];
                else $saveas = $this->params['hash'] . ".txt";

                $headers = array();

                $mime = null;
                if (\CodeIsOk\Config::GetInstance()->GetValue('filemimetype', true)) {
                    if ((!isset($this->params['hash'])) && (isset($this->params['file']))) {
                        $commit = $this->project->GetCommit($this->params['hashbase']);
                        $this->params['hash'] = $commit->PathToHash($this->params['file']);
                    }

                    $blob = $this->project->GetBlob($this->params['hash']);
                    $blob->SetPath($this->params['file']);

                    $mime = $blob->FileMime();
                }

                $file_name = $this->params['file'];
                if (preg_match('/.*?\.(\w+)$/', $file_name, $matches)) {
                    $type = \CodeIsOk\SyntaxHighlighter::getTypeByExtension($matches[1]);
                    if ($type && isset($this->code_mirror_modes[$type])) {
                        $headers[] = 'Cm-mode: ' . $this->code_mirror_modes[$type];
                    } else {
                        $headers[] = 'Cm-mode: clike';
                    }
                }

                if ($mime && strpos($mime, 'text') !== 0) $headers[] = "Content-type: " . $mime;
                else $headers[] = "Content-type: text/plain; charset=UTF-8";

                $headers[] = "Content-disposition: inline; filename=\"" . $saveas . "\"";

                $this->tpl->assign("blobheaders", serialize($headers));
            }
            $out = $this->tpl->fetch('blobheaders.twig.tpl', $this->GetFullCacheKey());

            $this->headers = unserialize($out);
        }
    }

    /**
     * LoadData
     *
     * Loads data for this template
     *
     * @access protected
     * @throws \CodeIsOk\MessageException
     */
    protected function LoadData()
    {
        $commit = $this->project->GetCommit($this->params['hashbase']);
        if (!$commit) {
            throw new \CodeIsOk\MessageException("Incorrect hash {$this->params['hashbase']}", true, 404);
        }
        $this->tpl->assign('commit', $commit);

        if ((!isset($this->params['hash'])) && (isset($this->params['file']))) {
            $this->params['hash'] = $commit->PathToHash($this->params['file']);
        }

        $blob = $this->project->GetBlob($this->params['hash']);
        if ($this->params['file']) $blob->SetPath($this->params['file']);
        $blob->SetCommit($commit);
        $this->tpl->assign('blob', $blob);

        if (isset($this->params['plain']) && $this->params['plain']) {
            return;
        }

        $head = $this->project->GetHeadCommit();
        $this->tpl->assign('head', $head);

        $this->tpl->assign('tree', $commit->GetTree());

        if (\CodeIsOk\Config::GetInstance()->GetValue('filemimetype', true)) {
            $mime = $blob->FileMime();
            if ($mime) {
                $mimetype = strtok($mime, '/');
                if ($mimetype == 'image') {
                    $this->tpl->assign('datatag', true);
                    $this->tpl->assign('mime', $mime);
                    $this->tpl->assign('data', base64_encode($blob->GetData()));
                    return;
                }
            }
        }

        $this->tpl->assign('extrascripts', array('blame'));

        switch ($this->params['hi']) {
            case 'sexy':
                $SH = new \CodeIsOk\SyntaxHighlighter($blob->GetName());
                $this->tpl->assign('sexy', 1);
                $this->tpl->assign('extracss_files', $SH->getCssList());
                $this->tpl->assign('extrajs_files', $SH->getJsList());
                $this->tpl->assign('highlighter_brushes', $SH->getBrushesList());
                $this->tpl->assign('highlighter_brush_name', $SH->getBrushName());
                $this->tpl->assign('blobstr', '');
                if (strpos($blob->FileMime(), 'text') !== false || strpos($blob->FileMime(), 'xml') !== false) {
                    $this->tpl->assign('blobstr', $blob->getData(false));
                }
                return;

            case 'php':
                $this->tpl->assign('blobstr', highlight_string($blob->GetData(false), 1));
                $this->tpl->assign('php', 1);
                return;

            case 'no':
            default:
                $this->tpl->assign('bloblines', $blob->GetData(true));
        }

        $this->tpl->assign('blobstr', highlight_string($blob->GetData(false), 1));
        $this->tpl->assign('new', isset($_GET['new']));
    }
}
