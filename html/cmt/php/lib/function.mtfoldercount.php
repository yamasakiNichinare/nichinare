<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtfoldercount.php 5225 2010-01-27 07:14:14Z takayama $

require_once('function.mtcategorycount.php');
function smarty_function_mtfoldercount($args, &$ctx) {
    return smarty_function_mtcategorycount($args, $ctx);
}
?>
