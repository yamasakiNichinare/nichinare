# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package AForm::L10N::ja;

use strict;
use base qw( AForm::L10N::en_us );
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
# plugin setting
    'Alert Report Setting' => '動作確認レポート設定',

    'Report by access to some form Title' => 'フォームへのアクセスで起動する',
    'Report by access to some form Description' => 'どこかのフォームがアクセスされた時に前回の動作確認プログラムの起動から一定期間以上経過していた場合に、再び動作確認プログラムを起動するようにします。
これによってcron程確実ではありませんが、定期的にフォームの動作確認プログラムを起動させることができます。
cronが使えないサーバを利用している場合は必ずチェックして有効にしてください。
起動する間隔が未指定の場合は一日(24h)が指定されたものとして動作します。',
    'Report by access to some form' => 'フォームへのアクセスで起動',
    'Interval of check(ex: 30min, 24h, 3day)' => '起動する間隔(例：30min、24h、3day)',

    'Alert mail address Title' => '動作確認レポート送信先メールアドレス',
    'Alert mail address Description' => '動作確認レポートを受け取る受信可能なメールアドレスを必ず指定してください。',
    'Alert mail address' => '動作確認レポート送信先',

    'Alert confirm pv Title' => '確認画面アクセス数の閾値',
    'Alert confirm pv Description' => '指定した回数より小さな回数しか確認画面にアクセスがなかった場合に、フォームが正しく動いていない可能性があると判断して確認処理の動作確認レポートメールを送ります。未指定の場合は1を指定したものとして動作します。',
    'Alert confirm pv' => '確認画面アクセス数の閾値',

    'Alert Data count Title' => '受付データ保存数の閾値',
    'Alert Data count Description' => '指定した回数より小さな回数しか受付データが保存されていなかった場合に、フォームが正しく動いていない可能性があると判断して保存処理の動作確認レポートメールを送ります。未指定の場合は1を指定したものとして動作します。',
    'Alert Data count' => '受付データ保存数の閾値',

    'Script URL Setting' => 'スクリプトURLの設定',
    'Script URL Directory Title' => 'スクリプト類設置ディレクトリのURL',
    'Script URL Directory Description' => 'フォームのエンジンをデフォルトの設置場所から変更する場合に、変更先のディレクトリのURLを指定します。設置場所は同じサーバマシン上でCGIが使えるディレクトリである必要があります。',
    'Script URL Directory' => 'スクリプト類設置ディレクトリのURL',

    'SerialNumber Setting' => 'シリアルナンバーの設定',
    'SerialNumber: ' => 'シリアルナンバー: ',
    'Invalid SerialNumber' => 'シリアルナンバーは無効です',
    'SerialNumber Title for Business' => 'シリアルナンバー',
    'SerialNumber Description for Business' => 'A-Form購入時に発行されたシリアルナンバーを入力してください。<br />
未購入の場合は、A-Form購入フォームからご購入後に発行されるシリアルナンバーを入力してください。<br />
<a href="https://www.ark-web.jp/movabletype/a-form/price.html">A-Form購入フォームはこちらから。</a>',
    'SerialNumber Title for Personal' => 'シリアルナンバー',
    'SerialNumber Description for Personal' => '『Powered by A-Form for Movable Type』の表記を削除したい場合は、A-Formをご購入ください。<br />
A-Form購入時に発行されたシリアルナンバーを入力してください。<br />
<a href="https://www.ark-web.jp/movabletype/a-form/price.html">A-Form購入フォームはこちらから。</a>',

# common
    'List' => '一覧',
    'Previous' => '前',
    'Next' => '次',
    'Edit [_1]' => '[_1]の編集',

