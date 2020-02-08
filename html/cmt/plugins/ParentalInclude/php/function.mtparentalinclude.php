<?php
# ParentalInclude - When including the template, recursive searching against own blog, parental website and global
#       Copyright (c) 2009 SKYARC System Co.,Ltd.
#       @see http://www.skyarc.co.jp/engineerblog/entry/parentalinclude.html

require_once ('function.mtinclude.php');

function smarty_function_mtparentalinclude ($args, &$ctx) {

    # Try usually except global template
    $args['global'] = 0;
    $ret = smarty_function_mtinclude ($args, $ctx);
    if ($ret) return $ret;

    # Try in parent blog/website (also global template)
    if ($ctx->stash('blog')->parent_id)
        $args['blog_id'] = $ctx->stash('blog')->parent_id;
    else
        $args['blog_id'] = 0;
    $ret = smarty_function_mtinclude ($args, $ctx);
    if ($ret) return $ret;

    if ($args['blog_id']) {
        $args['global'] = 1; #18115
        $ret = smarty_function_mtinclude ($args, $ctx);
        if ($ret) return $ret;
    }

    return $ret;
} ?>