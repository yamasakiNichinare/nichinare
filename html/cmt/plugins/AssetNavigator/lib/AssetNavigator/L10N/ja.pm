package AssetNavigator::L10N::ja;

use strict;
use base qw( AssetNavigator::L10N );

use vars qw( %Lexicon );
%Lexicon = (
    # pl
    'Enable you to drag and drop the assets into WYSIWYG editor from assets navigator.' => 'アセットをドラッグ＆ドロップでWYSIWYGエディタに挿入できます。',
    # config.tmpl
    'Thumbnail Size' => 'サムネイル画像のサイズ',
    'pixels ' => 'ピクセル',
    'input the pixels of thumbnail images' => 'サムネイル画像のピクセル値を入力してください',
    # CMS.pm
    'Entry assets of this entry' => 'このページのアイテム',
    'Recent uploaded assets' => '最近アップロードされたアイテム',
    'All assets' => '全てのアイテム',
    # tmpl/asset_navi.tmpl
    'Focus by filename' => 'ファイル名で探す',
    'No entry assets' => 'このページに所属するアイテムはありません',
    'Upload new item on this folder' => '新規アイテムのアップロード',
    'For registering the entry assets to this page, at first once you should save this page.' => 'アップロードしたアイテムをこのページに関連づけるには、一旦、このページを保存してください。',
);

1;