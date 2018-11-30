package DynamicViewer::App;

use strict;
use warnings;
use CGI::Carp qw( fatalsToBrowser );
use base qw( MT::App );
use MT::Auth;
use MT::Blog;
use MT::Website;
use MT::FileInfo;
use MT::Template;
use MT::Template::Context;
use MT::Util qw( decode_url encode_url unescape_unicode escape_unicode );
use Fcntl;
use HTTP::Date qw(time2isoz time2str str2time);
use Data::Dumper;

my $COOKIE_NAME = 'mt_user';
sub COMMENTER_COOKIE_NAME () {"mt_commenter"};

our %ERRORLIST = (
  '1'    => 'Initailize Error',
  '404'  => 'Not Found',
  '403'  => 'Forbidden',
  '500'  => 'Internal Server Error',
  '1000' => 'Rebuild Error',
);

sub id   { 'proxy'; }
sub mode { 'proxy'; }

## システムページ宣言
sub add_system_page {
   my $app = shift;
   my %pages = (
       'login'  => {
           code => \&proxy_login,
           auth => 1,
       },
       'logout' => {
           code => \&proxy_logout,
           auth => 1,
       },
       'error'  => {
           code => \&proxy_error,
           auth => 0,
       },
   );
   return \%pages;
}

## システム用ページ登録
sub proxy_system_pages {
    my $app = shift;
    my $pageset = $app->add_system_page();
    my %pages;

    for( keys( %{$pageset} ) ){
          my $name = $_ . '_page';
          next if $pageset->{$_}->{'auth'} && !$app->{'__proxy_info'}->{'auth'};
          $pages{$app->{'__proxy_info'}->{$name}} = ({
             'key' => $_,
             'page' => $app->{'__proxy_info'}->{'owner_id'}
                 ? File::Spec->catdir( $app->{'__proxy_group_blogs'}->{ $app->{'__proxy_info'}->{'owner_id'} }->{'path'} , $app->{'__proxy_info'}->{$name} )
                 : File::Spec->catdir( $app->{'__proxy_info'}->{'site_path'} , $app->{'__proxy_info'}->{$name} ),
             'code' => $pageset->{$_}->{'code'},
             'template_type' => $app->{'__proxy_info'}->{$_},
             'template' => $app->{'__proxy_info'}->{$_.'_tmpl'},
         });
    }
    return \%pages;
}



## リダイレクト元のURLを取得
sub proxy_request_url {
   my $app = shift;
   my ( $p , $port , $host , $url ) = ( '' , '' , '' , '' );

   my ( $site_host ) = $app->{'__proxy_default_url'} =~ m!^http.?://([^/]+)/! and $1 or undef;
   my ( $site_p )    = $app->{'__proxy_default_url'} =~ m!^(http.?)://! and $1 or undef;
   my ( $site_port ) = $app->{'__proxy_default_url'} =~ m!^http.?://[^/:]+:(\d+)/! and $1 or undef;

   if( %ENV ){
      $p = defined $site_p 
           ? $site_p
           : exists $ENV{'HTTPS'}
               ? $ENV{'HTTPS'} eq 'on'
                   ? 'https'
                   : 'http'
               : 'http';
      $p .= '://' if $p;

      $port = defined $site_port 
                ? ':' . $site_port
                : exists $ENV{'SERVER_PORT'} 
                     ? $ENV{'SERVER_PORT'} == 443 || $ENV{'SERVER_PORT'} == 80 
                            ? '' 
                            : ':' . $ENV{'SERVER_PORT'}
                     : '';

      $host = defined $site_host
                ? $site_host
                : exists $ENV{'SERVER_NAME'}
                       ? $ENV{'SERVER_NAME'}
                       : '';

      $url = exists $ENV{'REDIRECT_URL'}
          ? $ENV{'REDIRECT_URL'}
          : exists $ENV{'HTTP_X_ORIGINAL_URL'}
              ? $ENV{'HTTP_X_ORIGINAL_URL'}
              : '';

      $url = $ENV{'REQUEST_URI'} if $url =~ /mt-dynamicviewer\.f?cgi$/;

      unless ( $host ) {
          $p = '';
          $port = '';
      }
      return sprintf ( '%s%s%s%s' , $p , $host , $port , $url );
   }
   return '';
}

