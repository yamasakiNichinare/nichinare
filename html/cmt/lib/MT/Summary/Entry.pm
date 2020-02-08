# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Entry.pm 5151 2010-01-06 07:51:27Z takayama $

# Core Summary Object Framework functions for MT::Entry

package MT::Summary::Entry;

use strict;
use warnings;
use MT::Asset;
use MT::Entry;

sub summarize_all_assets {
    my $entry = shift;
    my ($terms) = @_;
    my %args;

    require MT::ObjectAsset;
    my @assets = MT::Asset->load({ class => '*' }, { join => MT::ObjectAsset->join_on(undef, {
        asset_id => \'= asset_id', object_ds => 'entry', object_id => $entry->id })});

    return @assets ? join(',', map {$_->id} @assets) : '';
}

1;
