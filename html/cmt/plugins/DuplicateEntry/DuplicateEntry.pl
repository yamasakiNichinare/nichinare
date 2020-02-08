package MT::Plugin::SKR::DuplicateEntry;
# DuplicateEntry - Move or Duplicate the entries and pages between blogs
#       Copyright (c) 2008 SKYARC System Co.,Ltd.
#       http://www.skyarc.co.jp/engineerblog/entry/duplicateentry.html

use strict;
use MT 4;
use MT::Entry;
use MT::Blog;
use MT::Placement;
use MT::Permission;
use MT::I18N;
use MT::ConfigMgr;
use Data::Dumper;#DEBUG

use constant PREFIX_OF_COPY => '(Copy) ';

use vars qw( $MYNAME $VERSION );
$MYNAME = 'DuplicateEntry';
$VERSION = '1.235';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
        name => $MYNAME,
        id => lc $MYNAME,
        key => lc $MYNAME,
        version => $VERSION,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp/',
        doc_link => 'http://www.skyarc.co.jp/engineerblog/entry/duplicateentry.html',
        description => <<HTMLHEREDOC,
<__trans phrase="Move or Duplicate the entries and webpages between blogs">
HTMLHEREDOC
        l10n_class => $MYNAME. '::L10N',
});
MT->add_plugin( $plugin );

sub instance { $plugin; }

### Registry
sub init_registry {
    my $plugin = shift;
    my $app = MT->instance;
    $plugin->registry({
        callbacks => {
            'MT::App::CMS::template_source.edit_entry' => sub {
                if (5.0 <= $MT::VERSION) {
                    # do nothing
                }
                elsif (4.0 <= $MT::VERSION) {
                    _edit_entry_source_v4 (@_);
                }
            },
        },
        applications => {
            cms => {
                page_actions => {
                    entry => {
                        duplicate_move => {
                            label => 'Duplicate',
                            condition => sub {
                                return 5.0 <= $MT::VERSION;
                            },
                            mode => 'duplicate_mode_copy',
                        },
                    },
                    page => {
                        duplicate_move => {
                            label => 'Duplicate',
                            condition => sub {
                                return 5.0 <= $MT::VERSION;
                            },
                            mode => 'duplicate_mode_copy',
                        },
                    },
                },
                list_actions => {
                    entry => {
                        duplicate_move => {
                            label       => 'Duplicate or Move',
                            order       => 100,
                            code        => \&_hdlr_configure,
                            permission  => 'edit_all_posts',
                            condition   => sub {
                                return $app->mode ne 'view';
                            },
                        },
                    },
                    page => {
                        duplicate_move => {
                            label       => 'Duplicate or Move',
                            order       => 100,
                            code        => \&_hdlr_configure,
                            permission  => 'edit_all_posts',
                            condition   => sub {
                                return $app->mode ne 'view';
                            },
                        },
                    },
                },
                methods => {
                    duplicate_mode_copy   => \&_hdlr_duplicate_mode,
                    duplicate_mode_move   => \&_hdlr_duplicate_mode,
                    duplicate_mode_cancel => \&_hdlr_duplicate_mode,
                },
            },
        },
    });
}



### Callback - template_source.edit_entry (MT4)
sub _edit_entry_source_v4 {
    my ($eh, $app, $tmpl) = @_;

    my $old = trimmed_quotemeta(<<'HTMLHEREDOC');
        ><__trans phrase="Delete"></button>
HTMLHEREDOC
    my $new = &instance->translate_templatized (<<'HTMLHEREDOC');
    <button
        onclick="confirm('<__trans phrase="Are you sure to duplicate this item ?">') && (location.href='<mt:var name="script_url">?__mode=duplicate_mode_copy&id=<mt:var name=id>&blog_id=<mt:var name=blog_id>');"
        type="button"
        title="<__trans phrase="Duplicate">"
        ><__trans phrase="Duplicate"></button>
HTMLHEREDOC
    $$tmpl =~ s/($old)/$1$new/;
}

