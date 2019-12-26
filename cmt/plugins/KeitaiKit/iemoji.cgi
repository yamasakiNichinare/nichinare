#!/usr/bin/perl -w

use strict;

# キャリア判別
$_ = $ENV{HTTP_USER_AGENT};
my $ext = 'gif';

# SoftBankのみ、pngファイルとする
$ext = 'png' if(/^SoftBank\/[^\/]+\/([^\/]+)/i || /^J\-PHONE\/[^\/]+\/([^\/]+)/i
                || /^Vodafone\/[^\/]+\/([^\/]+)/i || /^MOT\-([^\/]+)\/80.2F.2E.MIB/i);

# 絵文字パス
$_ = $ENV{QUERY_STRING};
my $path = (/^(.+?)&/i) ? "iemoji/$1.$ext" : "iemoji/$_.$ext";
my $header = "Content-Type: image/$ext";

# ファイルの存在チェック
exit 1 if(/^(i|ez|s)\/[a-z0-9]+$/i);
exit 1 unless(-e $path);

# ヘッダ
print "$header\n\n";

# 画像データの送信
open IMG, "<$path";
binmode IMG;
binmode STDOUT;
print while(<IMG>);
close IMG;
