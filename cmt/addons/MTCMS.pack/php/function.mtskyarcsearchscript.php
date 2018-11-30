<?php
# SKYARC (C) 2008-2009 SKYARC System Co., Ltd, All Rights Reserved.

function smarty_function_mtskyarcsearchscript($args, &$ctx) {
    $script = $ctx->mt->config('skyarcsearchscript');
    if (!$script) $script = 'mt-search.cgi';
    return $script;
}
?>