# list_aform
    'No A-Form could be found.' => 'フォームが作成されていません。',
    'Id' => 'フォームID',
    '_PLUGIN_DESCRIPTION' => 'A-Form機能をMTに追加するプラグインです。フォームの設置、管理、受付データのダウンロード、コンバージョン率の確認といった機能が利用可能になります。',
    '_PLUGIN_AUTHOR' => 'ARK-Web\'s MT Plugin Developers',
    'AForm' => 'A-Form',
    'AForms' => 'A-Form',
    'aform' => 'A-Form',
    'aforms' => 'A-Form',
    'aform_field' => 'A-Formフィールド',
    'Edit AForm' => 'A-Formの編集',
    'Unpublished' => '非公開',
    'Waiting' => '公開待ち',
    'Published' => '公開',
    'Closed' => '終了',
    'Create AForm' => '新しいフォームを作成する',
    'Session Count' => 'セッション数',
    'Page View' => 'PV',
    'Conversion Count' => 'コンバージョン数',
    'Conversion Rate' => 'コンバージョン率',
    'Preview' => '表示',
    'Manage A-Form' => 'フォームの一覧',
    'All A-Form' => 'すべてのフォーム',
    'Your form has been deleted from the database.' => 'フォームをデータベースから削除しました。 ',
    'Display' => '確認',
    'Show' => '表示する',
    'Are you sure you want to Delete the selected A-Form?' => 'チェックされているフォームを削除します。よろしいですか？\n【ご注意】フォームが保持している受付データも削除されます',
    'Please input Form Title.' => 'フォーム名を入力してください。',
    'Publish this form.' => '「公開」にする',
    'Unpublish this form.' => '「非公開」にする',
    'conversion rate description' => 'コンバージョン率 = 受付数/ページビュー',
    'preview this form' => 'フォームプレビューを見る',
    'how to build A-Form' => "作成したフォームを記事に埋め込むには、目的のブログ記事あるいは<br />ウェブページ内に[_1]（XXX部分はフォームIDの3桁の数字）と記入してください。<br />フォームを埋め込んだ後には必ずフォームの動作確認を行ってください。動作確認の手順は<a href='[_2]' target='_blank'>「マニュアル」</a>を参照してください。",

