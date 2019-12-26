#!/usr/bin/perl -w

use strict;
use lib "lib", ($ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : "../../lib"); 
use MT;
use MT::Bootstrap App => (
    MT->version_number >= 4.2? 'KeitaiKit::App::Search2'
    : 'KeitaiKit::App::Search'
);
