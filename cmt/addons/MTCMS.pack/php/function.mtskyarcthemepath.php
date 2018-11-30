<?php
# SKYARC (C) 2008-2009 SKYARC System Co., Ltd, All Rights Reserved.

function smarty_function_mtskyarcthemepath($args, &$ctx) {
    $script = $ctx->mt->config('skyarcthemepath');
    if (!$script) $script = 'themes/SKYARC.pack/';
    return $script;
}
?>