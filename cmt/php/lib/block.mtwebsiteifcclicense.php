<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtwebsiteifcclicense.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtwebsiteifcclicense($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: none
    require_once('block.mtblogifcclicense.php');
    return smarty_block_mtblogifcclicense($args, $content, $ctx, $repeat);
}
?>
