<?php

/*
 グラフィックライブラリ
 gd:GD
 im:ImageMagick 6+
 im5: ImageMagick 5)
*/
$kg->php_graphic = 'im';

/*
 convertコマンドのパス
 グラフィックライブラリにImageMagickを指定した場合のみ
*/
$kg->convert = '/usr/bin/convert';

/*
 identifyコマンドのパス
 グラフィックライブラリにImageMagickを指定した場合のみ
*/
$kg->identify = '/usr/bin/identify';

/*
 キャッシュディレクトリ
*/
$kg->temp_dir = '/var/tmp/keitaikit';

/*
 キャッシュの有効期間(秒)
*/
$kg->cache_expires = 60 * 60 * 24 * 14;

?>