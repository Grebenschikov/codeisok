<?php
/**
 * @team QA <qa@corp.badoo.com>
 * @maintainer Aleksandr Izmaylov <a.izmaylov@corp.badoo.com>
 */

namespace CodeIsOk\Controller;

/**
 * Interface ControllerInterface
 * @package CodeIsOk\Controller
 */
interface ControllerInterface
{
    /**
     * Called to render page
     * @return mixed
     */
    public function Render();
}
