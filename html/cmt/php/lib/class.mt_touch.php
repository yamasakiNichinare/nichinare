<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: class.mt_touch.php 5225 2010-01-27 07:14:14Z takayama $

require_once("class.baseobject.php");

/***
 * Class for mt_touch
 */
class Touch extends BaseObject
{
    public $_table = 'mt_touch';
    protected $_prefix = "touch_";
}
?>
