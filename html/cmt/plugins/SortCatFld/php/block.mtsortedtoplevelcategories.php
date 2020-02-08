<?php

# $Id: block.mtsortedtoplevelcategories.php $

function smarty_block_mtsortedtoplevelcategories($args, $content, &$ctx, &$repeat) {
    if (!isset($content)) {
        $ctx->localize(array('category', 'archive_category'));
        $ctx->stash('category', null);
        $ctx->stash('archive_category', null);
        require_once("block.mtsortedsubcategories.php");
        $args['top_level_categories'] = 1;
    }
    $result = smarty_block_mtsortedsubcategories($args, $content, $ctx, $repeat);
    if (!$repeat) {
        $ctx->restore(array('category', 'archive_category'));
    }
    return $result;
}
?>
