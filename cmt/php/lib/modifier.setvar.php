<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: modifier.setvar.php 5225 2010-01-27 07:14:14Z takayama $

function smarty_modifier_setvar($text, $name) {
    $mt = MT::get_instance();
    $ctx =& $mt->context();
    if (array_key_exists('__inside_set_hashvar', $ctx->__stash)) {
        $vars =& $ctx->__stash['__inside_set_hashvar'];
    } else {
        $vars =& $ctx->__stash['vars'];
    }
    $vars[$name] = $text;
    return '';
}
?>