## 初期化
sub init {
   my $app = shift;
   my %param = @_;

#   # FASTCGI用パス調整
#   unless(  exists $ENV{'MT_HOME'} )
#   {
#       $param{Config}    = File::Spec->catdir( $param{site_info}->{script_path} , 'mt-config.cgi' );
#       $param{Directory} = $param{site_info}->{script_path} . ( $param{Directory} =~ m/\\/ ? '\\' : '/');
#       $MT::MT_DIR       = $param{Directory};
#       $ENV{'MT_HOME'}   = $param{Directory};
#       unshift @INC, File::Spec->catdir( $param{Directory}, 'extlib' );
#       unshift @INC, File::Spec->catdir( $param{Directory}, 'lib' );
#       $MT::APP_DIR = $MT::MT_DIR;
#       MT::set_language( MT->instance , 'en_US');
#       $app->bootstrap();
#       $app->SUPER::init(@_) or return;
#   }
   $app->SUPER::init( %param ) or return;

   $app->{'default_mode'} = 'proxy';
   my $info  = $param{'site_info'};
   my $blogs = $param{'group_blogs'};

   ## サイト情報登録
   $app->{'__proxy_info'}              = $param{'site_info'};
   $app->{'__proxy_group_blogs'}       = $param{'group_blogs'};
   $app->{'__proxy_mime_types'}        = $param{'mime_types'};
   $app->{'__proxy_directory_indexes'} = $param{'directory_indexes'};

   ## 初期ページを設定する。
   $app->{'__proxy_default_url'}  = $info->{'owner_id'} 
        ? $blogs->{ $info->{'owner_id'} }->{'url'}
        : $info->{'site_url'};
   $app->{'__default_proxy_page'} = $info->{'owner_id'} 
        ? $blogs->{ $info->{'owner_id'} }->{'path'}
        : $info->{'site_path'};
   $app->{'script_url'} = $app->{'__proxy_default_url'};

   ## モード初期化
   $app->param( '__mode' , 'proxy' );
   $app->param( 'blog_id' , $info->{'id'} );
   $app->{'_stock_blog'} = $blogs->{$info->{'id'}}->{'blog'} 
         ? MT::Blog->load( $info->{'id'} )
         : MT::Website->load( $info->{'id'} );

   $app->add_methods(
        'proxy' => {
           'code' => \&proxy,
        },
   );
   $app;
}
sub init_request {
    my $app = shift;
    $app->SUPER::init_request( @_ );
    $app->{'no_print_body'} = 0;
    $app->{'__proxy_request_error'}        = 0;
    $app->{'__proxy_request_error_msg_no'} = 0;
    $app->{'__proxy_request_error_msg'}    = '';
}

