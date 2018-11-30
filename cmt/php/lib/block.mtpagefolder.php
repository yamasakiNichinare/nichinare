<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtpagefolder.php 5151 2010-01-06 07:51:27Z takayama $

require_once('block.mtentrycategories.php');
function smarty_block_mtpagefolder($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mtentrycategories($args, $content, $ctx, $repeat);
}
?>
