<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtcommentrank.php 5151 2010-01-06 07:51:27Z takayama $

require_once('rating_lib.php');

function smarty_function_mtcommentrank($args, &$ctx) {
    return hdlr_rank($ctx, 'comment', $args['namespace'], $args['max'],
        "AND (comment_visible = 1)\n", $args
    );
}
?>
