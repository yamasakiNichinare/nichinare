package DynamicViewer::Settings;

use strict;
use warnings;
use CGI::Carp;
use MT 5;
use base qw( MT::App::CMS );
use MT::Util qw( encode_html );
use File::Spec;
use File::Basename;
use Data::Dumper;

sub plugin_class { MT->instance->component( 'DynamicViewer' ); };

## 許容権限 システム管理者 (未使用)
sub _accept_system_permission {
    my $app = shift;

    return 0 unless $app->user;
    return 1 if $app->user->is_superuser;

    my $perms = MT::Permission->load({ blog_id => 0 , 'author_id' => $app->user->id }) || '';
    return 1 if $perms && $perms->can_administer;

    return 0;

}

##  許容権限 ウェブサイト管理者
sub _accept_website_permission {
    my ( $app , $blog ) = @_;

    return 0 unless $app->user;
    return 1 if $app->user->is_superuser;

    my $perms = MT::Permission->load({ blog_id => 0 , 'author_id' => $app->user->id }) || '';
    return 1 if $perms && $perms->can_administer;

    $blog = $blog->website if $blog->is_blog;
    $perms = MT::Permission->load({ blog_id => $blog->id , 'author_id' => $app->user->id })
        or return 0;
    return 1 if $perms->can_administer;

    return 0;

}

## 実行スコープ判定 ( ブログ,ウェブサイトのみ )
sub _accept_scope {
    my $app = shift;
    return $app->param('blog_id') ? 1 : 0;
}

## 機能実行権限判定
sub _accept_request {
    my ( $app ) = @_;

   ## 実行権限
    return $app->error( $app->translate('Invalid request.') )
       unless ref $app eq 'MT::App::CMS';

    my $blog = $app->blog
          || ( $app->param('blog_id') && MT::Blog->load($app->param('blog_id')) )
          || return return $app->error( $app->translate('Invalid request.') );

    return $app->error( $app->translate('Permission denied.') )
       unless _accept_website_permission( $app , $blog );

    return $blog;

}

## メニュー表示判定 ( システム画面では表示しない  )
sub menu_condition {
    my $app = MT->instance;
    return 0 if 'MT::App::CMS' ne ref $app;
    return 0 unless _accept_scope( $app );
    my $blog = $app->blog
          || ( $app->param('blog_id') && MT::Blog->load($app->param('blog_id')) )
          || return 0;
    return _accept_website_permission( $app , $blog );
}

##############################################################################

## ウェブサイトから配下の継承設定が有効になっている全ブログを指定
sub prepare {
    my $app = shift;

    ## 実行権限の判定
    my $site = _accept_request( $app ) or return;

    ## プラグインデータ取得
    my $plugin = plugin_class();
    my $param = $plugin->load_plugin_param( $site->id );

    ## 継承
    if( $site->is_blog && $param->{'inheritance'} ){
        my $owner_param = $plugin->load_plugin_param( $site->website->id );
        foreach my $key ( keys %{$owner_param} ){
             next if $key eq 'inheritance' || 'exclude_path';
             $param->{$key} = $owner_param->{$key};
        }
    }

    ## テンプレート用パラメター追加
    $param->{'is_website'}  = $site->is_blog ? 0 : 1;
    $param->{'is_blog'}     = $site->is_blog ? 1 : 0;
    $param->{'return_args'} = $site->id;

    $param->{'mode'} = 'dynamic_viewer_execute';
    $param->{'phase'} = 'save_config';

    $param->{'script_uri'} = $app->uri();
    $param->{'blog_id'} = $site->id;

    $param->{'system_overview_navi'} = 1;
    $param->{'screen_group'} = 'settings';

    $param->{'saved'} = $app->param('saved') || 0;
    $param->{'error'} = encode_html( $app->param('error') ) || '';

    ## テンプレート表示
    $app->build_menus ( $param );
    return $plugin->load_tmpl ( $plugin->name . '/cms/edit_config.tmpl', $param );
}

## 設定実行
sub execute {
    my $app = shift;

    ## 実行権限の判定
    my $site = _accept_request( $app ) or return;

    ## 実行フェーズ設定
    my %phase_method = (
        'save_config'    => \&_save_config,
        'proxy_settings' => \&_proxy_settings
    );

    ## フェーズ判定
    my $phase = $app->param('phase') || '';
    return $app->error( $app->translate('Invalid request.') )
             unless $phase && exists $phase_method{$phase};

    ## 実行
    return &{ $phase_method{$phase} }( $app , $site );
}

##############################################################################

sub improved_path {
   return $_[0] if $_[0] eq '/';
   $_[0] =~ s|/$||;
   return $_[0];
}
sub improved_url {
   return $_[0] if $_[0] =~ m|/$|;
   return $_[0] . '/';
}

