package MT::Plugin::MultiTransEncodingPlus;

use strict;
use warnings;
use MT 3;
use MT::Template::Context;
use Encode;

use vars qw( $PLUGIN_NAME $VERSION );
$PLUGIN_NAME = 'MultiTransEncodingPlus';
$VERSION = '1.30';

use base qw{ MT::Plugin };
my $plugin = new MT::Plugin::MultiTransEncodingPlus({
    name    => $PLUGIN_NAME,
    version => $VERSION,
    key     => lc $PLUGIN_NAME,
    id      => lc $PLUGIN_NAME,
    description => 'This plug-in replaces the special characters and symbols to HTML entities.',
    author_name => 'SKYARC System Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
});
MT->add_plugin($plugin);

### Registry
MT::Template::Context->add_global_filter (encode_specialchar => \&_get_entity);
MT::Template::Context->add_global_filter (encode_html => \&_encode_html);

###
sub _encode_html {
    my ($data, $arg, $ctx) = @_;

    if ($arg) {
       require MT::Util;
       $data = MT::Util::encode_html ($data, 1);
    }
    _delete_amp ($data);
}

###
sub _get_entity {
    my ($str, $args) = @_;

    if (MT->version_number =~ /^5/) {
         Encode::_utf8_off (\&$str) if Encode::is_utf8 ($str);
    }
    else {
         $str = Encode::decode ('UTF-8', $str);
    }

    ### HTML SpecialCharacter Set
    $str =~ s/\x{00AE}/&reg;/g;     #(R)
    $str =~ s/\x{00A9}/&copy;/g;    #(c)
    $str =~ s/\x{2122}/&trade;/g;   #TM

    $str =~ s/\x{03b1}/&alpha;/g;   #
    $str =~ s/\x{03b2}/&beta;/g;    #
    $str =~ s/\x{03b3}/&gamma;/g;   #
    $str =~ s/\x{03b4}/&delta;/g;   #

    $str =~ s/\x{00BC}/&frac14;/g;  #1/4
    $str =~ s/\x{00BD}/&frac12;/g;  #1/2
    $str =~ s/\x{00BE}/&frac34;/g;  #3/4

     unless( $args ){
        require MT::Util;
        $str = MT::Util::encode_html ($str, 1);
        $str = _delete_amp ($str);
    }

    if( MT->version_number =~ /^5/ ){
        Encode::_utf8_on (\&$str) unless Encode::is_utf8 ($str);
    }
    else {
        $str = Encode::encode ('utf8', $str);
    }

    $str;
}

###
sub _delete_amp {
    my ($str) = @_;
    my $char_map = join '|', qw(
        reg copy trade alpha beta gamma delta frac14 frac12 frac34
    );

    $str =~ s/&amp;($char_map);/&$1;/g;
    $str;
}

1;
