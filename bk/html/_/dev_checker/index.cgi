#!/usr/bin/perl
# ==============================================
# Develop Checker
# Ver. 1.00
# auth wws nakanishi
# 開発にあたっての必要な情報をチェックするツールです
# ----------------------------------------------
# Last Update
# 2012/05/09 作成
# ==============================================
use lib './lib';
use File::Path;

# =========================
# 設定
# =========================
my ( %in, %local, @modules, @modules_check );
Parse();

# Perlモジュール設定
@modules = qw(
    CGI
    File::Basename
    File::Path
    Jcode
    Unicode::Japanese
    HTML::Template
    DBD::mysql
    DBD::SQLite
    PDFJ
    XML::FeedPP
    Image::Magick
    GD
    LWP::Simple
    LWP::UserAgent
    HTTP::Lite
    MIME::QuotedPrint
    MIME::Lite
    MIME::Base64
    MIME::Entity
    Net::FTP
    Archive::Zip
    Net::Twitter
);

# Sendmail設定
@smcommands = qw(
    /usr/lib/sendmail
    /usr/sbin/sendmail
    /usr/bin/sendmail
    /sbin/sendmail
    /bin/sendmail
    /lib/sendmail
);

# =========================
# 処理
# =========================

# htaccessファイル設置処理
if ( $in{'c'} eq 'set_htaccess' ) {
    &setHtaccess;
}

# 「.htaccessをチェック」ボタン 表示/非表示
my $chk_html_path     = "tmp/check.html";
my $chk_htaccess_path = "tmp/.htaccess";
if ( -e $chk_html_path && -e $chk_htaccess_path ) {
    $local{'btn_chkhtaccess'} = <<EOF;
<form action="tmp/check.html" method="POST">
<input type="submit" value=".htaccessをチェック" />
</form>
EOF
}

# =========================
# 各情報を取得
# =========================

# -------------------
# OS
# -------------------
$local{'os'} = $^O;

# -------------------
# Perlのパス
# -------------------
$local{'perl_path'} = $^X;
$local{'perl_path'} =~ s/\\/\//g;

# -------------------
# 現在のディレクトリの絶対パス表記
# -------------------
eval { $local{'currentdir'} = `pwd`; };
if ( $@ || !$local{'currentdir'} ) { $local{'currentdir'} = '<span class="red">unknown</span>'; }

# -------------------
# Perlバージョン
# -------------------
$local{'perl_version'}
    = $] >= 5.006
    ? sprintf( '%s (%vd)', $], $^V, )
    : sprintf( '%s',       $], );

# -------------------
# Sendmailのチェック
# -------------------
for ( my $i = 0; $i <= $#smcommands; $i++ ) {    # >
    ( -x $smcommands[$i] )
        and $local{'if_sendmail_avail'} = $smcommands[$i]
        and last;
}
if ( $local{'if_sendmail_avail'} ) {
    $local{'sendmailinfo'} = sprintf( q{%s が使えます。}, $local{'if_sendmail_avail'}, );
}
else {
    $local{'sendmailinfo'} = qq|<span class="red">利用できません</span>|;
}

# -------------------
# モジュールのチェック
# -------------------
for ( my $i = 0; $i <= $#modules; $i++ ) {
    eval "use $modules[$i];";
    $modules_check[$i]->{'name'} = $modules[$i];
    $modules_check[$i]->{'version'} = eval "\$$modules[$i]::VERSION" || undef;

    if ( $modules_check[$i]->{'version'} ) {
        $modules_check[$i]->{'version_str'} = sprintf( qq|<span class="blue">利用可能</span>（Ver. %s）|, $modules_check[$i]->{'version'}, );
        if ( $modules_check[$i]->{'name'} eq 'Jcode' ) {
            $local{'if_jcode_pm_avail'} = $modules_check[$i]->{'name'};
        }
    }
    else {
        $modules_check[$i]->{'version_str'} = qq|<span class="red">利用できません</span>|;
    }
}

# -------------------
# モジュール一覧セット
# -------------------
$local{'modul_list'} .= qq|<table border="1">\n|;
foreach my $data (@modules_check) {
    $local{'modul_list'} .= qq|<tr>\n|;
    $local{'modul_list'} .= qq|<td>$data->{'name'}</td>\n|;
    $local{'modul_list'} .= qq|<td>$data->{'version_str'}</td>\n|;
    $local{'modul_list'} .= qq|</tr>\n|;
}
$local{'modul_list'} .= qq|</table>\n|;

# -------------------
# インクルード
# -------------------
$local{'INC_FILE'} = `php -f 'include.html'`;
if ( $local{'INC_FILE'} ) {
    $local{'INC_PHP_FLG'} = qq|<span class="blue">可能</span>|;
    $local{'INC_PHP_TAG'} = qq|<span class="blue">&lt;tmpl_var name=INC_INCLUDE&gt;</span>|;
}
else {
    $local{'INC_PHP_FLG'} = qq|<span class="red">不可</span>|;
    $local{'INC_PHP_TAG'} = qq|--|;
}

