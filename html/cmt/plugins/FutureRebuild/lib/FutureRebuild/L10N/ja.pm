package FutureRebuild::L10N::ja;

use strict;
use base 'FutureRebuild::L10N';
use vars qw( %Lexicon );

our %Lexicon = (
    'Enable you the scheduled rebuilding of entries and webpages.' => 'エントリやウェブページの指定日に再構築します',
    '<br />- [_1]/[_2]/[_3]' => '<br />- [_1]年[_2]月[_3]日',
    '<br />(Stay Published)' => '<br />(継続公開)',
    'Future Rebuild' => '指定日再構築',
    'Rebuild only' => '再構築のみ',
    'Rebuild on' => '再構築日',
    'Not in use' => '使用しない',
    'Scheduled unpublish' => '指定日非公開',
);

1;