<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mttagid.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mttagid($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    if (!$tag) return '';
    if (is_object($tag)) {
        return $tag->tag_id;
    } else {
        $tag = $ctx->mt->db()->fetch_tag_by_name($tag);
        if ($tag) {
            $ctx->stash('Tag', $tag);
            return $tag->tag_id;
        }
        return '';
    }
}
?>
