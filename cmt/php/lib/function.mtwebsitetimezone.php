<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtwebsitetimezone.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_function_mtwebsitetimezone($args, &$ctx) {
    // status: complete
    // parameters: no_colon
    require_once('function.mtblogtimezone.php');
    return smarty_function_mtblogtimezone($args, $ctx);
}
?>
