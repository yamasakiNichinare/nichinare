#!/usr/bin/perl
# !/usr/local/bin/perl5.8
#-------------------------------------
# MySQL管理ﾂｰﾙ
# last update 2009-09-16
#-------------------------------------
use CGI::Carp qw(fatalsToBrowser);

our $MYSQL;
our %my;
if ( $ENV{'WINDIR'} ) {
    %my = (
        'bin'  => 'C:/mysql/bin/mysql',
        'host' => 'localhost',
        'user' => 'root',
        'pass' => '',
    );
}
else {
    %my = (
        'bin'        => 'mysql',
        'host'       => 'localhost',
        'user'       => 'z304150',
        'pass'       => '58Akabxn',
        'dafault_db' => 'z304150',

        #        'character-set' => 'latin1',
    );

    if ( !$ENV{'REMOTE_USER'} ) {
        print "Content-Type: text/html; charset=EUC-JP\n\n";
        print 'Basic認証を設置するまで動作しません';
        exit;
    }

}

&mysqldump if ( $ARGV[0] eq 'mysqldump' );

our %Label = (
    'table-Name'            => '&#65411;&#65392;&#65420;&#65438;&#65433;&#21517;',
    'table-Type'            => '&#65408;&#65394;&#65420;&#65439;',
    'table-Row_format'      => '&#65434;&#65402;&#65392;&#65412;&#65438;&#38263;',
    'table-Rows'            => '&#34892;&#25968;',
    'table-Avg_row_length'  => '&#24179;&#22343;&#65434;&#65402;&#65392;&#65412;&#65438;&#38263;',
    'table-Data_length'     => '&#20351;&#29992;&#23481;&#37327;',
    'table-Max_data_length' => '&#26368;&#22823;&#12524;&#12467;&#12540;&#12489;&#25968;',
    'table-Index_length'    => '&#65394;&#65437;&#65411;&#65438;&#65391;&#65400;&#65405;&#12539;&#65420;&#65383;&#65394;&#65433;&#23481;&#37327;',
    'table-Data_free'       => '&#38283;&#25918;&#21487;&#33021;&#12394;&#23481;&#37327;',
    'table-Auto_increment'  => '&#27425;&#12395;&#20351;&#29992;&#12377;&#12427;&#36899;&#30058;',
    'table-Create_time'     => '&#20316;&#25104;&#26085;',
    'table-Update_time'     => '&#26356;&#26032;&#26085;&#26178;',
    'table-Check_time'      => '&#26908;&#26619;&#26085;&#26178;',
    'table-Create_options'  => '&#20316;&#25104;&#26178;&#65397;&#65420;&#65439;&#65404;&#65390;&#65437;',
    'table-Comment'         => '&#65402;&#65426;&#65437;&#65412;',
);

our %in;
Parse();

if ( !%in && $my{'dafault_db'} ) {
    print "Location: $ENV{'SCRIPT_NAME'}?c=db&db=$my{'dafault_db'}\n\n";
    exit;
}

my %ck = Cookies('sql');
$ck{'charset'} ||= 'EUC-JP';
$ck{'view'}    ||= 50;

our %replace;

our %icon;
&icon;

$in{'c'} ||= 'Index';
&{ $in{'c'} };
&toHTML( \%replace );
exit;

#==================
# DB管理
#==================
sub js {
    print "Content-Type: text/javascript\n\n";
    print <<'EOF';

var read_option = function ( my_option, initial ) {
  if ( !my_option ) my_option = initial;
  return  my_option.split( /\D+/ );
}

var $j= jQuery;

$j(function () {

  /* 小窓を開く */
  $j('a.ow').click( function (){
    var opt = read_option( $j(this).attr('ow_option'), '600,300' );
    window.open( this.href, 'sw', 'resizable=yes,scrollbars=yes,width='+opt[0]+',height='+opt[1]).focus();
    return false;
  });

  $j('form.hw select').change( function (){
    var f = this.form;
    $j.ajax({
      url : f.action,
      data: $j(f).serialize(),
      type: 'post',
      success : function(){ document.location.reload(true) }
    }); // $j.ajax

    return false;
  });

  $j('a.hw').click( function (){
    var param = new String(this.href).match(/(.*?)\?(.*)/);
    $j.ajax({
      url : param[1],
      data: param[2],
      type: 'post',
      success : function(){ document.location.reload(true) }
    });
    return false;
  });

  /* ストライプ */
  $j("table.stripe tr:odd").addClass("odd");
  $j("table.stripe tr").hover( function () { $j(this).addClass("hover") }, function () { $j(this).removeClass("hover") } );

  /* クリックアクション */
  $j('a.db_drop').click(function () {
    var in_db = $j(this).parent().parent().attr('db');
    if ( confirm('databese: '+in_db+'\n\n★★ﾃﾞｰﾀﾍﾞｰｽを削除します。★★\n一度削除すると元に戻すことはできません。')
      ) {
      $j.ajax({
        url : 'index.cgi',
        data: 'c=db_drop&db='+in_db ,
        type: 'post',
        success : function(){ document.location.reload(true) }
      });
    }
    return false;
  });
  
  $j('a.dump').each(function () {
    in_db    =  $j(this).parent().parent().attr('db')    || in_db    || '';
    in_table =  $j(this).parent().parent().attr('table') || in_table || '';
    $j(this).attr('href','?c=dump&db='+in_db+'&table='+in_table);
  });

  $j('a.db_copy_form').each(function () {
    $j(this).attr('href','?c=db_copy_form&db='+$j(this).parent().parent().attr('db'));
  });

  $j('a.table').each(function () {
    $j(this).attr('href','?c=table&db='+in_db+'&table='+$j(this).parent().parent().attr('table'));
  });

  $j('a.data_view').each(function () {
    in_db    =  $j(this).parent().parent().attr('db')    || in_db    || '';
    in_table =  $j(this).parent().parent().attr('table') || in_table || '';
    $j(this).attr('href','?c=data_view&db='+in_db+'&table='+in_table);
  });

  $j('a.table_info').each(function () {
    $j(this).attr('href','?c=table_info&db='+in_db+'&table='+$j(this).parent().parent().attr('table'));
  });

  $j('a.table_copy_form').each(function () {
    $j(this).attr('href','?c=table_copy_form&db='+in_db+'&table='+$j(this).parent().parent().attr('table'));
  });

  $j('a.table_drop').click(function () {
    in_table =  $j(this).parent().parent().attr('table') || in_table || '';
    if ( confirm('table: '+in_table+'\n\n★★ﾃｰﾌﾞﾙを削除します。★★\n一度削除すると元に戻すことはできません。')
      ) {
      $j.ajax({
        url : 'index.cgi',
        data: 'c=table_drop&db='+in_db+'&table='+in_table,
        type: 'post',
        success : function(){ document.location.href='?c=db&db='+in_db }
      });
    }
    return false;
  });

  $j('a.data_delete').click(function () {
    if ( confirm('★★ﾃﾞｰﾀを削除します。★★\n一度削除すると元に戻すことはできません。')
      ) {
      var param = new String(this.href).match(/(.*?)\?(.*)/);
      $j.ajax({
        url : param[1],
        data: param[2],
        type: 'post',
        success : function(){ document.location.reload(true) }
      });
    }
    return false;
  });

  $j('a.sql_import_form').each(function () {
    in_db    =  $j(this).parent().parent().attr('db')    || in_db    || '';
    in_table =  $j(this).parent().parent().attr('table') || in_table || '';
    $j(this).attr('href','?c=sql_import_form&db='+in_db+'&table='+in_table);
  });

});
EOF
    exit;

}

