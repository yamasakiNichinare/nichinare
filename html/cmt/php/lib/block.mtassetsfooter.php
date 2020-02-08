<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtassetsfooter.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtassetsfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $assets = $ctx->stash('_assets');
        $counter = $ctx->stash('_assets_counter');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, count($assets) == $counter);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
