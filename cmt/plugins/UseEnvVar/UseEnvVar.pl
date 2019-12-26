package MT::Plugin::SKR::UseEnvVar;
# UseEnvVar - Enable you to retrieve the environment values of CGI
#       Copyright (c) 2009 SKYARC System Co.,Ltd.
#       @see http://www.skyarc.co.jp/engineerblog/entry/useenvvar.html

use strict;
use MT 4;
#use Data::Dumper;#DEBUG

use constant VARIABLE_NAME => 'env';

use vars qw( $MYNAME $VERSION );
$MYNAME = 'UseEnvVar';
$VERSION = '0.02';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
        name => $MYNAME,
        id => lc $MYNAME,
        key => lc $MYNAME,
        version => $VERSION,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp/',
        doc_link => 'http://www.skyarc.co.jp/engineerblog/entry/useenvvar.html',
        description => <<HTMLHEREDOC,
<__trans phrase="Enable you to retrieve the environment values of CGI">
HTMLHEREDOC
});
MT->add_plugin( $plugin );



### Global filter - UseEnvVar
use MT::Template::Context;
MT::Template::Context->add_tag( $MYNAME => sub {
    my ($ctx, $args, $cond) = @_;

    $args->{name} = VARIABLE_NAME;
    while (($args->{key}, $args->{value}) = each %ENV) {
        $ctx->tag ('SetVar', $args, $cond);
    }

    ''; # output nothing
});

1;