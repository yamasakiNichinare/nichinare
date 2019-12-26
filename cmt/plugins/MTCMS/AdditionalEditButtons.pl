package MT::Plugin::SKR::AdditionalEditButtons;

use strict;
use MT 5;

use vars qw( $MYNAME $VERSION );
$MYNAME = 'AdditionalEditButtons';
$VERSION = '0.01';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
        name => $MYNAME,
        id => lc $MYNAME,
        key => lc $MYNAME,
        version => $VERSION,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp/',
        doc_link => 'http://www.skyarc.co.jp/engineerblog/entry/additionaleditbuttons.html',
        description => <<HTMLHEREDOC,
<__trans phrase="Additional buttons for edit actions in compose screen.">
HTMLHEREDOC
});
MT->add_plugin( $plugin );

sub instance { $plugin; }

### Registry
sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        callbacks => {
            'MT::App::CMS::template_source.edit_entry' => \&_hdlr_src_edit_entry,
        },
    });
}

###
sub _hdlr_src_edit_entry {
    my ($eh, $app, $tmpl) = @_;
    my $old = quotemeta (<<'HTMLHEREDOC');
<div id="quickpost">
HTMLHEREDOC
    my $new = <<'HTMLHEREDOC';
    <div class="actions-bar">
<mt:if name="can_publish_post">
        <button
            mt:mode="save_entry"
            name="status"
            type="submit"
            title="<mt:var name="button_title">"
            class="publish action primary-button"
            value="2"
            ><mt:var name="button_text"></button>
        <button
            mt:mode="save_entry"
            type="submit"
            title="<mt:var name="draft_button_title">"
            class="save draft action"
            value="1"
            ><mt:var name="draft_button_text"></button>
</mt:if>
        <button
            mt:mode="preview_entry"
            name="preview_entry"
            type="submit"
            accesskey="v"
            title="<mt:var name="preview_button_title">"
            class="preview action"
            ><__trans phrase="Preview"></button>
<mt:if name="can_publish_post">
    <mt:if name="id">
        <button
           mt:command="do-remove-items"
           mt:object-singular="<mt:var name="object_label" lower_case="1" escape="html">"
           mt:object-plural="<mt:var name="object_label_plural" lower_case="1" escape="html">"
           mt:object-type="<mt:var name="object_type" escape="html">" mt:blog-id="<mt:var name="blog_id">"
            name="preview_entry"
            type="submit"
           title="<mt:var name="delete_button_title">"
           class="delete action"
           accesskey="x"
            ><__trans phrase="Delete"></button>
    </mt:if>
</mt:if>
    </div><br />
HTMLHEREDOC
    $$tmpl =~ s!($old)!$new$1!;
}

1;