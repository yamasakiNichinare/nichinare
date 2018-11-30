<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: modifier.encode_html.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_modifier_encode_html($text) {
    if (version_compare(phpversion(), '4.3.0', '>=')) {
        $mt = MT::get_instance();
        $charset = $mt->config('PublishCharset');
        return htmlentities($text, ENT_COMPAT, $charset);
    } else {
        return htmlentities($text, ENT_COMPAT);
    }
}
?>
