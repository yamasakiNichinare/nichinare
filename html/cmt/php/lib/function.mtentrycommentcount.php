<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtentrycommentcount.php 5225 2010-01-27 07:14:14Z takayama $

function smarty_function_mtentrycommentcount($args, &$ctx) {
    $entry = $ctx->stash('entry');
    $count = $entry->entry_comment_count;
    return $ctx->count_format($count, $args);
}
?>
