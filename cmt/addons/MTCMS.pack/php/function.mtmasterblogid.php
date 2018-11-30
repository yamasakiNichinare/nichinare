<?php
# SKYARC (C) 2008-2009 SKYARC System Co., Ltd, All Rights Reserved.

function smarty_function_mtmasterblogid($args, &$ctx) {
    $script = $ctx->mt->config('masterblogid');
    if (!$script) $script = '1';
    return $script;
}
?>
