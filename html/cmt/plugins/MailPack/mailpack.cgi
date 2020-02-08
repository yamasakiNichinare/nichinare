#!/usr/bin/perl -w
use strict;

use lib 'lib';
use lib '../../lib';
use lib '../../extlib';

use MT::App;
my $app = MT::App->new;
my $url = $app->base . $app->mt_uri . '?__mode=list_mailpack';
print "Location: $url\n\n";
1;
