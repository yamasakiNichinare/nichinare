package MT::Plugins::SKR::AssetFilterByFolder;

use strict;
use MT 5;
use MT::Folder;

use vars qw( $MYNAME $VERSION );
$MYNAME = (split /::/, __PACKAGE__)[-1];
$VERSION = '1.03_02';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
        id => $MYNAME,
        key => $MYNAME,
		name => $MYNAME,
		version => $VERSION,
		author_name => 'SKYARC System Co.,Ltd.',
		author_link => 'http://www.skyarc.co.jp/',
		doc_link => 'http://www.mtcms.jp/',
		description => <<HTMLHEREDOC,
<__trans phrase="Filter assets by the deployed folders">
HTMLHEREDOC
        l10n_class => 'Sitemap::L10N',
        registry => {
            callbacks => {
                'MT::App::CMS::template_source.list_asset' => \&_cb_template_source_list_asset,
                'MT::App::CMS::template_param.list_asset' => \&_cb_template_param_list_asset,
            },
        },
});
MT->add_plugin ($plugin);

###
sub _cb_template_source_list_asset {
    my ($cb, $app, $tmpl) = @_;

    ###
    my $old = quotemeta (<<'HTMLHEREDOC');
                            <option value="normalizedtag"><__trans phrase="tag (fuzzy match)"></option>
HTMLHEREDOC
    my $new = $plugin->translate_templatized (<<'HTMLHEREDOC');
                            <option value="folder"><__trans phrase="Folders"></option>
HTMLHEREDOC
    $$tmpl =~ s/($old)/$1$new/;

    ###
    $old = quotemeta (<<'HTMLHEREDOC');
                    <!-- filter form ends -->
HTMLHEREDOC
    $new = $plugin->translate_templatized (<<'HTMLHEREDOC');
<span id="filter-folder" style="display: none">
  <select id="folder-val" name="filter_val" onchange="enableFilterButton()"><mt:loop name="folder_loop">
    <option value="<mt:var name="value" escape="html">"><mt:var name="label" escape="html"></option>
  </mt:loop></select>
</span>
HTMLHEREDOC
    $$tmpl =~ s/($old)/$new$1/;
}

sub _cb_template_param_list_asset {
    my ($cb, $app, $param, $tmpl) = @_;

    # All folders index
    my @folders = _get_folders ($param->{blog_id}, 0);
    my @folder_loop  = ({
        label => '(root)',
        value => '/',
        depth => '',
    });
    for (@folders) {
        push @folder_loop, {
            label => "\xA0 " x $_->{depth}. $_->{obj}->label,
            value => $_->{obj}->publish_path,
        };
    }
    $param->{folder_loop} = \@folder_loop;

    # Do filter
    if (($app->param('filter') || '') eq 'folder') {
        my $filter_path = $app->blog->site_url;
        $filter_path .= '/' if $filter_path !~ m!/$!;
        $filter_path .= $app->param('filter_val');
        $filter_path .= '/' if $filter_path !~ m!/$!;
        $filter_path =~ s!//+$!/!; # searching for (root)

        my $ctx = $tmpl->context
            or return; # do nothing;
        my $object_loop = $ctx->var('object_loop') || [];
        my @object_loop;
        for (@$object_loop) {
            push @object_loop, $_ if $_->{url} =~ m!^\Q$filter_path\E[^/]+$!;
        }
        $ctx->var('object_loop', \@object_loop);
    }
}

my $depth = 1;
sub _get_folders {
    my ($bid, $pid) = @_;
    my @folders;
    for (MT::Folder->load ({ blog_id => $bid, parent => $pid })) {
        push @folders, { depth => $depth, obj => $_ };
        $depth++; push @folders, _get_folders ($bid, $_->id); $depth--;
    }
    @folders;
}

# Omit paging when filtered
use MT::App;
{
    local $SIG{__WARN__} = sub { };

    my $original_listing = \&MT::App::listing;
    *MT::App::listing = sub {
        my ($app, $param) = @_;
    
        if (($app->param('filter') || '') eq 'folder') {
            $param->{no_limit} = 1;
        }
    
        $original_listing->($app, $param);
    };
}

1;