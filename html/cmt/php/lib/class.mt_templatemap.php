<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: class.mt_templatemap.php 5225 2010-01-27 07:14:14Z takayama $

require_once("class.baseobject.php");

/***
 * Class for mt_templatemap
 */
class TemplateMap extends BaseObject
{
    public $_table = 'mt_templatemap';
    protected $_prefix = "templatemap_";

    public function template() {
        $col_name = "templatemap_template_id";
        $template = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $template_id = $this->$col_name;

            require_once('class.mt_template.php');
            $template = new Template;
            $template->Load("template_id = $template_id");
        }

        return $template;
    }
}
?>
