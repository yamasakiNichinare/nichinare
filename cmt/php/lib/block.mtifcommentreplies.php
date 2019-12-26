<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtifcommentreplies.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtifcommentreplies($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $comment = $ctx->stash('comment');
        $args['comment_id'] = $comment->comment_id;
        $children = $ctx->mt->db()->fetch_comment_replies($args);
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, count($children));
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
