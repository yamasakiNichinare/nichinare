<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: modifier.spam_protect.php 5151 2010-01-06 07:51:27Z takayama $

function smarty_modifier_spam_protect($text, $value) {
    # defined in mt.php itself
    if (isset($value) && $value) {
        return spam_protect($text);
    } else {
        return $text;
    }
}
?>
