# Movable Type (r) (C) 2007-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: L10N.pm 117483 2010-01-07 08:27:20Z ytakayama $

package MT::Community::L10N;
use strict;
use base 'MT::L10N';

sub init {
    my $lh = shift;
    $lh->SUPER::init(@_);
    $lh->fail_with('mt_fallback');
    return;
}

sub mt_fallback {
    my $lh = shift;
    MT->language_handle->maketext(@_);
}

sub get_handle {
    my $this = shift;
    my ($lang) = @_;
    my $lh;

    # Look up plugin's handle first.  
    # If not available, use system's handle.
    eval { $lh = $this->SUPER::get_handle($lang) ||
        $this->SUPER::get_handle('en_us'); };
    if (!$@ && $lh) {
        return $lh;
    }
    return MT->language_handle;
}

1;

