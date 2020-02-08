<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: modifier.numify.php 5225 2010-01-27 07:14:14Z takayama $

function smarty_modifier_numify($text, $attr = ',') {
    if ($attr == "1") $attr = ',';
    return preg_replace('/(^[−+]?\d+?(?=(?>(?:\d{3})+)(?!\d))|\G\d{3}(?=\d))/', '\\1' . $attr, $text);
}
?>
