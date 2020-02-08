# Movable Type (r) (C) 2007-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: CMS.pm 117483 2010-01-07 08:27:20Z ytakayama $

package MT::Community::CMS;

use strict;

# This package simply holds code that is being grafted onto the CMS
# application; the namespace of the package is different, but the 'app'
# variable is going to be a MT::App::CMS object.

sub cfg_community_prefs {
    my $app     = shift;
    my $q       = $app->param;
    my $blog_id = scalar $q->param('blog_id');

    return $app->return_to_dashboard( redirect => 1 )
      unless $blog_id;

    my $blog_class = $app->model('blog.community');
    my $blog = $blog_class->load($blog_id);
    return $app->return_to_dashboard( redirect => 1 )
      unless $blog && $blog->is_blog;
    $blog = bless $blog, $blog_class;

    my $perms = $app->permissions;
    return $app->error( $app->translate('Permission denied.') )
      unless $app->user->is_superuser()
      || (
        $perms
        && $perms->can_administer_blog
      );
    
    my $param = {
        allow_anon_recommend => $blog->allow_anon_recommend,
        object_label => $blog->class_label,
    };

    my $path = $blog->upload_path || '';
    if ( $path =~ m|^%([ar])[/\\](.+)$| ) {
        $param->{archive_path} = 1
            if $1 && ($1 eq 'a');
        $param->{extra_path} = $2;
    }

    $param->{enable_archive_paths} = $blog->column('archive_path');
    $param->{local_site_path}      = $blog->site_path;
    $param->{local_archive_path}   = $blog->archive_path;
    $param->{cfg_community_prefs}      = 1;

    $app->load_tmpl('tmpl/cfg_community_prefs.tmpl', $param);
}

sub save_community_prefs {
    my $app     = shift;
    my $q       = $app->param;

    $app->validate_magic
      or return $app->errtrans("Invalid request.");

    my $perms = $app->permissions;
    return $app->error( $app->translate('Permission denied.') )
      unless $app->user->is_superuser()
      || (
        $perms
        && $perms->can_administer_blog
      );

    my $blog_id = scalar $q->param('blog_id')
      or return $app->errtrans("Invalid request.");
    my $blog_class = $app->model('blog.community');
    my $blog = $blog_class->load($blog_id);
    return $app->return_to_dashboard( redirect => 1 )
      unless $blog;
    $blog = bless $blog, $blog_class;

    if ( $q->param('allow_anon_recommend') ) {
        $blog->allow_anon_recommend(1);
    }
    else {
        $blog->allow_anon_recommend(0);
    }

    my $root_path;
    if ( $q->param('site_path') ) {
        $root_path = $blog->site_path;
    }
    else {
        $root_path = $blog->archive_path;
    }
    return $app->error(
        $app->translate(
            'Movable Type was unable to write on the "Upload Destination". Please make sure that the folder is writable from the web server.'
        )
    ) unless -d $root_path;

    my $relative_path = $q->param('extra_path');
    my $path = $root_path;
    if ($relative_path) {
        if ( $relative_path =~ m!\.\.|\0|\|! ) {
            return $app->error(
                $app->translate(
                    "Invalid extra path '[_1]'", $relative_path
                )
            );
        }
        $path = File::Spec->catdir( $path, $relative_path );
        ## Untaint. We already checked for security holes in $relative_path.
        ($path) = $path =~ /(.+)/s;
        ## Build out the directory structure if it doesn't exist. DirUmask
        ## determines the permissions of the new directories.
        my $fmgr = $blog->file_mgr;
        unless ( $fmgr->exists($path) ) {
            $fmgr->mkpath($path)
              or return $app->error(
                $app->translate(
                    "Can't make path '[_1]': [_2]",
                    $path, $fmgr->errstr
                )
              );
        }
    }
    my $param = {};

    my $save_path = $q->param('site_path') ? '%r' : '%a';
    $param->{archive_path} = 1
        if $save_path eq '%a';
    $param->{extra_path} = $relative_path;

    $save_path = File::Spec->catfile( $save_path, $relative_path );
    $blog->upload_path($save_path);

    $blog->save
      or $param->{error} = $blog->errstr;

    $param->{allow_anon_recommend} = $blog->allow_anon_recommend;
    $param->{object_label}         = $blog->class_label;

    $param->{enable_archive_paths} = $blog->column('archive_path');
    $param->{local_site_path}      = $blog->site_path;
    $param->{local_archive_path}   = $blog->archive_path;
    $param->{saved}                = 1;

    $app->mode('cfg_community_prefs');
    $app->load_tmpl('tmpl/cfg_community_prefs.tmpl', $param);
}

