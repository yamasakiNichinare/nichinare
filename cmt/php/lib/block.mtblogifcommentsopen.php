<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtblogifcommentsopen.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtblogifcommentsopen($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: none
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        if ($ctx->mt->config('AllowComments') &&
            (($blog->blog_allow_reg_comments && $blog->remote_auth_token)
             || $blog->blog_allow_unreg_comments))
            $open = 1;
        else
            $open = 0;
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $open);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
