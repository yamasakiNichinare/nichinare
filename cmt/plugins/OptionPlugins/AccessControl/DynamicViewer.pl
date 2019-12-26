package MT::Plugin::DynamicViewer;
use strict;
use warnings;
use MT 5;
use base qw( MT::Plugin );
use MT::Util qw( encode_url );
use vars qw( $PLUGIN_NAME $VERSION );
$PLUGIN_NAME = 'DynamicViewer';
$VERSION = '0.0471';
use DynamicViewer::Tags;
use File::Basename;
use Data::Dumper;

my $plugin = __PACKAGE__->new({
    name    => $PLUGIN_NAME,
    version => $VERSION,
    key     => lc $PLUGIN_NAME,
    id      => lc $PLUGIN_NAME,
    author_name => 'SKYARC System Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
    l10n_class => $PLUGIN_NAME. '::L10N',
    system_config_template => $PLUGIN_NAME . '/cms/system_config.tmpl',
    settings => new MT::PluginSettings([

     ## blog
        ## 継承設定 0:独立 1:Websiteの値を継承する。対象[ status , exclude_js , exclude_css , autherntication ]
        ['inheritance',{ default => 1 , scope => 'blog' }], 

     ## website and blog
        ## 利用状態  0:無効 1:有効
        ['status',{ default => 0 , scope => 'blog' }],

        ## 認証設定 0:無効 1:有効
        ['authentication',{ default => 0 , scope => 'blog' }],

        ## cssファイルは除外する。 0:除外しない 1:除外する
        ['exclude_css',{ default => 1 , scope => 'blog' }],

        ## Javascriptファイルは除外する。 0:除外しない 1:除外する
        ['exclude_js',{ default => 1 , scope => 'blog'}],

        ## エラーページタイプ 0:プラグイン提供テンプレート 1:ファイルパス 2:モジュールテンプレート名
        ['error_page_type',{ default => 0 , scope => 'blog' }],

        ## エラーページ名
        ['error_page_name',{ default => 'Error',scope => 'blog' }],

        ## エラーページ用テンプレートの名称またはファイル名
        ['error_page_tmpl',{ default => '' , scope => 'blog' }],


        ## ログインページタイプ 0:プラグイン提供テンプレート 1:ファイルパス 2:モジュールテンプレート名
        ['login_page_type',{ default => 0 , scope => 'blog' }],

        ## ログインページ名
        ['login_page_name',{ default => 'Login',scope => 'blog' }],

        ## ログインページ用テンプレートの名称またはファイル名
        ['login_page_tmpl',{ default => '' , scope => 'blog' }],


        ## ログアウトページタイプ 0:プラグイン提供テンプレート 1:ファイルパス 2:モジュールテンプレート名
        ['logout_page_type',{ default => 0 , scope => 'blog' }],

        ## ログアウトページ名
        ['logout_page_name',{ default => 'Logout',scope => 'blog' }],

        ## ログアウトページ用テンプレートの名称またはファイル名
        ['logout_page_tmpl',{ default => '' , scope => 'blog' }],


        ## 除外するファイル・ディレクトリを指定する ドキュメントルートからの相対パス指定
        ['exclude_path',{ default => '' , scope => 'blog' }],

        ## Add WebConfig .htaccessコードの先頭に追加する。
        ['add_webconfig',{ default => '' , scope => 'blog' }],
        
        ## MIME TYEP
        ['mime_type' , { default => '' , scope => 'blog' }],
        
        ## DIRECTORY_INDEXES
        ['directory_indexes' , { default => '' , scope => 'blog' }],

     ## system
        ## 環境指定 0:apache(mod_rewrite) 1:iis( URL Rewrite Module 1.x )
        ['platform',{ default => 0 , scope => 'system' }],

        ## FastCGI 0:*.cgi 1:*.fcgi
        ['fastcgi_mode',{ default => 0 , scope => 'system' }], 

    ]),
    description => <<HTMLHEREDOC,
<__trans phrase="Perl scripts using the dynamic and displays. Can now be dynamically displayed on a static file even partially.">
HTMLHEREDOC
});
MT->add_plugin( $plugin );

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        callbacks => {
            'search_blog_list'                 => sub { return \&authentication_trigger( 'search'   , @_ ); },
            'MT::App::Comments::init_request'  => sub { return \&authentication_trigger( 'comments' , @_ ); },
            'MT::App::Community::init_request' => sub { return \&authentication_trigger( 'community', @_ ); },
        },
        applications => {
           search => {
               methods => {
                    'dynamic_viewer_permission_denied'  => \&app_method_permission_denied,
               },
           },
           community => {
               methods => {
                    'dynamic_viewer_no_response'       => sub { return ''; },
                    'dynamic_viewer_permission_denied' => \&app_method_permission_denied,
               },
           },
           comments => {
               methods => {
                    'dynamic_viewer_no_response'       => sub { return ''; },
                    'dynamic_viewer_permission_denied' => \&app_method_permission_denied,
               },
           },
           cms => {
               methods => {
                   'dynamic_viewer_prepare' => '$DynamicViewer::DynamicViewer::Settings::prepare',
                   'dynamic_viewer_execute' => '$DyanmicViewer::DynamicViewer::Settings::execute',
               },
               menus => {
                   'settings:DynamicViewer' => {
                       label => 'Dynamic Viewer',
                       order => 1020,
                       mode => 'dynamic_viewer_prepare',
                       view => [ 'blog' , 'website' ],
                       condition => '$DynamicViewer::DynamicViewer::Settings::menu_condition',
                   },
              },
           },
       },
       tags => {
            block => {
               'DynamicSpace'    => 'DynamicViewer::Tags::dynamic_space',
               'DynamicSpaceExecute' => 'DynamicViewer::Tags::dynamic_space_execute',
            },
            function => {
               'isDynamic'        => \&is_dynamic,
               'DynamicViewerLoginURL'  => 'DynamicViewer::Tags::system_pages',
               'DynamicViewerLogoutURL' => 'DynamicViewer::Tags::system_pages',
               'DynamicViewerErrorURL'  => 'DynamicViewer::Tags::system_pages',
           }
       },
       default_templates => {
           base_path => 'templates/DynamicViewer/',
           'global:system' => {
              dynamicviewer_login => {
                  label => 'DynamicViewer Login',
              },
              dynamicviewer_logout => {
                  label => 'DynamicViewer Logout',
              },
              dynamicviewer_error => {
                  label => 'DynamicViewer Error',
              },
          },
       },
    });
}

