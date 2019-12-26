<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtifmoreresults.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtifmoreresults($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $limit = $ctx->stash('__pager_limit');
        $count = $ctx->stash('__pager_total_count');
        $offset = $ctx->stash('__pager_offset');
        if ( $limit && !$offset ) $offset += $limit;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, ( $limit + $offset ) < $count);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