sub recent_favorites_widget {
    my ($app, $tmpl, $widget_param) = @_;

    require MT::ObjectScore;
    require MT::Entry;
    require MT::App::Community;

    my %terms = ( status => MT::Entry->RELEASE() );
    if ($widget_param->{blog_id}) {
        $terms{blog_id} = $widget_param->{blog_id};
    }

    my @entries = MT::Entry->search(\%terms, {
        join => MT::ObjectScore->join_on(
            'object_id',
            {
                object_ds => MT::Entry->datasource,
                namespace => MT::App::Community->NAMESPACE(),
            },
            {
                limit     => 5,
                sort_by   => 'created_on',
                direction => 'descend',
                unique    => 1,
            }
        ),
    });

    $widget_param->{has_favorite_entries} = @entries ? 1 : 0; # deprecated in favor of: has_scored_entries
    $widget_param->{has_scored_entries} = @entries ? 1 : 0;
    $tmpl->context->stash('entries', \@entries);

    return 1;
}

sub recent_submissions_widget {
    my ($app, $tmpl, $widget_param) = @_;

    require MT::Entry;

    my %terms = ( status => MT::Entry->REVIEW() );
    if ($widget_param->{blog_id}) {
        $terms{blog_id} = $widget_param->{blog_id};
    }

    my @entries = MT::Entry->search(\%terms, {
        sort_by   => 'created_on',
        direction => 'descend',
    });  # all of 'em

    $widget_param->{has_submitted_entries} = @entries ? 1 : 0;
    $tmpl->context->stash('user', $app->user);
    $tmpl->context->stash('entries', \@entries);

    return 1;
}

sub most_popular_entries_widget {
    my ($app, $tmpl, $widget_param) = @_;

    require MT::ObjectScore;
    require MT::Entry;
    require MT::App::Community;

    my $score_data = MT::Entry->_load_score_data({
        namespace => MT::App::Community->NAMESPACE(),
        object_ds => MT::Entry->datasource,
    });

    my %score_for_id;
    for my $score (@$score_data) {
        $score_for_id{$score->object_id} += $score->score;
    }
    my @scoring_entries = sort { $score_for_id{$b} <=> $score_for_id{$a} }
        keys %score_for_id;
    my @entries;

    if (@scoring_entries) {
        my %terms = ( status => MT::Entry->RELEASE() );
        if ($widget_param->{blog_id}) {
            $terms{blog_id} = $widget_param->{blog_id};
        }

        while (@scoring_entries && 10 > scalar @entries) {
            my $id = shift @scoring_entries;

            my ($entry) = MT::Entry->search({
                %terms,
                id => $id,
            });

            push @entries, $entry if $entry;
        }
    }

    $widget_param->{has_popular_entries} = @entries ? 1 : 0;
    $tmpl->context->stash('user', $app->user);
    $tmpl->context->stash('entries', \@entries);

    return 1;
}

sub generate_dashboard_stats_registration_tab {
    my $app = shift;
    my ($tab) = @_;

    my $blog_id = $app->blog ? $app->blog->id : 0;
    my $author_class = $app->model('author');
    my $terms = {};
    my $args = {
        group => [
            "extract(year from created_on)",
            "extract(month from created_on)",
            "extract(day from created_on)"
        ],
    };
    $args->{join} = MT::Permission->join_on('author_id', { blog_id => $blog_id })
        if $blog_id;
    my $reg_iter = $author_class->count_group_by( $terms, $args );

    my %counts;
    while (my ($count, $y, $m, $d) = $reg_iter->()) {
        my $date = sprintf( '%04d%02d%02dT00:00:00', $y, $m, $d );
        $counts{$date} = $count;
    }

    %counts;
}

