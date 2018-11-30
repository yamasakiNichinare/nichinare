<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtpagepermalink.php 5151 2010-01-06 07:51:27Z takayama $

require_once('function.mtentrypermalink.php');
function smarty_function_mtpagepermalink($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry)
        return '';
    $blog = $ctx->stash('blog');
    $at = 'Page';
    if (!isset($args['blog_id']))
        $args['blog_id'] = $blog->blog_id;
    return $ctx->mt->db()->entry_link($entry->entry_id, $at, $args);
}
?>
