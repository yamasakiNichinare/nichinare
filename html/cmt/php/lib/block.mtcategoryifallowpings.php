<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtcategoryifallowpings.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtcategoryifallowpings($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $cat = $ctx->stash('category');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $cat->category_allow_pings > 0);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>