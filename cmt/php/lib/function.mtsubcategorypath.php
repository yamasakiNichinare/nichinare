<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtsubcategorypath.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtsubcategorypath($args, &$ctx) {
    require_once("block.mtparentcategories.php");
    require_once("function.mtcategorybasename.php");

    $bargs = array();
    if (isset($args['separator']))
        $bargs['separator'] = $args['separator'];

    $args = array('glue' => '/');
    $content = null;
    $repeat = true;
    smarty_block_mtparentcategories($args, $content, $ctx, $repeat);
    $res = '';

    while ($repeat) {
        $content = smarty_function_mtcategorybasename($bargs, $ctx);
        $res .= smarty_block_mtparentcategories($args, $content, $ctx, $repeat);
    }
    return $res;
}
?>
