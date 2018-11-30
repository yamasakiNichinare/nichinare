package BlogRebuilder::L10N::ja;

use strict;
use base 'BlogRebuilder::L10N';
use vars qw( %Lexicon );

our %Lexicon = (
    'Enable you to rebuild a number of blogs at once' => '一度に複数のブログを再構築できるようにします',
    'Rebuild blogs' => '複数ブログの再構築',
    'Start rebuilding' => '再構築開始',
    'Select all' => '全て選択',
    'Rebuild Error' => '再構築に失敗しました。',
    'Rebuild website' => 'ウェブサイト全体の再構築',
    'Rebuild sites' => 'システム全体の再構築',
    'Site' => 'サイト',
    'return dashboard' => 'ダッシュボードに戻る',
    'Rebuilding done.' => '再構築が完了しました。',
    'Start Rebuilding...' => '再構築を開始します...',
    'Rebuilding' => '再構築中',
    'Rebuild' => '再構築',

    'Hold down Ctrl to select multiple blog websites.' => 'Ctrlを押しながら、複数のウェブサイト・ブログを選択できます。',

## system error.

    'Permission denied.' => '権限がありません。',
    "Couldn't load Blog" => 'ブログが見つかりません。',

## movable type tmpl/error.tmpl copyed.

    'An error occurred' => 'エラーが発生しました。',
	'Missing Configuration File' => '環境設定ファイルが見つかりません。',
	'_ERROR_CONFIG_FILE' => 'Movable Type の環境設定ファイルが存在しないか、または読み込みに失敗しました。詳細については、Movable Type マニュアルの<a href="javascript:void(0)">インストールと設定</a>の章を確認してください。',
	'Database Connection Error' => 'データベースへの接続でエラーが発生しました。',
	'_ERROR_DATABASE_CONNECTION' => '環境設定ファイルのデータベース設定に問題があるか、または設定がありません。詳細については、Movable Type マニュアルの<a href="javascript:void(0)">インストールと設定</a>の章を確認してください。',
	'CGI Path Configuration Required' => 'CGIPath の設定が必要です。',
	'_ERROR_CGI_PATH' => '環境設定ファイルの CGIPath の項目の設定に問題があるか、または設定がありません。詳細については、Movable Type マニュアルの<a href="javascript:void(0)">インストールと設定</a>の章を確認してください。',

);

1;
