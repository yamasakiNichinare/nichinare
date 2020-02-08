<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtarchivecategory.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtarchivecategory($args, &$ctx) {
    if ($ctx->stash('inside_mt_categories')) {
        require_once("function.mtcategorylabel.php");
        return smarty_function_mtcategorylabel($args, $ctx);
    }

    $cat = $ctx->stash('archive_category');
    return $cat ? $cat->category_label : '';
}
?>
