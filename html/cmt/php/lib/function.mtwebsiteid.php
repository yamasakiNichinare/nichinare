<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtwebsiteid.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtwebsiteid($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once('function.mtblogid.php');
    return smarty_function_mtblogid($args, $ctx);
}
?>
