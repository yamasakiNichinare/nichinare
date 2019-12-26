<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtentrybasename.php 5225 2010-01-27 07:14:14Z takayama $

function smarty_function_mtentrybasename($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if (!$entry) return '';
    $basename = $entry->entry_basename;
    if ($sep = $args['separator']) {
        if ($sep == '-') {
            $basename = preg_replace('/_/', '-', $basename);
        } elseif ($sep == '_') {
            $basename = preg_replace('/-/', '_', $basename);
        }
    }
    return $basename;
}
?>