### Handler - duplicate_move
sub _hdlr_configure {
    my ($app) = @_;
    my $q = $app->{query};

    my %param;
    $param{return_args} = $q->param ('return_args');
    my $blog_id = ( $app->blog 
         && $app->blog->id ) 
         || $app->param('blog_id') 
         || 0;

    # List of entries
    my @eids = $q->param ('id');
    my @items;
    my $type = '';
    foreach (@eids) {
        my $entry = MT::Entry->load ({ id => $_ })
            or next;
        unless ( $type ) {
           $type = $entry->can('class') && $entry->class eq 'page'
                 ? 'page' : 'entry';
        }
        push @items, {
            id => $entry->id,
            name => $entry->title || '...',
        };
    }
    $type = 'entry' unless $type;
    $param{items} = \@items;

    # List blogs
    my $user = $app->user;
    my $terms = {};
    if ( $MT::VERSION >= 5.0 ) {
       $terms->{class} = $type eq 'entry' ? 'blog' : '*';
    }
    my @blogs;
    my $blog_iter = MT::Blog->load_iter( $terms );
    while ( my $blog = $blog_iter->() ) {

          ## special
          unless ( $user->is_superuser ) {

              ## adminnistrator
              my $perm = MT::Permission->load({ author_id => $user->id , blog_id => 0 });

              ## entry or page post
              unless ( $perm ) {
                   $perm = MT::Permission->load({ author_id => $user->id , blog_id => $blog->id })
                       or next;

                   if ( $type eq 'entry' ) {
                       $perm->can_post or next;
                   } else {
                       $perm->can_manage_pages or next;
                   }
              }
          }
          push @blogs , { 
              id => $blog->id,
              name => $blog->name,
              selected => $blog->id == $blog_id ? 1 : 0,
          };
    }

    $param{blogs} = \@blogs;
    &instance->load_tmpl ('duplicate_entry.tmpl', \%param);
}

### Application Methods - duplicate_mode_*
sub _hdlr_duplicate_mode {
    my ($app) = @_;
    my $q = $app->{query};
    $app->return_args ($q->param ('return_args'));

    my $target_blog_id = $q->param ('blog_id');
    my $mode = $q->param('__mode') || '';
    $target_blog_id || $mode
        or return $app->redirect ($app->return_uri); #error

    my $charset = {
        'shift_jis' => 'sjis',
        'iso-2022-jp' => 'jis',
        'euc-jp' => 'euc',
        'utf-8' => 'utf8'
    }->{lc MT::ConfigMgr->instance->PublishCharset} || 'utf8';

    # Move/Duplicate entries
    my @eids = $q->param ('id');
    my $redirect_object = '';
    foreach (@eids) {
        my $original = MT::Entry->load ({ id => $_ })
            or next;
        my $entry = $original->clone;

        $entry->status (MT::Entry::HOLD());

        # Workflow plugin features
        if ($entry->can ('workflow_id')) {
            $entry->workflow_id (0);
            $entry->workflow_level (0);
            $entry->workflow_approved_id (0);
        }

        if ($mode eq 'duplicate_mode_move') {
            # Remove of Category placements when moved to other blog
            if ($entry->blog_id != $target_blog_id) {
                map {
                    $_->remove;
                } MT::Placement->load ({ entry_id => $entry->id });
            }

            my @tags = $entry->get_tags;
            $entry->blog_id ($target_blog_id);
            $entry->set_tags (@tags); # Clone of Tag
 
            $app->run_callbacks(
                'duplicate_entry_pre_save',
                $app,
                $mode,
                $entry,
                $original,
            );
            $entry->save;
        }
        elsif ($mode eq 'duplicate_mode_copy') {
            my $clone = $entry->clone;

            $clone->id (undef);

            ## change the base name                 
            my $class = MT->model($clone->class);
            my $exist =
                  $class->exist( { blog_id => $clone->blog_id, basename => $clone->basename } );
            $clone->basename( MT::Util::make_unique_basename( $clone ) ) if $exist;

            $clone->title (MT::I18N::encode_text (PREFIX_OF_COPY, 'utf8', $charset). $entry->title);

            my @tags = $entry->get_tags;
            $clone->blog_id ($target_blog_id);
            $clone->set_tags (@tags); # Clone of Tag
  
            $app->run_callbacks(
                'duplicate_entry_pre_save',
                $app,
                $mode,
                $clone,
                $original,
            );
            $original->save;
            $clone->save;
            $redirect_object = $clone;
            # Clone of Category placements when copying in same blog
            if ($entry->blog_id == $clone->blog_id) {
                map {
                    my $clone_placement = $_->clone;
                    $clone_placement->id (undef);
                    $clone_placement->entry_id ($clone->id);
                    $clone_placement->save;
                } MT::Placement->load ({ entry_id => $entry->id });
            }
            $entry = $clone;
        }

        $app->run_callbacks(
            'duplicate_entry_post_save',
            $app,
            $mode,
            $entry,
            $original,
        );

    }

    ## Redirected to the destination page. ( PageAction )
    if( $redirect_object && $app->return_args =~ m!__mode=view! ) {
        return $app->redirect($app->uri(
            mode => 'view',
            args => {
               _type => $redirect_object->class,
               id => $redirect_object->id,
               blog_id => $redirect_object->blog_id,
               duplicate_entry => 1,
        }));
    }
    return $app->redirect ($app->return_uri. '&saved=1');
}



### Space and CR,LF trimmed quotemeta
sub trimmed_quotemeta {
    my ($str) = @_;
    $str = quotemeta $str;
    $str =~ s/(\\\s)+/\\s+/g;
    $str;
}

1;
