<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtpageauthorlink.php 5151 2010-01-06 07:51:27Z takayama $

require_once('function.mtentryauthorlink.php');
function smarty_function_mtpageauthorlink($args, &$ctx) {
    return smarty_function_mtentryauthorlink($args, $ctx);
}
?>
