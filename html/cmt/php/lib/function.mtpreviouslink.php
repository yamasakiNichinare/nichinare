<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtpreviouslink.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtpreviouslink($args, &$ctx) {
    $limit = $ctx->stash('__pager_limit');
    $offset = $ctx->stash('__pager_offset');

    if ( $offset <= $limit )
        $offset = 0;
    else
        $offset -= $limit;

    if ( strpos($link, '?') ) {
        $link .= '&';
    }
    else {
        $link .= '?';
    }

    $link .= "limit=$limit";
    if ( $offset )
        $link .= "&offset=$offset";
    return $link;
}
?>