# edit_aform_field
    'Manual(Edit Form)' => 'マニュアル（フォーム編集）',

    'Edit Field' => 'フォーム編集',
    'Config Form' => '詳細設定',
    'Manage Data' => '受付データ管理',
    'List A-Form Input Error' => 'アクセスレポート',

    'AForm Field Types' => '基本パーツ',
    'AForm Field Type Label' => '見出し',
    'AForm Field Type Note' => 'コメント・注釈',
    'AForm Field Type Text' => 'テキスト',
    'AForm Field Type Textarea' => '複数行テキスト',
    'AForm Field Type Select' => 'ドロップダウンリスト',
    'AForm Field Type Checkbox' => 'チェックボックス',
    'AForm Field Type Radio' => 'ラジオボタン',

    'AForm Field Extra Types' => '定番パーツ',
    'AForm Field Extra Type Email' => 'メールアドレス',
    'AForm Field Extra Type Telephone' => '電話番号',
    'AForm Field Extra Type URL' => 'URL',
    'AForm Field Extra Type ZipCode' => '郵便番号',
    'AForm Field Extra Type Prefecture' => '都道府県',
    'AForm Field Extra Type Privacy' => '個人情報保護方針',

    'tip_email' => 'メールアドレス形式かチェックします',
    'tip_tel' => '数字とハイフンのみ受け付けます',
    'tip_url' => 'URL形式かチェックします',
    'tip_zipcode' => '3桁+4桁の数字とハイフンのみ受け付けます',
    'tip_prefecture' => '都道府県をプルダウンから選べます',
    'tip_privacy' => '方針への同意チェックと方針ページへのリンクが設置できます',

    'Undefined' => '未定義',
    'necessary' => '必須入力',
    'not necessary' => '任意入力',
    'necessary description' => "クリックすると［必須入力］［任意入力］を切り替えられます。<br>［必須入力］にすると、未入力の場合エラーが出るようになります。",
    'edit label' => '項目名編集',
    'copy' => '複製',
    'delete' => '削除',
    'up' => '上へ',
    'down' => '下へ',
    'input example is not displayed' => '入力例を表示しない',
    'edit input example' => '入力例を編集',
    'Example:' => '入力例:',
    'edit max length' => '文字数制限を編集',
    'Max Length:' => '文字数制限:',
    'undefined max length' => '制限しない',
    'reset default checked' => 'チェック済を解除する',
    'add value' => '選択肢追加',
    'delete default' => '「選択してください」を削除',
    'use default' => '「選択してください」を追加',
    'edit' => '編集',
    'delete' => '削除',
    'Value' => '値',
    'Email' => 'メールアドレス',
    'Tel' => '電話番号',
    'URL' => 'URL',
    'ZipCode' => '郵便番号',
    'Prefecture' => '都道府県',
    'Privacy' => '個人情報保護方針',
    'privacy_link' => '個人情報保護ページのURL',
    'privacy policy warning' => '個人情報保護方針の同意チェックをデフォルトでOnにすることは推奨されません',
    'Edit Privacy Link' => 'リンクを設定',
    'Agree' => '同意する',
    'please select' => '選択してください',
    'check status is reflected in default check status of form.' => 'ここでチェックを入れると、実際のフォームも標準でチェックされた状態になります',
    'Your changes has not saved! Are you ok?' => '保存されていない変更は失われます。',
    'alert disable tab' => 'フォームが未定義です。フォーム編集、受付データ管理、アクセスレポートはまだ使えません。フォーム名を入力して「保存」してください。',
    'Please enter Title.' => 'フォーム名を入力してください',
    'At least one option is required.' => '少なくとも一つのオプションは必要です',
    'Please rebuild blog which has some AForm.' => 'この変更をページに反映させるにはブログを再構築してください。',
    'description when there is no field' => '右メニューのパーツをクリックするか、またはドラッグ＆ドロップでここにもってきてください。選択したパーツがフォームに追加されます。パーツの表示順はドラッグ＆ドロップか、ブロック内の上下キーで後から変更できます。',
    'is replyed to customer' => 'このアドレスにも控えメールを送る',
    'Status is published. Cannot edit fields.' => '受付データの安全のためフォームの公開状態を「非公開」にしないとフォーム編集での編集内容を保存できません。',
    'Publish this A-Form.' => '公開状態を「公開」にする。',
    'Unpublish this A-Form.' => '公開状態を「非公開」にする。',
    'Currently, Form Status is Published.' => '現在、公開状態は「公開」です。',
    'Currently, Form Status is Unpublished.' => '現在、公開状態は「非公開」です。',
    'Status was changed Published.' => '公開状態を「公開」に変更しました。',
    'Status was changed Unpublished.' => '公開状態を「非公開」に変更しました。',
    'Currently, This form status is Unpublished.' => '現在フォームの公開状態が「非公開」になっています。',
    'Form data exists. Please download and clear data first.' => '取得済みの受付データが存在します。フィールドを編集する前に、まず「受付データ管理」タブに移ってデータのバックアップを行い、一旦データクリアしてください。',
    'You have successfully deleted the Form data(s).' => '受付データを削除しました',
    'Invalid max length.' => '文字数制限には半角数字のみ入力可能です。',

# edit_aform
    'Title Setting' => 'フォーム名の指定',
    'Title' => 'フォーム名',
    'Thanks page Setting' => '送信完了時の動作',
    'Enter URL or Select Web Page.' => '送信完了時の動作を指定します。',
    'ThanksURL' => 'URLで指定',
    'Select Page' => 'ウェブページの一覧から指定',
    'Form Status' => 'フォームの状態',
    'Enable' => '公開',
    'Disable' => '非公開',
    'Form Schedule' => 'フォームの公開状態',
    'Schedule Start Date' => '開始日',
    'Schedule End Date' => '終了日',
    'Mail To' => 'To:',
    'Mail From' => 'From:',
    'Mail CC' => 'CC:',
    'Mail BCC' => 'BCC:',
    'Replyed to Customer' => 'ユーザにも控えメールを送る',
    'New A-Form' => '新しいフォーム',
    'label_thanks_url_default' => '確認画面に完了メッセージを表示',
    'label_thanks_url_select' => 'ウェブページにジャンプ',
    'label_thanks_url' => 'URLで指定したページにジャンプ',
    'Schedule Setting' => 'フォームの公開状態',
    'description schedule setting' => 'フォームの状態を「公開」にすると、埋め込んだ記事内に表示されます。<br />