sub instance { $plugin; }

## 権限エラー表示
sub app_method_permission_denied {
    my $app = shift;
    my $url = '';
    my $blog_id = 0;
    if( $app->param('blog_id') ){
       $blog_id = $app->param('blog_id');
    }elsif( $app->param('entry_id') ){
       my $entry = MT::Entry->load( $app->param('entry_id') ) || '';
       $blog_id = $entry->blog_id if $entry;
    }
    if( $blog_id ){
       my $params = $plugin->load_plugin_param( $blog_id );
       if ( $params ){
           my $blog = MT::Blog->load( $blog_id );
           if( $blog ){
               if( $blog->is_blog && $params->{'inheritance'} ){
                  $blog = $blog->website;
                  $params = $plugin->load_plugin_param( $blog->id );
               }
               $url = sprintf('%s%s?no=%d' , $blog->site_url , $params->{'error_page_name'} , 403 );
           }
       }
    }
    if( $url ){
       $app->print( $app->param->redirect({ -uri => $url } ) );
       return '';
    }
    return $app->error( MT->translate('Permission denied.') );
}

## 再認証要求もしくはエラー表示へ誘導
## 
## 検索以外は強制的にメソッドを変更し処理を認証、エラー表示へのリダイレクトに置き換えます。
sub authentication_trigger {
    my $type = shift;
    my $eh   = shift;
    my $app  = shift;

    my $change_method = 0;
    my $author = '';
    my $blogs;
    if( $type eq 'search' ){
        my ( $list , $flag ) = @_;
        $$flag = 1;
        my $blog_list = $app->create_blog_list();
        $blogs = $blog_list->{IncludeBlogs};
    }else{
       if( $app->param('blog_id' ) ){
           push @{$blogs} , $app->param( 'blog_id' );
       }elsif( $app->param('entry_id') ){
           my $entry = MT::Entry->load( $app->param('entry_id') );
           push @{$blogs} , $entry->blog_id if $entry;
       }
       $change_method = 1;
    }
    ## permission
    my @permit_blogs;
    my $permit = 0;
    foreach my $id ( @$blogs )
    {
         my $params = $plugin->load_plugin_param( $id );
         if( $params && $params->{'status'} && $params->{'authentication'} ){
             unless( $author )
             {
                  ## login
                  my ( $author ) = $app->login;
                  if( $author && $app->is_authorized ){

                     $app->user( $author ) unless $app->user;
                     $author = $app->user;

                  }else{
                       my $blog = MT::Blog->load( $id );
                       require MT::Log;
                       $app->log(
                           {
                             message => $plugin->translate( "Authentication Failed. ([_1])" , ref $app ),
                             level    => MT::Log::SECURITY(),
                             class    => 'AccessControl',
                             category => $app->id,
                             $blog ? ( blog_id => $blog->id ) : ()
                           }
                       );
                       $app->print(
                         $app->param->redirect({ -uri => ( !$blog->is_blog || !$params->{'inheritance'} ? $blog->site_url : $blog->website->site_url ) . $params->{'login_page_name'} } )
                       );
                       if( $change_method ){
                           $app->mode( 'dynamic_viewer_no_response' );
                           if( $type eq 'comments' ){
                                comments_param_reset( $app );
                           }
                           return 1;
                       }
                       return 0;
                  }
             }
             if( $app->user->is_superuser || $app->user->has_perm( $id ) ){
                  push @permit_blogs , $id;
             }
             $permit = 1;
         }else{
            push @permit_blogs , $id;
         }
    }
    unless( @{$blogs} ){
       return $app->error( 'Invalidate request.' );
    }
    if( $permit ){
       unless ( @permit_blogs ){
             if( $change_method ){
                $app->mode( 'dynamic_viewer_permission_denied' );
                if( $type eq 'comments' ){
                    comments_param_reset( $app );
                }
                return 1;
             }
             return 0;
       }
       if( 'search' eq $type ){
           @{$app->{searchparam}{IncludeBlogs}} = @permit_blogs;
       }
    }else{
       if( 'search' eq $type ){
           @{$app->{searchparam}{IncludeBlogs}} = @$blogs;
       }
    }
    return 1;
}
sub comments_param_reset {
  my $app = shift;
  for( 'post' , 'preview' , 'reply' , 'reply_preview' ){
      $app->param( $_ , '' ) if $app->param( $_ );
      $app->param( $_ . '_x' , '' ) if $app->param( $_ . '_x' );
      $app->param( $_ . '.x' , '' ) if $app->param( $_ . '.x' );
  }
  $app->{__path_info} = $app->path_info;
  $app->{__path_info} =~ s/captcha//;
}

