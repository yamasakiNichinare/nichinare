package CategoryImExporter::L10N::ja;

use strict;
use base 'CategoryImExporter::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'Export category settings to CSV file. And import them from exported CSV file.' => 'カテゴリ設定をCSVファイルにエクスポートします。また、エクスポートされたCSVファイルから設定をインポートします。',
    'Category management' => 'カテゴリの一括管理',
    'Folder management' => 'フォルダの一括管理',
    #
    'Export [_1] Setting' => '[_1]のエクスポート',
    'Exporting the [_1] setting as a CSV file.' => '[_1]の設定をCSVファイルとしてエクスポートします。',
    'Export settings' => '設定のエクスポート',
    'Import [_1] Setting' => '[_1]のインポート',
    'Importing the [_1] setting from the uploaded CSV file.' => '[_1]の設定をアップロードされたCSVファイルからインポートします。',
    'CSV File' => 'CSVファイル',
    'Select the CSV file of exported setting' => 'エクスポートされた設定の書かれたCSVファイルを選択してください',
    'Overwrite' => '上書き',
    'If there are any items have same ID, The old one will be over-written.' => '同じIDを持つ項目があった場合、古いものを上書きします。',
    'Import settings' => '設定のインポート',
    # CMS.pm
    'File upload error' => 'ファイルのアップロードに失敗しました',
    'CSV file type error: [_1]' => 'CSVファイルの型が不正です: [_1]',
    'CSV file has been proceeded.' => 'CSVデータの一括登録を行いました。',
    'Lines: Total [_1] lines' => '全 [_1] 件中',
    'Newly created: [_1] items' => '追加 [_1] 件',
    'Updated: [_1] items' => '更新 [_1] 件',
    'Skipped: [_1] items' => '未処理 [_1] 件',
    'Errored: [_1] items' => 'エラー [_1] 件',
    'Warned : [_1] items' => '警告   [_1] 件',

    'Failed to parse csv. line:[_1]' => 'CSVの書式として解釈できませんでした。[_1]行目',
    'Culumns [_1] and [_2] are required.' => '[_1]と[_2]のカラムは必須カラムです。',
    'ID([_1]) can not be used. Are already available on other blogs or websites. line: [_2]'
       => '指定のID([_1])は別のウェブサイトもしくはブログで使用しています。[_2]行目',
    'Column ([_1]) You must enter a value. This column is required. line:[_2]'
       => 'カラム([_1])の値がありません。このカラムの値は必須です。[_2]行目',
    'Datetime column ([_1]) improper values, we substitute a default value. line: [_2]'
       => '日時指定カラム([_1])の値が不正です。現在の時間に置き換えました。[_2]行目',
    'Failed to save. line: [_1] [_2]' => '保存に失敗しました。[_1]行目 内容:[_2]',
);

1;
