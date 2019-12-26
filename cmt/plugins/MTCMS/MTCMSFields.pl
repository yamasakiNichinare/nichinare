package MT::Plugin::AddField;

use strict;
use warnings;

use MT;
use MT::Blog;

use vars qw( $PLUGIN_NAME $VERSION $ADD_FIELD_NAME_1 $ADD_FIELD_NAME_2 $ADD_FIELD_NAME_5 $ADD_FIELD_NAME_6 $ADD_FIELD_NAME_7 $ADD_FIELD_NAME_8 $ADD_FIELD_NAME_9);
$PLUGIN_NAME = 'AddField';
$VERSION = '1.01';

## 拡張するフィールド名
$ADD_FIELD_NAME_1 = 'entry_important';
$ADD_FIELD_NAME_2 = 'website_keywords';
$ADD_FIELD_NAME_5 = 'entry_extref';
$ADD_FIELD_NAME_6 = 'website_analytics';
$ADD_FIELD_NAME_7 = 'website_copyright';
$ADD_FIELD_NAME_8 = 'website_title';

use base qw( MT::Plugin );
@MT::Plugin::AddField::ISA = qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
    name    => $PLUGIN_NAME,
    version => $VERSION,
    author_name => 'SKYARC System Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
    l10n_class     => 'AddField::L10N',
    description => <<HTMLHEREDOC,
entry add field.
HTMLHEREDOC
});
MT->add_plugin( $plugin );

sub instance { $plugin; }

### Registry initialization
sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        init_app => \&_init_app,
    });
}

