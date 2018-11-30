<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtcommentblogid.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtcommentblogid($args, &$ctx) {
    $comment = $ctx->stash('comment');
    return (isset($args['pad']) && $args['pad']) ? sprintf("%06d", $comment->comment_blog_id) : $comment->comment_blog_id;
}
?>
