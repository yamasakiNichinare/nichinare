<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtentryrecommendedtotal.php 117483 2010-01-07 08:27:20Z ytakayama $

function smarty_function_mtentryrecommendedtotal($args, &$ctx) {
    $else = $ctx->stash('cp_if_recommended_else');
    if (!$else) {
        if (!($ctx->stash('cp_if_recommended'))) {
            return $ctx->error('Context not valid');
        }
    }
    $entry = $ctx->stash('entry');
    if (!isset($entry)) {
        return $ctx->error('No entry available.');
    }
    $class = $args['class'];
    if ($class) {
        require_once("MTUtil.php");
        $class = strip_tags($class);
        $class = ' class="' . $class . '"';
    }
    $entry_id = $entry->entry_id;
    $id = "cp_total_$entry_id";
    if ($else) {
        $id .= "_else";
    }
    return "<span id=\"$id\"$class></span>";
}
?>