sub _init_app {

    ## 強制的に作成します。カスタムフィールド画面で削除しても再作成されます。
    
    ## ■オブジェクトタイプについて、以下の種類があります。
    ## entry :ブログ記事
    ## page  :ウェブページ
    ## category  :カテゴリ
    ## folder  :フォルダ
    ## author  :ユーザー (ブログIDを指定する場合は、使用できません、グローバルのみ)

    ## ■データの型について、以下の種類があります。
    ## text :テキスト
    ## textarea :テキスト(複数行)
    ## checkbox :チェックボックス
    ## url :URL
    ## datetime :日付と時刻   オプションでfield_optionsの値が必要 (datetime or date or time)
    ## select :ドロップダウン オプションでfield_optionsの値が必要（値をカンマ区切りで入力）
    ## radio :ラジオボタン オプションでfield_optionsの値が必要（値をカンマ区切りで入力）
    ## asset :アイテム (ブログIDを指定する場合のみ）
    ## asset.audio :オーディオ(ブログIDを指定する場合のみ）
    ## asset.video :ビデオ(ブログIDを指定する場合のみ）
    ## asset.image :画像(ブログIDを指定する場合のみ）
    
    my ($custom);
## ADD_FIELD_NAME_1 追加用 **************************************************************************
    $custom = CustomFields::Field->load({ basename => $ADD_FIELD_NAME_1 } );
    unless($custom){
        $custom = CustomFields::Field->new;
        $custom->blog_id(0);                       ## 0でシステム全体、ブログを特定する場合、ブログIDを指定
        $custom->name($plugin->translate('Important Entry'));    ## カスタムフィールド名
        $custom->basename($ADD_FIELD_NAME_1);      ## base_name
        $custom->obj_type('entry');                ## オブジェクトタイプ
        $custom->type('checkbox');                 ## データの型
        $custom->tag('entryimportant');            ## ※ユニークな名前を付けてください。MTのタグ名 (頭にMTは自動的につきます)
        $custom->required(0);                      ## 必項目フラグ
        $custom->description($plugin->translate('If you specify a important entry, please check.')); ## 項目の説明
        $custom->options('');                      ## オプションが必要な場合。type が、datetime,select,radioの場合
        $custom->save;
    }

## ADD_FIELD_NAME_2 追加用 **************************************************************************
    $custom = CustomFields::Field->load({ basename => $ADD_FIELD_NAME_2 } );
    unless($custom){
        $custom = CustomFields::Field->new;
        $custom->blog_id(0);                       ## 0でシステム全体、ブログを特定する場合、ブログIDを指定
        $custom->name($plugin->translate('Website keywords'));  ## カスタムフィールド名
        $custom->basename($ADD_FIELD_NAME_2);      ## base_name
        $custom->obj_type('website');              ## オブジェクトタイプ
        $custom->type('text');                     ## データの型
        $custom->tag('websitekeywords');               ## ※ユニークな名前を付けてください。MTのタグ名 (頭にMTは自動的につきます)
        $custom->required(0);                      ## 必項目フラグ
        $custom->description($plugin->translate('Website META Keywords Common Please enter separated by commas.'));  ## 項目の説明
        $custom->options('');                      ## オプションが必要な場合。type が、datetime,select,radioの場合
        $custom->save;
    }

## ADD_FIELD_NAME_5 追加用 **************************************************************************
    $custom = CustomFields::Field->load({ basename => $ADD_FIELD_NAME_5 } );
    unless($custom){
        $custom = CustomFields::Field->new;
        $custom->blog_id(0);                       ## 0でシステム全体、ブログを特定する場合、ブログIDを指定
        $custom->name($plugin->translate('External site links'));          ## カスタムフィールド名
        $custom->basename($ADD_FIELD_NAME_5);      ## base_name
        $custom->obj_type('entry');               ## オブジェクトタイプ
        $custom->type('text');                     ## データの型
        $custom->tag('entryextref');            ## ※ユニークな名前を付けてください。MTのタグ名 (頭にMTは自動的につきます)
        $custom->required(0);                      ## 必項目フラグ
        $custom->description($plugin->translate('If you want to change the link to an external site article list, please enter the URL here.')); ## 項目の説明
        $custom->options('');                      ## オプションが必要な場合。type が、datetime,select,radioの場合
        $custom->save;
    }

## ADD_FIELD_NAME_6 追加用 **************************************************************************
    $custom = CustomFields::Field->load({ basename => $ADD_FIELD_NAME_6 } );
    unless($custom){
        $custom = CustomFields::Field->new;
        $custom->blog_id(0);                       ## 0でシステム全体、ブログを特定する場合、ブログIDを指定
        $custom->name($plugin->translate('Tag access analysis'));          ## カスタムフィールド名
        $custom->basename($ADD_FIELD_NAME_6);      ## base_name
        $custom->obj_type('website');               ## オブジェクトタイプ
        $custom->type('textarea');                     ## データの型
        $custom->tag('websiteanaliticstag');            ## ※ユニークな名前を付けてください。MTのタグ名 (頭にMTは自動的につきます)
        $custom->required(0);                      ## 必項目フラグ
        $custom->description($plugin->translate('Please enter the tag web analytics.'));                  ## 項目の説明
        $custom->options('');                      ## オプションが必要な場合。type が、datetime,select,radioの場合
        $custom->save;
    }

## ADD_FIELD_NAME_7 追加用 **************************************************************************
    $custom = CustomFields::Field->load({ basename => $ADD_FIELD_NAME_7 } );
    unless($custom){
        $custom = CustomFields::Field->new;
        $custom->blog_id(0);                       ## 0でシステム全体、ブログを特定する場合、ブログIDを指定
        $custom->name($plugin->translate('Copyright')); ## カスタムフィールド名
        $custom->basename($ADD_FIELD_NAME_7);      ## base_name
        $custom->obj_type('website');               ## オブジェクトタイプ
        $custom->type('text');                     ## データの型
        $custom->tag('websitecopyright');            ## ※ユニークな名前を付けてください。MTのタグ名 (頭にMTは自動的につきます)
        $custom->required(0);                      ## 必項目フラグ
        $custom->description($plugin->translate('Please enter the copyright. example) SKYARC System Co., Ltd,')); ## 項目の説明
        $custom->options('');                      ## オプションが必要な場合。type が、datetime,select,radioの場合
        $custom->save;
    }
## ADD_FIELD_NAME_8 追加用 **************************************************************************
    $custom = CustomFields::Field->load({ basename => $ADD_FIELD_NAME_8 } );
    unless($custom){
        $custom = CustomFields::Field->new;
        $custom->blog_id(0);                       ## 0でシステム全体、ブログを特定する場合、ブログIDを指定
        $custom->name($plugin->translate('Website Title'));          ## カスタムフィールド名
        $custom->basename($ADD_FIELD_NAME_8);      ## base_name
        $custom->obj_type('website');               ## オブジェクトタイプ
        $custom->type('text');                     ## データの型
        $custom->tag('websitetitle');            ## ※ユニークな名前を付けてください。MTのタグ名 (頭にMTは自動的につきます)
        $custom->required(0);                      ## 必項目フラグ
        $custom->description($plugin->translate('Please enter the TITLE of the website. example) Sukaiakushisutemu service site.')); ## 項目の説明
        $custom->options('');                      ## オプションが必要な場合。type が、datetime,select,radioの場合
        $custom->save;
    }

}
1;
__END__
