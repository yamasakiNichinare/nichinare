# SKYARC (C) 2008-2009 SKYARC System Co., Ltd, All Rights Reserved.
package MT::MTCMS::Tags;

use strict;

use MT::Util qw( offset_time_list );

###########################################################################

=head2 SKYARCProductName

=for tags configuration

=cut

sub _hdlr_skyarc_product_name {
    return MT->config('SKYARCProductName');
}

###########################################################################

=head2 CMSThemePath

=for tags configuration

=cut

sub _hdlr_cms_theme_path {
    return MT->config('CMSThemePath');
}
###########################################################################

1;
__END__
