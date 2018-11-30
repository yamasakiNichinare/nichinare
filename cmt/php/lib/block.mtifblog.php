<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtifblog.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtifblog($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $ok = empty($blog)
            ? 0
            : $blog->class == 'blog'
                ? 1
                : 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $ok);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
