<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtcgipath.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtcgipath($args, &$ctx) {
    // status: complete
    // parameters: none
    $path = $ctx->mt->config('CGIPath');
    if (substr($path, 0, 1) == '/') {  # relative
        $blog = $ctx->stash('blog');
        $host = $blog->site_url();
        if (!preg_match('!/$!', $host))
            $host .= '/';
        if (preg_match('!^(https?://[^/:]+)(:\d+)?/!', $host, $matches)) {
            $path = $matches[1] . $path;
        }
    }
    if (substr($path, strlen($path) - 1, 1) != '/')
        $path .= '/';
    return $path;
}
?>