sub registration_blog_stats_recent_registrations {
    my ($app, $tmpl, $widget_param) = @_;

    my %terms;
    my %args = (
        sort      => 'created_on',
        direction => 'descend',
        limit     => 10,
    );

    if (my $blog_id = $widget_param->{blog_id}) {
        require MT::Permission;
        $args{join} = MT::Permission->join_on(
            'author_id',
            { blog_id => $blog_id },
        );
    }
    else {
        $terms{type} = MT::Author->AUTHOR();
    }

    require MT::Author;
    my @authors = MT::Author->search(\%terms, \%args);
    my @regs;
    for my $user (@authors) {
        my %param = (
            id => $user->id,
            name => $user->name,
            type => $user->type,
            nickname => $user->nickname,
            auth_type => $user->auth_type,
            auth_icon_url => $user->auth_icon_url,
        );
        $param{author_userpic_width}  = 50;
        $param{author_userpic_height} = 50;
        $param{has_edit_access} = 
          $app->user->is_superuser || ($user->id == $app->user->id)
            ? 1 : 0;
        if (my ($url) = $user->userpic_url()) {
            $param{author_userpic_url}    = $url;
        } else {
            $param{author_userpic_url}    = '';
        }
        push @regs, \%param;
    }
    $tmpl->context->var('recent_registrations', \@regs);
}

sub cfg_content_nav_param {
    my ($cb, $app, $param, $tmpl) = @_;
    my $plugin = $cb->plugin;

    my $more = $tmpl->getElementById('more_items');
    return 1 unless $more;

    my $existing = $more->innerHTML;
    $more->innerHTML(<<HTML);
$existing
<li<mt:if name="cfg_community_prefs"> class="active"</mt:if>><a href="<mt:var name="script_url">?__mode=cfg_community_prefs<mt:if name="blog_id">&amp;blog_id=<mt:var name="blog_id" escape="html"></mt:if>"><em><__trans phrase="Community"></em></a></li>
HTML
}

## Friending related methods
sub list_friends {
    my $app = shift;

    my $blog_id = $app->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        if $blog_id;

    my $perms = $app->permissions;
    if ( !$app->user->is_superuser ) {
        return $app->error( $app->translate('Permission denied.') )
            if $app->user->id != $app->param('author_id');
    }

    my $plugin = $app->component('community');
    my $return_args = $app->make_return_args();
    $return_args .= '&author_id=' . $app->param('author_id');
    my $this_author = $app->user;
    my %authors;

    require MT::Community::Friending;
    return $app->listing ({
        template => 'list_author.tmpl',
        type     => 'author',
        args     => {
          'join' => $app->model('objectscore')->join_on('object_id', 
          { 
            author_id => $app->param ('author_id'),
            namespace  => MT::Community::Friending::FRIENDING()
          }),
        },
        params   => {
            author_id   => $app->param('author_id'),
            id => $app->param('author_id'),
            list_noncron => 1,
            return_args => $return_args,
            list_friends => 1,
            user_view => 1,
            $app->param('saved') ? ( saved => 1 ) : (),
            $app->param('saved_deleted') ? ( saved_deleted => 1 ) : (),
            $app->param('saved_removed') ? ( saved_removed => 1 ) : (),
            $app->param('saved_status')
              ? ( 'saved_status_' . $app->param('saved_status') => 1 ) 
              : (),
            $app->user->is_superuser ? () : ( hide_entries_col => 1 ),
        },
        code     => sub {
            my ($au, $row) = @_;
            $row->{name} = '(unnamed)' if !$row->{name};
            $row->{author_id}    = $au->id;
            $row->{email} = ''
              unless ( !defined $au->email )
              or ( $au->email =~ /@/ );
            $row->{has_edit_access}      = $this_author->is_superuser;
            $row->{status_enabled}       = $au->is_active;
            $row->{status_pending}       = $au->status == MT::Author::PENDING();

            if ( $row->{created_by} ) {
                my $parent_author = $authors{ $au->created_by } ||=
                  MT::Author->load( $au->created_by )
                  if $au->created_by;
                if ($parent_author) {
                    $row->{created_by_name} = $parent_author->name;
                }
                else {
                    $row->{created_by_name} = $app->translate('(user deleted)');
                }
            }
            
        }
    });
}

