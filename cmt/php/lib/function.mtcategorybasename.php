<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtcategorybasename.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtcategorybasename($args, &$ctx) {
    $cat = $ctx->stash('category');
    if (!$cat) return '';
    $basename = $cat->category_basename;
    if ($sep = $args['separator']) {
        if ($sep == '-') {
            $basename = preg_replace('/_/', '-', $basename);
        } elseif ($sep == '_') {
            $basename = preg_replace('/-/', '_', $basename);
        }
    }
    return $basename;
}
?>
