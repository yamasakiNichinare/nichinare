package MT::Plugin::SKR::DisableListPublic;
use strict;
use base qw( MT::Plugin );

our $PLUGIN_NAME = 'DisableListPublic';
our $VERSION = '0.1';

my $plugin = __PACKAGE__->new({
    name     => $PLUGIN_NAME,
    version  => $VERSION,
    key      => lc $PLUGIN_NAME,
    id       => lc $PLUGIN_NAME,
    author_name => 'SKYARC System Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
});

MT->add_plugin( $plugin );

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        callbacks => {
            'template_output.list_entry' => \&_hdlr_template,
        },
    });
}
sub _hdlr_template {
    my ($cb, $app, $tmpl) = @_;

    my $w1 = quotemeta q{<button};
    my $w2 = quotemeta q{accesskey="r"};
    my $w3 = quotemeta q{</button>};


    $$tmpl =~ s{<button\s+accesskey="r".*?</button>}{}igsm;

    1;
}
1;
__END__
