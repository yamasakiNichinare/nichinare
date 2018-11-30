<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtpagerlink.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtpagerlink($args, &$ctx) {
    $page = $ctx->__stash['vars']['__value__'];
    if ( !$page ) return '';

    $limit = $ctx->stash('__pager_limit');
    $offset = ( $page - 1 ) * $limit;

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

