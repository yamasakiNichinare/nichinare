package DirectoryMenuAssistant::CMS;

use strict;
use MT 4;
use MT::Category;

sub instance { MT->component('DirectoryMenuAssistant'); }

### template_source.edit_category
sub _hdlr_src_edit_category {
    my ($cb, $app, $tmpl) = @_;

    my $old = quotemeta (<<'HTMLHEREDOC');
<mt:setvarblock name="action_buttons">
HTMLHEREDOC
    my $new = &instance->translate_templatized (<<'HTMLHEREDOC');
    <fieldset>
        <h3><__trans phrase="Appearance in Navigation menu"></h3>
<mtapp:setting
    id="hidden"
    label="<__trans phrase="Hide in navigation">"
    hint="<__trans phrase="Check on when hiding the menu item in navigations.">"
    show_hint="1">
    <input type="checkbox" name="hidden" id="hidden" value="1"<mt:if name="hidden"> checked="checked"</mt:if> />
    <label for="hidden"><__trans phrase="On"></label>
</mtapp:setting>

<mtapp:setting
    id="hidden"
    label="<__trans phrase="Open in a new window">"
    hint="<__trans phrase="Check on when opening the link in a new window.">"
    show_hint="1">
    <input type="checkbox" name="target_blank" id="target_blank" value="1"<mt:if name="target_blank"> checked="checked"</mt:if> />
    <label for="target_blank"><__trans phrase="On"></label>
</mtapp:setting>

<mtapp:setting
    id="link_option"
    label="<__trans phrase="Alternative Link">"
    hint="<__trans phrase="Fill with the alternative link URL of menu item">"
    show_hint="1">
    <div class="textarea-wrapper">
        <input type="text" class="full-width" name="alt_link" id="alt_link" value="<mt:var name="alt_link" escape="html">" />
    </div>
</mtapp:setting>

    </fieldset>
HTMLHEREDOC
    $$tmpl =~ s!($old)!$new$1!;
}

### template_param.edit_category
sub _hdlr_param_edit_category {
    my ($cb, $app, $param, $tmpl) = @_;

    my $category = MT::Category->load({ id => $param->{id} })
        or return;
    map { $param->{$_} = $category->$_; } qw/ hidden target_blank alt_link /;
}

### cms_post_save.category
sub _hdlr_post_save_category {
    my ($cb, $app, $obj) = @_;

    map { $obj->$_ ($app->param($_) || 0) }
        qw/ hidden target_blank /;
    map { $obj->$_ ($app->param($_) || '') }
        qw/ alt_link /;
    $obj->update;
}

1;