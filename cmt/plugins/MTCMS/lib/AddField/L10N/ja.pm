package AddField::L10N::ja;

use strict;
use MT;
require utf8 if 5.0 <= $MT::VERSION;
use base 'AddField::L10N';
use vars qw( %Lexicon );

our %Lexicon = (

 'Important Entry' => '重要な記事',
 'If you specify a important entry, please check.' => '重要な記事を指定する場合チェックしてください。',
 'Website keywords' => 'ウェブサイトのキーワード',
 'Website META Keywords Common Please enter separated by commas.' => 'ウェブサイト共通のMETA Keywordsをカンマ区切りで入力してください。',
 'Hide navigation' => 'ナビゲーションに表示しない',
 'Does not display the folder name in navigation, please check.' => 'ナビゲーションにフォルダ名を表示しない場合はチェックしてください。',
 'To change the link to the file' => 'リンクをファイルに変更する',
 'If you change the file list of links to entries, please attach the file here.' => '記事一覧のリンクをファイルに変更する場合、ここにファイルを添付してください。',
 'External site links' => '外部サイトリンク',
 'If you want to change the link to an external site article list, please enter the URL here.' => '記事一覧のリンクを外部サイトに変更する場合、ここにURLを記入してください。',
 'Tag access analysis' => 'アクセス解析タグ',
 'Please enter the tag web analytics.' => 'ウェブサイトのアクセス解析タグを入力してください。',
 'Copyright' => 'コピーライト',
 'Please enter the copyright. example) SKYARC System Co., Ltd,' => 'コピーライトを入力してください。 例) SKYARC System Co., Ltd,',
 'Website Title' => 'ウェブサイトのタイトル',
 'Please enter the TITLE of the website. example) Sukaiakushisutemu service site.' => 'ウェブサイトのTITLEを入力してください。 例) スカイアークシステム サービスサイト',

);

1;
