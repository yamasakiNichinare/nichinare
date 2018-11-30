<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtcommentauthor.php 5225 2010-01-27 07:14:14Z takayama $

function smarty_function_mtcommentauthor($args, &$ctx) {
    $c = $ctx->stash('comment');
    if (!$c)
        return $ctx->error("No comment available");
    $a = isset($c->comment_author) ? $c->comment_author : '';
    if ($c->comment_commenter_id) {
        $commenter = $ctx->stash('commenter');
        if ($commenter)
            $a = $commenter->nickname;
    }
    if (isset($args['default']))
        $a or $a = $args['default'];
    else {
        $mt = MT::get_instance();
        $a or $a = $mt->translate("Anonymous");
    }
    $a or $a = '';
    return strip_tags($a);
}
?>