## リクエストページの設定
sub make_request_page {
   my $app = shift;

   my $info  = $app->{'__proxy_info'};
   my $blogs = $app->{'__proxy_group_blogs'};

   ## リクエストページを設定する。
   $app->{'__proxy_request_page'}  = '';
   $app->{'__proxy_request_url'}   = $app->proxy_request_url();

   $app->{'__proxy_request_error_msg_no'} = 1;
   $app->{'__proxy_request_error'} = 1;
   $app->{'__proxy_request_error_msg'} = 'Invalidate request';

   my $request_path = '';
   my $request_url = exists $ENV{'REDIRECT_URL'}
          ? $ENV{'REDIRECT_URL'}
          : exists $ENV{'HTTP_X_ORIGINAL_URL'}
              ? $ENV{'HTTP_X_ORIGINAL_URL'}
              : '';

   $request_url = $ENV{'REQUEST_URI'} if $request_url =~ /mt-dynamicviewer\.f?cgi$/;

   $request_url = $1 if $request_url =~ m!^([^?&]*)!;
   my $base_url = $info->{'site_url'} =~ m!(?:^https?://[^/]*)?(/.*)$! ? $1 : '/';
   my $base_path = $info->{'site_path'};
   $base_path .= '/' if $base_path !~ m!/$!;

   if ( $request_url =~ m!\Q$base_url\E! )
   {
       $request_path = $request_url;
       $request_path =~ s!\Q$base_url\E!$base_path!e;
       $request_path =~ s!/!\\!g if $request_path =~ m!\\!;
       $app->{'__proxy_request_page'} = $request_path;
       $app->{'__proxy_request_error_msg_no'} = 0;
       $app->{'__proxy_request_error'} = 0;
       $app->{'__proxy_request_error_msg'} = '';
   }
}

## プロキシ実行
sub proxy {
   my $app = shift;
   my $file_exists = 0;
   my %opt;

   my $blog_id = $app->{'__proxy_info'}->{'id'};
   $app->param( 'blog_id' , $blog_id );
   $app->{'_blog'} = $app->{'_stock_blog'}; 

   # 1: 部分的レンダリング 2:フルレンダリング 0:なし
   $app->{'__proxy_partial_rendering'} = 0;
   $app->{'__proxy_request_page'} = '';

   $app->make_request_page();
   my $spages = $app->proxy_system_pages();
   for( keys %$spages ) {
       if( $spages->{$_}->{'page'} eq $app->{'__proxy_request_page'} ) {
          return  $spages->{$_}->{'code'}->( $app );
       }
   }
   if( $app->{'__proxy_request_error'} && $app->{'__proxy_request_error_msg_no'} == 1){
      return $app->proxy_error();
   }
   ## 認証
   my ( $author , $newlogin );
   if( $app->{'__proxy_info'}->{'auth'} ) {

       ( $author , $newlogin ) = $app->login();
       if( !$author || !$app->is_authorized ) {
           return $app->load_tmpl( 
                 'login.tmpl',
                 {
                     relogin => 1,
                     error  => $app->errstr,
                     no_breadcrumbs => 1,
                     login_fields => sub { MT::Auth->login_form( $app ); },
                     can_recover_passwd => sub { MT::Auth->can_recover_passwd },
                     delegate_auth => sub { MT::Auth->delegate_auth },
                 }
           );
       }
       if( $newlogin ){
           return $app->redirect( $app->{'__proxy_request_url'} );
       }
   }
   unless( exists $app->{author} && $app->{author} ) {
       my ( $author ) = $app->login;
       $app->user( $author ) if $author && ref $author eq $app->user_class && $app->is_authorized;
   }
   ## エラーページ
   if ( !$app->{'__proxy_request_page'} ) {
      return $app->errordisp_not_found();
   }

   ## ブログアクセス制限
   if( $app->{'__proxy_info'}->{'auth'} ) {
        %opt = (
           status => 1,  ## 0: 権限がない 1:権限がある。
           blog_id => $app->{'__proxy_info'}->{'id'},
           redirect => '',
        );
        $app->run_callbacks(
           'accesscontrol_blog_permission',
            $app,
            \%opt,
        );
        if( $opt{'redirect'} ) {
             $app->redirect( $opt{'redirect'} );
             return '';
        }
        unless ( $opt{'status'} ){
             return $app->errordisp_permission();
        }
   }

   ## ページ選択
   my $file_info = '';
   my $di_page = '';
   if( $app->{'__proxy_request_page'} =~ m|[/\\]$| ) {
       for ( $app->blog->file_extension , @{$app->{'__proxy_directory_indexes'}}  ) { 
          if ( -f ( $app->{'__proxy_request_page'} . $_ ) ) { 
              $file_exists = 1;
          }
          $file_info = $app->resolve_path( $app->{'__proxy_request_page'} .$_  , 0 );
          if( $file_info || $file_exists ){
              $di_page = $app->{'__proxy_request_page'} . $_;
              last;
          }
       }
       return $app->errordisp_not_found() unless $di_page; 
       $app->{'__proxy_request_page'} = $di_page;
   }
   else{
       if( -f $app->{'__proxy_request_page'} ){
          $file_exists = 1;
       }
       $file_info = $app->resolve_path( $app->{'__proxy_request_page'} , 0 );
   }
   my $suffix = $app->{'__proxy_request_page'} =~ m/\.([^.]*)$/ ? $1 : '';
   my $mimes = $app->{'__proxy_mime_types'} || '';
   my $mime_type = $mimes && exists $mimes->{ $suffix } ? $mimes->{ $suffix } : '';

   if( $file_exists && !$file_info && $mime_type =~ /^text/ ) {

       ## ファイルが存在していて、FileInfoが存在していない場合はダミーのFileInfoを作成して処理する。

       $file_info = MT::FileInfo->new;
       $file_info->archive_type( 'index' );
       $file_info->file_path( $app->{'__proxy_request_page'} );
       $file_info->url( $app->{'__proxy_request_url'} );
       $file_info->blog_id( $blog_id );

   }

   ## ページアクセス制限
   if( $app->{'__proxy_info'}->{'auth'} ){
        %opt = (
           status => 1,  ## 0: 権限がない 1:権限がある。
           blog_id => $blog_id,
           file_info => $file_info || '',
           request_page_path => $app->{'__proxy_request_page'},
        );
        $app->run_callbacks(
           'accesscontrol_page_permission',
            $app,
            \%opt,
        );
        unless ( $opt{'status'} ) {
             return $app->errordisp_permission();
        }
   }

   ## xsendfile利用できる状況の場合
   my $modified_since = $app->get_header('If-Modified-Since') || 0;

   my $contents = '';
   if ( $ENV{XsendFileStatus} && $mime_type !~ /^text\/.*$/i ) {
        return $app->errordisp_not_found() unless $file_exists;
        %opt = (
            type => 'xsendfile',
            send_header => 1,
            send_contents => 1,
            send_no_cache => 0,
            encode => '',
            exit => 1,
            page =>  $app->{'__proxy_request_page'},
            mime_type => $mime_type,
        );
        $opt{'mime_type'} .= sprintf( "\nX-Sendfile: %s\n" , $app->{'__proxy_request_page'} );
   }
   else{
        %opt = (
            type => 'not_xsendfile',  
            send_header => 0,
            send_contents => 0,
            send_no_cache => 0,
            encode => '',
            exit => 0,
            page =>  $app->{'__proxy_request_page'},
            mime_type => $mime_type,
        );
   }
   $opt{'modified_since'} = $modified_since ? str2time( $modified_since ) : 0;
   $opt{'last_modified'} =  $file_exists ? ( stat( $opt{'page'} ))[9] : 0;
   $app->run_callbacks(
       'dynamicviewer_output_filter',
        $app,
        \$contents,
        \$file_info,
        \%opt,
   );
   $app->{'no_print_body'} = 1;
   $app->set_no_cache() if $opt{'send_no_cache'};
   if ( $opt{'send_header'} ) {
      unless ( $opt{'send_no_cache'} ) {
          if ( $opt{'last_modified'} && $opt{'modified_since'} && $opt{'last_modified'} <= $opt{'modified_since'} ) {
              $app->response_code( 304 );
              $app->response_message( 'Not Modified' );
              $app->send_http_header( $mime_type );
              return undef if $opt{'exit'};
          } else {
              $app->set_header('Last-Modified', time2str($opt{'last_modified'}) ) if $opt{'last_modified'};
              $app->send_http_header( $opt{'mime_type'} );
          }
      }
   }
   $app->print( $contents ) if $opt{'send_contents'};
   return undef if $opt{'exit'};
   $app->{'no_print_body'} = 0;

   ## ファイル読み込む
   my $tmpl = '';
   if ( $file_exists ) {
      my $open_mode = $mime_type !~ m|^text\/.*$|i ? O_RDONLY | O_BINARY : O_RDONLY;
      sysopen my $IN, $app->{'__proxy_request_page'} , $open_mode;
      $contents .= $_ while <$IN>;
      close $IN;
      if ( $contents =~ m!<\$?MT[^>]+>!i ) {
          $app->{'__proxy_partial_rendering'} = 1;
      }

   }
   ## テンプレートを読み込む
   elsif( $file_info ) {
      $tmpl = MT::Template->load( $file_info->template_id );
      unless ( $tmpl ){
           return $app->errordisp_not_found();
      }
      $app->{'__proxy_partial_rendering'} = 2;
  }else{
      return $app->errordisp_not_found();
  }

  # Forbidden
  unless ( $mime_type ){
     return $app->errordisp_permission();
  }

  ## バイナリー系の情報は直接送信
  if ( !$file_info && $mime_type !~ /^text\/.*$/i ) {
      %opt = (
          type => 'binary',
          send_header => 1,
          send_contents => 1,
          send_no_cache => 0,
          encode => '',
          exit => 1,
          page => $app->{'__proxy_request_page'},
          mime_type => $mime_type,
      );
  }
  else {
      %opt = (
          type => 'not_binary',
          send_header => 0,
          send_contents => 0,
          send_no_cache => 0,
          encode => '',
          exit => 0,
          page => $app->{'__proxy_request_page'},
          mime_type => $mime_type,
      );
  }
  $opt{'modified_since'} = $modified_since ? str2time($modified_since) : 0;
  $opt{'last_modified'} = $file_exists ? ( stat( $opt{'page'} ))[9] : 0;
  $app->run_callbacks(
      'dynamicviewer_output_filter',
       $app,
       \$contents,
       \$file_info,
       \%opt,
  );
  $app->{'no_print_body'} = 1;
  $app->set_no_cache() if $opt{'send_no_cache'};
  if ( $opt{'send_header'} ) {
     unless ( $opt{'send_no_cache'} ) {
         if ( $opt{'last_modified'} && $opt{'modified_since'} && $opt{'last_modified'} <= $opt{'modified_since'} ) {
             $app->response_code( 304 );
             $app->response_message( 'Not Modified' );
             $app->send_http_header( $opt{'mime_type'} );
             return undef if $opt{'exit'};
         } else {
             $app->set_header( 'Last-Modified', time2str($opt{'last_modified'}) ) if $opt{'last_modified'};
             $app->send_http_header( $opt{'mime_type'} );
         }
     }
  }
   if ( $opt{'send_contents'} ) {
      binmode( STDOUT );
      print $contents;
  }
  return undef if $opt{'exit'};
  $app->{'no_print_body'} = 0;
 
  my $blog = $app->blog || MT::Blog->load( $blog_id ) || '';
  return $app->errordisp_not_found() unless $blog;

  ## 読み込んだファイルの文字コードを内部コードへ調整する。
  my $enc = $app->charset || 'UTF-8';
  if ( $contents ) {
      my $multi_trans_encoding = MT->component('MultiTransEncoding');
      if( $multi_trans_encoding ){
          my $system_encode = $multi_trans_encoding->get_code(0);
          my $change_encode = $multi_trans_encoding->get_code($blog->id); 
          unless ( $change_encode =~ /DEFAULT/i ) {
              $enc = $multi_trans_encoding->get_name($blog->id)
                  if $change_encode ne $system_encode;
          }
      }
      $contents = Encode::decode($enc,$contents);
  }

  ## レンダリング
  my $ctx = MT::Template::Context->new;
  my $context_blog = $blog;
  $context_blog = MT::Blog->load({ id => $file_info->blog_id })
     if $file_info && ( $file_info->blog_id != $blog->id );
  $ctx->{__stash}{blog} = $context_blog;
  $ctx->{__stash}{local_blog_id} = $context_blog->id;
  $ctx->{__stash}{author} = $file_info 
          ? $file_info->author_id && MT::Author->load( $file_info->author_id ) || ''
          : $app->user || '';
  
  if( $file_info && $app->{'__proxy_partial_rendering'} ){
      
       my $pub = $app->publisher;
       my $archiver = $pub->archiver( $file_info->archive_type );
       my $archive_type = $file_info->archive_type;
       my $archive_label = $archiver ? $archiver->archive_label : '';
       $archive_label = $app->translate($archive_type) unless $archive_label;
       $archive_label = $archive_label->() if ( ref $archive_label ) eq 'CODE';

       my ( $start, $end ) = ( '' , '' );
       if ( $file_info->startdate ) {
          ( $start , $end ) = $archiver && $archiver->date_range( $file_info->startdate ) || ( '' , '');
       }
       my $category = '';
       if ( $file_info->category_id ) {
          $category = MT::Category->load( $file_info->category_id ) || '';
       }
       my $entry = '';
       if ( $file_info->entry_id ) {
          $entry = MT::Entry->load( $file_info->entry_id ) || '';
       }
       my $author = '';
       if ( $file_info->author_id ) {
          $author = MT::Author->load( $file_info->author_id ) || '';
       }
       if( $entry ){ 
          return $app->errordisp_not_found() unless $entry->status == MT::Entry::RELEASE();
       } 
       $ctx->{current_archive_type} = $archive_type;
       $ctx->{archive_type}         = $archive_type;
       ## カテゴリアーカイブ
       if ( $archiver && $archiver->category_based ) {
            unless ( $category ) {
                $app->{'__proxy_request_error_msg'} = "Category archive type requires Category parameter";
                return $app->errordisp_rebuild();
            }
            $ctx->var( 'category_archive', 1 );
            $ctx->{__stash}{archive_category} = $category;
       }
       ## エントリアーカイブ
       if ( $archiver && $archiver->entry_based ) {
           unless ( $entry ) {
                $app->{'__proxy_request_error_msg'} = "$archive_type archive type requires Entry parameter";
                return $app->errordisp_rebuild();
           }
           $ctx->var( 'entry_archive', 1 );
           $ctx->{__stash}{entry} = $entry;
       }
       ## 日付アーカイブ
       if ( $archiver && $archiver->date_based ) {
          unless ( $start ) {
                $app->{'__proxy_request_error_msg'} = "Date-based archive types require StartDate parameter";
                return $app->errordisp_rebuild();
          }
          $ctx->var( 'datebased_archive', 1 );
       }
       if ( $archiver && $archiver->author_based ) {
          unless ( $start ) {
                $app->{'__proxy_request_error_msg'} = "Author-based archive type requires Author parameter";
                return $app->errordisp_rebuild();
          }
          $ctx->var( 'author_archive', 1 );
          $ctx->{__stash}{author} = $author;
       }
       local $ctx->{current_timestamp} = $start if $start;
       local $ctx->{current_timestamp_end} = $end if $end;

       ## 部分的再構築の場合はテンプレートを静的ファイルの内容に入れ替える。
       if ( $file_exists && $app->{'__proxy_partial_rendering'} == 1 )
       {
           $tmpl = MT::Template->new();
           $tmpl->text( $contents );
       }
       $tmpl->context( $ctx );
       my $tmpl_param = $archiver ? $archiver->template_params : '';
       if ( $tmpl_param )
       {
           $tmpl->param($tmpl_param);
       }
       if ( $archiver && $archiver->group_based ) 
       {
            require MT::Promise;
            my $entries = sub { $archiver->archive_group_entries($ctx) };
            $ctx->stash( 'entries', MT::Promise::delay($entries) );
       }
       my $cond = '';
       my $html = undef;
       $ctx->stash( 'blog', $context_blog );
       $ctx->stash( 'entry', $entry ) if $entry;
       $html = $tmpl->build( $ctx, $cond );
       unless( $html ) {
           $app->{'__proxy_request_error_msg'} = $tmpl->errstr;
           return $app->errordisp_rebuild();
       }
       $contents = $html;

       ## ページ制御
       if( $ctx->stash('PageBute') ) {
          my $plugin_res = 0;
          my $page = $app->param( 'page' ) || 1;
          my $pagebute = MT->component('PageBute') || '';
          if( $pagebute )
          {
             eval {
                $plugin_res = 
                   $pagebute->_page_bute_cgi( $ctx , $app->{'__proxy_request_url'} , \$contents , $page );
             };
             if( !$plugin_res ) {
                  $app->{'__proxy_request_error_msg'} = $@
                       ? $@
                       : 'PageBute plug-in error.';
                  return $app->errordisp_rebuild()
             }
          }          
       }
    }
    ## リンクを相対パスに変換する。
    my $abs2rel = MT->component('Abs2Rel') || '';
    if( $abs2rel ){
        my $plugin_res = 0;
        %opt = (
          Blog => $app->blog,
          File => $app->{'__proxy_request_page'},
          Content => \$contents,
          Context => $ctx,
        );
        eval {
          $plugin_res = $abs2rel->_hdlr_build_page( %opt );
        };
        if( !$plugin_res || $@ )
        {
           $app->{'__proxy_request_error_msg'} = $@
               ? $@
               : 'Abs2Rel plug-in error.'; 
           return $app->errordisp_rebuild();
        }
    }

    ## 出力文字コード設定
    $enc = $app->charset || 'UTF-8';
    my $multi_trans_encoding = MT->component( 'MultiTransEncoding'); 
    if( $multi_trans_encoding ){
        my $system_encode = $multi_trans_encoding->get_code(0);
        my $change_encode = $multi_trans_encoding->get_code($blog->id);
        unless ( $change_encode =~ /DEFAULT/i ) {
           $enc = $multi_trans_encoding->get_name($blog->id)
              if $system_encode ne $change_encode;
           Encode::_utf8_off( $contents ) if Encode::is_utf8( $contents );
           $contents = $multi_trans_encoding->change_entity(
              $contents,
              $system_encode,
              $change_encode
           );
           Encode::_utf8_on( $contents ) unless Encode::is_utf8( $contents );
        }
    }
    %opt = (
       type => 'text',
       send_header => 1,
       send_contents => 1,
       send_no_cache => 1,
       encode => $enc,
       page => $app->{'__proxy_request_page'},
       mime_type => $mime_type,
    );
    $app->run_callbacks(
        'dynamicviewer_output_filter',
        $app,
        \$contents,
        \$file_info,
        \%opt,
    );
    $app->{'no_print_body'} = 1;
    if ( $opt{'send_header'} ) {
       $app->set_no_cache() if $opt{'send_no_cache'};
       $mime_type = $opt{'mime_type'};
       $mime_type .= sprintf  "; charset=%s" , $opt{'encode'}; 
       $app->response_content_type( $mime_type );
       $app->send_http_header;
    }
    $app->print( Encode::encode( $opt{'encode'} , $contents ) ) if $opt{'send_contents'};
    return undef;
}

sub resolve_path {
    my ( $app , $path , $blog_id ) = @_;

    require MT::TemplateMap;

    my @template;
    my @templatemap;
    my $blog_scope;
    $blog_scope = $blog_id ? { blog_id => $blog_id } : {},

    ## Index Templat.
    ## 公開設定(build_type)が0以外のものを利用する
    ## インデックステンプレートは最後に再構築されるものなので、ファイル上では最も存在が優先されるものとし最初に検索する。
    @template = MT::Template->load({
           %$blog_scope,
           type => { not => 'backup' },
           build_type => [ 1, 5 ],
        },{ 
           join => MT::FileInfo->join_on( 'template_id' , {
               %$blog_scope,
               file_path => $path,
               archive_type => 'index',
           },undef),
           range_incl => { build_type => 1 },
    });
    for ( @template ) {
       my $file_info = MT::FileInfo->load({ 
            %$blog_scope,
            file_path => $path,
            template_id => $_->id,
        }) or next;
        return $file_info;;
    }

    ## Archive Template
    ## アーカイブテンプレートは重複したテンプレートが常に存在しているものとして扱う。
    ## テンプレートマップの優先順位は、is_preferredとするが、同様のレベルの場合は、データベースの順に取ってくる
    ## テンプレートの公開設定はテンプレートではなく、テンプレートマップ上で管理しているものとし扱う
    @templatemap = MT::TemplateMap->load({
           %$blog_scope,
           build_type => [ 1, 5 ],
           is_preferred => 1,
         },{ 
           join => MT::FileInfo->join_on( 'templatemap_id' , {
               %$blog_scope,
               file_path => $path,
               archive_type => { not => 'index' },
           },undef ),
           range_incl => { build_type => 1 },
    });
    for ( @templatemap ) {
       my $file_info = MT::FileInfo->load({
           templatemap_id => $_->id,
           file_path => $path,
           %$blog_scope,
           archive_type => { not => 'index' },
       }, undef ) or next;
       return $file_info;
    }

    return "";
}

## ページが存在しない場合
sub errordisp_not_found {
   my $app = shift;

   $app->{'__proxy_request_error'} = 1;
   $app->response_content_type( 'text/html' );
   $app->response_code( 404 );
   $app->response_message( $ERRORLIST{404} );
   unless ( $app->{'__proxy_request_error_msg'} ) {
      $app->{'__proxy_request_error_msg'} = $ERRORLIST{404};
   }
   $app->{'__proxy_request_error_msg_no'} = 404;
   return $app->proxy_error();
}
## ページへのアクセス権がない場合
sub errordisp_permission {
   my $app = shift;

   $app->{'__proxy_request_error'} = 1;
   $app->response_content_type( 'text/html' );
   $app->response_code( 403 );
   $app->response_message( $ERRORLIST{403} );
   $app->{'__proxy_request_error_msg'} = $ERRORLIST{403};
   $app->{'__proxy_request_error_msg_no'} = 403;
   return $app->proxy_error();

}
## ページ再構築エラー
sub errordisp_rebuild {
   my $app = shift;

   $app->{'__proxy_request_error'} = 1;
   $app->response_content_type( 'text/html' );
   $app->response_code( 200 );
   $app->response_message( 'ok' );
   unless ( $app->{'__proxy_request_error_msg'} ) {
      $app->{'__proxy_request_error_msg'} = $ERRORLIST{1000};
   }
   $app->{'__proxy_request_error_msg_no'} = 1000;
   return $app->proxy_error();
}

## エラーページ
sub proxy_error {
   my $app = shift;
   my $plugin = MT->component( 'DynamicViewer' );
   $app->{'__proxy_request_error'} = 1;
   unless ( $app->{'__proxy_request_error_msg_no'} ){
      if( $app->param('no') ){
          if( exists $ERRORLIST{ $app->param('no') } ){
             $app->{'__proxy_request_error_msg'} = $ERRORLIST{ $app->param('no') };
          }else{
             $app->{'__proxy_request_error_msg'}    = 'Is Unknown';
          }
          $app->{'__proxy_request_error_msg_no'} = $app->param('no');
          $app->{'__proxy_request_error_msg_no'} =~ s/[^0-9]//g;
          $app->{'__proxy_request_error_msg_no'} ||= 500;
      }
   }
   unless ( $app->{'__proxy_request_error_msg'} ) {
      if( exists $ERRORLIST{ $app->{'__proxy_request_error_msg_no'} } ){
           $app->{'__proxy_request_error_msg'} = $ERRORLIST{ $app->{'__proxy_request_error_msg_no'} };
      }else{
           $app->{'__proxy_request_error_msg_no'} =~ s/[^0-9]//g;
           $app->{'__proxy_request_error_msg_no'} ||= 500;
           $app->{'__proxy_request_error_msg'}    = 'Is Unknown';
      }
   }
   $app->set_no_cache();
   return $app->load_tmpl( 
       'error.tmpl',
       {
           error => $plugin->translate( $app->{'__proxy_request_error_msg'} ),
           error_no => $app->{'__proxy_request_error_msg_no'},
       }
   );
}

## ログインページ
sub proxy_login {
   my $app = shift;
   $app->set_no_cache();
   return $app->logout( 0 );
}

## ログアウトページ
sub proxy_logout {
    my $app = shift;
    $app->set_no_cache();
    return $app->logout( 1 );
}

my $system_page_default_template_path = {
   'login.tmpl'  => 'dynamicviewer_login.mtml',
   'logout.tmpl' => 'dynamicviewer_logout.mtml',
   'error.tmpl'  => 'dynamicviewer_error.mtml',
};

my $system_page_default_template_name = {
   'login.tmpl'  => 'DynamicViewer Login',
   'logout.tmpl' => 'DynamicViewer Logout',
   'error.tmpl'  => 'DynamicViewer Error',
};

sub change_system_logo {
    my $app = shift;
    return $app->static_path . 'addons/MTCMS.pack/images/login_logo.png'
       if -f  $app->static_file_path . '/addons/MTCMS.pack/images/login_logo.png';
    return $app->static_path . 'images/chromeless/mt_logo.png';
}

## テンプレートの切り替え
sub load_tmpl {
    my $app = shift;
    my ( $file , @p ) = @_;

    my $param = '';
    if (@p && (ref($p[$#p]) eq 'HASH')) {
       $param = pop @p;
    }
    unless( $param ){
       $param = ({ script_url => exists $app->{'__proxy_default_url'} 
          && $app->{'__proxy_default_url'} 
          ? $app->{'__proxy_default_url'} 
          : '' });
    }
    $param->{'script_url'} = $param->{system_page}
            ? $app->{'__proxy_default_url'}
            : $app->{'__proxy_request_url'};

    $param->{'plugin_path'} = exists $app->{'__proxy_info'}->{'plugin_path'} 
        ? $app->{'__proxy_info'}->{'plugin_path'} 
        : undef;

    unless( exists $system_page_default_template_path->{ $file } ) {
        return $app->SUPER::load_tmpl( $file , $param );
    }

    $param->{system_logo} = $app->change_system_logo();
    $param->{can_recover_password} = 1 if $file ne 'error.tmpl';
    my $template = $app->change_templates( $file , $param );
    return $app->SUPER::load_tmpl( $template->{'template'} , $param );
}

sub build_page {
    my $app = shift;
    my($file, $param) = @_;

    unless( exists $system_page_default_template_path->{ $file } ) {
        return $app->SUPER::build_page( $file , $param );
    }

    $param->{system_logo} = $app->change_system_logo();
    $param->{'plugin_path'} = exists $app->{'__proxy_info'}->{'plugin_path'} 
        ? $app->{'__proxy_info'}->{'plugin_path'} 
        : undef;

    unless( $param ){
       $param = ({ script_url => exists $app->{'__proxy_default_url'} 
           && $app->{'__proxy_default_url'} 
           ? $app->{'__proxy_default_url'} 
           : '' });
    }
    $param->{'script_url'} = $param->{system_page}
            ? $app->{'__proxy_default_url'}
            : $app->{'__proxy_request_url'};

    if( 'error.tmpl' eq $file ) {
        $file = File::Spec->catfile( 
              $app->{'__proxy_info'}->{'plugin_path'} , 
              'templates' ,
              'DynamicViewer' , 
              $system_page_default_template_path->{$file} );

        return $app->SUPER::build_page( $file , $param );
    }

    $param->{can_recover_password} = 1;
    my $template = $app->change_templates( $file , $param );
    return $app->SUPER::build_page( $template->{'template'} , $param );
}

sub change_templates {
    my ( $app , $file , $param ) = @_;

    my $plugin = MT->component( 'DynamicViewer' );
    my %template = (
        type     => 0,
        template => '',
    );
    ## テンプレート変更処理
    $template{'template'} = File::Spec->catfile( 
          $app->{'__proxy_info'}->{'plugin_path'} ,
          'templates' ,
          'DynamicViewer' ,
          $system_page_default_template_path->{$file} );

    my $name = '';
    my ( $filename ) = $file =~ /^([a-z]+)\.tmpl$/;
    $template{'type'} = $app->{'__proxy_info'}->{$filename} || 0;
    if ( $template{'type'} == 1 ) {
       ## file path type:1
       if ( -f $app->{'__proxy_info'}->{$filename . '_tmpl'} ) {
           $template{'template'} = $app->{'__proxy_info'}->{$filename . '_tmpl'};
       }
       $template{'type'} = 0;
    }else{ 
       ## database type:0 or 2
       $template{'type'} = 2;
       $name = $app->{'__proxy_info'}->{$filename . '_tmpl'} 
          || $plugin->translate( $system_page_default_template_name->{ $file } );
    }
    if( $file ne 'error.tmpl' ) {
        $param->{'error_no'} = 0;
        if ( $param->{'logged_out'} ) {
             ## ログアウトしました。
             $param->{'error_no'} = 1;
             if ( $param->{'delegate_auth'} ) {
                   ## ユーザが削除、もしくは無効です。
                   $param->{'error_no'} = 2;
             }
        }
        else{
             ## 再ログインが必要です。（セッション切れ)
             $param->{'error_no'} = 3;
             if ( !$param->{'login_agin'} ) {
                  ## 再ログインが必要です。（セッション切れ)
                  $param->{'error_no'} = 4;
             }
        }
    }
    if ( $template{'type'} == 2 ) {
        my $blog_id = $app->{'__proxy_info'}->{'owner_id'} 
            || $app->{'__proxy_info'}->{'id'};

        my $t = '';
        eval {
            $t = MT::Template->load( { name => $name , blog_id => $blog_id } );
            $t = MT::Template->load( { name => $name , blog_id => 0 } ) unless $t;
        };
        if (!$@ && $t ) {
            my $txt = $t->text;
            $template{'template'} = \$txt;
            return \%template;
        }
    }
    $template{'type'} = 0;
    return \%template;
}

## ログアウト
sub logout {
    my ( $app , $page )  = @_;  ## page( 0: Login 1: Logout )
    my $logged_out = 0;
    $logged_out = 1 if $page;

    require MT::Auth;
    my $ctx = MT::Auth->fetch_credentials( { app => $app } );
    if ( $ctx && $ctx->{username} ) {

        unless( $page ){
           $app->redirect( $app->{'__proxy_default_url'} );
           return 0;
        }
        my $user_class = $app->user_class;
        my $user       = $user_class->load(
            { name => $ctx->{username}, type => MT::Author::AUTHOR() } );
        if ($user) {
            $app->user($user);
            $app->log(
                $app->translate(
                    "User '[_1]' (ID:[_2]) logged out", $user->name,
                    $user->id
                )
            );
        }
        $logged_out = 1;
    }
    MT::Auth->invalidate_credentials( { app => $app } );
    my %cookies = $app->cookies();
    $app->_invalidate_commenter_session( \%cookies );

    my $delegate = MT::Auth->delegate_auth();
#    if ($delegate) {
#        my $url = $app->config->AuthLogoutURL;
#        if ( $url && !$app->{redirect} ) {
#            $app->redirect($url);
#        }
#        if ( $app->{redirect} ) {
#
#            # Return 0 to force MT to follow redirects
#            return 0;
#        }
#    }

    $app->load_tmpl(
        $page ? 'logout.tmpl' : 'login.tmpl',
        {   
            system_page          => 1,
            logged_out           => $logged_out,
            no_breadcrumbs       => 1,
            login_fields         => MT::Auth->login_form($app) || '',
            can_recover_password => 1,
            delegate_auth        => $delegate || 0,
        }
    );
}

## ログ情報のクラスをaccesscontrolに変更する。
sub log {
    my $app = shift;
    unless ($MT::plugins_installed) {
        $app->init_schema();
    }
    my ($msg) = @_;
    require MT::Log;
    my $log = MT::Log->new;
    if ( ref $msg eq 'HASH' ) {
        $log->set_values($msg);
        $msg = $msg->{'message'} || '';
    }
    elsif ( ( ref $msg ) && ( UNIVERSAL::isa( $msg, 'MT::Log' ) ) ) {
        $log = $msg;
    }
    else {
        $log->message($msg);
    }
    $log->ip( $app->remote_ip );
    if ( my $blog = $app->blog ) {
        $log->blog_id( $blog->id );
    }
    if ( my $user = $app->user ) {
        $log->author_id( $user->id );
    }
    $log->level( MT::Log::INFO() )
        unless defined $log->level;

    $log->class('AccessControl');
    $log->save;
}

## サイト上の承認で利用されているクッキーの更新を必要とする場合
sub user_session_cookie_refresh {
   my $app = shift;
   my $cookie = $app->cookies or return;
   my $user_session_cookie_name = MT::Core::UserSessionCookieName( $app->{cfg} );
   return unless exists $cookie->{$user_session_cookie_name};
   my $c = $cookie->{$user_session_cookie_name} or return;
   my $user_name = '';
   ( $user_name ) = $c->value =~ m!name:\'([^\']+)\'!;
   if( $user_name && $user_name ne $app->user->name )
   {
       my $ctx = MT::Template::Context->new;
       $ctx->stash( 'blog' , $app->blog );
       $ctx->stash('blog_id' , $app->blog->id );
       my $domain = $ctx->invoke_handler( 'MTUserSessionCookieDomain' ); 
       my %mt_blog_user = (
          -name  => $user_session_cookie_name,
          -value => '',
          -path  => $c->path,
          -domain => $domain,
          -expires => '-1y',
       );
       $app->bake_cookie(%mt_blog_user);
   }
}

1;
