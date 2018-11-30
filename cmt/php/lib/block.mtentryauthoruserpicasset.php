<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtentryauthoruserpicasset.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtentryauthoruserpicasset($args, $content, &$ctx, &$repeat) {
    $entry = $ctx->stash('entry');
    if (!$entry) {
        return $ctx->error("No entry available");
    }

    $author = $entry->author();
    if (!$author) return '';

    $asset = $author->userpic();
    if (!$asset) return '';

    $ctx->stash('asset',  $asset);

    return $content;
}
?>
