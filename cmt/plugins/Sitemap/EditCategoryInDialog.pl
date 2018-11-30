package MT::Plugins::SKR::EditCategoryInDialog;

use strict;
use MT 5;

use vars qw( $MYNAME $VERSION );
$MYNAME = (split /::/, __PACKAGE__)[-1];
$VERSION = '0.00_03';

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
<__trans phrase="Enable you to edit category/folder in dialog mode.">
HTMLHEREDOC
        l10n_class => 'Sitemap::L10N',
        registry => {
            callbacks => {
                'MT::App::CMS::template_source.edit_category' => \&_cb_template_source_edit_category,
                'MT::App::CMS::template_source.edit_folder' => \&_cb_template_source_edit_category,
                'MT::App::CMS::template_param.edit_category' => \&_cb_template_param_edit_category,
                'MT::App::CMS::template_param.edit_folder' => \&_cb_template_param_edit_category,
            },
        },
});
MT->add_plugin ($plugin);



### Callback - template_*.edit_category
sub _cb_template_source_edit_category {
    my ($cb, $app, $tmpl) = @_;

    # header
    my $old = quotemeta (<<'HTMLHEREDOC');
<mt:include name="include/header.tmpl">
HTMLHEREDOC
    my $new = <<'HTMLHEREDOC';
<mt:unless id>
  <mt:if name="object_type" eq="category">
    <mt:setvar name="page_title" value="<__trans phrase="Create Category">">
  <mt:else>
    <mt:setvar name="page_title" value="<__trans phrase="Create Folder">">
  </mt:if>
</mt:unless>

<mt:if dialog>
  <mt:include name="dialog/header.tmpl">
<mt:else>
  <mt:include name="include/header.tmpl">
</mt:if>
HTMLHEREDOC
    $$tmpl =~ s/$old/$new/;

    # footer
    $old = quotemeta (<<'HTMLHEREDOC');
<mt:include name="include/footer.tmpl">
HTMLHEREDOC
    $new = <<'HTMLHEREDOC';
<mt:if dialog>
  <mt:include name="dialog/footer.tmpl">
<mt:else>
  <mt:include name="include/footer.tmpl">
</mt:if>
HTMLHEREDOC
    $$tmpl =~ s/$old/$new/;

    # action_buttons
    $old = quotemeta (<<'HTMLHEREDOC');
<mt:include name="include/actions_bar.tmpl" bar_position="bottom" hide_pager="1" settings_bar="1">
HTMLHEREDOC
    $new = <<'HTMLHEREDOC';
<mt:setvarblock name="action_buttons">
    <button
        type="submit"
        accesskey="x"
        class="cancel action mt-close-dialog"
        title="<__trans phrase="Cancel (x)">">
        <__trans phrase="Cancel"></button>
    <button
        type="submit"
        accesskey="s"
        class="save action primary-button"

<mt:if id>
  <mt:if name="object_type" eq="category">
        title="<__trans phrase="Save changes to this category (s)">"
  <mt:else>
        title="<__trans phrase="Save changes to this folder (s)">"
  </mt:if>
        ><__trans phrase="Save Changes"></button>
<mt:else>
        title="<__trans phrase="Create New">"
        ><__trans phrase="Create New"></button>
</mt:if>
</mt:setvarblock>
HTMLHEREDOC
    $$tmpl =~ s/($old)/$new$1/;

    # <form>
    $old = quotemeta (<<'HTMLHEREDOC');
method="post" action="<mt:var name="script_url">" onsubmit="return validate(this)">
HTMLHEREDOC
    $new = <<'HTMLHEREDOC';
target="_top"
HTMLHEREDOC
    my $new2 = <<'HTMLHEREDOC';
<mt:if parent>
    <input type="hidden" name="parent" value="<mt:var name="parent" escape="html">" />
</mt:if>
HTMLHEREDOC
    $$tmpl =~ s/($old)/$new$1$new2/;
}

sub _cb_template_param_edit_category {
    my ($cb, $app, $param) = @_;

    # Query
    $param->{dialog} = $app->param ('dialog') || 0;
    $param->{parent} = $app->param ('parent') || 0;
    # MT/CMS/Category.pm
    $param->{path_prefix} ||= $app->blog->site_url;
    $param->{path_prefix} .= '/' unless $param->{path_prefix} =~ m!/$!;
    if (defined $app->param ('parent')) {
        my $obj = $app->model ($param->{object_type})->load ($app->param ('parent'));
        if ($obj) {
            $param->{path_prefix} .= $obj->publish_path;
            $param->{path_prefix} .= '/' unless $param->{path_prefix} =~ m!/$!;
        }
    }
    # Override
    $param->{return_args} = $app->param ('return_args')
        if defined $app->param ('return_args');
}

1;