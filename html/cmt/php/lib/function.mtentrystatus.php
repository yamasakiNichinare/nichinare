<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtentrystatus.php 5151 2010-01-06 07:51:27Z takayama $

function status_text($s) {
    $status = array(
        1 => "Draft",    # STATUS_HOLD
        2 => "Publish",  # STATUS_RELEASE
        3 => "Review",   # STATUS_REVIEW
        4 => "Future"    # STATUS_FUTURE
    );

    $mt = MT::get_instance();
    return $mt->translate($status[$s]);
}

function smarty_function_mtentrystatus($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return status_text($entry->entry_status);
}
?>
