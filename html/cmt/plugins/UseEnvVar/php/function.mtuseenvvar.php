<?php
# UseEnvVar - Enable you to retrieve the environment values of CGI
#       Copyright (c) 2009 SKYARC System Co.,Ltd.
#       @see http://www.skyarc.co.jp/engineerblog/entry/useenvvar.html

define ('VARIABLE_NAME', 'env');

function smarty_function_mtuseenvvar ($args, &$ctx) {
    reset ($_SERVER);
    while (list ($key, $value) = each ($_SERVER)) {
        $args['name'] = VARIABLE_NAME. '{'. $key. '}';
        $args['value'] = $value;

        require_once ('function.mtsetvar.php');
        smarty_function_mtsetvar ($args, $ctx);
    }

    return ''; # output nothing
} ?>