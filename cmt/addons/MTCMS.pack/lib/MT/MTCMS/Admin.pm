package MT::MTCMS::Admin;

use strict;
use File::Spec;

### Settings
my $LOGO_LOGIN  = 'addons/MTCMS.pack/images/login_logo.png';
my $LOGO_HEADER = 'addons/MTCMS.pack/images/header_admin_logo.png';
my $FOOTER_LINK = 'http://www.mtcms.jp/';

### template_source.chromeless_header
sub login_logo_transform {
    my ($cb, $app, $tmpl_ref) = @_;

    my $filepath = File::Spec->catdir ($app->static_file_path, $LOGO_LOGIN);
    return unless -f $filepath; # There is no file

    my $new = <<"HTMLHEREDOC";
<mt:setvarblock name="html_head" append="1">
<style type="text/css">
#brand {
    background-image:url("<mtvar static_uri>$LOGO_LOGIN");
}
</style>
</mt:setvarblock>
HTMLHEREDOC
    $$tmpl_ref = $new. $$tmpl_ref;
}

### template_source.header
sub header_logo_transform {
    my ($cb, $app, $tmpl_ref) = @_;

    my $filepath = File::Spec->catdir ($app->static_file_path, $LOGO_HEADER);
    return unless -f $filepath; # There is no file

    my $new = <<"HTMLHEREDOC";
<mt:setvarblock name="html_head" append="1">
<style type="text/css">
.system #brand a, .system.preview-screen #brand,
.website #brand a, .website.preview-screen #brand,
#brand a, .preview-screen #brand {
    background-image:url("<mtvar static_uri>$LOGO_HEADER");
}
</style>
</mt:setvarblock>
HTMLHEREDOC
    $$tmpl_ref = $new. $$tmpl_ref;
}

### template_output
sub footer_link_transform {
    my ($cb, $app, $html) = @_;

    $$html =~ s!\Qhttp://www.sixapart.jp/movabletype/pack/mtcms/\E!$FOOTER_LINK!;
}

1;
