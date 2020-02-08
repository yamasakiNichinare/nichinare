<?php
# Movable Type (r) (C) 2007-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: class.mt_field.php 117483 2010-01-07 08:27:20Z ytakayama $

require_once("class.baseobject.php");

/***
 * Class for mt_field
 */
class Field extends BaseObject
{
    public $_table = 'mt_field';
    protected $_prefix = "field_";
    protected $_has_meta = false;
}

