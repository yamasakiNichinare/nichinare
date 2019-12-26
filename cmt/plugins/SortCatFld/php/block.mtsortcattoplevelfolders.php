<?php

# $Id block.mtsortedtoplevelfolders.php$

require_once('block.mtsortedtoplevelcategories.php');
function smarty_block_mtsortedtoplevelfolders($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mtsortedtoplevelcategories($args, $content, $ctx, $repeat);
}
?>
