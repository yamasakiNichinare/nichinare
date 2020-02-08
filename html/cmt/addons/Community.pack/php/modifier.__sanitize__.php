<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: modifier.__sanitize__.php 117483 2010-01-07 08:27:20Z ytakayama $

function smarty_modifier___sanitize__($text) {
    require_once("modifier.sanitize.php");
    return smarty_modifier_sanitize($text, '1');
}
