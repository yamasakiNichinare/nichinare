<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: modifier.decode_xml.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_modifier_decode_xml($text) {
    require_once("MTUtil.php");
    return decode_xml($text);
}
?>
