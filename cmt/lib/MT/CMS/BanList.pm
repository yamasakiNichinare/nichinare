# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: BanList.pm 5151 2010-01-06 07:51:27Z takayama $
package MT::CMS::BanList;

use strict;

sub can_save {
    my ( $eh, $app, $id ) = @_;
    return $app->can_do('save_banlist');
}

sub save_filter {
    my $eh    = shift;
    my ($app) = @_;
    my $ip    = $app->param('ip');
    $ip =~ s/(^\s+|\s+$)//g;
    return $eh->error(
        MT->translate("You did not enter an IP address to ban.") )
      if ( '' eq $ip );
    my $blog_id = $app->param('blog_id');
    require MT::IPBanList;
    my $existing =
      MT::IPBanList->load( { 'ip' => $ip, 'blog_id' => $blog_id } );
    my $id = $app->param('id');

    if ( $existing && ( !$id || $existing->id != $id ) ) {
        return $eh->error(
            $app->translate(
                "The IP you entered is already banned for this blog.")
        );
    }
    return 1;
}

1;
