<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtsubfolders.php 5151 2010-01-06 07:51:27Z takayama $

require_once('block.mtsubcategories.php');
function smarty_block_mtsubfolders($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mtsubcategories($args, $content, $ctx, $repeat);
}
?>
