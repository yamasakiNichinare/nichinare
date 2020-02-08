<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtfolderfooter.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtfolderfooter($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $categories =& $ctx->stash('_categories');
        $counter = $ctx->stash('_categories_counter');

        return $ctx->_hdlr_if($args, $content, $ctx, $repeat, 
                              ((isset($counter) && isset($categories)) && $counter == count($categories) || $ctx->stash('subFolderFoot'))
        );
    } else {
        return $ctx->_hdlr_if($args, $content, $ctx, $repeat);
    }
}
?>
