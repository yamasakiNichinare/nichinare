package MT::Plugin::SKR::IndentFolderTree;
# SpeedySystemMenu - Add sub menus onto drop down menu of system overview.
#       Copyright (c) 2009 SKYARC System Co.,Ltd.
#       @see http://www.skyarc.co.jp/engineerblog/entry/IndentFolderTree.html

use strict;
use MT 5;

use vars qw( $MYNAME $VERSION );
$MYNAME = 'IndentFolderTree';
$VERSION = '0.01';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
        name => $MYNAME,
        id => lc $MYNAME,
        key => lc $MYNAME,
        version => $VERSION,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp/',
        doc_link => 'http://www.skyarc.co.jp/engineerblog/entry/IndentFolderTree.html',
        description => <<HTMLHEREDOC,
<__trans phrase="Add pretty indent to folder list.">
HTMLHEREDOC
});
MT->add_plugin( $plugin );

sub instance { $plugin; }

### Registry
sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        callbacks => {
            'MT::App::CMS::template_source.list_folder' => sub {
                my ($old, $new, $tmpl) = @_;
                $new = $old = <<'HTMLHEREDOC';
<td><a href="<mt:var name="script_url">?__mode=view&amp;_type=<mt:var name="object_type">&amp;blog_id=<mt:var name="blog_id">&amp;id=<mt:var name="category_id">"><$mt:var name="category_label" escape="html"$></a></td>
HTMLHEREDOC
                $new =~ s!(<td>)!$1<div style\="margin-left\: <mt\:var name="category_pixel_depth">px;">!;
                $new =~ s!(</td>)!</div>$1!;
                $old = quotemeta $old;
                $$tmpl =~ s/$old/$new/;
            },
        },
    });
}

1;