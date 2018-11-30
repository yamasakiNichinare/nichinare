<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: block.mtarchivenext.php 5151 2010-01-06 07:51:27Z takayama $

require_once("archive_lib.php");
function smarty_block_mtarchivenext($args, $content, &$ctx, &$repeat) {
    return _hdlr_archive_prev_next($args, $content, $ctx, $repeat, 'archivenext');
}
?>
