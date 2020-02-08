<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtentryifallowpings.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtentryifallowpings($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $entry = $ctx->stash('entry');
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $entry->entry_allow_pings > 0);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>