package rssEntry::L10N::ja;

use strict;
use base 'rssEntry::L10N';
use vars qw( %Lexicon );

our %Lexicon = (
    # .pl
    'Retrieve the RSS and post them as entries' => 'RSS を取得し、それらを記事として投稿します。',
    '[_1]: [_2] entries was posted from [_3]' => '[_1]: [_3] から [_2] 個の記事が投稿されました',
    # config.tmpl
    'RSS List' => 'RSS リスト',
    'Post User' => '投稿ユーザ',
);

1;