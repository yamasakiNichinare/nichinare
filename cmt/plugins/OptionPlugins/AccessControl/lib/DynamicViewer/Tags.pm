package DynamicViewer::Tags;

use strict;
use warnings;
use CGI::Carp;
use MT 5;
use MT::Template::Context;
use Data::Dumper;

sub plugin { MT->instance->component( 'DynamicViewer' ); }

## 動的領域の設定
sub dynamic_space {
   my ($ctx , $args , $cond ) = @_;
   my $tag = $ctx->stash('tag');
   ## MT管理画面以外はそのまま再構築
   return dynamic_space_execute( $ctx , $args , $cond )
       if plugin->is_dynamic();

   ## MT管理画面から再構築した場合( 部分的な再構築の仕掛け )
   my $template = '<MTDynamicSpaceExecute>'. $ctx->stash('uncompiled') . '</MTDynamicSpaceExecute>';
   return $template;
}

## 動的領域の実行
sub dynamic_space_execute {
  my ($ctx , $args , $cond ) = @_;
  my $tokens = $ctx->stash( 'tokens' );
  my $builder = $ctx->stash( 'builder' );
  my $out = $builder->build( $ctx , $tokens , $cond )
                  or return $ctx->error( $builder->errstr );
  return $out;
}

## 専用ページ
sub system_pages {
   my ( $ctx , $args , $cond ) = @_;
   my $tag = lc $ctx->stash('tag');
   require MT::Blog;
   my $blog = '';
   if ( exists $args->{blog_id} ) {
       $blog = MT::Blog->load( $args->{blog_id} ) || '';
   }else{
       $blog = $ctx->stash('blog');
       unless( $blog ){
           $blog = $ctx->stash('blog_id') 
              ? MT::Blog->load( $ctx->stash('blog_id') ) || '' 
              : '';
      }
   }
   return $ctx->error('no blog') unless $blog;
   my $page_key = 'error_page_name';
   my $default_name = 'Error';
   if( 'dynamicviewerloginurl' eq $tag ){
      $page_key = 'login_page_name';
      $default_name = 'Login';
   }elsif( 'dynamicviewerlogouturl' eq $tag ) {
      $page_key = 'logout_page_name';
      $default_name = 'Logout';
   }
   my $param = plugin->load_plugin_param( 'blog:'.$blog->id );
   if( $blog->is_blog && $param->{'inheritance'} ){
       $param = plugin->load_plugin_param( 'blog:'.$blog->website->id );
   }
   return sprintf '%s%s' , $blog->site_url , $param->{$page_key};
}

1;

