<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: function.mtcommunityscript.php 117483 2010-01-07 08:27:20Z ytakayama $

function smarty_function_mtcommunityscript($args, &$ctx) {
    $script = $ctx->mt->config('CommunityScript');
    if (!$script) $script = 'mt-cp.cgi';
    return $script;
}
?>
