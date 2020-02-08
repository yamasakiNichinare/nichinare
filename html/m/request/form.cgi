#!/usr/bin/perl
use CGI::Carp qw(fatalsToBrowser);
use lib '../../../sys-perl/lib';
use HTML::Template;
use Unicode::Japanese qw(unijp);

require '../../../sys-perl/require.pl';

our ( %dir, %cmd, %in, %replace, $TMPL, %error, $sid_path, @mail_template );

%dir = (
    'db'       => '../../../sys-perl/db',
    'script'   => '../../../sys-perl/script/mob/request',
    'template' => '../../../sys-perl/template/mob/request',
);

%cmd = (
    ''        => '01_form.pl',
    'conf'    => '02_conf.pl',
    'send'    => '03_thanks.pl',
    'reg'     => '04_reg.pl',
    'KOUMOKU' => 'KOUMOKU.pl',
);

# メールテンプレート
@mail_template = (
    './tmpl-admin.txt',    # 管理者に送信
    # './tmpl-user.txt',     # 投稿者に送信
);

if ( !-w "$dir{'db'}" ) {
    print "Content-Type: text/html; charset=Shift_JIS\n\n";
    print qq| $dir{'db'} の パーミッションを 777にしてください |;
    exit;
}
if ( grep { !-e $_ } @mail_template ) {
    print "Content-Type: text/html; charset=Shift_JIS\n\n";
    print 'メールテンプレートが見つかりません';
    exit;
}

require "$dir{'script'}/lib.pl";

#---------------
# ﾃﾞｰﾀﾍﾞｰｽに接続
#---------------
connectDB();

main();

#------------------
# ﾃﾞｰﾀﾍﾞｰｽから切断
#------------------
disconnectDB();

#===============
# HTML出力
#===============
my $template = HTML::Template->new(
    loop_context_vars => 1,
    die_on_bad_params => 0,
    filename          => "$dir{'template'}/$TMPL",
);

for my $key ( keys %replace ) {
    $template->param( $key => $replace{$key} );
}

print "Content-Type: text/html; charset=Shift_JIS\n\n";
print $template->output;
print $credit if ( $in{'c'} eq 'send' );
exit;

1;
