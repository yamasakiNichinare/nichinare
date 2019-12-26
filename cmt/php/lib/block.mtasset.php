<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtasset.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtasset($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $asset = $ctx->mt->db()->fetch_assets($args);
    } else {
        $asset = array();
    }

    if (count($asset) == 1) {
        $ctx->stash('asset',  $asset[0]);
        $ctx->stash('_assets_counter', 1);
        $repeat = true;
    } else {
        $repeat = false;
    }

    return $content;
}
?>

