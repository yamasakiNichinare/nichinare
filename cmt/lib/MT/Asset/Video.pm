# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Video.pm 5151 2010-01-06 07:51:27Z takayama $

package MT::Asset::Video;

use strict;
use base qw( MT::Asset );

__PACKAGE__->install_properties( { class_type => 'video', } );

# List of supported file extensions (to aid the stock 'can_handle' method.)
sub extensions {
    my $pkg = shift;
    return $pkg->SUPER::extensions(
        [   qr/mov/i, qr/avi/i, qr/3gp/i, qr/asf/i, qr/mp4/i, qr/qt/i,
            qr/wmv/i, qr/asx/i,  qr/mpg/i, qr/flv/i, qr/mkv/i, qr/ogm/i
        ]
    );
}

sub class_label {
    MT->translate('Video');
}

sub class_label_plural {
    MT->translate('Videos');
}

# translate('video')

1;

__END__

=head1 NAME

MT::Asset::Video

=head1 AUTHOR & COPYRIGHT

Please see the L<MT/"AUTHOR & COPYRIGHT"> for author, copyright, and
license information.

=cut
