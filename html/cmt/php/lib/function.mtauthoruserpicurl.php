<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtauthoruserpicurl.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtauthoruserpicurl($args, &$ctx) {
    $author = $ctx->stash('author');
    if (empty($author)) {
        $entry = $ctx->stash('entry');
        if (!empty($entry)) {
            $author = $entry->atuhor();
        }
    }

    if (empty($author)) {
        return $ctx->error("No author available");
    }

    $asset_id = isset($author->author_userpic_asset_id) ? $author->author_userpic_asset_id : 0;
    $asset = $ctx->mt->db()->fetch_assets(array('id' => $asset_id));
    if (!$asset) return '';

    $blog =& $ctx->stash('blog');

    require_once("MTUtil.php");
    $userpic_url = userpic_url($asset[0], $blog, $author);
    return $userpic_url;
}
?>