$local{'LWP_VERSION'} = eval "\$LWP::UserAgent::VERSION" || undef;
if ( $local{'LWP_VERSION'} ) {
    if ( $local{'LWP_VERSION'} ) {
        $local{'INC_LWP_FLG'} = qq|<span class="blue">可能</span>|;
        $local{'INC_LWP_TAG'} = qq|<span class="blue">&lt;tmpl_var name=INC_INCLUDE&gt;</span>|;
    }
    else {
        $local{'INC_LWP_FLG'} = qq|<span class="blue">不可</span>|;
        $local{'INC_LWP_TAG'} = qq|--|;
    }

}

# =========================
# 表示
# =========================
my $html = <<EOF;
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta name="keywords" content="" />
<meta name="description" content="" />
</head>

<style type="text/css">
<!--
body {
	font-size: 15px;
  line-height: 110%;
}
table {
	font-size: 15px;
}

.red {
  color: #FF0000;
}
.blue {
  color: #0000FF;
}
.gray {
  color: #A9A9A9;
}


.midasi {
  background-color: #CCCCCC;
}

td.dot_mario_0{
width: 2px;
height: 2px;
background-color: #FFFFFF;
}

td.dot_mario_1{
width: 2px;
height: 2px;
background-color: #E32300;
}

td.dot_mario_2{
width: 2px;
height: 2px;
background-color: #867500;
}

td.dot_mario_3{
width: 2px;
height: 2px;
background-color: #F8AB2B;
}


-->
</style>
<body>
<h1>Develop Checker（仮）</h1>

<table cellspacing="1" cellpadding="3" border="0" summary="">
  <tr>
    <td>
      <!-- マリオ -->
      <table border=0 cellspacing=0 cellpadding=0>
      <tr>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      </tr>
      <tr>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_0"></td>
      </tr>
      <tr>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      </tr>
      <tr>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_0"></td>
      </tr>
      <tr>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      </tr>
      <tr>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_0"></td>
      </tr>
      <tr>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      </tr>
      <tr>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      </tr>
      <tr>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_0"></td>
      </tr>
      <tr>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      </tr>
      <tr>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      </tr>
      <tr>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      </tr>
      <tr>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_3"></td>
      <td class="dot_mario_3"></td>
      </tr>
      <tr>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_1"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      </tr>
      <tr>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_0"></td>
      </tr>
      <tr>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_0"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      <td class="dot_mario_2"></td>
      </tr>
      </table>
    </td>
    <td><div>Ver：<b>1.00</b>　　auth：<b>wws Nakanishi</b></div></td>
  </tr>
</table>
<hr size="1">
  <a href="#place">[環境]</a>
  <a href="#php">[PHP]</a>
  <a href="#htaccess">[.htaccess]</a>
  <a href="#include">[インクルードの話]</a>
<hr size="1">

<!-- [環境] ============================================ -->
<h2 id="place">【環境】</h2>
<table cellspacing="1" cellpadding="3" border="1">
  <col class="midasi">
  <col>
  <tr>
    <td>OS</td>
    <td>$local{'os'}</td>
  </tr>
  <tr>
    <td>Perlのパス</td>
    <td>$local{'perl_path'}</td>
  </tr>
  <tr>
    <td>現在のディレクトリの絶対パス</td>
    <td>$local{'currentdir'}</td>
  </tr>
  <tr>
    <td>perl バージョン</td>
    <td>$local{'perl_version'}</td>
  </tr>
  <tr>
    <td>Sendmail</td>
    <td>$local{'sendmailinfo'}</td>
  </tr>
  <tr>
    <td>Perl モジュール</td>
    <td>
    $local{'modul_list'}
    <br /><font size="2">※一部の標準モジュールは利用できる場合でも<br />「利用できません」と表示される場合があります。</font>
    </td>
  </tr>
</table>
<hr size="1">
<!-- [PHP] ============================================ -->
<h2 id="php">【PHP】</h2>
<div>※下記に「PHP OK」の表示が在ればPHPは動作しています<div>
<iframe src="check.php" width="400" height="50" frameborder="0" style="border: 1px solid #999999;"></iframe>
<hr size="1">

<!-- [.htaccess] ============================================ -->
<h2 id="htaccess">【.htaccess】</h2>
<div>※「.htaccessが使えるか」、及び「.htaccessでHTMLをPHPとして動作させられるか」をチェックします<div>
<div>※チェックした結果、エラーとなるようならそもそもhtaccessが使用できません<div>
<form action="$ENV{'SCRIPT_NAME'}" method="POST">
<input type="hidden" name="c" value="set_htaccess" />
<input type="submit" value=".htaccessをセット" />
</form>
$local{'btn_chkhtaccess'}
<hr size="1">

