<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtassettype.php 5225 2010-01-27 07:14:14Z takayama $

function smarty_function_mtassettype($args, &$ctx) {
    $asset = $ctx->stash('asset');
    if (!$asset) return '';

    $mt = MT::get_instance();
    return $mt->translate($asset->asset_class);
}
/*
 * translate('image')
 * translate('Image')
 * translate('file')
 * translate('File')
 * translate('audio')
 * translate('Audio')
 * translate('video')
 * translate('Video')
 */
?>