公開予約で時限公開することも可能です（※次バージョンで対応）。<br />
フォームの状態が「非公開」なら、公開予約の設定に関わらず常に非表示になります。',
    'Mail Setting' => '控えメールの管理',
    'Mail Subject' => 'メールタイトル',
    'Mail Header' => '	メールの冒頭文',
    'Mail Footer' => '	メール末尾の署名',
    'Mail Header Description' => '１行あたり全角60文字までを推奨',
    'Mail Footer Description' => '１行あたり全角60文字までを推奨',
    'Title Setting Description' => 'フォームにわかりやすい名前をつけます。<br />ここで指定したフォーム名は、生成されるフォームの先頭に見出しとして表示されます。<br />フォームを埋め込んだページのTITLEタグの値には影響を与えません。',
    'Mail Setting Description' => '受付内容を指定した宛先にメール送信します。',
    'View Sample' => '→管理者宛メールのサンプル',
    'Your changes have been saved. Please confirm Mail To is Valid Email Address.' => '変更を保存しました。宛先(メールアドレス)に指定したメールアドレスが受信可能なメールアドレスであることを確認してください。',
    'Your changes have been saved. Mail To is null. We strongly recommend to set Mail To.' => '変更を保存しました。宛先(メールアドレス)が指定されていません。万一の事態に備えるためにも受信可能なメールアドレスを指定されることを強く推奨します。',
    'Data No. Setting' => '受付番号の設定',
    'Data No. Setting Description' => '受付番号は、フォームが完了処理まで実行される毎にカウントアップする番号です。<br/><br/>受付番号は変数__%aform-data-id%__で取り出せます。<br/>変数を書きこめるのはメールタイトル、メールの冒頭文、メールの末尾の署名です。<br/>たとえば、「【No. __%aform-data-id%__】お問い合わせ」とメールタイトルに指定すれば、<br/>受付番号がXの場合、「【No. X】お問い合わせ」という題名のメールが送られます。<br/><br/>また、受付番号にはオフセット値を指定することができます。オフセット値を指定すると、<br/>通常1からスタートする受付番号が指定したオフセット値+1からのスタートになります。<br/><br/>「受付番号のカウントアップをクリア」にチェックを入れて保存すると、受付データの<br/>カウントアップがクリアされて、再度1からのカウントアップになります。<br/><br/>',
    'Data No. offset' => 'オフセット値',
    'Reset Data No.' => '受付番号のカウントアップをクリア',
    'mail to description' => '※ Fromの指定は,を含まず、aaa@example.comと指定してください。<br />To, Cc, Bccには複数の宛先を指定できます。aaa@example.com, bbb@example.comとカンマ区切りで指定してください。',
    'Input check Setting' => '入力チェックの設定',
    'Input check Setting Description' => '',
    'Input check' => '入力チェック',
    'Check Immediately.' => '即時にチェック（入力フィールドからフォーカスが外れた時点で入力チェックが行われます）',
    'Check only when Confirm button is pushed.' => '確認ボタン押下時のみチェック（確認ボタンが押された時のみ入力チェックが行なわれます）',


# manage_aform_data
    'Manage [_1] Data' => '[_1]の受付データ管理',
    'Manage AForm Data' => '受付データの管理',
    'Backup this AForm Data(CSV Download)' => '受付データのダウンロード(CSVファイル)',
    'Clear this AForm Data' => '受付データのクリア',
    'No data in this form.' => 'このフォームに受付データはありません。',
    'Manage AForm Description.' => '受付データをダウンロードしたり、クリアしたりできます。',
    'Clear Data Confirm' => '受付データをクリアします。よろしいですか？',
    'Received Datetime' => '受付日時',
    'Received Data ID' => '受付番号',

# prefecture list
    'PrefectureList' => "'北海道','青森県','岩手県','宮城県','秋田県','山形県','福島県','茨城県','栃木県','群馬県','埼玉県','千葉県','東京都','神奈川県','新潟県','富山県','石川県','福井県','山梨県','長野県','岐阜県','静岡県','愛知県','三重県','滋賀県','京都府','大阪府','兵庫県','奈良県','和歌山県','鳥取県','島根県','岡山県','広島県','山口県','徳島県','香川県','愛媛県','高知県','福岡県','佐賀県','長崎県','熊本県','大分県','宮崎県','鹿児島県','沖縄県'",

