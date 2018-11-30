<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtwebsitehasblog.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtwebsitehasblog($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        if (empty($blog)) {
            $ret = false;
        } else if($blog->class == 'blog') {
            $ret = false;
        } else {
            $blogs = $blog->blogs();
            $ret = empty($blogs)
                ? false
                : true;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $ret);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
