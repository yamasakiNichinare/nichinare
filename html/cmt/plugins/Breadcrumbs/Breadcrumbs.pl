package MT::Plugin::SKR::Breadcrumbs;
#   Breadcrumbs - Supply template tags to generate breadcrumbs easily.
#           Copyright (c) 2009 SKYARC System Co.,Ltd.
#           @see http://www.skyarc.co.jp/engineerblog/entry/breadcrumbs.html

use strict;
use MT 4;
use MT::Template::Context;
use MT::Placement;
use MT::Category;
use MT::Blog;

use vars qw( $MYNAME $VERSION );
$MYNAME = (split /::/, __PACKAGE__)[-1];
$VERSION = '0.07';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
        id => $MYNAME,
        key => $MYNAME,
        name => $MYNAME,
        version => $VERSION,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp/',
        doc_link => 'http://www.skyarc.co.jp/engineerblog/entry/breadcrumbs.html',
        description => <<HTMLHEREDOC,
<__trans phrase="Supply template tags to generate breadcrumbs easily.">
HTMLHEREDOC
        registry => {
            tags => {
                function => {
                    BreadcrumbsTitle => \&_hdlr_breadcrumbs_item,
                    BreadcrumbsLink => \&_hdlr_breadcrumbs_item,
                },
                block => {
                    Breadcrumbs => \&_hdlr_breadcrumbs,
                    BreadcrumbsHeader => \&MT::Template::Context::slurp,
                    BreadcrumbsFooter => \&MT::Template::Context::slurp,
                },
            },
        },
});
MT->add_plugin( $plugin );



### Breadcrumbs*
sub _hdlr_breadcrumbs_item {
    my ($ctx, $args) = @_;

    $ctx->stash('breadcrumbs_item')
        ? $ctx->stash('breadcrumbs_item')->{lc $ctx->stash('tag')} || ''
        : $ctx->error(MT->translate(
            "You used an [_1] tag outside of the proper context.",
            '<$MT'. $ctx->stash('tag'). '$>'));
}

### Breadcrumbs
sub _hdlr_breadcrumbs {
    my ($ctx, $args, $cond) = @_;

    my $blog = $ctx->stash('blog')
        or return $ctx->error(MT->translate('No Blog'));

    my $at =  $ctx->invoke_handler('ArchiveType');
    local $ctx->{archive_type} ||= $at;

    # Each archive type
    my @items;
    if (!defined $ctx->{archive_type}) {
        # do nothing
    }
    elsif ($ctx->{archive_type} =~ /Individual|Page/) {
        my $entry = $ctx->stash('entry')
            or return $ctx->_no_entry_error();
        my $plc = MT::Placement->load({ blog_id => $blog->id, entry_id => $entry->id, is_primary => 1 });
        if ($plc) {
            my $cat = MT::Category->load({ id => $plc->category_id });
            while ($cat) {
                unshift @items, {
                    breadcrumbstitle => $cat->label,
                    breadcrumbslink => $blog->archive_url. $cat->category_path. '/',
                };
                $cat = MT::Category->load({ id => $cat->parent });
            }
        }
        push @items, {
            breadcrumbstitle => $ctx->tag('EntryTitle', $args, $cond),
            breadcrumbslink => $ctx->tag('EntryPermalink', $args, $cond),
        } if $args->{with_index} || $entry->basename !~ m!^index(?:\.\w+)?$!;
    }
    elsif ($ctx->{archive_type} =~ /Category/) {
        my $cat = $ctx->stash('archive_category')
            or return $ctx->error(MT->translate('No categories could be found.'));
        while ($cat) {
            local $ctx->{__stash}{archive_category} = $cat;
            unshift @items, {
                breadcrumbstitle => $ctx->tag('ArchiveTitle', $args, $cond),
                breadcrumbslink => $ctx->tag('ArchiveLink', $args, $cond),
            };
            $cat = MT::Category->load({ id => $cat->parent });
        }
    }
    elsif ($ctx->{archive_type} =~ /Yearly|Monthly|Weekly|Daily/) {
        unshift @items, {
            breadcrumbstitle => $ctx->tag('ArchiveTitle', $args, $cond),
            breadcrumbslink => $ctx->tag('ArchiveLink', $args, $cond),
        };
    }
    elsif ($ctx->{archive_type} =~ /Author/) {
        unshift @items, {
            breadcrumbstitle => $ctx->tag('ArchiveTitle', $args, $cond),
            breadcrumbslink => $ctx->tag('ArchiveLink', $args, $cond),
        };
    }

    # Top
    if (!$args->{no_top}) {
        unshift @items, {
            breadcrumbstitle => $args->{top_label} || 'TOP',
            breadcrumbslink => $blog->site_url,
        };
        # Parent Website
        if ($args->{parent} && $blog->is_blog && $blog->parent_id) {
            my $parent = MT::Blog->load ($blog->parent_id);
            unshift @items, {
                breadcrumbstitle => $args->{parent_label} || $parent->name,
                breadcrumbslink => $parent->site_url,
            };
        }
    }

    # Reverse
    @items = reverse @items if $args->{reverse};

    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $i = 0;
    my $vars = $ctx->{__stash}{vars} ||= {};
    my @outputs;
    foreach my $item (@items) {
        local $vars->{__first__} = !$i;
        local $vars->{__last__} = !defined $items[$i+1];
        local $vars->{__odd__} = ($i % 2) == 0; # 0-based $i
        local $vars->{__even__} = ($i % 2) == 1;
        local $vars->{__counter__} = $i+1;
        local $ctx->{__stash}{breadcrumbs_item} = $item;
        defined (my $out = $builder->build($ctx, $tokens, {
                %$cond,
                BreadcrumbsHeader => $vars->{__first__},
                BreadcrumbsFooter => $vars->{__last__},
        })) or $ctx->error($builder->errstr);
        push @outputs, $out;
        $i++;
    }
    join (($args->{glue} || ''), @outputs);
}

1;
