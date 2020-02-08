<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtindexlink.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtindexlink($args, &$ctx) {
    $tmpl = $ctx->stash('index_templates');
    $counter = $ctx->stash('index_templates_counter');
    $idx = $tmpl[$counter];
    if (!$idx) return '';

    $blog = $ctx->stash('blog');
    $site_url = $blog->site_url();
    if (!preg_match('!/$!', $site_url)) $site_url .= '/';
    $link = $site_url . $idx->template_outfile;
    if (!$args['with_index']) {
        $link = _strip_index($link, $blog);
    }
    return $link;
}
?>
