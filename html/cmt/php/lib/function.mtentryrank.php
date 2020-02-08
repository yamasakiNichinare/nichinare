<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtentryrank.php 5151 2010-01-06 07:51:27Z takayama $

require_once('rating_lib.php');

function smarty_function_mtentryrank($args, &$ctx) {
    return hdlr_rank($ctx, 'entry', $args['namespace'], $args['max'],
        "AND (entry_status = 2)\n", $args
    );
}
?>
