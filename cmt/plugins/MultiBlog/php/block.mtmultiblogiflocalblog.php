<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtmultiblogiflocalblog.php 5151 2010-01-06 07:51:27Z takayama $

if (MULTIBLOG_ENABLED) {
function smarty_block_mtmultiblogiflocalblog($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $blog_id = $ctx->stash('blog_id');
        $local_blog_id = $ctx->stash('local_blog_id');
        if (! isset($local_blog_id)) $local_blog_id = $blog_id;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat,
            $local_blog_id == $blog_id);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
}
?>