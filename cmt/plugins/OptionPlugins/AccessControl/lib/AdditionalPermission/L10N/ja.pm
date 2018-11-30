# $Id$

package AdditionalPermission::L10N::ja;

use strict;
use base 'AdditionalPermission::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
'This plugin function is to add a new permission.' => '新しいアクセス許可(permission)をシステムに追加し、ロールで設定できるようにします。追加されたアクセス許可はプラグインで利用することで独自のアクセス制限を行うことが可能になります。',
'Extended Permission' => '拡張アクセス許可',
'Add extended permissions.' => '拡張アクセス許可の追加',

'Format is ( setting_key:display_name ).One line is one item.' => '１項目は「設定値:表示名」の書式で設定します。複数設定する場合は改行区切りで１行１項目として下さい。',
'SAMPLE' => '例',
'HIGH_LEVEL' => '上位レベル',
'LOW_LEVEL' => '下位レベル',

);

1;
