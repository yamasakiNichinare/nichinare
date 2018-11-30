# $Id$

package DynamicViewer::L10N::ja;

use strict;
use base 'DynamicViewer::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

'Perl scripts using the dynamic and displays. Can now be dynamically displayed on a static file even partially.'
 => 'Perlスクリプトを利用した動的表示を行います。さらに静的ファイル上で部分的に動的表示することが出来るようになります。',

'Dynamic Viewer' => 'ダイナミック・ビュワー',
'DynamicViewer Settings' => 'ダイナミック・ビュワー設定',
'Its progress' => '処理済み',
'DynamicViewer has been installed.' => 'ダイナミックビュワーをサイトに設置しています。',
'DynamicViewer has been removed.' => 'ダイナミックビュワーをサイトから取り外しています。',
'Start DynamicViewer Settings.' => 'ダイナミックビュワーの設定を開始します。',

'Status' => '状態',
'Disabled' => '無効',
'Enable' => '有効',
'Exclude Files' => '除外ファイル',
'Exclude Path'  => '除外パス',
'Web Server' => 'ウェブ サーバ',
'Inheritance' => '継承設定',
'Authentication' => '認証機能',
'Error Page' => 'エラーページ',
'Login Page' => 'ログインページ',
'Logout Page' => 'ログアウトページ',
'Default template.' => '標準テンプレートの利用',
'File path.' => 'ファイルパスの指定',
'Template name.' => 'テンプレート名の指定',
'Template Location' => 'テンプレート',
'Page Name' => 'ページ名',

'Default template: Uses the template named (DynamicViewer Error)' => '標準テンプレートの利用の場合:「ダイナミック・ビュワーのエラー」という名前のテンプレートを利用します。',
'Default template: Uses the template named (DynamicViewer Login)' => '標準テンプレートの利用の場合:「ダイナミック・ビュワーのログイン」という名前のテンプレートを利用します。',
'Default template: Uses the template named (DynamicViewer Logout)' => '標準テンプレートの利用の場合:「ダイナミック・ビュワーのログアウト」という名前のテンプレートを利用します。',

'File Path: The path to the file descriptor is stored on the server where the template.'
 => 'ファイルパスの指定の場合:　テンプレートが保存されているサーバ上のファイルパスを記述します。',

'Template name: Write the name of the template.'
 => 'テンプレート名の指定の場合:　このサイトのテンプレートの名前を記述します。',

'"Enable" By selecting top sites CGI-PROXY can establishing.' 
 => '「有効」を選択することで、サイトのトップにダイナミックビュワーを設置することができます。',

'"Disabled" that into,PROXY remove settings.' 
 => '「無効」にすることで、ダイナミックビュワーを取り外します。',

'"Settings Inheritance" to enable the higher the "Website" and follow the set.' 
 => '「継承設定」を有効にすると、上位の「ウェブサイト」設定に従います。',

'PROXY above file can be referenced directly without going through.'
 => '上記ファイルをダイナミックビュワーを通さずに直接参照させることができます。',

'PROXY certain directories and files can be refarenced directly without going through.'
 => '特定のディレクトリやファイルをダイナミックビュワーを通さずに直接参照させることができます。',

'Description method' => '記述方法',

'The relative path from the top sites.'
 => 'サイトトップからの相対パスで指定します。',

'To specigy more than one are written separated by a newline.'
 => '複数指定する場合は改行区切りで記述します。',

'"Enable" is checked,inherit the settings of the parent object.'
 => '「有効」を設定した場合、親オブジェクトの設定を継承します。',

'example)&nbsp;System&nbsp;&gt;&nbsp;Website&nbsp;&gt;&nbsp;Blog' 
 => '例)&nbsp;ウェブサイト設定&nbsp;⇒&nbsp;ブログ設定',

## system_plugin_setting

'"URL Rewrite Module 1.1 for IIS" switch to using the rewrite capability.'
 => '「URL Rewrite Module 1.1 for IIS」を利用したリライト機能に切り替えます。',

'CGI extension fcgi output change. IIS FastCGI is not compatible with the environment.'
 => '出力するcgiの拡張子をfcgiに変更します。FastCGIはIIS環境には対応していません。',

## App

'Is Unknown' => 'エラーの詳細情報はありません',
'Not Found' => 'ページが見つかりません',
'Forbidden' => '権限がありません',
'Initailize Error' => '初期化に失敗しました',
'Internal Server Error' => 'システムの動作中にエラーが発生しました',
'Rebuild Error' => '表示中にエラーが発生しました',
'Invalidate request' => '不正な要求です',

'Authentication Failed. ([_1])' => '認証に失敗しました。([_1])',


# templates
'DynamicViewer Login'  => 'ダイナミック・ビュワーのログイン',
'DynamicViewer Logout' => 'ダイナミック・ビュワーのログアウト',
'DynamicViewer Error'  => 'ダイナミック・ビュワーのエラー',



);

1;
