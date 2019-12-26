<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtarchives.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtarchives($args, $content, &$ctx, &$repeat) {
    $localvars = array('current_archive_type', 'archive_types', 'archive_type_index', 'old_preferred_archive_type');
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $at = $args['type'];
        $at or $at = $args['archive_type'];
        $at or $at = $blog->blog_archive_type;
        if (empty($at) || $at == 'None') {
            $repeat = false;
            return '';
        }
        $at = explode(',', $at);

        $ctx->localize($localvars);
        $ctx->stash('archive_types', $at);
        $ctx->stash('old_preferred_archive_type', $blog->blog_archive_type_preferred);
        $i = 0;
    } else {
        $at = $ctx->stash('archive_types');
        $i = $ctx->stash('archive_type_index') + 1;
        $blog = $ctx->stash('blog');
    }

    if ($i < count($at)) {
        $curr_at = $at[$i];
        $ctx->stash('current_archive_type', $curr_at);
        $ctx->stash('archive_type_index', $i);
        $blog->blog_archive_type_preferred = $curr_at;
        $ctx->stash('blog', $blog);
        $repeat = true;
    } else {
        $blog->blog_archive_type_preferred = $ctx->stash('old_preferred_archive_type');
        $ctx->stash('blog', $blog);
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
