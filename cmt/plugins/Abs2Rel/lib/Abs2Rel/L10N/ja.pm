package Abs2Rel::L10N::ja;

use strict;
use base 'Abs2Rel::L10N';
use vars qw( %Lexicon );

our %Lexicon = (
    'Omit the domain name and base path from its URL, and make it only relative path.' => 'ブログ記事・ウェブページを出力する際にstyleやaタグを相対パスに変換して出力します。',
    'Ignore Extensions' => 'パス変換を行わない拡張子',
    'Ignore Directories' => 'パス変換を行わないディレクトリ',
);

1;