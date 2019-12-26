<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: class.mt_objectscore.php 5225 2010-01-27 07:14:14Z takayama $

require_once("class.baseobject.php");

/***
 * Class for mt_objectscore
 */
class ObjectScore extends BaseObject
{
    public $_table = 'mt_objectscore';
    protected $_prefix = "objectscore_";

    public function related_object() {
        require_once("class.mt_" . $this->object_ds . ".php");
        $class = $this->object_ds;
        $obj = new $class;
        $obj->Load($this->object_ds . "_id = " . $this->object_id);
        return $obj;
    }

}
?>