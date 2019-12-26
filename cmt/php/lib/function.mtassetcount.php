<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtassetcount.php 5225 2010-01-27 07:14:14Z takayama $

function smarty_function_mtassetcount($args, &$ctx) {
    $args['blog_id'] = $ctx->stash('blog_id');
    $count = $ctx->mt->db()->asset_count($args);
    return $ctx->count_format($count, $args);
}
?>
