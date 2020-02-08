#!/usr/bin/perl -w

# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: mt-add-notify.cgi 5151 2010-01-06 07:51:27Z takayama $

use strict;
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';
use MT::Bootstrap App => 'MT::App::NotifyList';
