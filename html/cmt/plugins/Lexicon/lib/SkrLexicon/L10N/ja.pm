package SkrLexicon::L10N::ja;

use strict;
use MT;
require utf8 if 5.0 <= $MT::VERSION;
use base 'SkrLexicon::L10N';

use vars qw( %Lexicon );
%Lexicon = (

'Allow you to replace any strings in the admin screens' => '管理画面の文言を指定の文言に置換します。',
'OriginalStrigs|ReplacedStrings' => '置換前の文言|置換後の文言',

'Replace Entry' => '「ブログ記事」を置換',
'Replace Page' => '「ウェブページ」を置換',
'Replace Asset' => '「アイテム」を置換',
'Replace Comment' => '「コメント」を置換',
'Others'	=> 'その他',
'Changing UI labels may cause unexpected appearance. Please be careful.' => "管理画面の文言を変更すると、本来システムが意図していない管理画面の表示になる場合がございます。十分ご注意の上ご利用下さい。",
);

1;
