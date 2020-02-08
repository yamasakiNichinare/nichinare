# Movable Type (r) (C) 2007-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Search.pm 117483 2010-01-07 08:27:20Z ytakayama $

package CustomFields::App::Search;

use strict;
use CustomFields::Util qw( get_meta);

sub _search_hit {
    my $plugin = shift;
    my ($app, $entry) = @_;

    my $search_hit_method = $plugin->{search_hit_method};
    return 1 if &{$search_hit_method}($app, $entry); # If query matches non-CustomFields, why waste time?
    return 0 if $app->{searchparam}{SearchElement} ne 'entries'; # If it hasn't matched and isn't searching on entries, again why waste time?

    my @text_elements = ($entry->title, $entry->text, $entry->text_more,
                      $entry->keywords);

    my $meta = get_meta($entry);

    foreach my $field (keys %$meta) {
        push @text_elements, $meta->{$field};
    }

    return 1 if $app->is_a_match(join("\n", map $_ || '', @text_elements));
}

1;
