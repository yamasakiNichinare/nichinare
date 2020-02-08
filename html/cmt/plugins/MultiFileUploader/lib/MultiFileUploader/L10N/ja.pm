package MultiFileUploader::L10N::ja;

use strict;
use base qw(MultiFileUploader::L10N);

our %Lexicon = (
    'Enable you to upload some files multiplly at once.' => '複数のファイルを一度にアップロードできるようにします。',
	'Please input tag' => 'タグを入力して下さい。',
	'MultiFileUploader' => '複数アップロード',
    'Please input size' => '画像をリサイズする場合は縦/横(ピクセル)の値を入力してください。片方のみ指定可能です。',
    'The following files were overwrited' => '以下のファイルを上書きしました。',
    'The following files are uploaded skipped' => '以下のファイルはアップロードをスキップしました。',
    'overwrite' => '同名のファイルが存在した場合',
    'overwrite_yes' => '上書きする',
    'overwrite_no' => '何もしない',
    'Skip the file' => 'そのファイルをスキップ',
    'Overwriting alert' => 'ファイルの上書き警告',
    'height and widh cannot be specified' => 'リサイズする場合はサイズ(ピクセル値)を入力して下さい。',
    'Invalid param' => '入力された値に問題があります',
    'height' => '縦', 
    'width' => '横',
    'Height' => '縦', 
    'Width' => '横',
    'Image resize mode' => '画像リサイズ設定', 
    'Maximum image size' => '画像サイズの上限',
    'pixel' => 'ピクセル',
    'returns to the list' => 'アイテムの一覧に戻る',
    'Uploading...' => 'アップロード中…',
    'error while writing image file: [_1]' => 'イメージファイルの書き込み時にエラーが発生しました。[_1]',
    'Finish uploading files.' => 'ファイルのアップロードが完了しました。',
    'Click me if you can\'t use Shockwave Flash' => '「参照」ボタンが表示されない場合はこちらをクリックしてください。',
    'Assets manage click here.' => 'アイテム一覧を見る',
    'Uploading ...' => 'アップロード中 ...',
    'Skipped because already existing file of same filename' => '同名のファイルが既に存在したためにスキップ',
    'Invalid filename. please rename with alpha-numeric characters only.' => '無効なファイル名です。英数字のファイル名に変更してください。',
	'As initial value' => '初期値とする',
	'As fixed value' => '固定値とする',
	'Follow [_1] settings' => '[_1]の設定に従う',
	'Behavior of image resize within upload.' => '画像をアップロードした際のサイズ調整設定を行います。',
	'Maximum size of uploaded image (height or width).' => 'リサイズする場合の最大画像サイズ（幅または高さ）。',
	'Web site' => 'ウェブサイト',
	'Image size must be numerical.' => '画像サイズは数値で入力してください。',
	'Replace upload menu' => 'ファイルアップロードメニューの置き換え',
	'Replace "[_1]" in the menu with multi file uploader.' => 'メニュー内の「[_1]」を複数ファイルアップローダーで置き換えます。',
	'Enabled' => '有効',
	'Disabled' => '無効',
	'Asset:New' => 'アイテム：新規',
);

1;