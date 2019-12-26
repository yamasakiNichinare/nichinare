<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtifcommenterregistrationallowed.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtifcommenterregistrationallowed($args, $content, &$ctx, &$repeat) {
    $registration = $ctx->mt->config('commenterregistration');
    $blog = $ctx->stash('blog');
    $allow = $registration['allow'] && ($blog && $blog->blog_allow_commenter_regist);
    if (!isset($content)) {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $allow);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
