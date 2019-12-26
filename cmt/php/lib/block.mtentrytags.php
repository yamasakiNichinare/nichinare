<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtentrytags.php 5225 2010-01-27 07:14:14Z takayama $

function smarty_block_mtentrytags($args, $content, &$ctx, &$repeat) {
    $localvars = array('_tags', 'Tag', '_tags_counter', 'tag_min_count', 'tag_max_count','all_tag_count', '__out', 'class_type');
    if (!isset($content)) {
        $class = 'entry';
        if (isset($args['class'])) {
            $class = $args['class'];
        }
        $ctx->localize($localvars);
        require_once("MTUtil.php");
        $entry = $ctx->stash('entry');
        $blog_id = $entry->entry_blog_id;

        $entry = $ctx->stash('entry');
        $tags = $ctx->mt->db()->fetch_entry_tags(array('entry_id' => $entry->entry_id, 'blog_id' => $blog_id, 'class' => $class));
        if (!is_array($tags)) $tags = array();
        $ctx->stash('_tags', $tags);
        $ctx->stash('__out', false);
        $ctx->stash('class_type', $class);

        $counter = 0;
        if (!count($tags)) {
            $ctx->restore($localvars);
            $repeat = false;
            return;
        }
    } else {
        $tags = $ctx->stash('_tags');
        $counter = $ctx->stash('_tags_counter');
        $out = $ctx->stash('__out');
    }
    if ($counter < count($tags)) {
        $tag = $tags[$counter];
        $ctx->stash('Tag', $tag);
        $ctx->stash('_tags_counter', $counter + 1);
        $repeat = true;
        if (isset($args['glue']) && !empty($content)) {
            if ($out)
                $content = $args['glue']. $content;
            else
                $ctx->stash('__out', true);
        }
    } else {
        if (isset($args['glue']) && $out && !empty($content))
            $content = $args['glue']. $content;
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
