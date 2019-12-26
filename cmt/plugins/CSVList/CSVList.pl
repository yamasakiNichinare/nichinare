package MT::Plugin::SKR::CSVList;
########################################################################
#   CSVList - Apply templates by using values from CSV; Comma Separated Values
#           Copyright (c) 2007-2008 SKYARC System Co.,Ltd.
#           @see http://www.skyarc.co.jp/engineerblog/entry/3859.html
########################################################################
use strict;
use MT::Template::Context;
use MT::Util;
use Encode;
use lib 'lib';
use Text::CSV_PP;
use Data::Dumper;

use vars qw( $MYNAME $VERSION );
$MYNAME = 'CSVList';
$VERSION = '1.11';

use constant MAX_COLUMNS => 20;

### Sub-Class
use base qw( MT::Plugin );
my $plugin = new MT::Plugin ({
        name        => $MYNAME,
        version     => $VERSION,
        author_name => q{ SKYARC System Co.,Ltd. },
        author_link => q{ http://www.skyarc.co.jp/ },
        doc_link    => qw{ http://www.skyarc.co.jp/engineerblog/entry/3859.html },
        description => <<HTMLHEREDOC,
Build templates with stored comma separated values.
HTMLHEREDOC
});
MT->add_plugin( $plugin );

sub instance { $plugin }

### Retrieving the values (max to 20 columns)
foreach (1..MAX_COLUMNS) {
	MT::Template::Context->add_tag ("CSV$_" => \&_hdlr_csv);
}
sub _hdlr_csv {
    my ($ctx, $args) = @_;
    my $columns = $ctx->{__stash}->{__PACKAGE__. '::columns'}
        or return $ctx->error('not used in CSVList');
    my ($col_num) = $ctx->stash('tag') =~ m!.+(\d+)$!;
    $$columns[--$col_num];
}

### Container Tag
MT::Template::Context->add_container_tag ( CSVList => \&_hdlr_csv_list );
sub _hdlr_csv_list {
    my ($ctx, $args, $cond) = @_;
    my $builder = $ctx->stash ('builder');
    my $tokens = $ctx->stash ('tokens');

    # Compile data
    $args->{data}
        or return $ctx->error('<data> param must be specified');
    my $compiled = $builder->compile ($ctx, MT::Util::decode_html ($args->{data}))
        or return $ctx->error ('compile');
    my $data = $builder->build ($ctx, $compiled, $cond)
        or return $ctx->error ('build data');

    # Column delimitor
    # Set Separator (defalt:Comma)
    my $separator = $args->{separator} || $args->{delimitor} || ',';
    return $ctx->error('Separated can not specify the double quotes.') if $separator =~ /^\"+$/;
    return $ctx->error('Separated can not specify the line end.')      if $separator =~ /^[\r\n]+$/;
    return $ctx->error('Separated can not specify the space.')         if $separator =~ /^\s+$/;

    my $parser = Text::CSV_PP->new( { 'binary' => 1 , 'sep_char' => $separator } );
    my @list = ();
    my @line = split( /(?:\n\r|\n)/ , $data );
    for my $line ( @line ){
        next if $line =~ m{^\s*$};
        next unless $parser->parse( $line );
        my @row = $parser->fields();
        push @list , \@row;
    }

    my $out = '';
    for my $row (@list){
        next unless $row;
        next unless scalar @{$row};
        local $ctx->{__stash}->{__PACKAGE__. '::columns'} = $row;
        $out .= $builder->build ($ctx, $tokens, $cond)
               or return $ctx->error ('build');
    }
    $out;
}
MT::Template::Context->add_global_filter( encode_csv => \&encode_csv);
#-----------------------------------------------------------------------------------------------
# フィルター encode_csv="区切り文字" もしくは encode_csv="1" でカンマ
# 
# CSVのカラムに利用する区切り文字がカラムを出力したタグの内容に含まれる場合、ダブルクォートで囲い
# CSVのフォーマット崩れを防ぎます。また、ダブルクォートが利用されている場合は２重にしてエスケープ
# します。
# 
#------------------------------------------------------------------------------------------------
sub encode_csv {
  my ($text, $arg, $ctx) = @_;
  
  my $separator = ',';
  
  if ($arg =~ /\d+/){
      return $text unless $arg;  #指定なし
  }else{
      $separator = $arg;
  }
  return $ctx->error('Separated can not specify the double quotes.') if $separator =~ /\"/;
  return $ctx->error('Separated can not specify the line end.')      if $separator =~ /[\r\n]/;
  return $ctx->error('Separated can not specify the space.')         if $separator =~ /^\s+$/;

  my $s = quotemeta($separator);
  if( $text =~ m/[\"\r\n$s]/g ){
      $text =~ s/(\")/\"\"/g;
      $text = '"'.$text.'"';
  }
  return $text;
}
1;
__END__
##############################################################################################
# '07/12/10  1.00   新規公開
# 2008.06.04 1.10   区切り、改行を含む情報を設定するためダブルクォーテーションによる記述を有効にする
#                   さらに区切り文字を変更可能にする。
#                   CSV情報用に調整して出力するGlobalFilter[encode_csv]追加
# 2009.11.09 1.11   CSVの解析はText::CSV_PPに置き換える。
#
