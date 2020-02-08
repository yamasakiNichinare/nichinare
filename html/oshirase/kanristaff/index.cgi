#!/usr/bin/perl
use lib '../../../sys-perl/lib';
require '../../../sys-perl/require.pl';

our %http = (    # URLの設定
    'htdocs' => '..',
    'ajax'   => '../ajax',
    'css'    => '.',

);

#------------------
# ｻﾌﾞﾙｰﾁﾝ読み込み
#------------------
require $_ for ( glob("$dir{'include'}/*.pl") );
require $_ for ( glob("$dir{'conf'}/*.pl") );

our $TIMEOUT;
$TIMEOUT = 60 * 60;

#------------------
# 動作ｺﾏﾝﾄﾞ読み込み
#------------------
our %cmd;
hash_IO( \%cmd, "$dir{'script'}/oshirase/kanristaff/cmd.ini", 'e' );

#---------------
# ﾃﾞｰﾀﾍﾞｰｽに接続
#---------------
connectDB();

#------------------
# ﾌｫｰﾑﾃﾞｰﾀ読み込み
#------------------
our %in;
Parse();

#---------------
# ｺﾏﾝﾄﾞ実行
#---------------
our %replace;
our $HTML;

exe( $in{'c'} );

#------------------
# ﾃﾞｰﾀﾍﾞｰｽから切断
#------------------
disconnectDB();

#------------------
# HTMLの出力
#------------------
use HTML::Template;

my $template = HTML::Template->new(
    loop_context_vars => 1,
    die_on_bad_params => 0,
    filename          => "$dir{'template'}/oshirase/kanristaff/$TMPL",
);

for my $key ( keys %replace ) {
    $template->param( $key => $replace{$key} );
}

print "Content-Type: text/html\n\n";
print $template->output;
exit;
1;
