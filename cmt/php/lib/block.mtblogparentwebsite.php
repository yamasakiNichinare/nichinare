<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtblogparentwebsite.php 5151 2010-01-06 07:51:27Z takayama $
require_once('block.mtblogs.php');
function smarty_block_mtblogparentwebsite($args, $content, &$ctx, &$repeat) {
    $blog = $ctx->stash('blog');
    $website = $blog->website();
    $args['class'] = 'website';
    $args['blog_id'] = $website->id;
    return smarty_block_mtblogs($args, $content, $ctx, $repeat);
}
?>
