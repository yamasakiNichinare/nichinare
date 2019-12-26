package BlogRebuilder::CMS;

use strict;
use warnings;
use Data::Dumper;

sub instance { MT->instance->component('BlogRebuilder'); }

## 左メニュー上に表示させることを許可するかどうか判定する
##  false: 非表示
##  true : 表示
sub show_blog_menu    { return &_show_condition( 'blog'    ); }
sub show_website_menu { return &_show_condition( 'website' ); }
sub show_system_menu  { return &_show_condition( 'system'  ); }
sub _show_condition {
    my ( $app, $scope, $old_version, $blog_id ) = &_show_option( @_ );

    $app or return 0;
    # version < 5
    if ( $old_version ) {
       return 0 if $scope ne 'blog';
    }
    # version >= 5
    return 0 if $scope eq 'blog' && !$blog_id; 
    return &_accept_permission( $app , $blog_id );
}
sub _show_option {
    my $scope = shift;

    my $app = MT->instance || "";
    my $old_version = $MT::VERSION < 5.0 ? 1 : 0;
    my $blog_id = $app && $app->can( 'param' ) ? $app->param('blog_id') || 0 : 0;

    return ( $app, $scope, $old_version, $blog_id );
}
## ユーザの実行権限判定
sub _accept_permission {
    my ( $app , $blog_id ) = @_;

    return 0 unless eval { $app->isa('MT::App') };
    $app->can( 'user' ) or return 0;
    $app->user or return 0;
    $app->user->is_superuser and return 1;

    my $perms;
    $perms = MT::Permission->load({ blog_id => 0 , author_id => $app->user->id });
    $perms && $perms->can_administer and return 1;

    $blog_id or return 0;
    
    $perms = MT::Permission->load({ blog_id => $blog_id , author_id => $app->user->id });
    $perms && $perms->can_rebuild and return 1;

    return 0;
}

## 再構築選択画面
sub setting {
    my $app = shift;

    eval { $app->isa('MT::App') }
       or die &instance->translate("Invalid request.");

    my $blog_id = $app->can('param') ? $app->param('blog_id') || 0 : 0;

    my $author = $app->can('user') && $app->user ? $app->user : '';
    $author or return $app->error( $app->translate( "Invalid request." ) );

    &_accept_permission( $app , $blog_id )
        or return $app->error( $app->translate("Permission denied.") );

    my $old_version = $MT::VERSION < 5.0 ? 1 : 0;

    my ( $blog , $scope )  = ( '' , 'system' );
    if ( $blog_id ) {

           $blog = MT::Blog->load( { id => $blog_id } )
               or return $app->error( $app->translate("Invalid request.") );

           $scope = 'blog';
           $scope = 'website' if !$old_version && $blog->can( 'is_blog' ) && !$blog->is_blog;
               
    }

    my @can_rebuild_blogs;
    @can_rebuild_blogs = &_can_rebuild_blogs ( $app , $scope , $old_version ,  $blog_id , $blog );

    my $params = {
      system_overview_nav => 1,
      screen_group => 'tools',
      return_blog_id => $blog_id,,
      scope => $scope,
      blog_id => $blog_id,
      can_rebuild_blogs => \@can_rebuild_blogs,
    };
    $app->build_menus ( $params );
    return &instance->load_tmpl ('default.tmpl', $params);

}

## ユーザが再構築可能なウェブサイト、ブログの一覧を構築
sub _can_rebuild_blogs {
    my ( $app , $scope , $old_version , $blog_id , $blog ) = @_;

    my @return_lists;
    my $terms = {};

    if ( $scope eq 'website' ) {

        $terms->{id} = $blog_id;

    } elsif ( $scope eq 'blog' && !$old_version ) {

        $terms->{id} = $blog->website->id;

    } elsif ( !$old_version ) {

        $terms->{class} = 'website';

    }

    my ( @blogs , $can_rebuild );
    @blogs = MT::Blog->load( $terms , undef );
    foreach my $p ( @blogs ) {

        $can_rebuild = _accept_permission( $app , $p->id );
        push @return_lists , {
             id => $p->id,
             name => $p->name,
             can_rebuild => $can_rebuild,
             indent => 0,
        };

        if ( !$old_version ) {
            my $childrens = $p->blogs;
            foreach my $c ( @$childrens ) {
                $can_rebuild = _accept_permission( $app , $c->id );
                push @return_lists , {
                    id => $c->id,
                    name => $c->name,
                    can_rebuild => $can_rebuild,
                    indent => 1,
                };
            }
        }

    }
    return @return_lists;
}

