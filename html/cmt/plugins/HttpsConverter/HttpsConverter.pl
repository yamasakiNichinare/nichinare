package MT::Plugin::httpsconverter;

use base qw( MT::Plugin );
my $plugin = new MT::Plugin ({
	name => 'HttpsConverter',
	version => '1.10',
	doc_link => 'http://www.skyarc.co.jp/',
	author_name => 'SKYARC System Co., Ltd,',
	author_link => 'http://www.skyarc.co.jp',
	description => <<HTMLHEREDOC,
'http://' is converted into 'https://'.
HTMLHEREDOC
});
MT->add_plugin ($plugin);


use MT::Template::Context;
MT::Template::Context->add_global_filter (ssl => \&ssl);

sub ssl {
	my ($data, $arg, $ctx) = @_;
	$data =~ s/http:\/\//https:\/\//g if  $arg;
	$data =~ s/https:\/\//http:\/\//g if !$arg;
	$data;
}

1;