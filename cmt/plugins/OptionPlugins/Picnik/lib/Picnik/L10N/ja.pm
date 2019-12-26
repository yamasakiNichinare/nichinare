package Picnik::L10N::ja;

use strict;
use base 'Picnik::L10N';
use vars qw( %Lexicon );

our %Lexicon = (
    # .pl
    'Provides some functions to edit image assets with Picnik' => 'Picnik を利用して画像アイテムを編集するための幾つかの機能を提供します',
    'Edit with Picnik' => 'Picnik で編集',
    # _config.tmpl
    'Picnik API Key' => 'Picnik API キー',
    'For using Picnik services, you need an API key of Picnik API. Please regist your account beforehand.' => 'Picnik のサービスを利用するには API キーが必要です。事前にアカウント登録を行ってください。',
    # .pm
    'Internal Error in [_1]' => '内部エラー ([_1] 行目)',
    'Error in proceeding of Picnik - [_1]' => 'Picnik の処理中にエラーが発生しました - [_1]',
    'No content' => 'コンテントがありません',
    'Network Error' => '通信エラー',
);

1;