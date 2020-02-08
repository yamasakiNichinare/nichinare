# $Id$

package AuthorRegistration::L10N::ja;

use strict;
use base 'AuthorRegistration::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'Export all authors to CSV file format. And import authors from exported file format.' => 'ユーザー情報をCSVでインポート・エクスポートできるようにするプラグインです。',
    'user csv all save' => 'ユーザーCSVデータを一括登録する',
    'AuthorRegistration' => 'ユーザーの一括管理', 
    'file upload error'  => 'ファイルのアップロードに失敗しました。',
    'file suffix error'  => 'ファイルの拡張子がcsvではありません',
    'title field error. field:[_1] not find'  => 'タイトルにフィールド[_1]が見つかりません。',
    'csv data field count error'  => '不正なデータ：フィールド数が足りません。',
    'user data import save'  => 'ユーザー一括登録を行いました。',
    'all count : [_1]'    => '全 [_1] 件中',
    'add count : [_1]'    => '追加 [_1] 件',
    'update count : [_1]' => '上書 [_1] 件',
    'skip count : [_1]'   => '未処理 [_1] 件',
    'error count : [_1]'  => 'エラー [_1] 件',
    '<a href="[_1]">show log<a>'  => ' 詳しくは<a href="[_1]">ログを確認</a>してください',
    '[_1] line: csv import error.<[_2]>'  => '[_1]行目: CSVデータ取込中にエラーが発生しました。「[_2]」',
    '[_1] line: same name user error. author_name:[_2]'  => '[_1]行目 同名のユーザーがすでに存在します。author_name:[_2]',
    '[_1] line: same id user error. author_id:[_2] author_name:[_3]' => '[_1]行目 同一のIDがすでに存在します。author_id:[_2] author_name:[_3]',
    '[_1] line: author_id error.'  => '[_1]行目 author_idが不正です。',
    '[_1] line: user save error.'  => '[_1]行目 ユーザーの登録に失敗しました。',
    '[_1] line: role save error. role_id:[_2]'  => '[_1]行目 ユーザー権限の登録に失敗しました。role_id:[_2]',
    '[_1] line:'  => '[_1]行目 ',
    'csv data error: [_1]'  => 'CSV: [_1]の値が不正です。',
    'csv data error: [_1] value: [_2]'  => 'CSV: [_1]の値が不正です。値:[_2]',
    'select import user csv file.' => '取込むユーザーのデータが保存されたCSVファイルを選択します。',
    'same author_id updated.' => 'CSVファイルに同じユーザーIDが存在する場合、そのユーザーを上書きします。',
    'csv file' => 'CSVファイル',
    'Export Authors' => 'ユーザーの一括出力',
    'Import Authors' => 'ユーザーの一括登録',
    'author data csv import' => 'ユーザーをCSVフォーマットで登録します。',
    'all save' => 'CSVフォーマットで一括登録する',
    'author data csv export' => 'ユーザーをCSVフォーマットで出力します。',
    'export csv' => 'CSVフォーマットで出力する',
    'Overwrite authors' => 'ユーザーを上書きする',
);

1;