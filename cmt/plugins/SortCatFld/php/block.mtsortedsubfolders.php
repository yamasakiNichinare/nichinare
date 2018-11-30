<?php
require_once('block.mtsortedsubfolders.php');
function smarty_block_mtsortedsubfolders ($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'folder';
    return smarty_block_mtsortedsubcategories($args, $content, $ctx, $repeat);
}
?>
