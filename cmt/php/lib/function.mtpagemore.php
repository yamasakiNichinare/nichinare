<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtpagemore.php 5151 2010-01-06 07:51:27Z takayama $

require_once('function.mtentrymore.php');
function smarty_function_mtpagemore($args, &$ctx) {
    return smarty_function_mtentrymore($args, $ctx);
}
?>
