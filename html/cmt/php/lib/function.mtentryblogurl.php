<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtentryblogurl.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtentryblogurl($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if ($entry->entry_blog_id) {
        $blog = $ctx->mt->db()->fetch_blog($entry->entry_blog_id);
        if ($blog) {
            $url = $blog->site_url();
            if (!preg_match('!/$!', $url))
                $url .= '/';
            return $url;
        }
    }
    return '';
}
?>