sub list_friends_of {
    my $app = shift;

    my $blog_id = $app->param('blog_id');
    return $app->return_to_dashboard( redirect => 1 )
        if $blog_id;

    my $perms = $app->permissions;
    if ( !$app->user->is_superuser ) {
        return $app->error( $app->translate('Permission denied.') )
            if $app->user->id != $app->param('author_id');
    }

    my $plugin = $app->component('community');
    my $return_args = $app->make_return_args();
    $return_args .= '&author_id=' . $app->param('author_id');
    my $this_author = $app->user;
    my %authors;

    require MT::Community::Friending;
    return $app->listing ({
        template => 'list_author.tmpl',
        type     => 'author',
        args     => {
          'join' => $app->model('objectscore')->join_on('author_id', 
          { 
            object_id => $app->param ('author_id'),   
            namespace  => MT::Community::Friending::FRIENDING() 
          }),
        },
        params   => {
            author_id => $app->param('author_id'),
            id => $app->param('author_id'),
            list_noncron => 1,
            return_args => $return_args,
            list_friends_of => 1,
            user_view => 1,
            $app->param('saved') ? ( saved => 1 ) : (),
            $app->param('saved_deleted') ? ( saved_deleted => 1 ) : (),
            $app->param('saved_removed') ? ( saved_removed => 1 ) : (),
            $app->param('saved_status')
              ? ( 'saved_status_' . $app->param('saved_status') => 1 ) 
              : (),
            $app->user->is_superuser ? () : ( hide_entries_col => 1 ),
        },
        code     => sub {
            my ($au, $row) = @_;
            $row->{name} = '(unnamed)' if !$row->{name};
            $row->{author_id}    = $au->id;
            $row->{email} = ''
              unless ( !defined $au->email )
              or ( $au->email =~ /@/ );
            $row->{has_edit_access}      = $this_author->is_superuser;
            $row->{status_enabled}       = $au->is_active;
            $row->{status_pending}       = $au->status == MT::Author::PENDING();

            if ( $row->{created_by} ) {
                my $parent_author = $authors{ $au->created_by } ||=
                  MT::Author->load( $au->created_by )
                  if $au->created_by;
                if ($parent_author) {
                    $row->{created_by_name} = $parent_author->name;
                }
                else {
                    $row->{created_by_name} = $app->translate('(user deleted)');
                }
            }
            
        }
    });
}

sub pending_entry_filter {
    my ($terms) = @_;
    $terms->{status} = MT->model('entry')->REVIEW;
}

sub spam_entry_filter {
    my ($terms) = @_;
    $terms->{status} = MT->model('entry')->JUNK;
}

sub many_friends {
    my ($terms, $args) = @_;

    require MT::Community::Friending;
    my $iter = MT->model('objectscore')->count_group_by(
      {
        object_ds  => 'author',
        namespace  => MT::Community::Friending::FRIENDING(),
      },
      { group => [ 'author_id' ] }
    );
    my @ids;
    while (my ($count, $author_id) = $iter->()) {
        next unless $count >= 1;
        push @ids, $author_id;
    }

    $terms->{id} = \@ids;
}

sub many_friends_of {
    my ($terms, $args) = @_;

    require MT::Community::Friending;
    my $iter = MT->model('objectscore')->count_group_by(
      {
        object_ds  => 'author',
        namespace  => MT::Community::Friending::FRIENDING(),
      },
      { group => [ 'object_id' ] }
    );
    my @ids;
    while (my ($count, $object_id) = $iter->()) {
        next unless $count >= 1;
        push @ids, $object_id;
    }

    $terms->{id} = \@ids;
}

