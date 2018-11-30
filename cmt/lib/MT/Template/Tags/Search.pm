# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Search.pm 5151 2010-01-06 07:51:27Z takayama $
package MT::Template::Tags::Search;

use strict;

###########################################################################

=head2 SearchMaxResults

Returns the value of the C<SearchMaxResults> or C<MaxResults> configuration
setting. Use C<SearchMaxResults> because MaxResults is considered deprecated.

=for tags search, configuration

=cut

sub _hdlr_search_max_results {
    my ($ctx) = @_;
    return $ctx->{config}->MaxResults;
}

1;
