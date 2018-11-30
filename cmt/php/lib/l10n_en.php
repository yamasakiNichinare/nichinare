<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: l10n_en.php 5151 2010-01-06 07:51:27Z takayama $

global $Lexicon;
$Lexicon['Individual'] = 'Entry';
function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_ja;
    $l10n_str = isset($Lexicon[$str]) ? $Lexicon[$str] : $str;
    return translate_phrase_param($l10n_str, $params);
}
?>