sub Index {
    &connectSQL('mysql');
    &printHtmlHeader('MySQL&#31649;&#29702;');

    my $list;
    {
        my $sth = $MYSQL->prepare('SHOW DATABASES');
        $sth->execute();
        my $bgcolor;
        while ( my $href = $sth->fetchrow_hashref ) {
            $bgcolor = ( $bgcolor == 0 );
            $list .= qq|      <tr db="$href->{'Database'}">\n|;
            $list .= qq|        <td><a href="?c=db&db=$href->{'Database'}">$icon{'db'} $href->{'Database'}</A> </td>\n|;
            $list .= qq|        <td align="center"><a class="dump">Download</A></td>\n|;
            $list .= qq|        <td align="center"><a class="db_copy_form ow">$icon{'copy'}Copy</A></td>\n|;
            $list .= qq|        <td align="center"><a class="db_drop">$icon{'delete'}Drop</A></td>\n|;
            $list .= qq|      </tr>\n|;
        }
    }

    my %local;
    $local{'charset'} = qq|<select name="charset">| . form_option( $ck{'charset'}, [ 'Shift_JIS', 'EUC-JP', 'UTF-8' ] );

    $replace{'head'} = <<EOF;    # >
EOF

    $replace{'html'} = <<EOF;    # >
<a href="?c=all_db">&#20840;&#12390;&#12398;&#68;&#66;&#12398;&#12486;&#12540;&#12502;&#12523;&#12434;&#34920;&#31034;&#12377;&#12427;</a>    
<table cellspacing="1" border="0">
  <tr>
    <td>
    <table cellspacing="1" cellpadding="1" border="0" class="stripe">
      <tr class="td_head">
        <td>&#65411;&#65438;&#65392;&#65408;&#65421;&#65438;&#65392;&#65405;&#21517;</td>
        <td>&#65396;&#65400;&#65405;&#65422;&#65439;&#65392;&#65412;</td>
        <td>&#65424;&#65431;&#65392;&#65432;&#65437;&#65400;&#65438;</td>
        <td>&#21066;&#38500;</td>
      </tr>
      $list
    </table>
    </td>
  </tr>
  <tr>
    <td>
    <a href="?c=db_form" class="ow">[ $icon{'db'} &#65411;&#65438;&#65392;&#65408;&#65421;&#65438;&#65392;&#65405;&#20316;&#25104;]</a>
    <a href="?c=show_variables" class="ow" ow_option="500,700">[ $icon{'search'} MySQL&#65403;&#65392;&#65418;&#65438;&#65392;&#29872;&#22659;&#24773;&#22577;]</a>
    </td>
  </tr>
  <tr>
    <td>
    <table cellspacing="1" border="0">
      <tr>
        <td>
        <form action="$ENV{'SCRIPT_NAME'}" method="GET" name="charset" class="hw">
        <input type="hidden" name="c" value="view_option">
        $local{'charset'}
        </form>
        </td>
        <td>
        <form action="$ENV{'SCRIPT_NAME'}" method="GET">
        <input type="hidden" name="c" value="global_search">
        <input size="20" type="text" name="WORD" value="">
        <input type="submit" value="&#20840;&#12390;&#12363;&#12425;&#26908;&#32034;">
        </form>
        </td>
      </tr>
    </table>
    </td>
  </tr>
</table>
EOF

}

#======================
# MySQLｻｰﾊﾞｰ環境情報
#======================
sub show_variables {
    &connectSQL('mysql');
    &printHtmlHeader('MySQL&#65403;&#65392;&#65418;&#65438;&#65392;&#29872;&#22659;&#24773;&#22577;');

    my $sth = $MYSQL->prepare('SHOW VARIABLES');
    $sth->execute();
    my $bgcolor;
    while ( my $href = $sth->fetchrow_hashref ) {
        $bgcolor = ( $bgcolor == 0 );

        $href->{'Variable_name'} = qq|$icon{'flag'} $href->{'Variable_name'}| if ( $href->{'Variable_name'} eq 'version' );
        $href->{'Variable_name'} = qq|$icon{'link'} $href->{'Variable_name'}| if ( $href->{'Variable_name'} eq 'character_sets' );

        $list .= qq|      <tr class="td$bgcolor">\n|;
        $list .= qq|        <td>$href->{'Variable_name'} </td>\n|;
        $list .= qq|        <td>$href->{'Value'} </td>\n|;
        $list .= qq|      </tr>\n|;
    }

    $replace{'html'} = <<EOF;    # >
<table cellspacing="1" border="0">
  <tr>
    <td>
    <table cellspacing="1" cellpadding="1" border="0" bgcolor="#666666">
      <tr class="td_head">
        <td>Variable_name</td>
        <td>Value</td>
      </tr>
      $list
    </table>
    </td>
  </tr>
</table>
EOF

}

#=============================
# DB内TABLE一覧
#=============================
sub db {
    &connectSQL( $in{'db'} );
    &printHtmlHeader( "MySQL&#31649;&#29702;:$ENV{'SCRIPT_NAME'}", $in{'db'} );

    if ( !$MYSQL ) {
        print "Location: $ENV{'SCRIPT_NAME'}?\n\n";
        exit;
    }

    my $list;
    my $sth = $MYSQL->prepare('SHOW TABLE STATUS');
    $sth->execute();
    my $bgcolor;
    my $i = 0;
    my @js;
    while ( my $table = $sth->fetchrow_hashref ) {
        $bgcolor = ( $bgcolor == 0 );
        $i++;
        push(
            @js,
            sprintf(
                "{'%s':'%s','%s':'%s','%s':'%s','%s':'%s'}\n",
                'n', $table->{'Name'}, 'r', Sanma( $table->{'Rows'} ),
                'l', Sanma( int( ( $table->{'Data_length'} + 1023 ) / 1024 ) ),
                'u', $table->{'Update_time'}
            )
        );

    }

    $js = join( ",", @js );

    $replace{'head'} = <<EOF;    # >
<script type="text/javascript">
<!--
var table = [$js];
// -->
</script>
EOF

    $replace{'html'} = <<EOF;    # >
<form action="$ENV{'SCRIPT_NAME'}" method="POST">
<input type="hidden" name="c" value="dump">
<input type="hidden" name="db" value="$in{'db'}">
<table cellspacing="1" border="0">
  <tr>
    <td>&#65411;&#65438;&#65392;&#65408;&#65421;&#65438;&#65392;&#65405;&#21517; : $icon{'db'} $in{'db'}<br>
    <br>
    <a href="?c=table_create_form&db=$in{'db'}" class="ow" ow_option="600,500">[&#65411;&#65392;&#65420;&#65438;&#65433;&#20316;&#25104;]</a>
    <a href="?c=command&db=$in{'db'}" class="ow" ow_option="700,400">[SQL&#25991;&#30330;&#34892;]</a>
    <a class="sql_import_form ow">[SQL&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412;]</a>
    <a class="dump">[SQL&#12434;&#65408;&#65438;&#65395;&#65437;&#65435;&#65392;&#65412;&#65438;]</a>
    </td>
  </tr>
  <tr>
    <td>
    <table cellspacing="1" cellpadding="1" border="0" class="stripe" id="table_list">
      <tr class="td_head">
        <td>&#36984;</td>
        <td>-</td>
        <td>$Label{'table-Name'}</td>
        <td>$Label{'table-Rows'}</td>
        <td>$Label{'table-Data_length'}</td>
        <td>$Label{'table-Update_time'}</td>
        <td>&#24773;&#22577;</td>
        <td>&#65396;&#65400;&#65405;&#65422;&#65439;&#65392;&#65412;</td>
        <td>&#65424;&#65431;&#65392;&#65432;&#65437;&#65400;&#65438;</td>
        <td>&#21066;&#38500;</td>
      </tr>
      <script type="text/javascript">
//<![CDATA[
for (var i=0; i < table.length ;i ++) {
    var str = '';
    var obj = table[i];
    str += '<tr table="' + obj.n + '">'; //'
    str += '  <td><input type="checkbox" name="table" value="' + obj.n + '"></td>';
    str += '  <td>' + ( i + 1 ) + '</td>';
    str += '  <td><a class="table">$icon{'table'} ' + obj.n + '</a></td>';
    str += '  <td align="right"><a class="data_view">' + obj.r + '</a></td>';
    str += '  <td align="right">' + obj.l + ' KB</td>';
    str += '  <td>' + obj.u + '</td>';
    str += '  <td align="center"><a class="table_info ow" ow_option="400,480">$icon{'search'}</a></td>';
    str += '  <td align="center"><a class="dump">Download</a></td>';
    str += '  <td align="center"><a class="table_copy_form ow">$icon{'copy'}Copy</a></td>';
    str += '  <td align="center"><a class="table_drop">$icon{'delete'}Drop</a></td>';
    str += '</tr>';
    document.write(str);
}

//]]>
</script>
    </table>
    </td>
  </tr>
  <tr>
    <td>
    <input type="checkbox" name=".manual" value="1">&#25836;&#20284;&#65408;&#65438;&#65437;&#65420;&#65439;
    <input type="submit" value="&#36984;&#25246;&#12375;&#12383;&#65411;&#65392;&#65420;&#65438;&#65433;&#12434;&#65408;&#65438;&#65437;&#65420;&#65439;">
    &nbsp;&nbsp;
    <a href="?c=table_create_form&db=$in{'db'}" class="ow" ow_option="600,500">[&#65411;&#65392;&#65420;&#65438;&#65433;&#20316;&#25104;]</a>
    <a href="?c=command&db=$in{'db'}" class="ow" ow_option="700,400">[SQL&#25991;&#30330;&#34892;]</a>
    <a class="sql_import_form ow">[SQL&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412;]</a>
    <a class="dump">[SQL&#12434;&#65408;&#65438;&#65395;&#65437;&#65435;&#65392;&#65412;&#65438;]</a>
    </td>
  </tr>
</table>
</form>
EOF

}

#====================
# ﾃｰﾌﾞﾙの詳細情報
#====================
sub table_info {
    &connectSQL( $in{'db'} );
    &printHtmlHeader("$in{'db'} &gt; $in{'table'}");

    my %table;
    my $sth = $MYSQL->prepare("SHOW TABLE STATUS");
    $sth->execute();
    while ( my $table = $sth->fetchrow_hashref ) {
        if ( $table->{'Name'} eq $in{'table'} ) {
            %table = %{$table};
            last;
        }
    }

    my $status;

    if ( exists $table{'Name'} ) {
        $status .= qq|  <tr>\n|;
        $status .= qq|    <td>$Label{'table-Name'}</td>\n|;
        $status .= qq|    <td>$icon{'page'} <input size="30" type="text" value="$table{'Name'}" readonly></td>\n|;
        $status .= qq|  </tr>\n|;
    }

    for my $clum ( 'Type', 'Row_format', 'Create_time', 'Update_time', 'Check_time', ) {
        if ( exists $table{$clum} ) {
            $status .= qq|  <tr>\n|;
            $status .= qq|    <td>$Label{"table-$clum"}</td>\n|;
            $status .= qq|    <td>$table{"$clum"}</td>\n|;
            $status .= qq|  </tr>\n|;
        }
    }

    for my $clum ( 'Rows', 'Avg_row_length', 'Max_data_length', 'Data_free', 'Auto_increment', ) {
        if ( exists $table{$clum} ) {
            $status .= qq|  <tr>\n|;
            $status .= qq|    <td>$Label{"table-$clum"}</td>\n|;
            $status .= qq|    <td>@{[Sanma($table{"$clum"})]}</td>\n|;
            $status .= qq|  </tr>\n|;
        }
    }

    for my $clum ( 'Data_length', 'Index_length', ) {
        if ( exists $table{$clum} ) {
            $status .= qq|  <tr>\n|;
            $status .= qq|    <td>$Label{"table-$clum"}</td>\n|;
            $status .= qq|    <td>@{[Sanma($table{"$clum"})]} (@{[Sanma(int(($table{"$clum"}+1023)/1024))]}KB)</td>\n|;
            $status .= qq|  </tr>\n|;
        }
    }

    if ( exists $table{'Create_options'} ) {
        $status .= qq|  <tr>\n|;
        $status .= qq|    <td>$Label{'table-Create_options'}</td>\n|;
        $status .= qq|    <td><input size="30" type="text" value="$table{'Create_options'}" readonly></td>\n|;
        $status .= qq|  </tr>\n|;
    }

    if ( exists $table{'Comment'} ) {
        $status .= qq|  <tr>\n|;
        $status .= qq|    <td>$Label{'table-Comment'}</td>\n|;
        $status .= qq|    <td><TEXTAREA rows="5" cols="30" readonly>$table{'Comment'}</TEXTAREA></td>\n|;
        $status .= qq|  </tr>\n|;
    }

    $replace{'head'} = <<EOF;    # >
<SCRIPT type="text/javascript">
<!--
window.focus();
// -->
</SCRIPT>
EOF

    $replace{'html'} = <<EOF;    # >
<table cellspacing="1" border="0" class="stripe">
  <tr class="td_head">
    <td colspan="2">&#65411;&#65438;&#65392;&#65408;&#65421;&#65438;&#65392;&#65405;&#21517;: $in{'db'}</td>
  </tr>
  $status
</table>
<br>
<div align="center"><a href="JavaScript:close();">-close-</a></div>
EOF

}

#=============================
# SQL文発行(ﾌｫｰﾑ&処理)
#=============================
sub command {
    &connectSQL( $in{'db'} );
    &printHtmlHeader("SQL&#25991;&#30330;&#34892; $in{'db'}");

    my %local;

    my $SQL;
    for my $str ( split( /\n/, "$in{'SQL'};" ) ) {
        next if ( $str =~ /^\-\-/ );
        $SQL .= $str;
        if ( $SQL =~ /;$/ ) {
            my $sth = $MYSQL->prepare($SQL);
            $sth->execute();
            $local{'result'} .= qq|<TABLE cellspacing="1" cellpadding="1" border="0" bgcolor="#666666">\n|;

            if ( $SQL =~ /^\s*(select|optimize)/i ) {
                while ( my @ST = $sth->fetchrow_array ) {
                    $local{'result'} .= qq|  <tr bgcolor="#ffffff">\n|;
                    for my $str (@ST) {
                        $local{'result'} .= qq|    <td>@{[norm_input($str)]}</td>\n|;
                    }
                    $local{'result'} .= qq|  </tr>\n|;
                }
            }

            $local{'result'} .= qq|</TABLE>\n|;
            $local{'result'} .= qq|<br>\n|;

            $sth->finish();
            $SQL = '';
        }
    }

    $in{'table'} ||= 't1';

    my %Option = (
        'OPTION' => qq|
<option value=""> --&#25407;&#20837;--</option>
<option value="INSERT INTO `$in{'table'}` VALUES( xx, xx, xx );">insert&#38619;&#24418;</option>
<option value="REPLACE INTO `$in{'table'}` VALUES( xx, xx, xx );">replace&#38619;&#24418;</option>
<option value="UPDATE `$in{'table'}` SET X=XX WHERE pk='__';">update&#38619;&#24418;</option>
<option value="DELETE FROM `$in{'table'}` WHERE pk='__';">delete&#38619;&#24418;</option>
<option value="ALTER TABLE $in{'table'} ADD PRIMARY KEY( clum );">&#12503;&#12521;&#12452;&#12510;&#12522;&#12461;&#12540;&#35373;&#23450;</option>
<option value="ALTER TABLE $in{'table'} DROP PRIMARY KEY;">&#12503;&#12521;&#12452;&#12510;&#12522;&#12461;&#12540;&#21066;&#38500;</option>
<option value="ALTER TABLE $in{'table'} DROP clum;"> &#12459;&#12521;&#12512;&#21066;&#38500;</option>
<option value="ALTER TABLE $in{'table'} ADD INDEX indexName( clum );">&#12452;&#12531;&#12487;&#12483;&#12463;&#12473;&#12461;&#12540;&#36861;&#21152;</option>
<option value="ALTER TABLE $in{'table'} DROP INDEX indexName;">&#12452;&#12531;&#12487;&#12483;&#12463;&#12473;&#12461;&#12540;&#21066;&#38500;</option>
<option value="ALTER TABLE $in{'table'} ADD FULLTEXT indexName( clum );">FULLTEXT &#36861;&#21152;</option>
<option value="DELETE FROM $in{'table'};"> &#12524;&#12467;&#12540;&#12489;&#12463;&#12522;&#12450;</option>
<option value="OPTIMIZE TABLE $in{'table'};"> &#12486;&#12540;&#12502;&#12523;&#12398;&#26368;&#36969;&#21270;</option>
<option value="create table  `$in{'table'}_@{[ &YYMMDD ]}` as select * from `$in{'table'}`;">&#12486;&#12540;&#12502;&#12523;&#12398;&#12467;&#12500;&#12540;</option>
<option value="ALTER ">ALTER</option>
<option value="CHANGE ">CHANGE</option>
<option value="$in{'table'} ">table</option>
<option value="ADD ">ADD</option>
<option value="DROP ">DROP</option>
<option value="PRIMARY KEY ">PRIMARY KEY</option>
<option value="INDEX ">INDEX</option>
<option value="SELECT $in{'table'}.clum FROM $in{'table'} ">SELECT</option>
<option value="LEFT JOIN t2 ON $in{'table'}.clum=t2.clum ">JOIN</option>
<option value="WHERE ">WHERE</option>
<option value="ORDER BY ">ORDER BY</option>
<option value="DESC ">DESC</option>
|,
    );

    $replace{'html'} = <<EOF;    # >
<form action="$ENV{'SCRIPT_NAME'}" method="POST" name="form">
<input type="hidden" name="c" value="command">
<input type="hidden" name="db" value="$in{'db'}">
<input type="hidden" name="table" value="$in{'table'}">
<table cellspacing="0" border="0">
  <tr>
    <td>
    <textarea name="SQL" cols="80" rows="5">@{[norm_input($in{'SQL'})]}</textarea>
    </td>
  </tr>
  <tr>
    <td>
    <input type="submit" value="SQL&#25991;&#30330;&#34892;">
    </td>
  </tr>
</table>
<br>
<select name="auto" onChange="SQL.value+=this.options[this.selectedIndex].value">
$Option{'OPTION'}
</select>
<input type="button" value="CLEAR" onclick="SQL.value='';auto.selectedIndex=0">
</form>
$local{'result'}
<script type="text/javascript">
<!--
document.form.SQL.focus();
// -->
</script>
EOF
}

#=============================
# SQLｲﾝﾎﾟｰﾄ(ﾌｫｰﾑ)
#=============================
sub sql_import_form {
    &printHtmlHeader("SQL&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412; $in{'db'}");

    $replace{'html'} = <<EOF;    # >
<form action="$ENV{'SCRIPT_NAME'}" method="POST" name="form" enctype="multipart/form-data">
<input type="hidden" name="c" value="sql_import">
<input type="hidden" name="db" value="$in{'db'}">
<table cellspacing="0" border="0">
  <tr>
    <td>
    SQL&#65420;&#65383;&#65394;&#65433;
    <input size="60" type="file" name="SQL" value=""><br>
    <br>
    Drop&#27083;&#25991;&#20184;&#12365;&#12384;&#12392;&#12487;&#12540;&#12479;&#12364;&#24046;&#12375;&#26367;&#12360;&#12395;&#12394;&#12426;&#12414;&#12377;&#12290;<br>
    <br>
    </td>
  </tr>
  <tr>
    <td><input type="submit" value="SQL&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412;"></td>
  </tr>
</table>
</form>
EOF
}

#=============================
# SQLｲﾝﾎﾟｰﾄ(処理)
#=============================
sub sql_import {
    &connectSQL( $in{'db'} );

    my $SQL;
    for my $str ( split( /\n/, $in_bin{'SQL'} ) ) {
        next if ( $str =~ /^\-\-/ );
        $SQL .= $str;
        if ( $SQL =~ /;$/ ) {
            my $sth = $MYSQL->prepare($SQL);
            $sth->execute();
            $sth->finish();
            $SQL = '';
        }
    }

    &printSwClose();
}

#=============================
# dump
#=============================
sub dump {
    my $fname = $in{'db'};
    &connectSQL( $in{'db'} );

    my @table = param('table');
    if ( $in{'table'} ) {
        if ($#table) {
            $fname .= sprintf("-[カスタム]");
        }
        else {
            $fname .= sprintf( "-[%s]", $table[0] );
        }
    }

    if ( !@table ) {
        my $sth = $MYSQL->prepare("show tables");
        $sth->execute();
        while ( my ($table) = $sth->fetchrow_array ) {
            push( @table, $table );
        }
    }

    print Content_Download("$fname.sql");
    binmode STDOUT;

    if ( $in{'.manual'} ) {
        $| = 1;

        for my $table (@table) {
            my $sth = $MYSQL->prepare("SELECT * FROM `$table`");
            $sth->execute();

            print qq|\n|;
            print &create_table_sql_dump($table);
            print qq|\n|;
            print qq|\n|;
            print qq|--\n|;
            print qq|-- Dumping data for table `$table`\n|;
            print qq|--\n|;
            print qq|\n|;

            while ( my @row = $sth->fetchrow_array ) {
                print qq|INSERT INTO `$table` VALUES (|;
                print join(
                    ',',
                    map {
                        $_ =~ s/\\/\\\\/g;
                        $_ =~ s/\0/\\0/g;
                        $_ =~ s/\r\n/\\r\\n/g;
                        $_ =~ s/\r/\\r/g;
                        $_ =~ s/\n/\\n/g;
                        $_ =~ s/'/\\'/g;
                        qq|'$_'|
                        } @row
                );
                print qq|);\n|;
            }
            print qq|\n|;

        }

    }
    else {

        for my $table (@table) {
            my $opt;
            $opt .= qq| -u$my{'user'}|;
            $opt .= qq| -p$my{'pass'}| if ( $my{'pass'} ne '' );
            $opt .= qq| -h$my{'host'}| if ( $my{'host'} ne '' );
            $opt .= qq| --add-drop-table|;
            $opt .= qq| --default-character-set=latin1| if ( $my{'character-set'} eq 'latin1' );
            $opt .= qq| $in{'db'} $table 2>&1 |;

            $| = 1;
            open( FH, "perl index.cgi mysqldump \"$opt\" |" );
            print <FH>;
            close(FH);
        }
    }

    exit;

}

#=============================
# mysqldump
#=============================
sub mysqldump {
    $| = 1;
    exec "$my{'bin'}dump $ARGV[1]";
    exit;
}

#=============================
# CSVｲﾝﾎﾟｰﾄ(ﾌｫｰﾑ)
#=============================
sub csv_import_form {
    &printHtmlHeader("CSV&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412; &gt; $in{'db'} &gt; $in{'table'}");

    $replace{'html'} = <<EOF;    # >
<table cellspacing="1" border="0">
  <tr>
    <td>
    $Label{'table-Name'} : $icon{'table'} $in{'table'}<br>
  </tr>
  <tr>
    <td>
    <form action="$ENV{'SCRIPT_NAME'}" method="POST" name="form" enctype="multipart/form-data">
    <input type="hidden" name="c" value="csv_import">
    <input type="hidden" name="db" value="$in{'db'}">
    <input type="hidden" name="table" value="$in{'table'}">
    <table cellspacing="0" border="0">
      <tr>
        <td>
        CSV&#12434;&#65420;&#65383;&#65394;&#65433;
        <input size="60" type="file" name="CSV" value=""><br>
        <br>
        </td>
      </tr>
      <tr>
        <td><input type="submit" value="CSV&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412;"></td>
      </tr>
    </table>
    </form>
    </td>
  </tr>
</table>
<div align="center"><a href="JavaScript:close();">-close-</a></div>
EOF
}

#=============================
# CSVｲﾝﾎﾟｰﾄ(処理)
#=============================
sub csv_import {
    &connectSQL( $in{'db'} );

    my @CLUM;
    {
        my $sth = $MYSQL->prepare("DESC `$in{'table'}`");
        $sth->execute();
        while ( my $clum = $sth->fetchrow_hashref ) {
            push( @CLUM, $clum->{'Field'} );
        }
    }
    my @CSV = map {"$_\n"} split( /\n/, $in_bin{'CSV'} );
    while ( my $line = shift @CSV ) {
        $line .= shift @CSV while ( $line =~ tr/"// % 2 and @CSV );
        $line =~ s/(?:\x0D\x0A|[\x0D\x0A])?$/,/;
        my @values = map { /^"(.*)"$/s ? scalar( $_ = $1, s/""/"/g, $_ ) : $_ } ( $line =~ /("[^"]*(?:""[^"]*)*"|[^,]*),/g );
        my %data;
        @data{@CLUM} = @values;

        my $sth = $MYSQL->prepare( "REPLACE INTO `$in{'table'}` SET " . join( ",", map { "$_='" . add_slash( $data{$_} ) . "'" } @CLUM ) );
        $sth->execute();
    }

    &printSwClose();
}

#=============================
# CSVｴｸｽﾎﾟｰﾄ(処理)
#=============================
sub csv_export {
    print Content_Download("$in{'db'}-$in{'table'}.csv");

    &connectSQL( $in{'db'} );
    my $sth = $MYSQL->prepare("SELECT * FROM `$in{'table'}`");
    $sth->execute();
    while ( my @data = $sth->fetchrow ) {
        print &make_csv(@data);
    }
    exit;
}

#=============================
# DB作成(ﾌｫｰﾑ)
#=============================
sub db_form {
    &printHtmlHeader('&#65411;&#65438;&#65392;&#65408;&#65421;&#65438;&#65392;&#65405;&#20316;&#25104;');

    $replace{'html'} = <<EOF;    # >
<form action="$ENV{'SCRIPT_NAME'}" method="POST" name="form">
<input type="hidden" name="c" value="db_create">
<table cellspacing="0" border="0">
  <tr>
    <td>
    <table cellspacing="1" cellpadding="1" border="0" bgcolor="#666666">
      <tr class="td_head">
        <td>&#65411;&#65438;&#65392;&#65408;&#65421;&#65438;&#65392;&#65405;&#21517;</td>
      </tr>
      <tr bgcolor="#ffffff">
        <td><input type="text" size="30" name="db" style="IME-MODE: disabled"></td>
      </tr>
    </table>
    </td>
  </tr>
  <tr align="center">
    <td><input type="submit" value="&#65411;&#65438;&#65392;&#65408;&#65421;&#65438;&#65392;&#65405;&#20316;&#25104;"></td>
  </tr>
</table>
</form>
<script type="text/javascript">
<!--
document.form.db.focus();
// -->
</script>
EOF
}

#=============================
# DB作成(処理)
#=============================
sub db_create {
    &connectSQL('mysql');
    my $sth = $MYSQL->prepare("CREATE DATABASE IF NOT EXISTS `$in{'db'}`");
    $sth->execute();
    &printSwClose();
}

#=============================
# DB削除(処理)
#=============================
sub db_drop {
    &connectSQL('mysql');
    my $sth = $MYSQL->prepare("DROP DATABASE IF EXISTS `$in{'db'}`");
    $sth->execute();
    &printHwClose();
}

#=============================
# TABLE作成(ﾌｫｰﾑ)
#=============================
sub table_create_form {
    &printHtmlHeader('&#65411;&#65392;&#65420;&#65438;&#65433;&#20316;&#25104;');

    $in{'NA1'} ||= 'pk';
    $in{'TY1'} ||= 'INT';
    $in{'PR1'} ||= '1';
    $in{'EX1'} ||= 'auto_increment';
    $in{'di1'} = $in{'di2'} = $in{'di3'} = 'block';

    my $clum;
    for my $i ( 1 .. 20 ) {

        $in{"di$i"} ||= 'none';

        $clum .= qq|\n|;
        $clum .= qq|<DIV id="div$i" style="display:$in{"di$i"};">\n|;
        $clum
            .= qq|<DIV align="right" style="background:#ccc;padding: 2px;margin: 2px;border-bottom: 2px #999 solid;"><a href="#" onclick="var o=div$i.style;o.display='none';plus@{[$i-1]}.style.display='block';return false;">[ X ]</A></DIV>\n|
            if ( $i > 3 );
        $clum .= qq|<TABLE cellspacing="1" bgcolor="#999999">\n|;
        $clum .= qq|  <tr>\n|;
        $clum .= qq|    <td bgcolor="#eeeeee" valign="top">$i.<input size="15" type="text" name="NA$i" value="$in{"NA$i"}" style="IME-MODE: disabled"><br>\n|;
        $clum .= qq|    | . check_box( "PR$i", $in{"PR$i"}, 1, 'PRI' ) . qq|<br>\n|;
        $clum .= qq|    | . check_box( "IN$i", $in{"IN$i"}, 1, 'INDEX' ) . qq|<br>\n|;
        $clum .= qq|    | . check_box( "NU$i", $in{"NU$i"}, 1, 'NULL' ) . qq|<br>\n|;
        $clum .= qq|    </td>\n|;
        $clum .= qq|    <td bgcolor="#ffffff">\n|;
        $clum .= qq|    <input size="20" type="text" name="TY$i" value="$in{"TY$i"}" style="IME-MODE: disabled">\n|;
        $clum .= qq|    <SELECT onChange="TY$i.value=this.options[this.selectedIndex].value"><SCRIPT type="text/javascript">oplist()</SCRIPT></SELECT>\n|;
        $clum .= qq|    <TABLE cellspacing="1">\n|;
        $clum .= qq|      <tr>\n|;
        $clum .= qq|        <td>&#29305;&#12288;&#21029;</td>\n|;
        $clum
            .= qq|        <td><input size="20" type="text" name="EX$i" value="$in{"EX$i"}"><SELECT onChange="EX$i.value=this.options[this.selectedIndex].value"><SCRIPT type="text/javascript">extra()</SCRIPT></SELECT></td>\n|;
        $clum .= qq|      </tr>\n|;
        $clum .= qq|      <tr>\n|;
        $clum .= qq|        <td>&#21021;&#26399;&#20516;</td>\n|;
        $clum .= qq|        <td><TEXTAREA rows="2" cols="40" name="DE$i"></TEXTAREA></td>\n|;
        $clum .= qq|      </tr>\n|;
        $clum .= qq|    </TABLE>\n|;
        $clum .= qq|    </td>\n|;
        $clum .= qq|  </tr>\n|;
        $clum .= qq|</TABLE>\n|;

        if ( $i >= 3 && $i < 20 ) {    # >
            $clum .= qq|<DIV id="plus$i" align="right">\n|;
            $clum .= qq|<HR size="1">\n|;
            $clum .= qq|<a href="#" onclick="var o=div@{[$i+1]}.style;o.display='block';NA@{[$i+1]}.focus();plus$i.style.display='none';return false;">++ADD</A>\n|;
            $clum .= qq|</DIV>\n|;
        }
        $clum .= qq|<br>\n|;
        $clum .= qq|</DIV>\n|;
        $clum .= qq|\n|;
    }

    $replace{'head'} = &pulldown_list;

    $replace{'html'} = <<EOF;    # >
<div align="center">
<form action="$ENV{'SCRIPT_NAME'}" method="POST" name="form">
<input type="hidden" name="c" value="table_create">
<input type="hidden" name="db" value="$in{'db'}">
<table cellspacing="1" bgcolor="#999999">
  <tr bgcolor="#ffffff">
    <td>$Label{'table-Name'}</td>
    <td><input size="50" type="text" name="Name" style="IME-MODE: disabled"></td>
  </tr>
</table>
<br>
<div>
$clum
</div>
<br>
<input type="submit" value="&#65411;&#65392;&#65420;&#65438;&#65433;&#20316;&#25104;">
</form>
</div>
<script type="text/javascript">
<!--
document.form.Name.focus();
// -->
</script>
EOF

}

#=============================
# TABLE作成(処理)
#=============================
sub table_create {

    my $TABLE;
    my $PRIMARY_KEY;
    my $INDEX;

    for my $i ( 1 .. 20 ) {
        next if ( $in{"NA$i"} eq '' );
        $TABLE .= qq|  $in{"NA$i"} |;

        $TABLE .= qq|$in{"TY$i"} |;
        my $type
            = ( $in{"TY$i"} =~ /char|text|blob|enum|set/i ) ? 'char'
            : ( $in{"TY$i"} =~ /int|float|double/i ) ? 'int'
            : ( $in{"TY$i"} =~ /date|time/i )        ? 'date'
            :                                          '';

        if ( $in{"EX$i"} =~ /auto_increment/i ) {
            $TABLE .= qq|NOT NULL $in{"EX$i"} |;
        }
        elsif ( $in{"TY$i"} =~ /\benum\b/i ) {
        }
        else {
            $TABLE .= qq|$in{"EX$i"} |;
            $TABLE .= qq|NOT NULL | if ( !$in{"NU$i"} && $type ne 'int' );

            if ( $in{"DE$i"} ne '' ) {
                $TABLE .= qq|default '@{[add_slash($in{"DE$i"})]}' |;
            }
            elsif ( $type eq 'char' ) {
                $TABLE .= qq|default '' |;
            }
            elsif ( $type eq 'int' ) {
                $TABLE .= qq|default '0' |;
            }
            elsif ( $in{"NU$i"} ) {
                $TABLE .= qq|default NULL |;
            }
        }

        $TABLE .= qq|,\n|;

        # PRIMARY
        if ( $in{"PR$i"} ne '' ) {
            $PRIMARY_KEY .= "," if ($PRIMARY_KEY);
            $PRIMARY_KEY .= qq|$in{"NA$i"}|;
        }

        # INDEX
        if ( $in{"IN$i"} ne '' ) {
            $INDEX .= ",\n" if ($INDEX);
            $INDEX .= qq|  INDEX $in{"NA$i"}($in{"NA$i"})|;
        }
    }

    $PRIMARY_KEY = qq|  PRIMARY KEY ($PRIMARY_KEY)| if ($PRIMARY_KEY);
    $PRIMARY_KEY .= "," if ($INDEX);

    my $SQL = <<EOF;
CREATE TABLE IF NOT EXISTS $in{'Name'}(
$TABLE
$PRIMARY_KEY
$INDEX
) TYPE=MyISAM
EOF

    &connectSQL( $in{'db'} );
    my $sth = $MYSQL->prepare("$SQL");
    $sth->execute();

    &printSwClose();
}

#=============================
# TABLE削除(処理)
#=============================
sub table_drop {
    &connectSQL( $in{'db'} );
    my $sth = $MYSQL->prepare("drop table if exists `$in{'table'}`");
    $sth->execute();
    &printHwClose();
}

#=============================
# TABLE
#=============================
sub table {
    &connectSQL( $in{'db'} );
    &printHtmlHeader( "MySQL&#31649;&#29702;:?", "$in{'db'}:?c=db&db=$in{'db'}", $in{'table'} );

    my $list;
    my $sth = $MYSQL->prepare("DESC `$in{'table'}`");
    $sth->execute();
    my $i;
    while ( my $clum = $sth->fetchrow_hashref ) {
        $list .= qq|      <tr>\n|;
        $list .= qq|        <td>@{[ ++$i ]}</td>\n|;
        $list .= qq|        <td><a href="?c=clum_alter_form&db=$in{'db'}&table=$in{'table'}&clum=$clum->{'Field'}" class="ow">$clum->{'Field'}</A></td>\n|;
        $list .= qq|        <td>$clum->{'Type'}</td>\n|;
        $list .= qq|        <td>$clum->{'Null'}</td>\n|;
        $list .= qq|        <td>$clum->{'Key'}</td>\n|;
        $list .= qq|        <td>@{[norm_input($clum->{'Default'})]}</td>\n|;
        $list .= qq|        <td>$clum->{'Extra'}</td>\n|;
        $list .= qq|      </tr>\n|;
    }

    $replace{'html'} = <<EOF;    # >
<table cellspacing="1" border="0">
  <tr>
    <td>
    $Label{'table-Name'} : $icon{'table'} $in{'table'}<br>
    <br>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=clum_add_form" class="ow">[&#65398;&#65431;&#65425;&#36861;&#21152;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=table_rename_form" class="ow">[ $icon{'table'} &#65411;&#65392;&#65420;&#65438;&#65433;&#21517;&#22793;&#26356;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=csv_import_form" class="ow">[CSV&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=csv_export">[CSV&#12434;&#65408;&#65438;&#65395;&#65437;&#65435;&#65392;&#65412;&#65438;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=command" class="ow" ow_option="700,400">[SQL&#25991;&#30330;&#34892;]</a>
    <a class="sql_import_form ow">[SQL&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=dump">[SQL&#12434;&#65408;&#65438;&#65395;&#65437;&#65435;&#65392;&#65412;&#65438;]</a>
    <a class="table_drop">[&#65411;&#65392;&#65420;&#65438;&#65433;&#21066;&#38500;]</a><br>
    </td>
  </tr>
  <tr>
    <td>
    <table cellspacing="1" cellpadding="1" border="0" class="stripe">
      <tr class="td_head">
        <td>-</td>
        <td>&#65398;&#65431;&#65425;&#21517;</td>
        <td>&#31278;&#39006;</td>
        <td>NULL&#35377;&#21487;</td>
        <td>&#12461;&#12540;</td>
        <td>&#21021;&#26399;&#20516;</td>
        <td>&#29305;&#12288;&#21029;</td>
      </tr>
      $list
    </table>
    </td>
  </tr>
  <tr>
    <td>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=clum_add_form" class="ow">[&#65398;&#65431;&#65425;&#36861;&#21152;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=table_rename_form" class="ow">[ $icon{'table'} &#65411;&#65392;&#65420;&#65438;&#65433;&#21517;&#22793;&#26356;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=csv_import_form" class="ow">[CSV&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=csv_export">[CSV&#12434;&#65408;&#65438;&#65395;&#65437;&#65435;&#65392;&#65412;&#65438;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=command" class="ow" ow_option="700,400">[SQL&#25991;&#30330;&#34892;]</a>
    <a class="sql_import_form ow">[SQL&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=dump">[SQL&#12434;&#65408;&#65438;&#65395;&#65437;&#65435;&#65392;&#65412;&#65438;]</a>
    <a class="table_drop">[&#65411;&#65392;&#65420;&#65438;&#65433;&#21066;&#38500;]</a><br>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=table_sql">[&#25836;&#20284;SQL]</a><br>
    <br>
    <a class="data_view">[$icon{'zoomin'} &#65411;&#65438;&#65392;&#65408;&#21442;&#29031;]</a>
    </td>
  </tr>
</table>
EOF

}

#=============================
# TABLE名変更(ﾌｫｰﾑ)
#=============================
sub table_rename_form {
    &printHtmlHeader('&#65411;&#65392;&#65420;&#65438;&#65433;&#21517;&#22793;&#26356;');

    $replace{'html'} = <<EOF;    # >
<form action="$ENV{'SCRIPT_NAME'}" method="POST" name="form">
<input type="hidden" name="c" value="table_rename">
<input type="hidden" name="db" value="$in{'db'}">
<input type="hidden" name="old_table" value="$in{'table'}">
<table cellspacing="0" border="0">
  <tr>
    <td>
    <table cellspacing="1" cellpadding="1" border="0" bgcolor="#666666">
      <tr class="td_head">
        <td>$Label{'table-Name'}</td>
      </tr>
      <tr bgcolor="#ffffff">
        <td><input name="table" size="30" value="$in{'table'}"></td>
      </tr>
    </table>
    </td>
  </tr>
  <tr align="center">
    <td><input type="submit" value="&#65411;&#65392;&#65420;&#65438;&#65433;&#21517;&#22793;&#26356;"></td>
  </tr>
</table>
</form>
<script type="text/javascript">
<!--
document.form.table.focus();
document.form.table.select();
// -->
</script>
EOF
}

#=============================
# TABLE名変更(処理)
#=============================
sub table_rename {
    &connectSQL( $in{'db'} );

    my $sth = $MYSQL->prepare("ALTER TABLE `$in{'old_table'}` RENAME AS `$in{'table'}`");
    $sth->execute();

    $replace{'head'} = <<EOF;    # >
<SCRIPT type="text/javascript">
<!--
opener.location.href="?c=table&db=$in{'db'}&table=$in{'table'}";
close();
// -->
</SCRIPT>
EOF
}

#=============================
# CLUM追加(ﾌｫｰﾑ)
#=============================
sub clum_add_form {
    &connectSQL( $in{'db'} );
    &printHtmlHeader('&#65398;&#65431;&#65425;&#36861;&#21152;');

    my %local;
    $local{'PR'} = check_box( 'PR', '', 1, 'PRIMARY' );
    $local{'IN'} = check_box( 'IN', '', 1, 'INDEX' );
    $local{'NU'} = check_box( 'NU', '', 1, 'NULL' );

    my $sth = $MYSQL->prepare("DESC $in{'table'}");
    $sth->execute();
    while ( my $clum = $sth->fetchrow_hashref ) {
        $local{'after'} .= qq|        <OPTION value="$clum->{'Field'}">after $clum->{'Field'}</OPTION>\n|;
    }

    $replace{'head'} = &pulldown_list;
    $replace{'html'} = <<EOF;            # >
<form method="POST" action="$ENV{'SCRIPT_NAME'}" name="form" onSubmit="return confirm('&#65398;&#65431;&#65425;&#12434;&#36861;&#21152;&#12375;&#12414;&#12377;&#12290;')">
<input type="hidden" name="c" value="clum_add">
<input type="hidden" name="db" value="$in{'db'}">
<input type="hidden" name="table" value="$in{'table'}">
<table cellspacing="1" border="0">
  <tr>
    <td>
    <table cellspacing="1" bgcolor="#999999">
      <tr>
        <td bgcolor="#eeeeee" valign="top"><input size="15" type="text" name="NA" value="$in{'NA'}" style="IME-MODE: disabled"><br>
        <font color="#999999">$local{'PR'}<br>
        $local{'IN'}<br>
        </font>
        $local{'NU'}<br>
        </td>
        <td bgcolor="#ffffff">
        <input size="20" type="text" name="TY" value="$in{'TY'}" style="IME-MODE: disabled">
        <select onChange="TY.value=this.options[this.selectedIndex].value">
        <script type="text/javascript">oplist()</script></select>
        <table cellspacing="1">
          <tr>
            <td>&#29305;&#12288;&#21029;</td>
            <td><input size="20" type="text" name="EX" value="$in{'EX'}"><select onChange="EX.value=this.options[this.selectedIndex].value">
            <script type="text/javascript">extra()</script></select>
            </td>
          </tr>
          <tr>
            <td>&#21021;&#26399;&#20516;</td>
            <td><textarea rows="2" cols="40" name="DE"></textarea></td>
          </tr>
        </table>
        </td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td>
    <table cellspacing="1" cellpadding="1" border="0" bgcolor="#666666">
      <tr class="td_head">
        <td>&#22580;&#25152;</td>
      </tr>
      <tr bgcolor="#ffffff">
        <td><select name="after">
        <option value="first">first</option>
        $local{'after'}
        </select>
        </td>
      </tr>
    </table>
    </td>
  </tr>
  <tr align="center">
    <td><input type="submit" value="&#65398;&#65431;&#65425;&#36861;&#21152;"></td>
  </tr>
</table>
</form>
<script type="text/javascript">
<!--
document.form.NA.focus();
document.form.after.selectedIndex=document.form.after.options.length-1;
// -->
</script>
EOF
}

#=============================
# CLUM追加(処理)
#=============================
sub clum_add {

    my $CLUM;
    my $PRIMARY_KEY;
    my $INDEX;

    $in{'NU'} = '' if ( $in{'PR'} );

    $CLUM .= qq|  $in{'NA'} |;
    $CLUM .= qq|$in{'TY'} |;
    my $type
        = ( $in{'TY'} =~ /char|text|blob|enum|set/i ) ? 'char'
        : ( $in{'TY'} =~ /int|float|double/i ) ? 'int'
        : ( $in{'TY'} =~ /date|time/i )        ? 'date'
        :                                        '';

    if ( $in{'EX'} =~ /auto_increment/i ) {
        $CLUM .= qq|NOT NULL $in{'EX'} |;
    }
    elsif ( $in{'TY'} =~ /\benum\b/i ) {
    }
    else {
        $CLUM .= qq|$in{'EX'} |;
        $CLUM .= qq|NOT NULL | if ( !$in{'NU'} && $type ne 'int' );
        if ( $in{'DE'} ne '' ) {
            $CLUM .= qq|default '@{[add_slash($in{'DE'})]}' |;
        }
        elsif ( $type eq 'char' ) {
            $CLUM .= qq|default '' |;
        }
        elsif ( $type eq 'int' ) {
            $CLUM .= qq|default '0' |;
        }
        elsif ( $type eq 'date' ) {
            $CLUM .= qq|default '0000-00-00' |;
        }
        elsif ( $type eq 'datetime' ) {
            $CLUM .= qq|default '0000-00-00 00:00:00' |;
        }
        elsif ( $in{'NU'} ) {
            $CLUM .= qq|default NULL |;
        }
    }

    $PRIMARY_KEY = $in{'NA'} if ( $in{'PR'} ne '' );    # PRIMARY
    $INDEX       = $in{'NA'} if ( $in{'IN'} ne '' );    # INDEX

    if ( $in{'after'} ne '' && $in{'after'} !~ /first/i ) {
        $CLUM .= "after $in{'after'}";
    }

    &connectSQL( $in{'db'} );

    {
        my $sth = $MYSQL->prepare(qq|ALTER TABLE `$in{'table'}` ADD $CLUM |);
        $sth->execute();
    }

    if ($PRIMARY_KEY) {
        my $sth = $MYSQL->prepare("ALTER TABLE `$in{'table'}` ADD PRIMARY KEY ( $PRIMARY_KEY )");
        $sth->execute();
    }

    if ($INDEX) {
        my $sth = $MYSQL->prepare("ALTER TABLE `$in{'table'}` ADD INDEX $INDEX ( $INDEX )");
        $sth->execute();
    }

    &printSwClose();
}

#=============================
# CLUM変更(ﾌｫｰﾑ)
#=============================
sub clum_alter_form {
    &connectSQL( $in{'db'} );
    &printHtmlHeader('&#65398;&#65431;&#65425;&#22793;&#26356;');

    my $clum;
    my $sth = $MYSQL->prepare("DESC `$in{'table'}` `$in{'clum'}`");
    $sth->execute();
    $clum = $sth->fetchrow_hashref;

    my %local;
    $local{'PR'} = check_box( 'PR', ( $clum->{'Key'}  eq 'PRI' ), 1, 'PRIMARY' );
    $local{'IN'} = check_box( 'IN', ( $clum->{'Key'}  eq 'MUL' ), 1, 'INDEX' );
    $local{'NU'} = check_box( 'NU', ( $clum->{'Null'} eq 'YES' ), 1, 'NULL' );

    $replace{'head'} = &pulldown_list;

    $replace{'html'} = <<EOF;    # >
<form method="POST" action="$ENV{'SCRIPT_NAME'}" name="form" onSubmit="return confirm('&#65398;&#65431;&#65425;&#12434;&#22793;&#26356;&#12375;&#12414;&#12377;&#12290;')">
<input type="hidden" name="c" value="clum_alter">
<input type="hidden" name="db" value="$in{'db'}">
<input type="hidden" name="table" value="$in{'table'}">
<input type="hidden" name="old_clum" value="$in{'clum'}">
<table cellspacing="1" border="0">
  <tr>
    <td>
    <table cellspacing="1" bgcolor="#999999">
      <tr>
        <td bgcolor="#eeeeee" valign="top"><input size="15" type="text" name="NA" value="$clum->{'Field'}" style="IME-MODE: disabled"><br>
        <font color="#999999">$local{'PR'}<br>
        $local{'IN'}</font><br>
        $local{'NU'}<br>
        </td>
        <td bgcolor="#ffffff">
        <input size="20" type="text" name="TY" value="$clum->{'Type'}" style="IME-MODE: disabled">
        <select onChange="TY.value=this.options[this.selectedIndex].value">
        <script type="text/javascript">oplist()</script></select>
        <table cellspacing="1">
          <tr>
            <td>&#29305;&#12288;&#21029;</td>
            <td><input size="20" type="text" name="EX" value="$clum->{'Extra'}"><select onChange="EX.value=this.options[this.selectedIndex].value">
            <script type="text/javascript">extra()</script></select>
            </td>
          </tr>
          <tr>
            <td>&#21021;&#26399;&#20516;</td>
            <td><textarea rows="2" cols="40" name="DE">$clum->{'Default'}</textarea></td>
          </tr>
        </table>
        </td>
      </tr>
    </table>
    </td>
  </tr>
  <tr align="center">
    <td>
    <input type="submit" value="&#65398;&#65431;&#65425;&#22793;&#26356;">
    <a href="?c=clum_drop&db=$in{'db'}&table=$in{'table'}&clum=$in{'clum'}" onclick="return confirm('clum: $in{'clum'}\\n\\n&#9733;&#9733;&#65398;&#65431;&#65425;&#12434;&#21066;&#38500;&#12375;&#12414;&#12377;&#12290;&#9733;&#9733;&#92;&#92;&#110;&#19968;&#24230;&#21066;&#38500;&#12377;&#12427;&#12392;&#20803;&#12395;&#25147;&#12377;&#12371;&#12392;&#12399;&#12391;&#12365;&#12414;&#12379;&#12435;&#12290;')">[&#65398;&#65431;&#65425;&#21066;&#38500;]</a>
    </td>
  </tr>
</table>
</form>
<script type="text/javascript">
<!--
document.form.NA.focus();
// -->
</script>
EOF
}

#=============================
# CLUM変更(処理)
#=============================
sub clum_alter {

    my $CLUM;
    my $PRIMARY_KEY;
    my $INDEX;

    $in{'NU'} = '' if ( $in{'PR'} );

    $CLUM .= qq|  $in{'NA'} |;
    $CLUM .= qq|$in{'TY'} |;
    my $type
        = ( $in{'TY'} =~ /char|text|blob|enum|set/i ) ? 'char'
        : ( $in{'TY'} =~ /int|float|double/i ) ? 'int'
        : ( $in{'TY'} =~ /date|time/i )        ? 'date'
        :                                        '';

    if ( $in{'EX'} =~ /auto_increment/i ) {
        $CLUM .= qq|NOT NULL $in{'EX'} |;
    }
    elsif ( $in{'TY'} =~ /\benum\b/i ) {
    }
    else {
        $CLUM .= qq|$in{'EX'} |;
        $CLUM .= qq|NOT NULL | if ( !$in{'NU'} && $type ne 'int' );
        if ( $in{'DE'} ne '' ) {
            $CLUM .= qq|default '@{[add_slash($in{'DE'})]}' |;
        }
        elsif ( $type eq 'char' ) {
            $CLUM .= qq|default '' |;
        }
        elsif ( $type eq 'int' ) {
            $CLUM .= qq|default '0' |;
        }
        elsif ( $in{'NU'} ) {
            $CLUM .= qq|default NULL |;
        }
    }

    $PRIMARY_KEY = $in{'NA'} if ( $in{'PR'} ne '' );    # PRIMARY
    $INDEX       = $in{'NA'} if ( $in{'IN'} ne '' );    # INDEX

    &connectSQL( $in{'db'} );

    my $sth = $MYSQL->prepare(qq|ALTER TABLE `$in{'table'}` CHANGE `$in{'old_clum'}` $CLUM |);
    $sth->execute();

    &printSwClose();

}

#=============================
# CLUM削除(処理)
#=============================
sub clum_drop {
    &connectSQL( $in{'db'} );

    my $sth = $MYSQL->prepare("ALTER TABLE `$in{'table'}` DROP `$in{'clum'}`");
    $sth->execute();

    &printSwClose();
}

#=============================
# DATA参照
#=============================
sub data_view {
    &connectSQL( $in{'db'} );
    &printHtmlHeader(
        "MySQL&#31649;&#29702;:$ENV{'SCRIPT_NAME'}",
        "$in{'db'}:?c=db&db=$in{'db'}",
        "$in{'table'}:?c=table&db=$in{'db'}&table=$in{'table'}",
        '&#65411;&#65438;&#65392;&#65408;&#21442;&#29031;'
    );

    $in{'page'} = 1 if ( $in{'page'} < 1 );    # >

    my @CLUM;
    my @PRI;
    my %type;
    my %pri;
    {
        my $sth = $MYSQL->prepare("DESC `$in{'table'}`");
        $sth->execute();
        while ( my $clum = $sth->fetchrow_hashref ) {
            push( @CLUM, $clum->{'Field'} );
            push( @PRI, $clum->{'Field'} ) if ( $clum->{'Key'} eq 'PRI' );
            $type{ $clum->{'Field'} } = $clum->{'Type'};
            $pri{ $clum->{'Field'} }  = $clum->{'Key'};
        }
    }

    my %local;

    for my $CLUM (@CLUM) {
        $local{'clum'} .= qq|        <td>\n|;
        $local{'clum'} .= qq|        $CLUM<br>\n|;
        $local{'clum'} .= qq|        $type{$CLUM}<br>\n|;
        $local{'clum'} .= qq|        <font color="#ff0000">$pri{$CLUM}</font><br>\n|;
        $local{'clum'} .= qq|        <input size="15" type="text" name="q-$CLUM" value="@{[ norm_input($in{"q-$CLUM"}) ]}">\n|;
        $local{'clum'} .= qq|        </td>\n|;
    }

    my ( $sql, @sql1, @sql2 );
    for my $key ( grep { $_ =~ /^q-/ && $in{$_} ne '' } keys %in ) {
        push( @sql2, $in{$key} );
        $key =~ s/^q-//;
        push( @sql1, "`$key` like binary ?" );
    }

    if (@sql1) {
        $sql = sprintf( "WHERE %s", join( " and ", @sql1 ) );
    }

    my $sth = $MYSQL->prepare(qq|SELECT * FROM `$in{'table'}` $sql LIMIT @{[ ( $in{'page'} - 1 ) * $ck{'view'} ]}, $ck{'view'}|);
    $sth->execute(@sql2);

    while ( my $value = $sth->fetchrow_hashref ) {
        my $qs;
        for my $PRI (@PRI) {
            $qs .= qq|&pri_$PRI=@{[URI_escape($value->{$PRI})]}|;
        }
        $local{'table'} .= qq|      <tr>\n|;
        $local{'table'} .= qq|        <td nowrap><a href="?db=$in{'db'}&table=$in{'table'}&c=data_delete$qs" class="data_delete">[&#21066;&#38500;]</A></td>\n|;
        $local{'table'} .= qq|        <td nowrap><a href="?db=$in{'db'}&table=$in{'table'}&c=data_update_form$qs" class="ow">[&#20462;&#27491;]</A></td>\n|;
        for my $CLUM (@CLUM) {
            $local{'table'} .= qq|        <td>@{[norm_input($value->{$CLUM})]}</td>\n|;
        }
        $local{'table'} .= qq|      </tr>\n|;
    }

    my $sth_COUNT = $MYSQL->prepare("SELECT COUNT(*) FROM `$in{'table'}` $sql");
    $sth_COUNT->execute(@sql2);
    ( $local{'COUNT'} ) = $sth_COUNT->fetchrow;

    $local{'seek'} .= qq|Total @{[ Sanma( $local{'COUNT'} ) ]}|;
    $local{'seek'} .= qq| [ $ck{'view'} line/page ]  :: |;
    $local{'seek'} .= qq|<a href="#" onclick="document.navi.page.value=1;document.navi.submit();return false;">$icon{'begin'}</A> |;
    $local{'seek'} .= ( $in{'page'} > 1 ) ? qq|<a href="#" onclick="document.navi.page.value--;document.navi.submit();return false;">$icon{'prev'}</A>| : $icon{'prev_inactive'};
    $local{'seek'} .= qq| $in{'page'}/| . ( int( ( $local{'COUNT'} - 1 ) / $ck{'view'} ) + 1 ) . qq|p |;
    $local{'seek'}
        .= ( $in{'page'} * $ck{'view'} < $local{'COUNT'} ) ? qq|<a href="#" onclick="document.navi.page.value++;document.navi.submit();return false;">$icon{'next'}</A>| : $icon{'next_inactive'};
    $local{'seek'} .= qq| <a href="#" onclick="document.navi.page.value=| . ( int( ( $local{'COUNT'} - 1 ) / $ck{'view'} ) + 1 ) . qq|;document.navi.submit();return false;">$icon{'end'}</A>|;
    $local{'seek'} .= qq|&nbsp;&nbsp;|;

    $local{'charset'} = qq|<select name="charset">| . form_option( $ck{'charset'}, [ 'Shift_JIS', 'EUC-JP', 'UTF-8' ] );
    $local{'view'} = qq|<select name="view">| . form_option( $ck{'view'}, [ '5', '10', '20', '50', '100' ] );

    {
        $local{'CLUM-select'} = qq|<select name="CLUM" size="7" multiple>|;
        my %inCLUM;
        for my $CLUM ( param('CLUM') ) {
            $inCLUM{$CLUM}++;
        }
        for my $CLUM (@CLUM) {
            my $selected = ( $inCLUM{$CLUM} ) ? ' selected' : '';
            $local{'CLUM-select'} .= qq|<OPTION value="$CLUM"$selected>$CLUM</OPTION>\n|;
        }
        $local{'CLUM-select'} .= '</SELECT>';
    }

    $replace{'head'} = <<EOF;    # >
<script type="text/javascript">
//<![CDATA[
jQuery(function () {
 jQuery('input').dblclick(srch);
})

function srch() {
  document.navi.page.value=0;
  document.navi.submit();
}
//]]>
</script>
<style type="text/css">
<!--
#list { width: 80%; height: 570px; background: #ffc; overflow: auto; }
// -->
</style>
EOF

    $replace{'html'} = <<EOF;    # >
<table cellspacing="1" border="0">
  <tr>
    <td colspan="2">
    <table cellspacing="1">
      <tr>
        <td>$Label{'table-Name'} : $icon{'table'} $in{'table'}</td>
        <td><form action="$ENV{'SCRIPT_NAME'}" method="GET" name="charset" class="hw">
        <input type="hidden" name="c" value="view_option">
        $local{'charset'}
        $local{'view'}
        </form>
        </td>
      </tr>
    </table>
    </td>
  </tr>
  <tr>
    <td>$local{'seek'}
    <a href="?db=$in{'db'}&table=$in{'table'}&c=data_insert_form" class="ow" ow_option="500,500">[&#65411;&#65438;&#65392;&#65408;&#36861;&#21152;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=csv_import_form" class="ow">[CSV&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=csv_export">[CSV&#12434;&#65408;&#65438;&#65395;&#65437;&#65435;&#65392;&#65412;&#65438;]</a>
    <a href="?db=$in{'db'}&table=$in{'table'}&c=command" class="ow" ow_option="700,400">[SQL&#25991;&#30330;&#34892;]</a>
    <a class="sql_import_form ow">[SQL&#12434;&#65394;&#65437;&#65422;&#65439;&#65392;&#65412;]</a>
    <a class="dump">[SQL&#12434;&#65408;&#65438;&#65395;&#65437;&#65435;&#65392;&#65412;&#65438;]</a>
    </td>
  </tr>
</table>
<form action="$ENV{'SCRIPT_NAME'}" method="GET" name="navi">
<div id="list">
<table cellspacing="1" cellpadding="1" border="0" class="stripe">
  <tr class="td_head" valign="top">
    <td>&#21066;&#38500;</td>
    <td>&#20462;&#27491;</td>
    $local{'clum'}
  </tr>
  $local{'table'}
</table>
</div>
<input type="hidden" name="c" value="data_view">
<input type="hidden" name="db" value="$in{'db'}">
<input type="hidden" name="table" value="$in{'table'}">
<input type="hidden" name="page" value="$in{'page'}">
</form>
EOF
}

#=============================
# 表示文字コードの切り替え
#=============================
sub view_option {
    $ck{'charset'} = $in{'charset'} || $ck{'charset'};
    $ck{'view'}    = $in{'view'}    || $ck{'view'};
    Write_Cookies(
        -name  => 'sql',
        -value => \%ck,
    );
    &printHwClose();
}

#=============================
# DATA追加(ﾌｫｰﾑ)
#=============================
sub data_insert_form {
    &connectSQL( $in{'db'} );
    &printHtmlHeader('&#65411;&#65438;&#65392;&#65408;&#36861;&#21152;');

    my %local;

    my @CLUM;
    my %type;
    my %pri;
    my $sth = $MYSQL->prepare("DESC `$in{'table'}`");
    $sth->execute();
    while ( my $clum = $sth->fetchrow_hashref ) {
        push( @CLUM, $clum->{'Field'} );
        $type{ $clum->{'Field'} } = $clum->{'Type'};
        $pri{ $clum->{'Field'} }  = $clum->{'Key'};
    }

    for my $CLUM (@CLUM) {
        my $maxlength = qq|maxlength="$1"|             if ( $type{$CLUM} =~ /\((\d+)\)/ );
        my $ime       = qq|style="IME-MODE: disabled"| if ( $type{$CLUM} =~ /int|date|time|float|double/ );
        $local{'FORM'} .= qq|      <tr>\n|;
        $local{'FORM'} .= qq|        <td class="td_head">$CLUM<br>$type{$CLUM}<br><font color="#ff0000">$pri{$CLUM}</font></td>\n|;
        if ( !$maxlength && !$ime ) {
            $local{'FORM'} .= qq|        <td bgcolor="#ffffff"><TEXTAREA rows="3" cols="40" name="clum-$CLUM"></TEXTAREA></td>\n|;
        }
        else {
            $local{'FORM'} .= qq|        <td bgcolor="#ffffff"><input type="text" name="clum-$CLUM" size="30" $maxlength $ime></td>\n|;
        }
        $local{'FORM'} .= qq|      </tr>\n|;
    }

    $replace{'html'} = <<EOF;    # >
<form method="post" action="$ENV{'SCRIPT_NAME'}">
<input type="hidden" name="c" value="data_insert">
<input type="hidden" name="db" value="$in{'db'}">
<input type="hidden" name="table" value="$in{'table'}">
<table cellspacing="1" border="0">
  <tr>
    <td>
    <table cellspacing="1" cellpadding="1" border="0" bgcolor="#666666">
      $local{'FORM'}
    </table>
    </td>
  </tr>
  <tr align="center">
    <td><input type="submit" value="&#65411;&#65438;&#65392;&#65408;&#36861;&#21152;"></td>
  </tr>
</table>
</form>
EOF
}

#=============================
# DATA追加(処理)
#=============================
sub data_insert {
    &connectSQL( $in{'db'} );

    my $sth = $MYSQL->prepare("DESC `$in{'table'}`");
    $sth->execute();

    my @SET;
    while ( my $clum = $sth->fetchrow_hashref ) {
        push( @SET, qq|$clum->{'Field'}='@{[add_slash($in{'clum-'.$clum->{'Field'}})]}'| ) if ( $in{ 'clum-' . $clum->{'Field'} } ne '' );
    }

    $sth = $MYSQL->prepare( "INSERT INTO `$in{'table'}` SET " . join( ',', @SET ) );
    $sth->execute();

    &printSwClose();
}

#=============================
# DATA更新(ﾌｫｰﾑ)
#=============================
sub data_update_form {
    &connectSQL( $in{'db'} );
    &printHtmlHeader('&#65411;&#65438;&#65392;&#65408;&#22793;&#26356;');

    my %local;

    my @CLUM;
    my @PRI;
    my %type;
    my %pri;
    {
        my $sth = $MYSQL->prepare("DESC `$in{'table'}`");
        $sth->execute();
        while ( my $clum = $sth->fetchrow_hashref ) {
            push( @CLUM, $clum->{'Field'} );
            $type{ $clum->{'Field'} } = $clum->{'Type'};
            $pri{ $clum->{'Field'} }  = $clum->{'Key'};
            if ( $clum->{'Key'} eq 'PRI' ) {
                push( @PRI, $clum->{'Field'} );
                $local{'pri_hidden'} .= qq|<input type="hidden" name="pri_$clum->{'Field'}" value="$in{'pri_'.$clum->{'Field'}}">|;
                $local{'qs'}         .= qq|&pri_$clum->{'Field'}=@{[URI_escape($in{'pri_'.$clum->{'Field'}})]}|;
            }
        }
    }

    my @data;
    {
        my $sth = $MYSQL->prepare( "SELECT * FROM `$in{'table'}` WHERE " . join( ' AND ', map {qq|$_='@{[ add_slash($in{'pri_'.$_})]}'|} @PRI ) );
        $sth->execute();
        @data = $sth->fetchrow;
    }

    for my $CLUM (@CLUM) {
        my $value     = shift @data;
        my $maxlength = qq|maxlength="$1"| if ( $type{$CLUM} =~ /\((\d+)\)/ );
        my $ime       = qq|style="IME-MODE: disabled"| if ( $type{$CLUM} =~ /int|date|time|float|double/ );
        $local{'FORM'} .= qq|      <tr>\n|;
        $local{'FORM'} .= qq|        <td class="td_head">$CLUM<br>$type{$CLUM}<br><font color="#ff0000">$pri{$CLUM}</font></td>\n|;
        if ( !$maxlength && !$ime ) {
            $local{'FORM'} .= qq|        <td bgcolor="#ffffff"><textarea rows="3" cols="40" name="clum-$CLUM">@{[norm_input($value)]}</textarea></td>\n|;
        }
        else {
            $local{'FORM'} .= qq|        <td bgcolor="#ffffff"><input type="text" name="clum-$CLUM" size="30" value="@{[norm_input($value)]}" $maxlength $ime></td>\n|;
        }
        $local{'FORM'} .= qq|      </tr>\n|;
    }

    $replace{'html'} = <<EOF;    # >
<form method="post" action="$ENV{'SCRIPT_NAME'}">
<input type="hidden" name="c" value="data_update">
<input type="hidden" name="db" value="$in{'db'}">
<input type="hidden" name="table" value="$in{'table'}">
$local{'pri_hidden'}
<table cellspacing="1" border="0">
  <tr>
    <td>
    <table cellspacing="1" cellpadding="1" border="0" bgcolor="#666666">
      $local{'FORM'}
    </table>
    </td>
  </tr>
  <tr align="center">
    <td>
    <input type="submit" value="&#65411;&#65438;&#65392;&#65408;&#22793;&#26356;"> 
    <a href="?c=data_delete&db=$in{'db'}&table=$in{'table'}$local{'qs'}" onclick="return confirm('&#9733;&#9733;&#65411;&#65438;&#65392;&#65408;&#12434;&#21066;&#38500;&#12375;&#12414;&#12377;&#12290;&#9733;&#9733;&#92;&#92;&#110;&#19968;&#24230;&#21066;&#38500;&#12377;&#12427;&#12392;&#20803;&#12395;&#25147;&#12377;&#12371;&#12392;&#12399;&#12391;&#12365;&#12414;&#12379;&#12435;&#12290;');">[&#21066;&#38500;]</a>
    </td>
  </tr>
</table>
</form>
EOF
}

#=============================
# DATA変更(処理)
#=============================
sub data_update {
    &connectSQL( $in{'db'} );

    my %local;

    my @CLUM;
    my @PRI;
    {
        my $sth = $MYSQL->prepare("DESC `$in{'table'}`");
        $sth->execute();
        while ( my $clum = $sth->fetchrow_hashref ) {
            push( @CLUM, $clum->{'Field'} );
            push( @PRI, $clum->{'Field'} ) if ( $clum->{'Key'} eq 'PRI' );
        }
    }

    for my $CLUM (@CLUM) {
        if ( $in{ 'clum-' . $CLUM } ne '' ) {
            if ( $in{ 'clum-' . $CLUM } eq 'null' ) {
                push( @SET, qq|$CLUM=null| );
            }
            else {
                push( @SET, qq|$CLUM='@{[add_slash($in{'clum-'.$CLUM})]}'| );
            }
        }
    }

    my $sth = $MYSQL->prepare( qq|REPLACE INTO `$in{'table'}` SET | . join( ',', @SET ) );
    $sth->execute();

    &printSwClose();
}

#=============================
# DATA削除(処理)
#=============================
sub data_delete {
    &connectSQL( $in{'db'} );

    my @PRI;
    {
        my $sth = $MYSQL->prepare("DESC `$in{'table'}`");
        $sth->execute();
        while ( my $clum = $sth->fetchrow_hashref ) {
            if ( $clum->{'Key'} eq 'PRI' ) {
                push( @PRI, $clum->{'Field'} );
            }
        }
    }

    my $sth = $MYSQL->prepare( qq|DELETE FROM `$in{'table'}` WHERE | . join( ' AND ', map {qq|$_='@{[ add_slash($in{'pri_'.$_})]}'|} @PRI ) );
    $sth->execute();

    &printHwClose();
}

#=============================
# DB copy
#=============================
sub db_copy_form {

    &printHtmlHeader('&#65411;&#65438;&#65392;&#65408;&#65421;&#65438;&#65392;&#65405;&#65402;&#65419;&#65439;&#65392;');

    $replace{'html'} = <<EOF;    # >
<table cellspacing="1" border="0">
  <tr>
    <td>
    &#12467;&#12500;&#12540;&#20803; : $in{'db'} -&gt;
    <form action="$ENV{'SCRIPT_NAME'}" method="POST" target="s" name="a">
    <input type="hidden" name="c" value="db_copy">
    <input type="hidden" name="db" value="$in{'db'}">
    &#26032;&#35215;&#12487;&#12540;&#12479;&#12505;&#12540;&#12473;&#21517;
    <input size="20" type="text" name="add_db" value="$in{'db'}_2" style="IME-MODE: disabled">
    <input type="submit" name="smt" value="&#65424;&#65431;&#65392;&#65432;&#65437;&#65400;&#65438;&#38283;&#22987;" onclick="document.f.s.value='Please wait for a while'">
    </form>
    </td>
  </tr>
</table>
<form name="f">
STATUS<br>
<textarea rows="10" cols="30" name="s" style="border: 0;background: #eee;"></textarea><br>
</form>
<iframe src="about:blank" width="1" height="1" name="s"></iframe>
EOF
}

#=============================
# DB copy(処理)
#=============================
sub db_copy {

    if ( $in{'add_db'} eq '' ) {
        print "Content-Type: text/html\n\n";
        exit;
    }

    &connectSQL('mysql');
    {
        my $sth = $MYSQL->prepare("CREATE DATABASE IF NOT EXISTS `$in{'add_db'}`");
        $sth->execute();
    }

    my $opt;
    $opt .= qq| -u$my{'user'}|;
    $opt .= qq| -p$my{'pass'}| if ( $my{'pass'} ne '' );
    $opt .= qq| -h$my{'host'}| if ( $my{'host'} ne '' );
    $opt .= qq| $in{'db'} 2>&1 |;

    &connectSQL( $in{'add_db'} );

    print "Content-Type: text/html\n\n";
    print qq|<SCRIPT type="text/javascript">\n|;
    print qq|<!--\n|;
    print qq|parent.document.a.smt.disabled=true;\n|;
    print qq|parent.document.f.s.value +="\\n-- Starting --";\n|;

    $| = 1;
    open( SQL, "perl index.cgi mysqldump \"$opt\" |" );
    my $SQL;
    while ( my $str = <SQL> ) {
        next if ( $str =~ /^\n/ );
        next if ( $str =~ /^\-\-/ );
        $SQL .= $str;
        if ( $SQL =~ s/\;\n.*// ) {

            print qq|parent.document.f.s.value +="\\n$in{'add_db'} :: $1";\n| if ( $SQL =~ /^CREATE TABLE (\w+)/ );
            my $sth = $MYSQL->prepare($SQL);
            $sth->execute();
            $sth->finish();
            $SQL = '';
        }
    }
    close(SQL);
    print qq|parent.document.f.s.value +="\\n-- Complete --";\n|;
    print qq|parent.opener.location.href ="?";\n|;
    print qq|// -->\n|;
    print qq|</SCRIPT>\n|;
    exit;
}

#=============================
# TABLE copy
#=============================
sub table_copy_form {

    &printHtmlHeader('&#65411;&#65392;&#65420;&#65438;&#65433;&#65402;&#65419;&#65439;&#65392;');

    $replace{'html'} = <<EOF;    # >
<table cellspacing="1" border="0">
  <tr>
    <td>
    &#12467;&#12500;&#12540;&#20803; : $in{'table'} -&gt;
    <form action="$ENV{'SCRIPT_NAME'}" method="POST" target="s" name="a">
    <input type="hidden" name="c" value="table_copy">
    <input type="hidden" name="db" value="$in{'db'}">
    <input type="hidden" name="table" value="$in{'table'}">
    &#26032;&#35215;&#12486;&#12540;&#12502;&#12523;&#21517;
    <input size="20" type="text" name="add_tbl" value="$in{'table'}_@{[ &YYMMDD ]}" style="IME-MODE: disabled">
    <input type="submit" name="smt" value="&#65424;&#65431;&#65392;&#65432;&#65437;&#65400;&#65438;&#38283;&#22987;" onclick="document.f.s.value='Please wait for a while'">
    </form>
    </td>
  </tr>
</table>
<form name="f">
STATUS<br>
<textarea rows="10" cols="30" name="s" style="border: 0;background: #eee;"></textarea><br>
</form>
<iframe src="about:blank" width="1" height="1" name="s"></iframe>
EOF
}

#=============================
# TABLE copy(処理)
#=============================
sub table_copy {

    if ( $in{'add_tbl'} eq '' ) {
        print "Content-Type: text/html\n\n";
        exit;
    }

    my $opt;
    $opt .= qq| -u$my{'user'}|;
    $opt .= qq| -p$my{'pass'}| if ( $my{'pass'} ne '' );
    $opt .= qq| -h$my{'host'}| if ( $my{'host'} ne '' );
    $opt .= qq| $in{'db'} $in{'table'} 2>&1 |;

    &connectSQL( $in{'db'} );

    print "Content-Type: text/html\n\n";
    print qq|<SCRIPT type="text/javascript">\n|;
    print qq|<!--\n|;
    print qq|parent.document.a.smt.disabled=true;\n|;
    print qq|parent.document.f.s.value +="\\n-- Starting --";\n|;
    $MYSQL->do("create table `$in{'add_tbl'}` as select * from `$in{'table'}`");
    print qq|parent.document.f.s.value +="\\n-- Complete --";\n|;
    print qq|parent.opener.location.reload(true);\n|;
    print qq|// -->\n|;
    print qq|</SCRIPT>\n|;
    exit;
}

#=============================
# 全てから検索
#=============================
sub global_search {
    &connectSQL('mysql');
    &printHtmlHeader( "MySQL&#31649;&#29702;:$ENV{'SCRIPT_NAME'}", '&#20840;&#12390;&#12363;&#12425;&#26908;&#32034;' );

    my $list;
    if ( $in{'WORD'} ne '' ) {

        my $WORD_type;
        if ( $in{'WORD'} =~ /^[^\-\.\:\s\d]$/ ) {
            $WORD_type++;
        }

        my $sth_db = $MYSQL->prepare('SHOW DATABASES');
        $sth_db->execute();
        while ( my $db = $sth_db->fetchrow_hashref ) {
            next if ( $db->{'Database'} eq 'mysql' );
            push( @db, $db->{'Database'} );
        }

        for my $db (@db) {
            &connectSQL($db);
            my $sth_table = $MYSQL->prepare('SHOW TABLE STATUS');
            $sth_table->execute();

            while ( my $table = $sth_table->fetchrow_hashref ) {
                my $sth_clum = $MYSQL->prepare("DESC `$table->{'Name'}`");
                $sth_clum->execute();
                my @CLUM;
                my $qs;
                while ( my $clum = $sth_clum->fetchrow_hashref ) {

                    my $type
                        = ( $clum->{'Type'} =~ /char|text|blob|enum|set/i ) ? 'char'
                        : ( $clum->{'Type'} =~ /int|float|double/i ) ? 'int'
                        : ( $clum->{'Type'} =~ /date|time/i )        ? 'date'
                        :                                              '';

                    next if ( $WORD_type && ( $type eq 'int' or $type eq 'date' ) );
                    push( @CLUM, $clum->{'Field'} );
                    $qs .= qq|&CLUM=| . URI_escape( $clum->{'Field'} );
                }

                if (@CLUM) {
                    my $sql = qq|WHERE | . join( " OR ", map {"$_ like  binary '%$in{'WORD'}%'"} @CLUM );
                    my $sth = $MYSQL->prepare(qq|SELECT * FROM `$table->{'Name'}` $sql LIMIT 0,1 |);
                    $sth->execute();
                    if ( $sth->fetchrow ) {
                        $list .= qq|  <tr>\n|;
                        $list .= qq|    <td>$db</td>\n|;
                        $list .= qq|    <td><a href="?db=$db&table=$table->{'Name'}$qs&c=data_view&WORD=@{[URI_escape($in{'WORD'})]}">$table->{'Name'}</A></td>\n|;
                        $list .= qq|  </tr>\n|;
                    }
                }
            }
        }
    }

    $replace{'html'} = <<EOF;    # >
<table cellspacing="1" border="0">
  <tr>
    <td>
    <form action="$ENV{'SCRIPT_NAME'}" method="GET">
    <input type="hidden" name="c" value="global_search">
    <input size="20" type="text" name="WORD" value="@{[norm_input($in{'WORD'})]}">
    <input type="submit" value="&#20840;&#12390;&#12363;&#12425;&#26908;&#32034;">
    </form>
    </td>
  </tr>
</table>
<br>
<table cellspacing="1" border="0" class="stripe">
  <tr class="td_head">
    <td>db</td>
    <td>table</td>
  </tr>
  $list
</table>
<br>
<table cellspacing="1" border="0">
  <tr>
    <td>
    <form action="$ENV{'SCRIPT_NAME'}" method="GET">
    <input type="hidden" name="c" value="global_search">
    <input size="20" type="text" name="WORD" value="@{[norm_input($in{'WORD'})]}">
    <input type="submit" value="&#20840;&#12390;&#12363;&#12425;&#26908;&#32034;">
    </form>
    </td>
  </tr>
</table>
EOF
}

#=============================
# DB内TABLE一覧
#=============================
sub all_db {
    &connectSQL('mysql');
    &printHtmlHeader( "MySQL&#31649;&#29702;:$ENV{'SCRIPT_NAME'}", 'mysql' );

    if ( !$MYSQL ) {
        print "Location: $ENV{'SCRIPT_NAME'}?\n\n";
        exit;
    }

    my @db;
    my $sth = $MYSQL->prepare('SHOW DATABASES');
    $sth->execute();
    while ( my $href = $sth->fetchrow_hashref ) {
        push( @db, $href->{'Database'} );
    }

    my $list;
    for my $db (@db) {
        my $sth = $MYSQL->prepare("SHOW TABLE STATUS FROM `$db`");
        $sth->execute();
        my $i = 0;
        my $list;

        my @table;

        while ( my $table = $sth->fetchrow_hashref ) {
            push( @table, $table );
        }

        @table = sort { $b->{'Update_time'} cmp $a->{'Update_time'} } @table;

        for my $table (@table) {
            $i++;
            $list .= qq|<tr db="$db" table="$table->{'Name'}">\n|;
            $list .= qq|  <td>$i</td>\n|;
            $list .= qq|  <td> $table->{'Name'}</td>\n|;
            $list .= qq|  <td align="right"><a href="# class="data_view ow">@{[ Sanma( $table->{'Rows'} ) ]}</a></td>\n|;
            $list .= qq|  <td align="right">@{[ Sanma( int( ( $table->{'Data_length'} + 1023 ) / 1024 ) ) ]}KB</td>\n|;
            $list .= qq|  <td align="center">@{[ $table->{'Update_time'} ]}</td>\n|;
            $list .= qq|</tr>\n|;
        }

        $replace{'html'} .= <<EOF;    # >
<br>
&#65411;&#65438;&#65392;&#65408;&#65421;&#65438;&#65392;&#65405;&#21517; <a href="?c=db&amp;db=$db " target="_blank">$db</a>
<table cellspacing="1" border="0">
  <tr>
    <td>
    <table cellspacing="1" cellpadding="1" border="0" class="stripe">
      <tr class="td_head">
        <td>-</td>
        <td>$Label{'table-Name'}</td>
        <td>$Label{'table-Rows'}</td>
        <td>$Label{'table-Data_length'}</td>
        <td>$Label{'table-Update_time'}</td>
      </tr>
      $list
    </table>
    </td>
  </tr>
</table>
EOF
    }

}

sub table_sql {

    &connectSQL( $in{'db'} );
    print Content_Download(qq|$in{'table'}.sql|);
    print &create_table_sql_dump( $in{'table'} );
    exit;
}

#===========================================================
# HTML出力
#===========================================================
sub printHtmlHeader {
    $replace{'title'} = $_[-1];
    while ( @_ > 1 ) {
        my @LINK = split( /:/, shift @_ );
        $replace{'HtmlHeader'} .= qq|    <a href="$LINK[1]">$LINK[0]</A> &gt; \n|;
    }
    $replace{'HtmlHeader'} .= qq|    <B>$_[0]</B>\n|;
}

sub printSwClose {
    $replace{'head'} = <<EOF;
<SCRIPT type="text/javascript">
<!--
opener.location.reload(true);
close();
// -->
</SCRIPT>
EOF

    &toHTML( \%replace );
}

sub printHwClose {
    print "Content-Type: text/plain\n\n";
    print "ajax-OK";
    exit;
}

#==========================================================#
# SQL系ｻﾌﾞﾙｰﾁﾝ
#==========================================================#

sub connectSQL {
    my $db = shift;
    use DBI;
    $MYSQL = DBI->connect( "DBI:mysql:$db:host=$my{'host'}", $my{'user'}, $my{'pass'} ) || die "CONNECT ERROR $DBI::errstr";
}

sub add_slash {
    my $str = shift;
    $str =~ s/\\/\\\\/g;
    $str =~ s/"/\\"/g;
    $str =~ s/'/\\'/g;
    $str =~ s/`/\\`/g;
    $str =~ s/\r/\\r/g;
    $str =~ s/\n/\\n/g;
    return $str;
}

#===========================================================
# 文字列変換
#===========================================================

sub Sanma {
    my ($num) = @_;
    my ( $j, $i );
    if ( $num =~ /^[-+]?\d\d\d\d+/g ) {
        for ( $i = pos($num) - 3, $j = $num =~ /^[-+]/; $i > $j; $i -= 3 ) {
            substr( $num, $i, 0 ) = ',';
        }
    }
    $num;
}

sub norm_input {
    my $str = $_[0];
    $str =~ s/&/&amp;/g;
    $str =~ s/"/&quot;/g;    # "
    $str =~ s/</&lt;/g;
    $str =~ s/>/&gt;/g;
    $str;
}

sub URI_escape {
    my $str = shift;
    $str =~ s/(\W)/'%'.unpack('H2',$1)/eg;
    $str;
}

sub icon {
    $icon{'page'}          = '&#10059;';
    $icon{'db'}            = '&#12292;';
    $icon{'table'}         = '&#9619;';
    $icon{'search'}        = '&#10022;';
    $icon{'zoomin'}        = '&#9675;&#111;&#12290;';
    $icon{'flag'}          = '&#9819;';
    $icon{'link'}          = '&#10026;';
    $icon{'begin'}         = '&#9504;';
    $icon{'prev'}          = '&#8592;';
    $icon{'prev_inactive'} = '&#12288;';
    $icon{'next'}          = '&#8594;';
    $icon{'next_inactive'} = '&#12288;';
    $icon{'end'}           = '&#9512;';
    $icon{'delete'}        = '&#9760;';
    $icon{'copy'}          = '&#10064;';
}

sub make_csv {
    my (@values) = @_;
    return join( ',', map { ( s/"/""/g or /[\r\n,]/ ) ? qq("$_") : $_ } @values ) . "\n";
}

#===========================================================
# 全般
#===========================================================
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

sub multipart_form {
    my $str = shift;
    my $br  = shift;
    $str =~ s/^$br(.*)$br$/$1/s;
    my %tmp;
    ( $tmp{'head'}, $tmp{'body'} ) = split( /$br$br/, $str, 2 );
    ( $tmp{'name'} )  = $tmp{'head'} =~ /name="(.+?)"/gi;
    ( $tmp{'value'} ) = $tmp{'head'} =~ /filename="(.+?)"/gi;
    $tmp{'value'} ||= $tmp{'body'};
    return ( @tmp{ 'name', 'value', 'body' } );
}

sub param {
    my @result = split( /\0/, $in{ $_[0] } );
    return wantarray ? @result : $result[0];
}

sub Cookies {
    my ( $cookie_name, $cookie_value, @values, $key, $value );
    undef %Cookies;
    my $tmp_name = shift;
    $tmp_name =~ s/(\W)/'%'.uc unpack('H2', $1)/eg;
    for my $i ( split( /; /, $ENV{'HTTP_COOKIE'} ) ) {
        ( $cookie_name, $cookie_value ) = split( /=/, $i );
        next unless ( $cookie_name eq $tmp_name );
        @values = map { s/%([0-9A-Fa-f][0-9A-Fa-f])/pack('H2', $1)/eg; $_ } split( /&/, $cookie_value );
        $Cookies{$key} = $value while ( ( $key, $value ) = splice( @values, 0, 2 ) );
        last;
    }
    %Cookies;
}

sub Write_Cookies {
    my ( $key, $value, %hash, @values, @list, %span );

    $hash{$key} = $value while ( ( $key, $value ) = splice( @_, 0, 2 ) );
    $hash{'-name'} =~ s/(\W)/'%'.uc unpack('H2', $1)/eg;
    ( ref( $hash{'-value'} ) eq 'HASH' )
        ? map push( @values, $_, ${ $hash{'-value'} }{$_} ), keys %{ $hash{'-value'} }
        : push( @values, $hash{'-value'} );

    s/(\W)/'%'.uc unpack('H2', $1)/eg for (@values);

    map { ( $span{$_} ) = $hash{'-expires'} =~ /([+-]*\d+?)$_/ig } 'm', 'h', 'd', 'y';
    ( $span{''} ) = $hash{'-expires'} =~ /^([+-]*\d+)$/ig;
    my ( $sec, $min, $hour, $day, $mon, $year, $wday ) = gmtime( time + $span{''} + $span{'m'} * 60 + $span{'h'} * 60 * 60 + $span{'d'} * 60 * 60 * 24 + $span{'y'} * 60 * 60 * 24 * 365 );

    $year += 1900;
    $wday = num2week( getWday( $year, $mon ) );

    push( @list, "$hash{'-name'}=" . join( "&", @values ) );
    push( @list, "domain=$hash{'-domain'}" ) if ( $hash{'-domain'} );
    push( @list, "path=$hash{'-path'}" )     if ( $hash{'-path'} );
    push( @list, sprintf( "expires=%s, %02d-%s-%04d %02d:%02d:%02d GMT", $wday, $day, num2mon($mon), $year, $hour, $min, $sec ) ) if ( $hash{'-expires'} );
    push( @list, "secure" ) if ( $hash{'-secure'} );
    print "Set-Cookie: " . join( '; ', @list ) . "\n";
}

sub getWday {
    my ( $year, $mon, $mday ) = @_;
    if ( $mon == 1 or $mon == 2 ) { $year--; $mon += 12 }
    int( $year + int( $year / 4 ) - int( $year / 100 ) + int( $year / 400 ) + int( ( 13 * $mon + 8 ) / 5 ) + $mday ) % 7;
}

sub num2mon  { (qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec))[shift] }
sub num2week { (qw(Sun Mon Tue Wed Thu Fri Sat))[shift] }

sub check_box {
    my ( $key, $the_key, $value, $view ) = @_;
    my ($modori);
    $value = 1 if ( $value eq '' );
    my $checked = ( $the_key eq $value ) ? ' checked' : '';
    $modori = qq|<input type="checkbox" name="$key" value="$value"$checked id="$key-$value">|;
    $modori .= qq|<LABEL for="$key-$value">$view</LABEL>| if ( $view ne '' );
    $modori;
}

sub form_option {
    my ( $the_key, $list_ref1, $list_ref2 ) = @_;
    my ($modori);
    for my $i ( 0 .. $#$list_ref1 ) {
        my $view = $list_ref2->[$i] || $list_ref1->[$i];
        my $selected = ( $list_ref1->[$i] eq $the_key ) ? ' selected' : '';
        $modori .= qq|\n<OPTION value="$list_ref1->[$i]"$selected>$view</OPTION>|;
    }
    $modori . qq|\n</SELECT>|;
}

sub toHTML {
    my ($ref) = shift;
    print <<EOF;
Content-Type: text/html

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=$ck{'charset'}">
<meta http-equiv="Content-Style-Type" content="text/css">
<title>$ref->{'title'}</title>
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js" charset="utf-8"></script>
<script type="text/javascript" src="$ENV{'SCRIPT_NAME'}?c=js" charset="EUC-JP"></script>
<script type="text/javascript">
//<![CDATA[
  var in_db = '$in{'db'}';
  var in_table = '$in{'table'}';
//]]>
</script>

$ref->{'head'}
<style type="text/css">
<!--
a {color: #000; text-decoration: none;cursor: hand;}
a: hover {color: #f00; text-decoration: underline;}
form {margin: 0;}
body {font-size: x-small; background: #fff;}
td {font-size: x-small; padding: 2px 4px 1px 4px;}
.stripe {background: #aaa;}
.stripe tr {background: #fff;}
.stripe tr.odd {background: #eee;}
.stripe tr.hover {background: #ffa;}
.stripe tr.td_head, .td_head {font-weight: bold; text-align: center; background: #ccc;}
#HH {padding: 5px; height: 20px; filter: progid: dximagetransform.microsoft.gradient(gradienttype=1, startcolorstr=#cccccc, endcolorstr=#f3f3f3);}
// -->
</style>
</head>
<body>
<div id="HH">$ref->{'HtmlHeader'}</div>
<div align="center">
$ref->{'html'}
</div>
<hr size="1">
</body>
</html>
EOF
    exit;

}

sub pulldown_list {

    return <<EOF;
<script type="text/javascript">
<!--
function oplist() {
  document.write('<option value="">-&#36984;&#25246;&#12391;&#12365;&#12414;&#12377;-</option>'); //'
  document.write('<optgroup label="CHAR">');
  document.write('<option value="VARCHAR(255)" style="color:#f00">VARCHAR(n)</option>');
  document.write('<option value="CHAR(255)">CHAR(n)</option>');
  document.write('<option value="TEXT" style="color:#f00">TEXT(65KB)</option>');
  document.write('<option value="MEDIUMTEXT">MEDIUMTEXT(16MB)</option>');
  document.write('<option value="BLOB">BLOB(65KB)</option>');
  document.write('<option value="MEDIUMBLOB">MEDIUMBLOB(16MB)</option>');
  document.write('<option value="ENUM(\\'A\\',\\'B\\',\\'O\\')">ENUM(\\'A\\',\\'B\\',\\'O\\')</option>');
  document.write('<option value="SET(\\'v1\\',\\'v2\\')">SET(\\'v1\\',\\'v2\\')</option>');
  document.write('</optgroup>');
  document.write('<optgroup label="INT">');
  document.write('<option value="INT(11)" style="color:#f00">INT(+-2,147,483,647)</option>');
  document.write('<option value="SMALLINT(4)">SMALLINT(+-32767)</option>');
  document.write('<option value="TINYINT" style="color:#f00">TINYINT(+-127)</option>');
  document.write('<option value="BIGINT">BIGINT</option>');
  document.write('<option value="FLOAT" style="color:#f00">FLOAT</option>');
  document.write('<option value="DOUBLE">DOUBLE</option>');
  document.write('</optgroup>');
  document.write('<optgroup label="DATE">');
  document.write('<option value="DATE" style="color:#f00">DATE</option>');
  document.write('<option value="DATETIME" style="color:#f00">DATETIME</option>');
  document.write('<option value="TIMESTAMP(14)" style="color:#f00">TIMESTAMP</option>');
  document.write('<option value="TIME">TIME</option>');
  document.write('</optgroup>');
}

function extra() {
  document.write('<option value="">-&#36984;&#25246;&#12391;&#12365;&#12414;&#12377;-</option>');
  document.write('<option value="auto_increment">[INT] AUTO_INCREMENT</option>');
  document.write('<option value="unsigned">[INT] UNSIGNED</option>');
  document.write('<option value="zerofill">[INT] ZEROFILL</option>');
  document.write('<option value="binary">[CHAR] BINARY</option>');
  document.write('<option value="ascii">[CHAR] ASCII</option>');
  document.write('<option value="unicode">[CHAR] UNICODE</option>');
}
// -->
</script>
EOF
}

sub JS_escape {
    my $str = shift;
    $str =~ s/'/\\'/g;
    $str =~ s/"/\\"/g;
    $str =~ s/\n/\\n/g;
    $str;
}

sub Content_Download {
    my ( $fname, $fsize ) = @_;
    use Jcode;
    if ( $ENV{'HTTP_USER_AGENT'} =~ /Firefox/i ) {
        $fname = jcode($fname)->utf8;
    }
    else {
        $fname = jcode($fname)->sjis;
    }

    $fname =~ tr/\/*\r\n\t\\//d;
    $fsize =~ tr/0-9//cd;

    $fname =~ s/"/\\"/g;
    $return .= qq|Content-Type: application/octet-stream\n|;
    $return .= qq|Content-Type: application/download; name="$fname"\n|;
    $return .= qq|Content-Disposition: attachment; filename="$fname"\n|;
    $return .= qq|Content-Length: $fsize\n| if ($fsize);
    $return .= qq|\n|;

    return $return;

}

sub create_table_sql_dump {
    my ($table) = shift;

    my $sth = $MYSQL->prepare("DESC `$table`");
    $sth->execute();

    my ( @FIELDS, @PRI, @MUL );
    while ( my @data = $sth->fetchrow ) {

        if ( $data[3] eq 'PRI' ) {
            push( @PRI, $data[0] );
        }
        elsif ( $data[3] eq 'MUL' ) {
            if (  $data[1] eq 'text' ) {
              push( @MUL, qq|FULLTEXT $data[0] ($data[0])| );
            }else {
              push( @MUL, qq|KEY $data[0] ($data[0])| );
            }
        }

        my $FIELD;
        $FIELD .= qq|`$data[0]` |;
        $FIELD .= qq|$data[1] |;

        $data[4] =~ s/'/\\'/g;

        if ( $data[5] ) {
            $FIELD .= qq|NOT NULL  $data[5]|;
        }
        elsif ( $data[2] ne 'YES' ) {
            if ( $data[4] ) {
                $FIELD .= qq|NOT NULL default '$data[4]'|;
            }
            elsif ( $data[1] =~ /int/ ) {
                $FIELD .= qq|NOT NULL default '0'|;
            }
            elsif ( $data[1] eq 'date' ) {
                $FIELD .= qq|NOT NULL default '0000-00-00'|;
            }
            elsif ( $data[1] eq 'datetime' ) {
                $FIELD .= qq|NOT NULL default '0000-00-00 00:00:00'|;
            }
            else {
                $FIELD .= qq|NOT NULL default ''|;
            }
        }
        elsif ( $data[4] ne '' ) {
            $FIELD .= qq|default '$data[4]'|;
        }
        else {
            $FIELD .= qq|default NULL|;
        }

        push( @FIELDS, $FIELD );
    }

    push( @FIELDS, sprintf( 'PRIMARY KEY (%s)', join( ', ', @PRI ) ) ) if (@PRI);
    push( @FIELDS, @MUL ) if (@MUL);

    my $sql_dump;
    $sql_dump .= qq|\n|;
    $sql_dump .= qq|--\n|;
    $sql_dump .= qq|-- Table structure for table `$table`\n|;
    $sql_dump .= qq|--\n|;
    $sql_dump .= qq|\n|;
    $sql_dump .= qq|DROP TABLE IF EXISTS `$table`;\n|;
    $sql_dump .= qq|CREATE TABLE `$table` (\n|;
    $sql_dump .= qq|  |;
    $sql_dump .= join( ",\n  ", @FIELDS );
    $sql_dump .= qq|\n|;
    $sql_dump .= qq|);\n|;

    return $sql_dump;
}

#=============================
# ｼﾘｱﾙ秒から各時間を取得
#=============================
sub YY { ( localtime( shift || time ) )[5] + 1900 }
sub MM { sprintf( "%02d", ( localtime( shift || time ) )[4] + 1 ) }
sub DD { sprintf( "%02d", ( localtime( shift || time ) )[3] ) }
sub hh { sprintf( "%02d", ( localtime( shift || time ) )[2] ) }
sub mm { sprintf( "%02d", ( localtime( shift || time ) )[1] ) }
sub ss { sprintf( "%02d", ( localtime( shift || time ) )[0] ) }

sub DATETIME {
    my $time = ( shift || time );
    sprintf( "%04d-%02d-%02d %02d:%02d:%02d", &YY($time), &MM($time), &DD($time), &hh($time), &mm($time), &ss($time) );
}

sub YYMMDD {
    my $time = ( shift || time );
    sprintf( "%04d%02d%02d", &YY($time), &MM($time), &DD($time) );
}
