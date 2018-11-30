# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Page.pm 5151 2010-01-06 07:51:27Z takayama $
package MT::CMS::Page;

use strict;
use MT::CMS::Entry;

sub edit {
    require MT::CMS::Entry;
    MT::CMS::Entry::edit(@_);
}
sub list {
    my $app = shift;
    $app->param( 'type', 'page' );
    return $app->forward('list_entry', { type => 'page' } );
}

sub save_pages {
    my $app = shift;
    return $app->forward('save_entries');
}

sub can_view {
    my ( $eh, $app, $id, $objp ) = @_;
    $app->can_do('open_page_edit_screen');
}

sub can_delete {
    my ( $eh, $app, $obj ) = @_;
    my $author = $app->user;
    return 1 if $author->is_superuser();
    my $perms = $app->permissions;
    if ( !$perms || $perms->blog_id != $obj->blog_id ) {
        $perms ||= $author->permissions( $obj->blog_id );
    }
    return $perms && $perms->can_do('delete_page');
}

sub pre_save {
    require MT::CMS::Entry;
    MT::CMS::Entry::pre_save(@_);
}

sub post_save {
    require MT::CMS::Entry;
    MT::CMS::Entry::post_save(@_);
}

sub CMSPostSave_page {
    require MT::CMS::Entry;
    MT::CMS::Entry::post_save(@_);
}

1;