<!-- [インクルードの話] ============================================ -->
<h2 id="include">【インクルードの話】</h2>
■インクルード先のファイルが静的な場合<br />
<span class="blue">&lt;tmpl_include name=./include.html&gt;</span>でテンプレートを作成してください<br />
<br />
■インクルード先のファイルが動的（PHPとして動作させる）な場合<br />
<table border="1">
  <col class="midasi">
  <col class="midasi">
  <col>
  <col>
  <tr>
    <td>1</td>
    <td>`php -f 'include.html'`の書き方</td>
    <td>$local{'INC_PHP_FLG'}</td>
    <td>$local{'INC_PHP_TAG'}</td>
  </tr>
  <tr>
    <td>2</td>
    <td>LWPモジュール</td>
    <td>$local{'INC_LWP_FLG'}</td>
    <td>$local{'INC_LWP_TAG'}</td>
  </tr>
  <tr>
    <td>3</td>
    <td>HTTP::Liteモジュール</td>
    <td>インストール無くてもピュアPerlだから設置すれば可能</td>
    <td><font color="#0000FF">&lt;tmpl_var name=INC_INCLUDE&gt;</font></td>
  </tr>
</table>
<br />
<br />
<hr size="1">
</body>
</html>
EOF

print "Content-Type: text/html\n\n";
print $html;
exit;
1;

# =========================
# 関数
# =========================
sub Parse {
    my ( $query, $key, $val );
    binmode(STDIN);
          ( $ENV{'REQUEST_METHOD'} eq 'GET' ) ? { $query = $ENV{'QUERY_STRING'} }
        : ( $ENV{'REQUEST_METHOD'} eq 'POST' ) ? { read( STDIN, $query, $ENV{'CONTENT_LENGTH'} ) }
        :                                        0;
    if ( $ENV{'CONTENT_TYPE'} =~ /multipart/i ) {
        my $separater = quotemeta( ( split( /boundary=/, $ENV{'CONTENT_TYPE'} ) )[-1] );
        my @cell = split( /[-]*$separater/, $query );
        shift @cell;
        pop @cell;

        my ($br);
        while ( my $str = shift @cell ) {
            ($br) = $str =~ /(\s*)/sg if ( !$br );
            my ( $name, $value, $bin ) = multipart_form( $str, $br );
            $in{$name} .= "\0" if ( defined( $in{$name} ) );
            $value =~ s/\x0D\x0A/\n/g;
            $value =~ tr/\x0D\x0A/\n\n/;
            $in{$name} .= $value;
            $in_bin{$name} = $bin;
        }
    }
    else {
        for ( split( /&/, $query ) ) {
            tr/+/ /;
            ( $key, $val ) = split(/=/);
            $key =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/pack("H2",$1)/eg;
            $val =~ s/%([A-Fa-f0-9][A-Fa-f0-9])/pack("H2",$1)/eg;
            $val =~ s/\x0D\x0A/\n/g;
            $val =~ tr/\x0D\x0A/\n\n/;
            $in{$key} .= "\0" if ( defined( $in{$key} ) );
            $in{$key} .= $val;
        }
    }
    return ( keys %in );
}

sub mkdirs {
    my $path = shift;
    my @dirs = split( /\//, $path );
    pop @dirs if ( $dirs[-1] =~ /\./ );
    mkpath( join( "/", @dirs ), 0, 0777 );
}

# -------------------
# htaccessファイル設置処理
# -------------------
sub setHtaccess {
    mkdirs("./tmp/");    # ディレクトリ作成
    chmod oct(777), "./tmp/";    # パーミッション

    my $html = <<EOF;
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>check HTML</title>
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta name="keywords" content="" />
<meta name="description" content="" />
</head>
<body>

<div>----------------------------------</div>
<div>▼HTMLで出力した文字列です</div>
<div>----------------------------------</div>
<div>HTMLで出力された文字です</div>
<br />
<div>----------------------------------</div>
<div>
▼PHPで出力した文字列です<br />
※空の場合はすなわち.htacceeでHTMLをPHPとして動作させる事が出来ません
</div>
<div>----------------------------------</div>
<?php echo '<div><font color="#0000FF">.htacceeでHTMLをPHPとして動作させる事が可能です</font></div>' ?>
</body>
</html>
EOF

    # テスト用HTMLファイルを出力
    open( OUT, ">tmp/check.html" );
    binmode OUT;
    print OUT $html;
    close(OUT);

    # .htaccessを出力
    open( OUT, ">tmp/.htaccess" );
    binmode OUT;
    print OUT "AddType application/x-httpd-php .php .html";
    close(OUT);
}
