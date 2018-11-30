<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtifpingsactive.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtifpingsactive($args, $content, &$ctx, &$repeat) {
    # status: complete
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $blog_active = $blog->blog_allow_pings && $ctx->mt->config('AllowPings');
        $entry = $ctx->stash('entry');
        if ($entry) {
            $active = $entry->entry_ping_count > 0;
            $active or $active = $blog_active && $entry->entry_allow_pings;
        } else {
            $active = $blog_active;
        }
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, $active);
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