## 判定
sub is_dynamic {
   my $app = MT->instance;
   my $script_name = 0;

   eval {
       $script_name = $ENV{MOD_PERL} ? $app->{apache}->uri : $ENV{SCRIPT_NAME};
       if ( !$script_name ) {
          require File::Basename;
          import File::Basename qw(basename);
          $script_name = basename($0);
       }
       $script_name =~ s!/$!!;
       $script_name = ( split /\//, $script_name )[-1];
   };
   $script_name = '' if $@;

   ## DyanmicViewer フルレンダリング
   return 2 if $app->id eq 'proxy'
      && $app->{'__proxy_partial_rendering'} == 2;

   ## DynamicViewer 部分的なレンダリング
   return 1 if $app->id eq 'proxy' 
      && $app->{'__proxy_partial_rendering'} == 1;

   return 2 if $script_name =~ m!^(mt\-search\.f?cgi|mt\-ftsearch\.fcgi|mt\-cp\.f?cgi|mt\-comments\.f?cgi|mt\-tb\.f?cgi)$!;

   ## MT管理画面上で再構築(部分的なレンダリングを行うための準備)
   return 0;
}

## プロキシ名
sub proxy_name {
   my $plugin = shift;
   my $name = 'mt-dynamicviewer';
   return sprintf "%s.fcgi" , $name if $plugin->get_config_value( 'fastcgi_mode' , 'system' );
   return sprintf "%s.cgi" , $name;
}

## プラグイン設定保存
sub save_plugin_param {
   my ( $class , $id , $param ) = @_;
   $class->save_config( $param , $id ? 'blog:' . $id : 'system' );
}

## プラグイン設定読込
sub load_plugin_param {
   my ( $class , $id ) =@_;
   my %param = ();
   $class->load_config( \%param , $id ? 'blog:' . $id : 'system' );
   return \%param;
}

## 設定保存(システム設定以外)
sub save_proxy_setting {
    my( $class, $param, $site ) = @_;

    my $id = $site->id;
    my $is_blog = $site->is_blog;

	## 設定読み込み
    my $owner_param = '';
    $owner_param = $class->load_plugin_param( $site->website->id ) if $is_blog;
    my $plugin_param = $class->load_plugin_param( $id );

    my @keys = $class->config_vars( 'blog' );
    foreach( @keys  ){

        my $inherit = 0;
        $inherit = 1 if $is_blog && $param->{'inheritance'};
        $inherit = 0 if 'exclude_path' eq $_ || 'inheritance' eq $_;
        $inherit = 0 unless $owner_param;

        $plugin_param->{$_} = $inherit
              ? $owner_param->{$_}
              : exists $param->{$_}
                     ? $param->{$_} 
                     : undef;

    }
    ## 自身を保存
    $class->save_plugin_param( $id , $plugin_param );
    #ウェブサイトの場合は継承しているブログの設定を再帰的に施す
    unless( $is_blog ){
         my $blogs = $site->blogs;
         foreach my $blog ( @{ $blogs } ){
             my $blog_param = $class->load_plugin_param( $blog->id );
             next unless $blog_param->{'inheritance'};
             $class->save_proxy_setting( $blog_param , $blog );
         }
    }
}

1;
