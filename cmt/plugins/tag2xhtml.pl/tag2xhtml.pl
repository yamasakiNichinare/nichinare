package MT::Plugin::tag2xhtml;
use strict;

use MT;
require MT::Plugin;

our $VERSION = "0.4";

@MT::Plugin::tag2xhtml::ISA = qw(MT::Plugin);

my $plugin = new MT::Plugin::tag2xhtml({
	name => 'tag2xhtml',
	version => $VERSION,
	description => 'Convert HTML Tag to XHTML format.',
	author_name => 'Junnama Noda',
	author_link => 'http://junnama.alfasado.net/online/',
});

MT->add_plugin($plugin);
MT->add_callback('BuildPage', 1, $plugin, \&_tag2xhtml);

######################################### Mainroutine #########################################

sub _tag2xhtml {
	my ($eh, %args) = @_;
	my $content = $args{'Content'};
	$$content =~ s/<i>(.*)<\/i>/<em>$1<\/em>/isg;
	$$content =~ s/<b>(.*)<\/b>/<strong>$1<\/strong>/isg;
	$$content =~ s/<strike>(.*)<\/strike>/<del>$1<\/del>/isg;
	$$content =~ s/<u>(.*)<\/u>/<ins>$1<\/ins>/isg;
	$$content =~ s/<font(.*?)>(.*?)<\/font>/<span$1>$2<\/span>/isg;
	$$content =~ s/<P>/<p>/g;
	$$content =~ s/<(a\s|p\s|div|pre|blockquote|li|ul|ol|span)(.*?)>/&tag2xhtml($1, $2 ,0)/eisg;
	$$content =~ s/<\/(a|p|div|pre|blockquote|li|ul|ol)>/'<\/'.lc($1).'>'/eig;
	$$content =~ s/<(br|hr|img|input|col|base|meta|area|param)(.*?)>/&tag2xhtml($1, $2, 1)/eisg;
	$$content =~ s/<form\smt:asset-id.*?>(<img\s.*?>)<\/form>/&pick_img($1)/eisg;
	$$content =~ s/<form\sclass="mt-enclosure\smt-enclosure-image".*?>(<img\s.*?>)<\/form>/&pick_img($1)/eisg;
	$$content =~ s/<span\sclass="mt-enclosure\smt-enclosure-image".*?>(<img\s.*?>)<\/span>/&pick_img($1)/eisg;
	$$content =~ s/(<img\s.*style=")(.*)("\s.*?>)/$1.&style2lower($2).$3/eisg;
	$$content =~ s/(<img\s.*alt=)(.*?)(\s.*?>)/$1.&add_quot($2).$3/eisg;
	$$content =~ s/(<img\s.*class=)(.*?)(\s.*?>)/$1.&add_quot($2).$3/eisg;
	$$content =~ s/(<img\s.*width=)(.*?)(\s.*?>)/$1.&add_quot($2).$3/eisg;
	$$content =~ s/(<img\s.*height=)(.*?)(\s.*?>)/$1.&add_quot($2).$3/eisg;
	$$content =~ s/(<.*?)align=left(>)/$1style="text-align:left"$2/isg;
	$$content =~ s/(<.*?)align=center(>)/$1style="text-align:center"$2/isg;
	$$content =~ s/(<.*?)align=right(>)/$1style="text-align:right"$2/isg;
}

sub tag2xhtml {
	my $ele = shift;
	my $att = shift;
	my $is_empty = shift;
	$ele = lc($ele);
	$att =~ s/(.*?)(=?".*?")/lc($1).$2/eisg;
	if (($att !~ /.*\/$/) && $is_empty){
		$att .= ' /';
	}
	return '<'.$ele.$att.'>';
}

sub pick_img {
	my $img = shift;
	if ($img =~ /(<img\s.*?)(=".*"\s)(.*?)(=".*"\s)(.*?)(=".*"\s)(.*?)(=".*"\s)(.*?)(=".*"\s)(.*?)(=".*")(.*?>)/gs) {
		$img = lc($1).$2.lc($3).$4.lc($5).$6.lc($7).$8.lc($9).$10.lc($11).$12.$13;
	}
	return $img;
}

1;