# list input error
    'No Input Errors.' => '入力エラーはありません。',
    '[_1] List Input Error' => '[_1]のアクセスレポート',
    'aform_input_errors' => 'アクセスレポート',
    'Error Datetime' => 'エラー発生日時',
    'Error Field' => 'エラーを生じた項目名',
    'Error Type' => 'エラータイプ',
    'Error Value' => 'エラーになった入力値',
    'Error Page' => 'エラー発生ページ',
    'email_format_error' => 'メールアドレスフォーマットエラー',
    'zipcode_format_error' => '郵便番号フォーマットエラー',
    'tel_format_error' => '電話番号フォーマットエラー',
    'url_format_error' => 'URLフォーマットエラー',
    'max_length_error' => '文字数オーバー',
    'not_selected' => '未選択',
    'empty' => '未入力',
    'privacy_error' => '個人情報保護方針非同意',
    'Access Info Summary' => '稼働状況サマリー',
    'Access Info Summary Description' => 'このフォームの閲覧数やコンバージョン率がわかります。',
    'Input Error Log' => '入力エラーログ',
    'Input Error Log Description' => 'フォームの入力エラーログです。ユーザの離脱要因を分析して、フォーム入力項目の最適化とコンバージョン率アップに役立てましょう。',
    'PV' => 'ページビュー',
    'Conversion Rate Help' => '<ul class="notice">
<li>※セッション数とページビューの違い：<br />
ページビューはユーザが何回このフォームを閲覧したかを表す数です。<br />
一方、セッション数は、ユーザが30分以内に何回このフォームを閲覧しても1回と見なします。</li>
<li>※コンバージョン数：簡単に言うと受付数のことです。フォーム完了まで到達した数をカウントします。</li>
<li>※コンバージョン率 ＝ コンバージョン／ページビュー</li>
    </ul>',

    '### form closed ###' => '受付を終了しました',
    'Copied ' => 'コピー',
    'Are you sure you want to Copy the selected A-Form?' => 'チェックされているフォームを複製します。よろしいですか？',
    'Copy selected [_1] (c)' => '選択された[_1]を複製 (c)',
    'Your form has been copied.' => 'フォームを複製しました。',

    'html_head' => 'HTMLヘッダー',
    'banner_header' => 'バナーヘッダー',
    'banner_footer' => 'バナーフッター',

#engine
    'Invalid request' => '不正な要求です',
    'Acceptance end' => '受付を終了しました',
    'Double submit warning. Please try again for a while.' => '連続投稿は禁止されています。しばらく後に再度お試しください。',
    'The data was sent. <a href="[_1]">Back to top page</a>' => '送信完了しました。<a href="[_1]">トップページに戻る</a>',

#validation
    'Please agree to [_1]. Please check if you agree. (It is not possible to send if you do not agree.)' => '[_1]に同意してください。規約にご同意いただける場合チェックを入れてください（ご同意いただけない場合は送信できません）',
    '[_1] is not input.' => '[_1]が入力されていません',
    '[_1] format is invalid. ex) foo@example.com (ascii character only)' => '[_1]のフォーマットが不正です。例）foo@example.com （英数記号のみ）',
    '[_1] format is invalid. ex) 03-1234-5678 (numbers and "-" only)' => '[_1]のフォーマットが不正です。例）03-1234-5678　（数字とハイフンのみ）',
    '[_1] format is invalid. ex) http://www.example.com/ (ascii character only)' => '[_1]のフォーマットが不正です。例）http://www.example.com/ （英数記号のみ）',
    '[_1] format is invalid. ex) 123-4567 (numbers and "-" only)' => '[_1]のフォーマットが不正です。例）123-4567　（数字とハイフンのみ）',
    'Please enter [_1] of [_2] characters.' => '[_1]は[_2]文字以内で入力してください。',

#warning
    '[Important] A-Form The save was failed.' => '【重要】A-Form 保存処理が失敗した可能性があります ',
    '[Important] A-Form Confirmation report' => '【重要】A-Form 確認処理 動作確認レポート',
    '[Important] A-Form Complete report' => '【重要】A-Form 保存処理 動作確認レポート',
);
1;
