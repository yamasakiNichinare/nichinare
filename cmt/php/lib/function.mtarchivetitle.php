<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtarchivetitle.php 5151 2010-01-06 07:51:27Z takayama $

require_once("archive_lib.php");
function smarty_function_mtarchivetitle($args, &$ctx) {
    $at = $ctx->stash('current_archive_type');
    if (isset($args['type'])) {
        $at = $args['type'];
    } elseif (isset($args['archive_type'])) {
        $at = $args['archive_type'];
    }
    if ($at == 'Category') {
        return $ctx->tag('CategoryLabel', $args);
    } else {
        $ar = ArchiverFactory::get_archiver($at);
        return $ar->get_title($args, $ctx);
    }
}
?>