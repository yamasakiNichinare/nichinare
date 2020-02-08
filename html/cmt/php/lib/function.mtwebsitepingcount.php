<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtwebsitepingcount.php 5225 2010-01-27 07:14:14Z takayama $

function smarty_function_mtwebsitepingcount($args, &$ctx) {
    require_once('function.mtblogpingcount.php');
    return smarty_function_mtblogpingcount($args, $ctx);
}
?>
