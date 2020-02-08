<?php
# SKYARC (C) 2008-2009 SKYARC System Co., Ltd, All Rights Reserved.

function smarty_function_mtskyarcproductname($args, &$ctx) {
    $script = $ctx->mt->config('skyarcproductname');
    if (!$script) $script = 'SKYARC Solanowa ';
    return $script;
}
?>