sub param_list_author {
    my ($cb, $app, $param, $tmpl) = @_;

    _inject_styles($tmpl);
    my $loop = $param->{object_loop};

	my %author_entries;
    # swap page titles for these screens
    if ( exists($param->{list_friends})
      || exists($param->{list_friends_of}) ) {
        my $elements = $tmpl->getElementsByTagName('setvarblock');
        my ($element) = grep { 'page_title' eq $_->getAttribute('name') }
            @$elements;
        if ( $element ) {
            my $title = q();
            if ( exists $param->{list_friends} ) {
                $title = '<__trans phrase="Users followed by [_1]" params="<mt:var name="au_name" escape="html" escape="html">">';
            }
            elsif ( exists $param->{list_friends_of} ) {
                $title = '<__trans phrase="Users following [_1]" params="<mt:var name="au_name" escape="html" escape="html">">';
            }
            $element->innerHTML(
                '<__trans_section component="community">'.$title.'</__trans_section>');
            my $au = $app->model('author')->load( $app->param('author_id') );
            $param->{au_name} = $au->name;
        }
		my @author_ids = map { $_->{id} } @$loop;
        my $author_entry_count_iter =
          MT::Entry->count_group_by(
            { author_id => \@author_ids },
            { group     => ['author_id'] } );
        while ( my ( $count, $author_id ) = $author_entry_count_iter->() ) {
            $author_entries{ $author_id } = $count;
        }
    }

    # add two columns to show the number of friends for each row
    my $header_str = q{
<th id="at-friend-count"><__trans_section component="community"><__trans phrase="Following"></__trans_section></th>
<th id="at-friend-of-count"><__trans_section component="community"><__trans phrase="Followers"></__trans_section></th>};
    if ( $param->{more_column_headers} ) {
        push @{ $param->{more_column_headers} }, $header_str;
    }
    else {
        $param->{more_column_headers} = [ $header_str ];
    }

    my $column_str = q{
<td><mt:if name="friends"><mt:if name="is_administrator"><a href="<mt:var name="script_url">?__mode=list_friends&amp;author_id=<mt:var name="id" escape="html">"></mt:if><mt:var name="friends" escape="html"><mt:if name="is_administrator"></a></mt:if><mt:else>0</mt:if></td>
<td><mt:if name="friends_of"><mt:if name="is_administrator"><a href="<mt:var name="script_url">?__mode=list_friends_of&amp;author_id=<mt:var name="id" escape="html">"></mt:if><mt:var name="friends_of" escape="html"><mt:if name="is_administrator"></a></mt:if><mt:else>0</mt:if></td>};
    require MT::Builder;
    my $builder = MT::Builder->new;
    my $ctx = $tmpl->context();
    my $column_tokens = $builder->compile( $ctx, $column_str )
        or return $cb->error($builder->errstr);

    if ( $param->{more_columns} ) {
        push @{ $param->{more_columns} }, bless $column_tokens, 'MT::Template::Tokens';
    }
    else {
        $param->{more_columns} = [ bless $column_tokens, 'MT::Template::Tokens' ];
    }

    # populate the number of friends for each author
    my $class = $app->model('objectscore');
    require MT::Community::Friending;
    foreach my $author (@$loop) {
		if ( %author_entries ) {
			$author->{entry_count} = $author_entries{ $author->{id} };
		}
        $author->{friends} = $class->count(
          {
            author_id => $author->{id},
            object_ds => 'author',
            namespace => MT::Community::Friending::FRIENDING(),
            score     => [ MT::Community::Friending::CONTACT(), undef ],
          },
          {
            range_incl => { score => 1 }
          }
        );
        $author->{friends_of} = $class->count(
          {
            object_id => $author->{id},
            object_ds => 'author',
            namespace => MT::Community::Friending::FRIENDING(),
            score     => [ MT::Community::Friending::CONTACT(), undef ],
          },
          {
            range_incl => { score => 1 }
          }
        );
    }
}

sub param_edit_entry {
    my ($cb, $app, $param, $tmpl) = @_;

    # Here, we handle sanitization of content for the MT richtext editor
    # for user-submitted posts. So, we only need to do this when
    #    1) editing an existing entry
    #    2) entry has both the richtext and "__sanitize__" text
    #       filters associated with it
    return unless $param->{id};

    my %f = map { $_ => 1 } split /\s*,\s*/, $param->{convert_breaks} || '';
    return unless $f{richtext} && $f{__sanitize__};

    my $blog = $app->blog;
    my $spec = $blog->sanitize_spec if $blog;
    $spec ||= $app->config->GlobalSanitizeSpec;

    require MT::Sanitize;
    $param->{text} = MT::Sanitize->sanitize( $param->{text}, $spec );
    $param->{text_more} = MT::Sanitize->sanitize( $param->{text_more}, $spec );
    $param->{convert_breaks} = 'richtext';
}

