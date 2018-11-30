<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtwebsitedescription.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtwebsitedescription($args, &$ctx) {
    // status: complete
    // parameters: none
    require_once('function.mtblogdescription.php');
    return smarty_function_mtblogdescription($args, $ctx);
}
?>
