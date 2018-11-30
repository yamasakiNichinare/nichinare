# Movable Type (r) (C) 2007-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Comments.pm 117483 2010-01-07 08:27:20Z ytakayama $
package CustomFields::App::Comments;

use strict;
use CustomFields::Util qw( field_loop );

sub signup_param {
    my ($cb, $app, $param, $tmpl) = @_;
    my %param = (
        object_type => 'author',
        simple      => 1,
    );
    $param->{field_loop} = field_loop(%param);
}

sub profile_param {
    my ($cb, $app, $param, $tmpl) = @_;
    return unless $app->user;

    # Get our header include using the DOM
    my ($header);
    my $includes = $tmpl->getElementsByTagName('include');
    foreach my $include (@$includes) {
        if($include->attributes->{name} =~ m!include/chromeless_header\.tmpl$!) {
            $header = $include;
            last;
        }
    }

    return 1 unless $header;

    require MT::Template;
    bless $header, 'MT::Template::Node';

    my $html_head = $tmpl->createElement('setvarblock', { name => 'html_head', append => 1 });
    my $innerHTML = q{
<link rel="stylesheet" href="<mt:var name="static_uri">addons/Commercial.pack/styles-customfields.css" type="text/css" media="screen" title="CustomFields Stylesheet" charset="utf-8" />
};
    $html_head->innerHTML($innerHTML);
    $tmpl->insertBefore($html_head, $header);

    my %param = (
        object_type => 'author',
        object_id   => $app->user->id,
        simple      => 1,
    );
    $param->{field_loop} = field_loop(%param);
}

1;