## 再構築の実行
sub execute {
    my $app = shift;

    eval { $app->isa('MT::App') }
       or die &instance->translate("Invalid request.");

    my $start = $app->param('start') || 0;
    my $scope = $app->param('scope') || 0;
    my $return_blog_id = $app->param('return_blog_id') || 0;
    my $blog_id = $app->can('param') ? $app->param('blog_id') || 0 : 0;
    my $author = $app->can('user') && $app->user ? $app->user : '';
    $author or return &_show_error( $app , $app->translate("Invalid request.")  );

    &_accept_permission( $app , $blog_id )
        or return &_show_error( $app , $app->translate("Permission denied.") );

    my $blog = MT::Blog->load( { id => $blog_id } , undef );
    my $blog_name = $blog ? $blog->name : 'system';
    unless ( $start ) {
        $blog or return &_show_rebuild_error( $app , $scope , $app->translate("Couldn't load Blog") , $blog_id , $return_blog_id );

        my $ret = &_rebuild_blog( $app , $blog_id );
        return &_show_rebuild_error( $app , $scope , $ret , $blog_id , $return_blog_id ) if $ret;

    }
    my $params = {
        blog_id => $blog_id,
        scope => $scope,
        blog_name => $blog_name,
        start => $start,
        return_blog_id => $return_blog_id,
    };
    my @q;
    @q = $app->param('queue') if $app->param('queue');
    if ( @q ) {

        my $target_id = $MT::VERSION < 5.0 ? pop @q : shift @q;
        MT::Blog->load( { id => $target_id } , undef )
            or return &_show_rebuild_error( $app , $scope , $app->translate("Couldn't load Blog") , $target_id , $return_blog_id );

        $params->{next_uri} = $app->uri( mode => "rebuild_blogs_execute", 
            args => { blog_id => $target_id , scope => $scope , return_blog_id => $return_blog_id }); 

        $params->{next_uri} = join "&queue=" , ( $params->{next_uri} , @q );
        $params->{blog_id} = $target_id;

    } else {

        $params->{next_uri} = $app->uri( mode => "rebuild_blogs_done",
            args => { blog_id => $return_blog_id , scope => $scope });

    }
    $app->build_menus ( $params );
    return &instance->load_tmpl ('rebuild.tmpl', $params);

}
sub _show_error {
   my ( $app , $error ) = @_;
   return $app->error( $error );
}
sub _show_rebuild_error {
   my ( $app , $scope , $error , $blog_id , $return_blog_id ) = @_;
   my $params = {
      error => $error,
      blog_id => $blog_id,
      return_blog_id => $return_blog_id,
      scope => $scope,
   };
   $app->build_menus ( $params );
   return &instance->load_tmpl ('error.tmpl', $params);
}
sub _rebuild_blog {
   my ( $app , $blog_id ) = @_;
   my $ret = $app->rebuild('BlogID' => $blog_id) || '';
   unless ( $ret == 1 ) {
       return $ret if $ret;
       $ret = $app->errstr;
       $app->{_errstr} = "";
       return $ret;
   }

   # full rebuild of categories
   my $mt = MT->instance;
   $ret = $mt->publisher->rebuild_categories('BlogID' => $blog_id) || '';

   unless ( $ret == 1 ) {
       return $ret if $ret;
       $ret = $app->errstr;
       $app->{_errstr} = "";
       return $ret;
   }

   return 0;
}
sub done {
    my $app = shift;

    eval { $app->isa('MT::App') }
       or die &instance->translate("Invalid request.");

    my $scope = $app->param('scope') || 0;
    my $return_blog_id = $app->param('return_blog_id') || 0;
    my $blog_id = $app->can('param') ? $app->param('blog_id') || 0 : 0;
    my $author = $app->can('user') && $app->user ? $app->user : '';
    $author or return $app->error( $app->translate("Invalid request.") );

    &_accept_permission( $app , $blog_id )
        or return $app->error( $app->translate("Permission denied.") );

    my $params = {
       scope => $scope,
       blog_id => $blog_id, 
    };

    $app->build_menus ( $params );
    return &instance->load_tmpl ('done.tmpl', $params);

}

1;
