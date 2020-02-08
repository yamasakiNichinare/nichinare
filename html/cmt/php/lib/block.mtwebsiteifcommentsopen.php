<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtwebsiteifcommentsopen.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_block_mtwebsiteifcommentsopen($args, $content, &$ctx, &$repeat) {
    // status: complete
    // parameters: none
    require_once('block.mtblogifcommentsopen.php');
    return smarty_block_mtblogifcommentsopen($args, $content, $ctx, $repeat);
}
?>
