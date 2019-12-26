<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtindexlist.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtindexlist($args, $content, &$ctx, &$repeat) {
    $localvars = array('index_templates', 'index_templates_counter');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $tmpl = $ctx->mt->db()->fetch_templates(array(
            type => 'index',
            blog_id => $ctx->stash('blog_id')
        ));
        $counter = 0;
        $ctx->stash('index_templates', $tmpl);
    } else {
        $tmpl = $ctx->stash('index_templates');
        $counter = $ctx->stash('index_templates_counter') + 1;
    }
    if ($counter < count($tmpl)) {
        $ctx->stash('index_templates_counter', $counter);
        $repeat = true;
    } else {
        $ctx->restore($localvars);
    }
    return $content;
}
?>
