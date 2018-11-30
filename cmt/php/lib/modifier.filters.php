<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: modifier.filters.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_modifier_filters($text,$filters) {
    // status: complete
    $mt = MT::get_instance();
    $ctx =& $mt->context();
    require_once 'MTUtil.php';
    $text = apply_text_filter($ctx, $text, $filters);

    return $text;
}
?>
