package AdditionalPermission::CMS;

use strict;
use MT;

sub instance { MT->component ('AdditionalPermission'); }

###
sub source_edit_role {
    my ($eh, $app, $tmpl) = @_;

    my $label = instance->translate('Extended Permission');

    my $old = quotemeta (<<'HTMLHEREDOC');
    </mtapp:setting>

</div>
HTMLHEREDOC
    my $new = <<"HTMLHEREDOC";
    </mtapp:setting>

    <mtapp:setting
        id="additional"
        label="$label"
        content_class="field-content-text"
        hint="">
        <ul>
<mt:loop name="loaded_permissions">
<mt:if name="group" eq="blog_additional">
            <li><label for="<mt:var name="id">"><input id="<mt:var name="id">" type="checkbox" onclick="togglePerms(this, '<mt:var name="children">')" class="<mt:var name="id"> cb" name="permission" value="<mt:var name="id">"<mt:if name="can_do"> checked="checked"</mt:if>> <mt:var name="label" escape="html"></label></li>
</mt:if>
</mt:loop>
        </ul>
HTMLHEREDOC
    $$tmpl =~ s!($old)!$new$1!;
}

1;