package AccessControl::Tags;
use strict;
use warnings;
use CGI::Carp;
use MT 5;
use MT::Template::Context;
use MT::Template::Tags::Entry;
use MT::Template::Tags::Website;
use MT::Template::Tags::Page;
use MT::Template::Tags::Category;
use MT::Template::Tags::Folder;
use MT::Template::Tags::Comment;
use MT::Template::Tags::Ping;
use MT::Template::Tags::Asset;

use Data::Dumper;
## ログインユーザ情報
sub author {
   my ( $ctx , $args , $cond ) = @_;
   my $dv = MT->instance->component( 'DynamicViewer' );
   if( $dv && $dv->is_dynamic()  ){
      my $app = MT->instance->app;
      my $author = ( $app && exists $app->{author} && $app->{author} ) ? $app->user : '' ;
      return '' unless $author;
      my $out = '';
      {
          local $ctx->{__stash}{author} = $author;
          my $tokens = $ctx->stash( 'tokens' );
          my $builder = $ctx->stash( 'builder' );
          $out = $builder->build( $ctx , $tokens , $cond )
                        or return $ctx->error( $builder->errstr );
      }
      return $out;
  }
  return '';
}

## パーミッション
sub permission_check {
  my ( $app , $blog_id , $permissions , $and ) = @_;

  return 0 unless $app && exists $app->{author} && $app->{author};
  return 1 if $app->user->is_superuser;
  my $p = MT::Permission->load( { author_id => $app->user->id , blog_id => 0  } );
  return 1 if $p && $p->can_administer;
  return 0 unless $blog_id;
  $p = MT::Permission->load( { author_id => $app->user->id , blog_id => $blog_id  } ) 
             or return 0;

  my $blog = MT::Blog->load( $blog_id ) or return 0;
  my $flg = 0;
  my $p_list = $p->permissions;
  foreach my $permit ( @{$permissions} )
  {
      if( $and )
      {
          $flg = 0;
          MT::I18N::utf8_off( $p_list );
          if( $permit eq '__AC_CAN_VIEW___' )
          {
              $flg = 1;
          }else{
              my $extended = MT::Util::perl_sha1_digest_hex ($permit);
              $flg = 1 if $p_list =~ m/(\'$permit\'|\'$extended\')/;
          }
          return 0 unless $flg;

      }else{

          return 1 if $permit eq '__AC_CAN_VIEW___'; ## 何かしらの権限があればいい
          my $extended = MT::Util::perl_sha1_digest_hex ($permit);
          return 1 if $p_list =~ m/(\'$permit\'|\'$extended\')/;

     }
  }
  return 1 if $and && $flg;
  return 0;

}

sub can_do {
  my ( $ctx , $args , $cond ) = @_;
  my $app = MT->instance->app or return 0;
  my $perms = ( exists $args->{perms} && $args->{perms} ) || '';
  my @permissions;
  if(  $perms =~ /,/ ){
     $perms =~ s!\s!!g;
     @permissions = split /,/ , $perms;
  }else{
     push @permissions , $perms;
  }
  my %alias = {
     'folder'  => 'category',
     'website' => 'blog',
     'page'    => 'entry',
  };
  my $blog_id = 0;
  if( exists $args->{blog_id} && $args->{blog_id} ){
      $blog_id = $args->{blog_id};
  }else{
      for( 'global' , 'blog' , 'entry' , 'page' , 'category' , 'folder' , 'comment' )
      {
          next unless ( exists $args->{$_} && $args->{$_} ) || ( exists $args->{space} && $args->{space} eq $_);
          if( $_ eq 'global' )
          {
              $blog_id = ( $app->blog && $app->blog->id ) || $app->param('blog_id') || 0;
              last;
          }
          my $obj = $ctx->stash($_)
                  ? $ctx->stash($_)
                  : $ctx->stash($alias{$_})
                        ? $ctx->stash($alias{$_})
                        : 0;
         last;
     }
     unless( $blog_id ){
        $blog_id = ( $app->blog && $app->blog->id ) || $app->param('blog_id') || 0;
     }
  }
  if( exists $app->{author} && $app->{author} )
  {
     my $and = 0;
     if( exists $args->{and} && $args->{and} ){
        $and = 1;
     }
     return permission_check( $app , $blog_id , \@permissions , $and );
  }
  return 0;
}
sub can_view {
   $_[1]->{perms}     = '__AC_CAN_VIEW___';
   return can_do( $_[0] , $_[1] , $_[2] );
}
sub can_comment { 
   $_[1]->{perms}     = 'comment';
   return can_do( $_[0] , $_[1] , $_[2] );
}
sub can_post {
   $_[1]->{perms}     = 'create_post,publish_post';
   $_[1]->{and} = 1;
   return can_do( $_[0] , $_[1] , $_[2]  );
}
sub can_edit {
   my ( $ctx , $args , $cond ) = @_;
   my $app = MT->instance->app or return 0;
   my $obj;
   my $obj_id;
   my %args;
   my $perms;
   return 0 unless exists $app->{author} && $app->{author};
   return 1 if $app->user->is_superuser;
   my $type = 'entry';
   $type = $args->{$_} ? $_ : next for( 'entry' , 'page' , 'category' , 'folder' );
   if( $type eq 'entry' || $type eq 'page' )
   {
       $obj_id = $ctx->invoke_handler( $type .'id' , \%args , $cond ) || 0;
      if( $obj_id ){
           $obj = MT::Entry->load( $obj_id ) || '';
           return 0 unless $obj;
           $perms = MT::Permission->load({ author_id => $app->user->id , blog_id => $obj->blog_id })
                      or return 0;
           return 1 if $perms->can_edit_entry( $obj , $app->user , $obj->status eq 2 ? undef : 1 );
       }
   }elsif( $type eq 'categroy' || $type eq 'folder' ){
       $obj_id = $ctx->invoke_handler($type.'id' , \%args , $cond ) || 0;
       if( $obj_id ){
           $obj = MT::Category->load( $obj_id ) || '';
           return 0 unless $obj;
           $perms = MT::Permission->load({ author_id => $app->user->id , blog_id => $obj->blog_id })
                      or return 0;
           return 1 if $perms->can_edit_categories;
       }
   }
   return 0;
}
sub can_blog_admin {
   $_[1]->{perms}     = 'administer_blog';
   return can_do( $_[0] , $_[1] , $_[2] );
}

sub can_website_admin {
   $_[1]->{perms}     = 'administer_website';
   return can_do( $_[0] , $_[1] , $_[2] );
}

sub can_administer {
   $_[1]->{perms}     = 'administer';
   return can_do( $_[0] , $_[1] , $_[2] );
}


## システムページ
##
## blog_id : 指定ブログのシステムページ
##
sub system_pages {
   my ( $ctx , $args , $cond ) = @_;

   my $app = MT->instance->app;
   my $tag = lc $ctx->stash('tag');
   require MT::Blog;
   my $blog = '';
   if ( exists $args->{blog_id} && $args->{blog_id} ) {
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
   my $object_id = '';
   if( 'accesscontrolloginurl' eq $tag || 'acloginurl' eq $tag ){
      $page_key = 'login_page_name';
      $default_name = 'Login';
   }elsif( 'accesscontrollogouturl' eq $tag || 'aclogouturl' eq $tag ) {
      $page_key = 'logout_page_name';
      $default_name = 'Logout';
   }elsif( 'accesscontrolsystemloginurl' eq $tag || 'acsystemloginurl' eq $tag ){
      return MT->config('CGIPath') . MT->config('AdminScript') . '?__mode=login&amp;blog_id=' . $blog->id;
   }elsif( 'accesscontrolsystemlogouturl' eq $tag || 'acsystemloginurl' eq $tag ){
      return MT->config('CGIPath') . MT->config('AdminScript') . '?__mode=logout&amp;blog_id=' . $blog->id;
   }elsif( 'accesscontrolsystemuserdashboard' eq $tag || 'acsystemuserdashboard' eq $tag ){
      return MT->config('CGIPath') . MT->config('AdminScript') . '?__mode=dashboard';
   }elsif( 'accesscontrolsystempostentry' eq $tag || 'acsystempostentry' eq $tag ){
      if( $blog->is_blog && !( exists $args->{'page'} && $args->{'page'} ) ){
          return MT->config('CGIPath') . MT->config('AdminScript') . '?__mode=view&amp;_type=entry&amp;blog_id=' . $blog->id;
      }
      return MT->config('CGIPath') . MT->config('AdminScript') . '?__mode=view&amp;_type=page&amp;blog_id=' . $blog->id;
   }elsif( 'accesscontrolsystemeditentry' eq $tag || 'acsystemeditentry' eq $tag ){
      $blog = $ctx->stash('blog') or 
            $ctx->stash('blog_id')
                 ? MT::Blog->load( $ctx->stash('blog_id') )
                 : 0;
      $object_id = $ctx->invoke_handler('entryid', $args , $cond ) || 0;
      if( $blog->is_blog && $object_id ){
          return MT->config('CGIPath') . MT->config('AdminScript') . '?__mode=view&amp;_type=entry&amp;blog_id=' . $blog->id . '&amp;id=' . $object_id;
      }
      return '';

   }elsif( 'accesscontrolsystemeditpage' eq $tag || 'acsystemeditpage' eq $tag ){
      $blog = $ctx->stash('blog') 
            or $ctx->stash('blog_id')
                 ? MT::Blog->load( $ctx->stash('blog_id') )
                 : 0;
      $object_id = $ctx->invoke_handler('pageid', $args , $cond ) || 0;
      if( $object_id ){
          return MT->config('CGIPath') . MT->config('AdminScript') . '?__mode=view&amp;_type=page&amp;blog_id=' . $blog->id . '&amp;id=' . $object_id;
      }
      return '';
   }elsif( 'accesscontrolsystemeditcategory' eq $tag || 'acsystemeditcategory' eq $tag ){
      $blog = $ctx->stash('blog') 
            or $ctx->stash('blog_id')
                 ? MT::Blog->load( $ctx->stash('blog_id') )
                 : 0;
      $object_id = $ctx->invoke_handler('categoryid', $args , $cond ) || 0;
      if( $blog->is_blog && $object_id ){
          return MT->config('CGIPath') . MT->config('AdminScript') . '?__mode=view&amp;_type=category&amp;blog_id=' . $blog->id . '&amp;id=' . $object_id;
      }
      return '';
   }elsif( 'accesscontrolsystemeditfolder' eq $tag || 'acsystemeditfolder' eq $tag ){
      $blog = $ctx->stash('blog') 
            or $ctx->stash('blog_id')
                 ? MT::Blog->load( $ctx->stash('blog_id') )
                 : 0;
      
      $object_id = $ctx->invoke_handler('folderid', $args , $cond ) || 0;
      if( $object_id ){
          return MT->config('CGIPath') . MT->config('AdminScript') . '?__mode=view&amp;_type=folder&amp;blog_id=' . $blog->id . '&amp;id=' . $object_id;
      }
      return '';
   }elsif( 'accesscontrolsystemurl' eq $tag || 'acsystemurl' eq $tag ){
      return MT->config('CGIPath');
   }elsif( 'accesscontrolsystemsettings' eq $tag || 'acsystemsettings' eq $tag ){
      return MT->config('CGIPath') . MT->config('AdminScript') . '?__mode=cfg_system_general&amp;blog_id=0';
   }elsif( 'accesscontrolsystemblogsettings' eq $tag || 'acsystemblogsettings' eq $tag ){
      return MT->config('CGIPath') . MT->config('AdminScript') . '?__mode=cfg_prefs&amp;blog_id=' . $blog->id;
   }
   my $dv = MT->instance->component( 'DynamicViewer' );
   return '' unless $dv;
   my $param = $dv->load_plugin_param( 'blog:'.$blog->id );
   if( $blog->is_blog && $param->{'inheritance'} ){
       $param = $dv->load_plugin_param( 'blog:'.$blog->website->id );
   }
   return sprintf '%s%s' , $blog->site_url , $param->{$page_key};
}

##
## 参照ブログ制限
##
sub accesscontrol_include_blogs {
  my $app = MT->instance->app;
  my @list;
  if( $app && exists $app->{author} && $app->{author} )
  {

      my $perms = MT::Permission->load( { author_id => $app->user->id , blog_id => 0 } );
      if( $app->user->is_superuser || ( $perms && $perms->permissions ) ){
          my @blogs;
          @blogs = MT::Blog->load( { class => '*' } );
          @list = map{ $_->id } @blogs;
      }else{
          my @perms = MT::Permission->load( { author_id => $app->user->id  });
          @list = map{ $_->blog_id } grep { $_->blog_id != 0 && $_->permissions } @perms;
      }
  }
  return \@list if scalar @list;
  return '';
}

sub accesscontrol_tags {
    my ( $ctx, $args, $cond ) = @_;

    my $app = MT->instance;
    my $tag = lc $ctx->stash('tag');
    $tag =~ s/^(?:accesscontrol|ac)//g;

    unless ($args->{blog_id} || $args->{blog_ids} || $args->{include_blogs} || $args->{exclude_blogs}) {
        if ($app->isa('MT::App::Search') && !$ctx->stash('inside_blogs')) {
            if (my $excl = $app->{searchparam}{ExcludeBlogs}) {
                $args->{exclude_blogs} ||= join ',', @$excl;
            } elsif (my $incl = $app->{searchparam}{IncludeBlogs}) {
                $args->{include_blogs} = join ',', @$incl;
            }
            delete $args->{blog_id}
                     if ($args->{include_blogs} || $args->{exclude_blogs}) 
                     && $args->{blog_id};
        }
    }

    ## MultiBlog supoorted.
    my $mb = MT->component('multiblog');
    if ( defined $mb && $args->{multiblog} ) {

        require MultiBlog;
        if ( ! MultiBlog::filter_blogs_from_args( $mb, $ctx, $args) ) {
            return $ctx->errstr ? $ctx->error($ctx->errstr) : '';
        }
        elsif ($tag eq 'include' and ! exists $args->{blog_id}) {
           if ( $ctx->stash('multiblog_context') && !$args->{local} ) {
               $args->{blog_id} = $ctx->stash('blog_id');
           }
           else {
               my $local_blog_id = $ctx->stash('local_blog_id');
               if (defined $local_blog_id) {
                   $args->{blog_id} = $local_blog_id;
               }
           }
        }
        elsif ( my $mode = $ctx->stash('multiblog_context') ) {
            $args->{$mode} = $ctx->stash('multiblog_blog_ids');
        }
        else {
           
           my $ids = $args->{include_websites} || $args->{exclude_websites};
           my $mode = $args->{include_websites} ? 'include_blogs' : 'exclude_blogs';
           my @ids;
           foreach my $id (split /\s*,\s*/,$ids) {
               if ($id =~ m/^(\d+)-(\d+)$/) {
                    push @ids , $_ for $1..$2;
               } else {
                    push @ids, $id;
               }
           }
           if ( @ids ) {
              $args->{$mode} = join ',' , @ids;
           }
           else {
              delete $args->{include_websites};
              delete $args->{exclude_websites};
           }

        }
    }
    else {
       &filter_blogs_from_args( $ctx , $args );
       return $ctx->error($ctx->errstr) if $ctx->errstr;

    }

    my ( $incl , $excl , $group_ids , $allow , $allow_ids  );
    $incl = $args->{include_blogs} || $args->{include_websites};
    $incl = 'all'
       if $incl =~ /all/ && $incl =~ /,/ && ( $args->{multiblog} && $mb ); 
    $excl = $args->{exclude_blogs} || $args->{exclude_websites};
    my $list = $ctx->{__stash}{accesscontrol_include_blogs} || '';
    unless ( $list ) {
        $allow = &accesscontrol_include_blogs();
        $ctx->{__stash}{accesscontrol_include_blogs} = $allow if $allow;
    } 
    else {
        $allow = $list;
    }
    return "" unless $allow && @$allow;

    $group_ids = $app->{'__proxy_group_blogs'} if keys %{$app->{'__proxy_group_blogs'}};
    $allow_ids = { map{ $_ => 1 } @$allow } if @$allow;
    if ( $args->{blog_id} ) {

        return ''
           unless $group_ids->{$args->{blog_id}} 
           && $allow_ids->{$args->{blog_id}};

        delete $args->{exclude_blogs};
        delete $args->{include_blogs};

    }
    elsif ( $incl ) {
        if ( $incl eq 'all') {
             if ( $tag eq 'blogs' || $tag eq 'websites' ) {
                 $incl = '';
                 for ( @$allow ) {
                    next if $tag eq 'blogs' && $group_ids->{$_} && $group_ids->{$_}->{website};
                    next if $tag eq 'websites' && $group_ids->{$_} && $group_ids->{$_}->{blog};
                    $incl .= $incl ? ",$_" : $_;
                 }
            }
            else {
               $incl = join ',' , @$allow if $incl eq 'all';
            }
        }
        if ( $incl eq 'site' || $incl eq 'children' || $incl eq 'siblings' ) {
             my $this_blog = $ctx->stash('blog');
             my $this_blog_id = $this_blog->is_blog ? $this_blog->website->id : $this_blog->id;
             
             $incl = join ',' , map { $_->id } MT->model('blog')->load(
                 { parent_id => $this_blog_id },
                 { fetch_only => ['id'], no_triggers => 1 }
             );

             $incl .= ",$this_blog_id"
                if $args->{include_with_website};

        }

        $incl = join ',' , grep {
             $group_ids->{$_} && $allow_ids->{$_}
        } split /\s*,\s*/ , $incl;
        $args->{include_blogs} = $incl;
    }
    elsif ( $excl ) {

        my $deny_ids = { map { $_ => 1 } split /\s*,\s*/ , $excl } if $excl;
        $incl = join ',' , grep {
             !( exists $deny_ids->{$_} ) && $allow_ids->{$_}
        } keys %$group_ids;
        delete $args->{'exclude_blogs'};
        $excl = '';
        $args->{'include_blogs'} = $incl;

    }
    else {

       $incl = join ',' , grep { 
           $group_ids->{$_}
              && (( (lc $tag eq 'blogs') && $group_ids->{$_}->{blog} )
                   || ( (lc $tag eq 'websites') && $group_ids->{$_}->{blog} == 0 ))
       } keys %$allow_ids;
       $args->{include_blogs} = $incl;

    }
    for ( 
      'include_with_website',
      'multiblog',
      'include_websites',
      'exclude_websites',
      'blog_ids',
    ){
        delete $args->{$_};
    }
    unless ( $args->{include_blogs} || $args->{exclude_blogs} ) {
        return 0 if $tag =~ /^blogentrycount|blogpingcount|blogcategorycount$/i;
        return "";
    }
    local $ctx->{__stash}{local_blog_id} = 0 if $tag eq 'tags';

    defined( my $result = $tag eq 'blogs'
         ? &blogs( $ctx , $args , $cond )
         : $ctx->invoke_handler( $tag , $args, $cond ))
              or return $ctx->error($ctx->errstr);

    $result;
}

sub filter_blogs_from_args {
    my ($ctx, $args) = @_;

    my $err;
    my $incl = $args->{blog_ids} 
             || $args->{include_blogs}
             || $args->{site_ids} 
             || $args->{include_websites};

    my $excl = $args->{exclude_blogs}
             || $args->{exclude_websites};

    return 0 unless $incl || $excl;

    my $args_count =  
         scalar grep { $_ and $_ ne '' } 
             $args->{include_blogs},
             $args->{blog_id},
             $args->{blog_ids},
             $args->{exclude_blogs};

    if ( $args_count > 1 ) {
       $err = MT->translate('The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.');
    } 
    elsif ( $excl
        && (   lc( $excl ) eq 'all'
            || lc( $excl ) eq 'site'
            || lc( $excl ) eq 'children'
            || lc( $excl ) eq 'siblings' )
    ) { 
        return $ctx->error(MT->translate(
                "The attribute exclude_blogs cannot take '[_1]' for a value.",
                $excl
            ));
    }
    elsif ($args->{blog_id} and $args->{blog_id} !~ /^\d+$/) {
        $err = MT->translate('The value of the blog_id attribute must be a single blog ID.');
    }
    else {
        my $list = $incl || $excl;
        if ( ( $list !~ /^\d+([,-]\d+)*$/ )
          && lc( $list ) ne 'all'
          && lc( $list ) ne 'site'
          && lc( $list ) ne 'children'
          && lc( $list ) ne 'siblings' )
        {   
            $err = MT->translate('The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.');
        }
    }
    return $ctx->error($err) if $err;

    my ($attr, $val, @blogs);
    if ($incl) {
        ($attr, $val) = ('include_blogs', $incl);
    } else {
        ($attr, $val) = ('exclude_blogs', $excl);
    }

    if ($val =~ m/-/) {
        my @list = split /\s*,\s*/, $val;
        my $ids = "";
        foreach my $id (@list) {
            if ($id =~ m/^(\d+)-(\d+)$/) {
                push @blogs, $_ for $1..$2;
            } else {
                push @blogs, $id;
            }
        }
    }
    else {
        @blogs = split(/\s*,\s*/, $val);
    }
    ## アクセスコントロールはallに対してはウェブサイト内のブログに限定するため、ここでは処理しない。
    if ( ($attr eq 'include_blogs') 
          && lc( $blogs[0] ) eq 'all'
    ){
        delete $args->{include_blogs};
        delete $args->{exclude_blogs};
        $args->{$attr} = $blogs[0]; 
        return 1;
    }
    elsif( ($attr eq 'include_blogs')
          && lc( $blogs[0] ) eq 'site'
          && lc( $blogs[0] ) eq 'children'
          && lc( $blogs[0] ) eq 'siblings' 
    ){ 
        my $blog = $ctx->stash('blog');
        @blogs = MT->model('blog')->load(
            { parent_id => $blog->is_blog ? $blog->website->id : $blog->id },
            { fetch_only => ['id'], no_triggers => 1 }
        );

        if ( $args->{include_with_website} ) {
            my $blog = $ctx->stash('blog');
            push @blogs, $blog->is_blog ? $blog->website->id : $blog->id;
        }
    }

    delete $args->{blog_ids} if exists $args->{blog_ids};

    if ($args->{blog_id}) {
        return 1;
    } else {
        delete $args->{include_blogs};
        delete $args->{exclude_blogs};
        $args->{$attr} = join(',', @blogs);
    }
    1;
}

sub blogs {
    my($ctx, $args, $cond) = @_;
    my (%terms, %args);

    $ctx->set_blog_load_context($args, \%terms, \%args, 'id')
        or return $ctx->error($ctx->errstr);

    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');

    local $ctx->{__stash}{entries} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp_end} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{category} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{archive_category} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{inside_blogs} = 1;

    require MT::Blog;
    my $blog_sort = MT->instance->component('BlogsSort') || '';
    $args{'sort'} = $blog_sort ? $blog_sort->sort_key : 'name';
    $args{direction} = 'ascend';
    my $iter = MT::Blog->load_iter(\%terms, \%args);
    my $res = '';
    my $count = 0;
    my $next = $iter->();
    my $vars = $ctx->{__stash}{vars} ||= {};
    while ($next) {
        my $blog = $next;
        $next = $iter->();
        $count++;
        local $ctx->{__stash}{blog} = $blog;
        local $ctx->{__stash}{blog_id} = $blog->id;
        local $vars->{__first__} = $count == 1;
        local $vars->{__last__} = !$next;
        local $vars->{__odd__} = ($count % 2) == 1;
        local $vars->{__even__} = ($count % 2) == 0;
        local $vars->{__counter__} = $count;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error($builder->errstr);
        $res .= $out;
    }
    return $res;
}

sub auto_commenter_sign_in {
  my ( $ctx , $args , $cond ) = @_;

  my $relations_script =  <<'__HTML__';
<MTDynamicSpace>
<MTACAuthor>
<script type="text/javascript">
<!--
function auto_commenter_sign_in () {
    author_name = '<$mt:AuthorDisplayName$>';
    var user = mtGetUser ? mtGetUser() : '';
    if ( user ) {
       if ( user.name != author_name ) {
          mtClearUser();
       }
       else return;
    }
    mtSignInOnClick('signin-widget-content');
    mtUpdateSignInWidget();
}
auto_commenter_sign_in();
//-->
</script>
</MTACAuthor>
</MTDynamicSpace>
__HTML__

   my $dv = MT->instance->component( 'DynamicViewer' );
   if( $dv ){  
      my $out = ''; 
      my $builder = $ctx->stash( 'builder' );
      my $tokens = $builder->compile( $ctx , $relations_script )
          or return $ctx->error ( $builder->errstr );

      $out = $builder->build( $ctx , $tokens , $cond )
          or return $ctx->error( $builder->errstr );

      return $out;
  }
  return "";
}


1;
