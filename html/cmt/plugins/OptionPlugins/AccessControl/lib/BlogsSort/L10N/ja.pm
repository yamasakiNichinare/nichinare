package BlogsSort::L10N::ja;

use strict;
use base 'BlogsSort::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'Enable you to arrange the listing order of blogs.' => 'ブログの並び順を変更することができます。',
    'blog sort Management' => 'ブログの並べ替え', 
    'sort_no' => 'レベル', 
    'save blog sort_no.' => 'ブログの並び順を保存しました。', 
    'name' => 'ブログ名',
    'class' => 'クラス名',
    'Configuration of the blogs listing order. Please fill the numbers of listing order. The blog filled by smaller number will be arraged previous to the others.'
        => 'ブログの並び順を設定します。並び順を数値で埋めてください。小さな番号が指定されたブログが他のものより上位に表示されます。',
    'Website ([_1]) blogs are not registered.' => 'ウェブサイト([_1])にはブログが登録されていません。',
    'Sort No Reset Error. (Website)ID:[_1]' => 'ウェブサイトの番号を0に設定できませんでした。[_1]', 
);

1;