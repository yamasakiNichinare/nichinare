package DynamicViewer::Bootstrap;

use strict;
use base qw ( MT::Bootstrap );

BEGIN {
  $ENV{'PROXY'}  = 1;
  $ENV{'MT_APP'} = 'DynamicViewer::App';
};

my $fcgi_exit_requested = 0;
my $fcgi_handling_request = 0;

sub fcgi_sig_handler {
    my $sig = shift;
    $fcgi_exit_requested = $sig;
    if ($fcgi_handling_request) {
        print STDERR "Movable Type: SIG$sig caught. Exiting gracefully after current request.\n";
    }
    else {
        print STDERR "Movable Type: SIG$sig caught. Exiting gracefully.\n";
        exit(1);
    }
}

sub import {
    my ($pkg, %param) = @_;
    my $class = $param{App} || $ENV{MT_APP};
    if ($class) {

        my $not_fast_cgi = 0;
        $not_fast_cgi ||= exists $ENV{$_}
            for qw(HTTP_HOST GATEWAY_INTERFACE SCRIPT_FILENAME SCRIPT_URL);

        my $fast_cgi = defined $param{FastCGI} ? $param{FastCGI} : (!$not_fast_cgi);
        if ($fast_cgi) {
            eval 'require CGI::Fast;';
            $fast_cgi = 0 if $@;
        }

        my $app;
        eval {

            require MT;
            eval "# line " . __LINE__ . " " . __FILE__ . "\nrequire $class; 1;" or die $@;
            if ($fast_cgi) {
                $ENV{FAST_CGI} = 1;
                require FCGI;
                $CGI::Fast::Ext_Request = FCGI::Request( \*STDIN, \*STDOUT, \*STDERR, \%ENV, 0, FCGI::FAIL_ACCEPT_ON_INTR());
                my ($max_requests, $max_time, $cfg);
                $SIG{USR1} = \&fcgi_sig_handler;
                $SIG{TERM} = \&fcgi_sig_handler;
                $SIG{PIPE} = 'IGNORE';
                while ($fcgi_handling_request = (my $cgi = new CGI::Fast)) {
                    $app = $class->new( %param, CGIObject => $cgi )
                        or die $class->errstr;

                    $ENV{FAST_CGI} = 1;
                    $app->{fcgi_startup_time} ||= time;
                    $app->{fcgi_request_count} = ( $app->{fcgi_request_count} || 0 ) + 1;

                    unless ( $cfg ) {
                        $cfg = $app->config;
                        $max_requests = $cfg->FastCGIMaxRequests;
                        $max_time = $cfg->FastCGIMaxTime;
                    }

                    local $SIG{__WARN__} = sub { $app->trace($_[0]) };
                    MT->set_instance($app);
                    $app->init_request( CGIObject => $cgi );
                    $app->run();
                    $CGI::Fast::Ext_Request->Finish();

                    $fcgi_handling_request = 0;
                    if ( $fcgi_exit_requested ) {
                        print STDERR "Movable Type: FastCGI request loop exiting. Caught signal SIG$fcgi_exit_requested.\n";
                        last;
                    }
                    elsif ( $max_time && ( time - $app->{fcgi_startup_time} >= $max_time ) ) {
                        last;
                    }
                    elsif ( $max_requests && ( $app->{fcgi_request_count} >= $max_requests ) ) {
                        last;
                    }
                    else {
                        require MT::Touch;
                        require MT::Util;
                        if ( my $touched = MT::Touch->latest_touch(0, 'config') ) {
                            $touched = MT::Util::ts2epoch(undef, $touched);
                            if ( $touched > $app->{fcgi_startup_time} ) {
                                last;
                            }
                        }
                    }
                }
            } else {
                $app = $class->new( %param ) or die $class->errstr;
                local $SIG{__WARN__} = sub { $app->trace($_[0]) };
                $app->run();
            }
        };
        if (my $err = $@) {
            if (!$app && $err =~ m/Missing configuration file/) {
                my $host = $ENV{SERVER_NAME} || $ENV{HTTP_HOST};
                $host =~ s/:\d+//;
                my $port = $ENV{SERVER_PORT};
                my $uri = $ENV{REQUEST_URI} || $ENV{SCRIPT_NAME};
                if ($uri =~ m/(\/mt\.(f?cgi|f?pl)(\?.*)?)$/) {
                    my $script = $1;
                    my $ext = $2;

                    if (-f File::Spec->catfile($ENV{MT_HOME}, "mt-wizard.$ext")) {
                        $uri =~ s/\Q$script\E//;
                        $uri .= '/mt-wizard.' . $ext;

                        my $prot = $port == 443 ? 'https' : 'http';
                        my $cgipath = "$prot://$host";
                        $cgipath .= ":$port"
                            unless $port == 443 or $port == 80;
                        $cgipath .= $uri;
                        print "Status: 302 Moved\n";
                        print "Location: " . $cgipath . "\n\n";
                        exit;
                    }
                }
            }
            my $charset = 'utf-8';
            eval {
                my $cfg = MT::ConfigMgr->instance;
                $app ||= MT->instance;
                my $c = $app->find_config;
                $app->{cfg}->read_config($c);
                $charset = $app->{cfg}->PublishCharset;
            };
            if ($app && UNIVERSAL::isa($app, 'DynamicViewer::App')) {
                eval {
                    if (!$MT::DebugMode && ($err =~ m/^(.+?)( at .+? line \d+)(.*)$/s)) {
                        $err = $1;
                    }
                    my %param = ( error => $err );
                    if ($err =~ m/Bad ObjectDriver/) {
                        $param{error_database_connection} = 1;
                    } elsif ($err =~ m/Bad CGIPath/) {
                        $param{error_cgi_path} = 1;
                    } elsif ($err =~ m/Missing configuration file/) {
                        $param{error_config_file} = 1;
                    }
                    my $page = $app->build_page('error.tmpl', \%param)
                        or die $app->errstr;
                    print "Content-Type: text/html; charset=$charset\n\n";
                    print $page;
                    exit;
                };
                $err = $@;
            }
            if ($err) {
                if (!$MT::DebugMode && ($err =~ m/^(.+?)( at .+? line \d+)(.*)$/s)) {
                    $err = $1;
                }
                print "Content-Type: text/plain; charset=$charset\n\n";
                print $app
                  ? $app->translate( "Got an error: [_1]", $err )
                  : "Got an error: $err";
            }
        }
    }
}


1;
__END__
