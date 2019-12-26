<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: class.mt_asset.php 5225 2010-01-27 07:14:14Z takayama $

require_once("class.baseobject.php");

/***
 * Class for mt_asset
 */
class Asset extends BaseObject
{
    public $_table = 'mt_asset';
    protected $_prefix = "asset_";
    protected $_has_meta = true;
}

// Relations
ADODB_Active_Record::ClassHasMany('Asset', 'mt_asset_meta','asset_meta_asset_id');	
?>
