<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtwebsitehost.php 5225 2010-01-27 07:14:14Z takayama $

function smarty_function_mtwebsitehost($args, &$ctx) {
    // status: complete
    // parameters: exclude_port, signature
    require_once('function.mtbloghost.php');
    return smarty_function_mtbloghost($args, $ctx);
}
?>