## PHASE:プロキシ設置
sub _proxy_settings {
    my ( $app , $site ) = @_;

    my $plugin = plugin_class();

    ## プロキシ設置開始用のテンプレート表示
    my %param;
    $param{'is_website'} = $site->is_blog ? 0 : 1;
    $param{'is_blog'}    = $site->is_blog ? 1 : 0;
    $param{'script_uri'} = $app->uri();

    $param{'max_phase'} = $app->param('max');
    $param{'accumulation'} = $app->param('ac');

    $param{'system_overview_navi'} = 1;
    $param{'screen_group'} = 'settings';

    $param{'site_name'} = $site->name;

    ## 進行率計算
    $param{'progress'} = $param{'accumulation'} ? int($param{'accumulation'} / $param{'max_phase'} * 100 ) : 0;
    $param{'progress'} = 100 if $param{'progress'} > 100;

    $param{'remove_flag'} = 0;
    if( $param{'accumulation'} < $param{'max_phase'} ){
 
        ## ブログデータ
        my @blogs;
        @blogs = split( '_' , $app->param('next') ) if $app->param('next');
        return return $app->error( $app->translate('Invalid request.') ) 
            unless scalar @blogs;

        my $blog_id = shift @blogs;
        $param{'accumulation'}++;

        ## 次へ
        $param{'next'} = sprintf(
           '__mode=%s&blog_id=%s&phase=%s&max=%s&ac=%s&next=%s&return_args=%s',
           'dynamic_viewer_execute',
           $blog_id,
           'proxy_settings',
           $param{'max_phase'},
           $param{'accumulation'},
           scalar @blogs > 1 ? join '_' , @blogs : shift @blogs,
           $app->param('return_args') || ''
       );

    }else{

        ## 終了
        $param{'next'} = sprintf(
           '__mode=%s&blog_id=%s&saved=1',
           'dynamic_viewer_prepare',
           $app->param('return_args') || ''
       );

    }

    ## プロキシの設置
    my $remove_flag = rebuild_proxy_files( $app , $plugin , $site );
    $param{'remove_flag'} = $remove_flag == 2
        ? 0
        : 1;

    ## 表示
    $app->build_menus ( \%param );
    return $plugin->load_tmpl ( $plugin->name . '/cms/proxy_settings.tmpl', \%param );
}


## PHASE:プラグイン保存
sub _save_config {
    my ( $app , $site ) = @_;

    my $plugin = plugin_class();

    ## 保存前の状態
    my $old_param = $plugin->load_plugin_param( $site->id );

    ## プラグインデータ抽出（空白、0は指定しない)
    my %param = '';
    my @keys = $plugin->config_vars( 'blog' );
    for ( @keys ){
        $param{$_} = $app->param($_) || undef;
    }
    
    ## プラグインデータ保存（継承関係にあるものも対象)
     $plugin->save_proxy_setting( \%param , $site );

    ## プロキシ設置の再実行が必要なサイトを抽出
    my @blogs;
    my $plugin_param = '';
    if( !$site->is_blog ){

       ##ウェブサイト
       for my $blog ( @{ $site->blogs } ){

          $plugin_param = $plugin->load_plugin_param( $blog->id );
          next unless $plugin_param->{'inheritance'};

          ##継承された配下のブログも同時に処理する。
          push @blogs , $blog->id;
       }
       push @blogs , $site->id;

    }else{

       ## ブログ
       my $plugin_param = $plugin->load_plugin_param( $site->id );
       push @blogs , $site->id;
       push @blogs , $site->website->id;

    }
 
#    return $app->redirect( $app->uri . '?' . $app->param('return_args') . '&saved=1' );

    ## プロキシ設置開始用のテンプレート表示
    $param{'is_website'} = $site->is_blog ? 0 : 1;
    $param{'is_blog'}    = $site->is_blog ? 1 : 0;
    $param{'script_uri'} = $app->uri();
    $param{'max_phase'}    = scalar @blogs;
    $param{'accumulation'} = 0;
    $param{'progress'}     = 0;
    $param{'system_overview_navi'} = 1;
    $param{'screen_group'} = 'settings';
    $param{'site_name'} = $site->name;

    ## 処理するブログを設置
    my $blog_id = shift @blogs;

    $param{'next'} = sprintf(
        '__mode=%s&blog_id=%s&phase=%s&max=%s&ac=%s&next=%s&return_args=%s',
        'dynamic_viewer_execute',
        $blog_id,
        'proxy_settings',
        $param{'max_phase'},
        1,
        scalar @blogs > 1 ? join '_' , @blogs : shift @blogs,
        $app->param('return_args') || ''
    );

    ## 表示
    $app->build_menus ( \%param );
    return $plugin->load_tmpl ( $plugin->name . '/cms/proxy_settings.tmpl', \%param );
}