sub param_users_content_nav {
    my ($cb, $app, $param, $tmpl) = @_;

    add_line_items(@_);
    1;
}

sub add_line_items {
    my ( $cb, $app, $param, $tmpl ) = @_;

    my $vars     = $tmpl->getElementsByTagName('setvartemplate');
    my $var      = $vars->[0];
    my $menu_var = $tmpl->createElement( 'setvartemplate',
        { name => 'line_items', function => 'push' } );
    my $menu_str = q{<mt:If name="edit_author_id">
    <mt:if name="list_friends">
    <li class="active"><em><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends&amp;author_id=<mt:var name="edit_author_id" escape="html">"><__trans_section component="community"><__trans phrase="Following"></__trans_section></a></em></li>
    <li><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends_of&amp;author_id=<mt:var name="edit_author_id" escape="html">"><__trans_section component="community"><__trans phrase="Followers"></__trans_section></a></li>
    <mt:elseif name="list_friends_of">
    <li><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends&amp;author_id=<mt:var name="edit_author_id" escape="html">"><__trans_section component="community"><__trans phrase="Following"></__trans_section></a></li>
    <li class="active"><em><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends_of&amp;author_id=<mt:var name="edit_author_id" escape="html">"><__trans_section component="community"><__trans phrase="Followers"></__trans_section></a></em></li>
    <mt:else>
    <li><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends&amp;author_id=<mt:var name="edit_author_id" escape="html">"><__trans_section component="community"><__trans phrase="Following"></__trans_section></a></li>
    <li><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends_of&amp;author_id=<mt:var name="edit_author_id" escape="html">"><__trans_section component="community"><__trans phrase="Followers"></__trans_section></a></li>
    </mt:if>
<mt:ElseIf name="id">
    <mt:if name="object_type" eq="author">
        <mt:if name="list_friends">
    <li class="active"><em><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends&amp;author_id=<mt:var name="id" escape="html">"><__trans_section component="community"><__trans phrase="Following"></__trans_section></a></em></li>
    <li><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends_of&amp;author_id=<mt:var name="id" escape="html">"><__trans_section component="community"><__trans phrase="Followers"></__trans_section></a></li>
        <mt:elseif name="list_friends_of">
    <li><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends&amp;author_id=<mt:var name="id" escape="html">"><__trans_section component="community"><__trans phrase="Following"></__trans_section></a></li>
    <li class="active"><em><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends_of&amp;author_id=<mt:var name="id" escape="html">"><__trans_section component="community"><__trans phrase="Followers"></__trans_section></a></em></li>
        <mt:else>
    <li><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends&amp;author_id=<mt:var name="id" escape="html">"><__trans_section component="community"><__trans phrase="Following"></__trans_section></a></li>
    <li><a href="<mt:var name="SCRIPT_URL">?__mode=list_friends_of&amp;author_id=<mt:var name="id" escape="html">"><__trans_section component="community"><__trans phrase="Followers"></__trans_section></a></li>
        </mt:if>
    </mt:if>
</mt:if>};
    $menu_var->innerHTML($menu_str);
    $tmpl->insertAfter( $menu_var, $var );
    1;
}

sub _inject_styles {
    my ($tmpl) = @_;

    my $elements = $tmpl->getElementsByTagName('setvarblock');
    my ($element) = grep { 'html_head' eq $_->getAttribute('name') }
        @$elements;
    if ( $element ) {
        my $contents = $element->innerHTML;
        my $text = <<EOT;
    <style type="text/css" media="screen">
        #zero-state {
            margin-left: 0;
        }
        #list-author .page-desc {
            display: none;
        }
        .system .content-nav .msg {
            margin-left: 160px;
        }
    </style>
EOT
       $element->innerHTML($text . $contents);
    }
    1;
}

1;
__END__
