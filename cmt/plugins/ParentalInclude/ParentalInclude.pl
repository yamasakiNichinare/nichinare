package MT::Plugin::SKR::ParentalInclude;
# ParentalInclude - When including the template, recursive searching against own blog, parental website and global
#       Copyright (c) 2009 SKYARC System Co.,Ltd.
#       @see http://www.skyarc.co.jp/engineerblog/entry/parentalinclude.html

use strict;
use MT 5;

use vars qw( $MYNAME $VERSION );
$MYNAME = (split /::/, __PACKAGE__)[-1];
$VERSION = '0.160';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
        id => $MYNAME,
        key => $MYNAME,
        name => $MYNAME,
        version => $VERSION,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp/',
        doc_link => 'http://www.skyarc.co.jp/engineerblog/entry/parentalinclude.html',
        description => <<HTMLHEREDOC,
<__trans phrase="When including the module template, recursive searching against own blog, parental website and global">
HTMLHEREDOC
        registry => {
            tags => {
                help_url => 'http://www.skyarc.co.jp/engineerblog/entry/parentalinclude.html',
                function => {
                    $MYNAME => "\$${MYNAME}::${MYNAME}::Tags::${MYNAME}",
                },
            },
        },
});
MT->add_plugin( $plugin );

1;