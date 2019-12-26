package Sitemap::L10N::ja;

use strict;
use MT;
require utf8 if 5.0 <= $MT::VERSION;
use base 'Sitemap::L10N';

use vars qw( %Lexicon );
%Lexicon = (
    'Overviewing your websites, blogs and webpages.' => 'ウェブサイトやブログ、ウェブページを俯瞰して表示します',
    'All Sitemap Overviewing' => '全てのサイトの概要',
    'Sitemap Overviewing' => 'サイト全体の概要',
    'Blog Overviewing' => 'ブログ全体の概要',
    'Website Overviewing' => 'ウェブサイト全体の概要',
    'Dashboard' => '移動',
    'Edit' => '編集',
    'View' => '表示',
    'Rebuild' => '再構築',
    'Config' => '設定',
    'Folder Config' => 'フォルダの設定',
    'Category Config' => 'カテゴリの設定',
    'Output basename' => '出力ファイル名',
    'Create New Webpage' => 'ウェブページ作成',
    'Create New Blog entry' => 'ブログ記事作成',
    'Create Category' => 'カテゴリを作成',
    'Create Sub Category' => 'サブカテゴリを作成',
    'Delete Category' => 'カテゴリを削除',
    'Create Folder' => 'フォルダを作成',
    'Create Sub Folder' => 'サブフォルダを作成',
    'Delete Folder' => 'フォルダを削除',
    'Assets List' => 'アイテム一覧',
    'Folders List' => 'フォルダ一覧',
    'Categories List' => 'カテゴリ一覧',
    'Page List' => 'ウェブページ一覧',
    'Entry List' => 'ブログ記事一覧',
    'Edit entry' => 'ブログ記事の編集',
    'Edit page' => 'ウェブページの編集',
    'More ([_1] entries) ...' => '更に見る(全[_1]件)...',
    'All entries ...' => '全ての記事...',
    'Blogs and websites that do not have permission.' => '権限があるウェブサイト・ブログがありません。',
    'No objects could be found.' => 'オブジェクトがありません。',
	'Delete' => '削除',
	'Cancel' => 'キャンセル',
    'Create new [_1] with following settings' => '以下の内容で[_1]を新規作成します。',
    'If you do advanced editing and folder, then create a new [_1],' => '[_1]の編集及び詳細設定を行う場合には、[_1]を新規作成後に、',
    'Sitemap dashboard from the name that appears in the [_1] you created Mausuonmenyu [Settings] from please go.' => 'サイトマップダッシュボードから、作成した[_1]名のマウスオンメニューで表示される「設定」から行って下さい。',
    'Delete the [_1].' => '[_1]を削除します。',
    'Are you sure to remove this [_1] ?' => 'この[_1]を本当に削除しても宜しいですか？',
    '[_1] information to be deleted' => '削除される[_1]の情報',

    # EditCategoryInDialog
    'Enable you to edit category/folder in dialog mode.' => 'カテゴリ/フォルダをダイアログモードで編集できるようにします',

    # AssetFilterByFolder
    'Filter assets by the deployed folders' => '配置されたフォルダに応じてアイテムをフィルタします',
);

1;