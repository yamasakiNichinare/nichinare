package MT::Plugins::SKR::EnableContext;

use strict;
use MT 4;
use MT::Entry;
use MT::Category;
use MT::Author;
BEGIN {
    if (5.0 <= $MT::VERSION) {
        require MT::Asset;
    }
}

use vars qw( $MYNAME $VERSION );
$MYNAME = (split /::/, __PACKAGE__)[-1];
$VERSION = '0.00_01';

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
<__trans phrase="Enable template context in MT::App::CMS">
HTMLHEREDOC
        registry => {
            callbacks => {
                'MT::App::CMS::template_param' => \&_cb_template_param,
            },
        },
});
MT->add_plugin ($plugin);

### Callbacks - template_source.header
sub _cb_template_param {
    my ($cb, $app, $param, $tmpl) = @_;

    $app->isa('MT::App::CMS')
        or return; # do nothing

    my $ctx = $tmpl->context
        or return; # do nothing
    $ctx->stash('author', $app->user);
    if (defined (my $blog = $app->blog)) {
        $ctx->stash('blog', $blog);
        $ctx->stash('blog_id', $blog->id);
    }

    my $mode = $app->param('__mode') || '';
    if ($mode eq 'view') {
        my $type = $app->param('_type') || '';
        # ブログ記事/ウェブページの編集
        if ($type eq 'entry' || $type eq 'page') {
            my $entry;
            if (defined (my $id = $app->param('id'))) {
                $entry = MT::Entry->load({ id => $id });
            }
            $entry ||= MT::Entry->new;
            $ctx->stash('entry', $entry);
        }
        # カテゴリ/フォルダの編集
        if ($type eq 'category' || $type eq 'folder') {
            my $category;
            if (defined (my $id = $app->param('id'))) {
                $category = MT::Category->load({ id => $id });
            }
            $category ||= MT::Category->new;
            $ctx->stash('category', $category);
        }
        # ユーザー情報の編集
        if ($type eq 'author') {
            my $author;
            if (defined (my $id = $app->param('id'))) {
                $author = MT::Author->load({ id => $id });
            }
            $author ||= MT::Author->new;
            $ctx->stash('author', $author);
        }
        # アイテムの編集 (MT5)
        if ($type eq 'asset') {
            my $asset;
            if (defined (my $id = $app->param('id'))) {
                $asset = MT::Asset->load({ id => $id });
            }
            $asset ||= MT::Asset->new;
            $ctx->stash('asset', $asset);
        }
    }
}

1;