##############################################################################

# プロキシ設置処理
sub rebuild_proxy_files {
    my ( $app , $plugin , $site ) = @_;

    ## プラグイン設定読込
    my $system = $plugin->load_plugin_param( 0 );
    my $param  = $plugin->load_plugin_param( $site->id );

    my $proxy_path   = File::Spec->catfile( improved_path( $site->site_path ) , $plugin->proxy_name );
    my $webconf_path = File::Spec->catfile( improved_path( $site->site_path ) , $system->{'platform'} ? 'web.config' : '.htaccess' );

    ## プロキシの削除
    unless( $param->{'status'} ){

        my $err = '';
        if( -f $webconf_path ){
            remove_file( $app , $webconf_path ) or return -1;
        }
        if( -f $proxy_path ){
            remove_file( $app , $proxy_path ) or return -1;
        }
        return 1; ## プロキシの取り外し完了
    }

    ## グループ情報
    ##  
    ##  path   : サイトのパス
    ##  url    : サイトのＵＲＬ
    ##  blog   : 0: ウェブサイト 1 :ブログ
    ##  website: 0: ブログ 1: ウェブサイト
    ##  owner  : 継承元ウェブサイト(0の場合、自身がオーナー)
    ##  auth   : 認証を利用
    ##  error  : エラーページのテンプレートタイプ
    ##  error_page  : エラーページ名
    ##  error_tmpl  : テンプレート位置情報(DBの場合はIDを指定)
    ##  

    my %group_blogs =();
    my $owner = '';
    my $owner_param = $param;
    my %exclude_blogs;
    my ( $blog , $website ) = ( '' , '' );

    if( $site->is_blog && !$param->{'inheritance'} ){
         $owner = $site;

         ## オーナー以外のブログもしくはウェブサイト
         my $iter = MT::Website->load_iter();
         while( $website = $iter->() ){
             foreach $blog ( @{ $website->blogs } ){
                  next if $owner->id == $blog->id;
                  $exclude_blogs{$blog->id} = ({
                      'path' => improved_path( $website->site_path ),
                      'url' => improved_url( $website->site_url ),
                      'website' => 1,
                      'blog' => 0,
                  });
             }
             $exclude_blogs{$website->id} = ({
                  'path' => improved_path( $website->site_path ),
                  'url' => improved_url( $website->site_url ),
                  'website' => 1,
                  'blog' => 0,
             });
         }

    }else{
         
         ## グループ
         $owner = $site->is_blog ? $site->website : $site;
         foreach $blog ( @{ $owner->blogs } ){
             my $child_param = $plugin->load_plugin_param($blog->id);
             if( $child_param->{'inheritance'} ){
                   $group_blogs{$blog->id} = ({
                      'path'  => improved_path( $blog->site_path ),
                      'url'   => improved_url( $blog->site_url ),
                      'blog'  => 1,
                      'website' => 0,
                      'auth'  => $owner_param->{'authentication'} ? 1 : 0,
                      'owner' => $owner->id,
                   });
             }else{
                   $exclude_blogs{$blog->id} = ({
                       'path' => improved_path( $blog->site_path ),
                       'url' => improved_url( $blog->site_url ),
                       'blog' => 1,
                       'website' => 0,
                   });
             }
         }
         ## オーナー以外のウェブサイトおよび配下ブログ
         my $iter = MT::Website->load_iter();
         while( $website = $iter->() ){
             next if $owner->id == $website->id;
             foreach $blog ( @{ $website->blogs } ){
                  $exclude_blogs{$blog->id} = ({
                       'path' => improved_path( $blog->site_path ),
                       'url' => improved_url( $blog->site_url ),
                       'blog' => 1,
                       'website' => 0,
                   });
             }
             $exclude_blogs{$website->id} = ({
                  'path' => improved_path( $website->site_path ),
                  'url' => improved_url( $website->site_url ),
                  'website' => 1,
                  'blog' => 0,
             });
         }
    }
    ## グループオーナーの設定
    $group_blogs{$owner->id} = ({
         'path'  => improved_path( $owner->site_path ),
         'url'   => improved_url( $owner->site_url ),
         'blog'  => $owner->is_blog ? 1 : 0,
         'website' => $owner->is_blog ? 0 : 1,
         'auth'  => $owner_param->{'authentication'} ? 1 : 0,
         'owner' => 0,
    });

    ## サイト情報の設定
    ##
    ##  script_path :
    ##  script_url  :
    ##  static_path :
    ##  static_url  :
    ##  site_path   :
    ##  stie_url    :
    ##  owner_id    : website or 0
    ##  id          : website or blog id
    ##  plugin_path : プラグインパス
    ##  platform    : 0 apache , 1 iis
    ##
    my %site_info;
    eval {

       $site_info{'script_url'} = $app->config( 'CGIPath' );
       $site_info{'script_url'} .= '/' unless $site_info{'script_url'} =~ m!/$!;
       if( $site_info{'script_url'} =~ m!^/! ){

          $site_info{'script_host'} = $ENV{'SERVER_PORT'} == 80 || $ENV{'SERVER_PORT'} == 443 
               ? $ENV{'SERVER_ADDR'}
               : $ENV{'SERVER_ADDR'} . ":" . $ENV{'SERVER_PORT'};

          $site_info{'script_host'} = exists $ENV{'HTTPS'} && $ENV{'HTTPS'} eq 'on' 
               ? 'https://' . $site_info{'script_host'} 
               : 'http://' . $site_info{'script_host'};

          $site_info{'script_url'} = $site_info{'script_host'} . $site_info{'script_url'};

       }
       $site_info{'script_path'} = $app->server_path();
       $site_info{'script_path'} =~ s!/*$!!;

       $site_info{'static_url'}  = $app->config('StaticWebPath');
       unless( $site_info{'static_url'} ){
           $site_info{'script_url'} .= '/' unless $site_info{'script_url'} =~ m!/$!;
           $site_info{'script_url'} .= 'mt-static/';
       }
       if($site_info{'static_url'} =~ m!^/!) {
           if( $site->archive_url =~ m|(.+://[^/]+)| ){
                 $site_info{'static_url'} = $1 .  $site_info{'static_url'};
           }
       }
       $site_info{'static_url'} .= '/' unless $site_info{'static_url'} =~ m!/$!;

       $site_info{'static_path'} = $app->config( 'StaticFilePath' );
       if ( !$site_info{'static_path'} ) {
           $site_info{'static_path'} = $site_info{'script_path'};
           $site_info{'static_path'} .= '/' unless $site_info{'static_path'} =~ m!/$!;
           $site_info{'static_path'} .= 'mt-static/';
       }
       $site_info{'static_path'} =~ s!/*$!!;


       ## オーナー側の除外パス指定を継承する(+ pattern)指定された場合
       my $re_exclude_path = '';
       for ( split ( /\n\r?/ , $param->{'exclude_path'} ) ) {
           my $pattern = $_;
           $pattern = $1 if $_ =~ /^\+\s+(.*)$/;
           $re_exclude_path .= $re_exclude_path
                   ? "\n" . $pattern
                   : $pattern;
       }
       $param->{'exclude_path'} = $re_exclude_path;
       my $inheritance_exclude_path = "";
       if ( $group_blogs{$site->id}->{owner} ) {
           my $o_param = $plugin->load_plugin_param( $group_blogs{$site->id}->{owner} ); 
           for ( split( /\n\r?/ , $o_param->{'exclude_path'} ) ) {
               next unless $_ =~ /^\+\s+(.*)$/;
               $inheritance_exclude_path .= $inheritance_exclude_path
                     ? "\n" . $1
                     : $1;
           }
       }
       $param->{'exclude_path'} .= $param->{'exclude_path'} 
              ? "\n" . $inheritance_exclude_path
              : $inheritance_exclude_path;

       ## MovableTypeディレクトリがサイトに含まれる場合は除外する。
       my $f = 0;
       if( $f = is_site_inner_site( 
                    improved_url( $site->site_url ),
                    improved_path( $site->site_path ),
                    $site_info{'script_url'},
                    $site_info{'script_path'} ) ) {

            $param->{'exclude_path'} .= "\n". $site_info{'script_path'} . "/" if $f > 0;
       }
       if( $f = is_site_inner_site( 
                    improved_url( $site->site_url ),
                    improved_path( $site->site_path ),
                    $site_info{'static_url'},
                    $site_info{'static_path'} ) ){

            $param->{'exclude_path'} .= "\n" . $site_info{'static_path'} . "/" if $f > 0;
       }

       ## 除外するパスに除外ブログのパスを追加
       foreach my $id ( keys %exclude_blogs ){ 
           if( $f = is_site_inner_site( 
                    improved_url( $site->site_url ),
                    improved_path( $site->site_path ),
                    $exclude_blogs{$id}->{'url'},
                    $exclude_blogs{$id}->{'path'} ) ) {
               if( $f > 0 ){
                    $param->{'exclude_path'} .= "\n" . $exclude_blogs{$id}->{'path'};
                    $param->{'exclude_path'} .= "/" unless $exclude_blogs{$id}->{'path'} =~ m!/$!;
               }
           }
       }

    };
    if( $@ ){
         return $app->error( $@ );
    }
    $site_info{'owner_id'}    = $group_blogs{$site->id}->{'owner'};
    $site_info{'id'}          = $site->id;
    $site_info{'plugin_path'} = $plugin->path;
    $site_info{'site_path'}   = improved_path( $site->site_path );
    $site_info{'site_url'}    = improved_url( $site->site_url );
    $site_info{'platform'}    = $system->{'platform'};
    $site_info{'auth'}        = $param->{'authentication'} ? 1 : 0;

    ## 設定保存先
    ##
    $param->{'webconf_path'} = $webconf_path;
    $param->{'proxy_path'}   = $proxy_path;

    ## システムページ ( オーナーサイトの直下に設定される )
    ##
    ##   errro/login/logout  0:プラグイン専用テンプレート 1:ファイルパス 2:データベース上テンプレート(グループオーナー側)
    ##   *_page リクエスト用のページ名
    ##   *_tmpl ファイルパス/テンプレート名
    ##
    $site_info{'error'}      = $param->{'error_page_type'} || 0;
    $site_info{'error_page'} = $param->{'error_page_name'} || 'Error';
    $site_info{'error_tmpl'} = $site_info{'error'} ? $param->{'error_page_tmpl'} : '';

    my %auth_pages = (
       login => {
          type => $param->{'login_page_type'} || 0,
          page => $param->{'login_page_name'} || 'Login',
          tmpl => $param->{'login_page_tmpl'} || '',
       },
       logout => {
          type => $param->{'logout_page_type'} || 0,
          page => $param->{'logout_page_name'} || 'Logout',
          tmpl => $param->{'logout_page_tmpl'} || '',
       },
    );
    $site_info{'login'}      = $auth_pages{'login'}->{'type'};
    $site_info{'login_page'} = $auth_pages{'login'}->{'page'};
    $site_info{'login_tmpl'} = $auth_pages{'login'}->{'type'} ? $auth_pages{'login'}->{'tmpl'} : '';
    
    $site_info{'logout'}      = $auth_pages{'logout'}->{'type'};
    $site_info{'logout_page'} = $auth_pages{'logout'}->{'page'};
    $site_info{'logout_tmpl'} = $auth_pages{'logout'}->{'type'} ? $auth_pages{'logout'}->{'tmpl'} : '';

    ## MIME TYPES
    ##
    ##  suffix => contents type
    ##  
    my %mime_types = (
       'text' => 'text/plain',
       'txt'  => 'text/plain',
       'html' => 'text/html',
       'php'  => 'text/html',
       'xml'  => 'application/xhtml+xml',
       'css'  => 'text/css',
       'js'   => 'text/javascript',
       'gif'  => 'image/gif',
       'jpeg' => 'image/jpeg',
       'jpg'  => 'image/jpeg',
       'png'  => 'image/png',
       'zip'  => 'application/octet-stream',
       'tar'  => 'application/octet-stream',
       'gz'   => 'application/octet-stream',
       'xls'  => 'application/octet-stream',
       'xlsx' => 'application/octet-stream',
       'pdf'  => 'application/octet-stream',
       'doc'  => 'application/octet-stream',
       'docx' => 'application/octet-stream',
       'csv'  => 'application/actet-stream',
    );

    ## Directory Indexes
    ## 
    my @directory_indexes = (
      'index.php',
      'index.html',
      'index.htm',
      'index.xml',
      'default.htm',
      'default.html',
      'default.asp',
    );

    return 0 unless create_files( $app , $plugin , $param , \%site_info , \%group_blogs , \%mime_types , \@directory_indexes );
    return 2; ## プロキシの設置完了

}

## プロキシ、ウェブ設定ファイルを作成
sub create_files {
    my ( $app , $plugin , $param , $site_info , $group_blogs , $mime_types , $directory_indexes ) = @_;
    
    ## プロキシファイルの構築
    my $tmpl = proxy_template( $plugin );
    my $mt_path = $site_info->{'script_path'};
    $mt_path =~ s!\\!\\\\!g;
    $tmpl =~ s!%%MT_PATH%%!$mt_path!eg;
    my $plugin_path = $plugin->path;
    $plugin_path =~ s!\\!\\\\!g;
    $tmpl =~ s!%%PLUGIN_PATH%%!$plugin_path!eg;
    my $webconfig_permission = oct $app->config->DynamicViewerWebconfigPermission || 0644;
    my $cgi_permission = oct $app->config->DynamicViewerCGIPermission || 0755;

    {
         my ( $si , $gb , $mm , $di ) = ( ''  , '' , '' , '' );
         $Data::Dumper::Indent = 1;
         $Data::Dumper::Terse  = 1;
         
         $si = 'site_info => ' . Dumper( $site_info );
         $si =~ s!\n$!!g;
         $si .= ",\n";
         $gb = 'group_blogs => ' . Dumper( $group_blogs );
         $gb =~ s!\n$!!g;
         $gb .= ",\n";
         $mm = 'mime_types => ' . Dumper( $mime_types );
         $mm =~ s!\n$!!g;
         $mm .= ",\n";
         $di = 'directory_indexes => ' . Dumper( $directory_indexes );
         $di =~ s!\n$!!g;
         $di .= ",\n";

         $tmpl =~ s!%%SITE_INFO%%!$si!g;
         $tmpl =~ s!%%GROUP_BLOGS%%!$gb!g;
         $tmpl =~ s!%%MIME_TYPES%%!$mm!g;
         $tmpl =~ s!%%DIRECTORY_INDEXES%%!$di!g;
    }
    $param->{'proxy'} = $tmpl;

    ## ウェブ設定ファイルの構築
    my ( $exclude_path_tmpl , $exclude_path , $exclude_js , $exclude_css , $relative_path , $site_path ) 
           = ( '' , '' , '' , '' , '' , '' );

    $tmpl = webconf_template( $plugin , $site_info->{'platform'} );

    $site_path = $site_info->{'site_path'};
    if ( $site_info->{'platform'} ) {
       $site_path =~ s!/!\\!g if $site_path =~ m!\\!;
    }else{
       $site_path =~ s!\\!\/!g if $site_path =~ m!\\!;
    }
    $site_path =~ s!\\!\\\\!g;
    $tmpl =~ s!%%SITE_PATH%%!$site_path!g;
    $tmpl =~ s!%%PLUGIN_NAME%%!$plugin->proxy_name!ge;
    $tmpl =~ s!%%MT_PATH%%!$mt_path!g;

    ( $relative_path ) = $site_info->{'site_url'} =~ m!^(https?://[^\/]+)?(/.*)$! ? $2 : '/';
    $tmpl =~ s!%%RELATIVE_SITE_URL%%!$relative_path!g;

    $exclude_path_tmpl = '  RewriteCond %{REQUEST_FILENAME} !%%PATTERN%%';
    $exclude_js = '  RewriteCond %{REQUEST_FILENAME} !\.js$';
    $exclude_css = '  RewriteCond %{REQUEST_FILENAME} !\.css$';

    if ( $site_info->{'platform'} )
    {
        ## CHANGE: web.config ( IIS )
        $exclude_path_tmpl = '<add input="{REQUEST_FILENAME}" negate="true" pattern="%%PATTERN%%" ignoreCase="false" />';
        $exclude_js = '<add input="{REQUEST_FILENAME}" negate="true" pattern="\.js$" ignoreCase="false" />';
        $exclude_css = '<add input="{REQUEST_FILENAME}" negate="true" pattern="\.css$" ignoreCase="false" />';

    }
    if( $param->{'exclude_path'} ){
        my @paths = split( /\n\r?/ , $param->{'exclude_path'} );
        my $a = '';
        my $b = '';
        my %check = ();
        for( @paths ){
             $a = $_;
             $a =~ s|\s||g;
             next unless $a;

             if ( $a =~ /^!(.*)!$/ ) {
                 $a = $1; ## set regex pattern.
             } else {
                 $a =~ s!/!\\!g if $site_info->{'site_path'} =~ m!\\!;
                 my $sep = $site_info->{'site_path'} =~ m!\\! ? '\\' : '/';
                 $a = $site_info->{'site_path'} . $sep .  $a unless $a =~ m!^[\\/]|(?:[a-zA-Z]+\:)!;
                 $a =~ s!\\!\\\\!g;
                 $a =~ s|\.|\\.|g;
             }
             $b = $exclude_path_tmpl;
             $b =~ s!%%PATTERN%%!$a!;
             $exclude_path .= $b . "\n"
                 unless exists $check{$a};

             $check{$a} = 1;

        }
    }
    $tmpl =~ s!%%EXCLUDE_PATH_LIST%%!$exclude_path!g;
    $exclude_js = $param->{'exclude_js'}
        ? $exclude_js
        : '';
    $tmpl =~ s!%%EXCLUDE_JS%%!$exclude_js!g;
    $exclude_css = $param->{'exclude_css'}
        ? $exclude_css
        : '';
    $tmpl =~ s!%%EXCLUDE_CSS%%!$exclude_css!g;

    ##
    ## 保存
    ##
    
    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new( 'Local' )
         or die MT::FileMgr->errstr;

    ## サイトのディレクトリを作成
    unless( $fmgr->exists( $site_info->{'site_path'} )){
         $fmgr->mkpath(  $site_info->{'site_path'} )
              or die $fmgr->errstr;
    }

    if ( $site_info->{'platform'} )
    {
        ## CHANGE: web.config ( IIS )
        $tmpl =~ s!%%BLOGID%%!$site_info->{'id'}!eg;

        my $web_handlers = '';
        my $base_config = $fmgr->get_data( $param->{'webconf_path'} );
        unless ( $base_config )
        {
             ## MT側の設定を継承する。
             my $mt_webconfig = $fmgr->get_data( 
                  File::Spec->catfile( $site_info->{'script_path'}, 'web.config' ) 
                ) or die $fmgr->errstr;
             MT::I18N::utf8_off( $mt_webconfig ) if MT::I18N::is_utf8( $mt_webconfig );
             $web_handlers = $1 if $mt_webconfig =~ m!(<handlers[^>]*>.*</handlers>)!ms;
        }
        else
        {
             ## 既存の設定を継承する。
             MT::I18N::utf8_off( $base_config ) if MT::I18N::is_utf8( $base_config );
             $web_handlers = $1 if $base_config =~ m!(<handlers[^>]*>.*</handlers>)!ms;
        }

        if ( $web_handlers 
             && !$site_info->{'owner_id'} 
             && !webcofnig_inheritance_hanlder_search( $fmgr , $param->{'webconf_path'} ) )
        {
             ## アクセスポリシーにReadが含まれない場合、CGIの以外の参照は無効。exclude指定したファイルが読めないので変更する必要がる。
             $web_handlers =~ s!accessPolicy="[^\"]*"!accessPolicy="Read, Script"!;

        }else{
             $web_handlers = '';
        }
        
        $tmpl =~ s!%%HANDLERS_START%%.*%%HANDLERS_END%%!$web_handlers!ms;

        ## ディレクトリ階層の上位にあるブログのweb.config設定を引き継がない
        if ( $site_info->{'owner_id'} )
        {
           my $remove_rule = sprintf '<remove name="AccessControl-DynamicViewer-BLOG%s" />' , $site_info->{'owner_id'};
           $tmpl =~ s!%%REMOVE_RULE%%!$remove_rule!;
        }
        else
        {
           $tmpl =~ s!%%REMOVE_RULE%%!!;
        }
    }
    $tmpl =~ s/\\\\/\//g if !$site_info->{'platform'} && $tmpl =~ m/\\\\/;
    $param->{'webconf'} = $tmpl;

    ## ウェブ設置の保存
    $fmgr->put_data( $param->{'webconf'} , $param->{'webconf_path'} . '.new' )
         or die $fmgr->errstr;

    chmod( $webconfig_permission , $param->{'webconf_path'} . '.new' );
    if ( $fmgr->exists( $param->{'webconf_path'} ) )
    {
        ## バックアップ
        my $file = $fmgr->get_data( $param->{'webconf_path'} );
        if ( $file !~ m!DynamicViewer|AccessControl-DynamicViewer!g )
        {
             $fmgr->rename( $param->{'webconf_path'} , $param->{'webconf_path'} . '.bak' )
                    or die $fmgr->errstr;
        }
    }
    $fmgr->rename( $param->{'webconf_path'} . '.new' , $param->{'webconf_path'} )
               or die $fmgr->errstr;

    ## プロキシCGIファイルの作成
    $fmgr->put_data( $param->{'proxy'} , $param->{'proxy_path'} . '.new' )
             or die $fmgr->errstr;

    chmod( $cgi_permission , $param->{'proxy_path'}. '.new' );
    $fmgr->rename( $param->{'proxy_path'} . '.new' , $param->{'proxy_path'}  )
             or die $fmgr->errstr;

    ## fcgiの切り替えによって発生するゴミファイルを削除
    my $remove_file = $param->{'proxy_path'};
    if ( $remove_file =~ /\.fcgi$/ ) { 
       $remove_file =~ s/\.fcgi$/.cgi/;
    }   
    else {
       $remove_file =~ s/\.cgi$/.fcgi/;
    }   
    remove_file( $app , $remove_file );


    return 1;
}

## ファイル削除
##
sub remove_file {
    my ( $app , $path ) = @_;

    eval {
       unlink $path ;
    };
    if( $@ ){
         return $app->error( $@ );
    }
    return 1;
}

## 上位階層のディレクトリで設定されたweb.config内のスクリプトハンドラーに
## cgi-perlの設定が存在するか判定する。
sub webcofnig_inheritance_hanlder_search {
    my $fmgr = shift;
    my $search_path     = shift;

    my ( $volume , $path , undef ) =  File::Spec->splitpath( $search_path );
    $path =~ s!\\$!!g;
    $path =~ s!^\\$!!g;
    return 0 unless $path;
    my @path = split /\\/ , $path;
    pop @path;
    my ( $t , $conf ) = ( '' , '' );
    while( @path ){
       
       $t = File::Spec->catfile( $volume , @path , 'web.config' );
       if ( -f $t )
       {
           $conf = $fmgr->get_data( $t );
           if ( $conf && $conf =~ m!perl\.exe! )
           {
               return 1;
           }
       }
       pop @path;
    }
    return 0;
}

## 二つのサイトパスの階層が同階層であるか判定する。
sub is_site_inner_site {
  my ( $a_url , $a_path , $b_url , $b_path ) = @_;
  my $a_root = document_root_path( $a_url , $a_path );
  my $b_root = document_root_path( $b_url , $b_path );
  if( $a_root eq $b_root ){
      my @r = split_dir( $a_root );
      my @a = split_dir( $a_path );
      my @b = split_dir( $b_path );
      my $i = 0;
      if( length( $a_path ) > length( $b_path ) ){
          for( $i = scalar @r; $i < scalar @b ; $i++ ){
              next if $a[$i] eq $b[$i];
              return 0;
          }
          return -1; ## b に a が含まれる
      }else{
          for( $i = scalar @r; $i < scalar @a ; $i++ ){
              next if $a[$i] eq $b[$i];
              return 0;
          }
          return 1; ## a に bが含まれる
     }
  }
  return 0;
}

## ドキュメントルート取得
sub document_root_path {
    my ( $site_url , $site_path ) = @_;
    my ( $d , $r ) = split_url( $site_url );
    my $sep = $site_path =~ m!\\! ? "\\" : '/';
    my $root = $site_path;
    if( $r ){
        $r =~ s!\/$!!;
        my @url = split_dir( $r );
        my @path = split_dir( $site_path );
        my $max = scalar @url;
        for( my $i = 0; $i < $max ; $i++ ){
            my $url_dir = pop @url;
            my $path_dir = pop @path;
            if( $url_dir ne $path_dir ){
                warn sprintf ( 'Some directories do not match your site URL and site path %s , %s , %s ne %s'
                   ,$site_url
                   ,$site_path
                   ,$url_dir ? $url_dir : 'undef'
                   ,$path_dir ? $path_dir : 'undef'
                );
            }
        }
        $root = join $sep , @path;
    }
    return $root;
}

## URLをドメインと相対パスに分解
sub split_url {
    return $_[0] =~ m!^https?://([^/]+)/(.*)$!
          ? ( $1 , $2 )
          : $_[0] =~ m!^/(.*)$!
               ? ('' , $1)
               : ('' , $_[0]);
}

## ディレクトリ分解（相対指定の解決も同時に行う)
sub split_dir {
    my $path = shift;
    my $UNCorDRIVE = '';
    if( $path =~ m!^(\\\\[^\\]*)(.*)$! ){
        $UNCorDRIVE = $1 ? $1 : '';
        $path = $2;
    }elsif( $path =~ m!^([\\]+)(.*)$! ){
        $UNCorDRIVE = $1;
        $path = $2;
    }
    my @path = split /[\/\\]/ , $path;
    my @repath;
    foreach my $dir ( @path ){
        next if '.' eq $dir;
        if( '..' eq $dir ){
            unless ( @repath ){
               warn sprintf 'The relative path ".." is in a suitable position sense. %s' , $path;
               next;
            }
            pop @repath;
            next;
        }
        push @repath , $dir;
    }
    if( $UNCorDRIVE ){
        shift @repath;
        unshift @repath , $UNCorDRIVE;
    }
    return @repath;
}

## ウェブ設定ファイルのテンプレート
sub webconf_template {
    my ( $plugin , $mod ) = @_;

    my $path = $plugin->path . "/tmpl/DynamicViewer/";
    if( $mod ){
       $path .= "webconfig.tmpl";
    }else{
       $path .= "htaccess.tmpl";
    }
    my $out = '';
    open(FH, "< $path" );
    $out .= $_ while ( <FH> );
    close(FH);
    return $out;

}

## プロキシファイルのテンプレート
sub proxy_template {
    my $plugin = shift;

    my $path = $plugin->path . "/tmpl/DynamicViewer/proxy.tmpl";
    my $out = '';
    open(FH, "< $path" );
    $out .= $_ while ( <FH> );
    close(FH);
    return $out;

}


1;
