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
hash_IO( \%cmd, "$dir{'script'}/oshirase/jukou/cmd.ini", 'e' );
require "$dir{'script'}/root/lib.pl";

#---------------
# ﾃﾞｰﾀﾍﾞｰｽに接続
#---------------
connectDB();

#------------------
# ﾌｫｰﾑﾃﾞｰﾀ読み込み
#------------------
our %in;
Parse();

our %login;
%login = Cookies('student_lo');

if ( $in{'c'} ne 'login-2' ) {
    if ( !$login{'pk'} ) {
        $in{'c'} = 'login-1';
    }
    elsif ( length $login{'sid'} != 30 ) {
        $in{'c'} = 'login-1';
    }
    elsif ( $login{'exp'} < time - $TIMEOUT ) {    # >
        $in{'c'} = 'login-5';
    }
    else {
        our %oshirase_student;
        %oshirase_student = _HTML_escape( readData( $login{'pk'}, 'oshirase_student' ) );

        if ( !$oshirase_student{'pk'} ) {
            $in{'c'} = 'login-1';
        }
    }
}

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
$HTML              ||= '_.htm';
$replace{'title'}  ||= '';
$replace{'htdocs'} ||= $http{'htdocs'};
$replace{'ajax'}   ||= $http{'ajax'};
$replace{'css'}    ||= $http{'css'};

my $template = HTML::Template->new(
    loop_context_vars => 1,
    die_on_bad_params => 0,
    global_vars       => 1,
    filename          => "$dir{'template'}/oshirase/jukou/$TMPL",
);

for my $key ( keys %replace ) {
    $template->param( $key => $replace{$key} );
}

print "Content-Type: text/html\n\n";
print $template->output;
exit;
1;
