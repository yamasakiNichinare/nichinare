# $Id$

package MailPack::L10N::ja;

BEGIN{ require utf8 if MT->version_number=~/^5/; }

use strict;
use base 'MailPack::L10N';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

    'MailPack Configure' => 'メール投稿設定',
    'BlogEntries Posted From Intarnet Mail.' => 'メールにて記事の投稿を行うためのプラグインです。メール投稿時の動作と通知について設定を行ってください。',
    'MailPack Check to Posted Mails' => 'MailPack：投稿メールチェック',
    'description of MailPack' => 'MailPackの説明',
    'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'mode属性が不正です。loopまたはcontextを指定してください。',
    'MailPack: Blog:[_1] mail entry error'                          => 'MailPack：ブログ「[_1]」へのメール投稿失敗',
    'MailPack: POP server connect error: [_1]'                      => 'MailPack：POPサーバーへの接続に失敗しました ([_1])',
    'MailPack: POP server attestation error: [_1]'                  => 'MailPack：POP3サーバーへの認証に失敗しました ([_1])',
    'MailPack: [_1] mail reception and delete ([_2] mails).'        => 'MailPack：([_1])のメール([_2]件)を受信してメールボックスから削除しました。',
    'MailPack: The mail not accepted was deleted ([_1] mails).'     => 'MailPack：許可されていない形式のメール([_1]件)を削除しました',
    'MailPack: USER:[_1](ID:[_2]) no contribution authority.'       => 'MailPack：ユーザー「[_1]」(ID：[_2])に投稿権限がありません',
    'MailPack: FromMail:[_1] not find user.'                        => 'MailPack：送信アドレス([_1])のユーザーが見つかりません。',
    'MailPack: Entry:[_1] (ID：[_2]) failed in restructuring .'     => 'MailPack：エントリー「[_1]」(ID：[_2])の再構築に失敗しました。',
    'MailPack: Failed to rebuild the entry:[_1] (ID: [_2]).'        => 'MailPack：エントリー「[_1]」(ID：[_2])の再構築に失敗しました。',
    'MailPack: Blog:[_1] (ID：[_2]) failed in restructuring .'      => 'MailPack：ブログ「[_1]」(ID：[_2])の再構築に失敗しました。',
    'MailPack: Entry:[_1] (ID：[_2]) is category save error . category(ID:[_3])' => 'MailPack：エントリー「[_1]」(ID：[_2])のカテゴリー(ID：[_3])の登録に失敗しました。',
    'MailPack: Entry:[_1] (ID：[_2]) upload dir ([_3]) make error.'    => 'MailPack：エントリー「[_1]」(ID：[_2])のアップロードフォルダ([_3])の作成に失敗しました。',
    'MailPack: Entry:[_1] (ID：[_2]) upload file ([_3]) upload error.' => 'MailPack：エントリー「[_1]」(ID：[_2])のアップロード(File：[_3])に失敗しました。',
    'MailPack: Entry:[_1] (ID：[_2]) upload file ([_3]) AttachFile save.' => 'MailPack：エントリー「[_1]」(ID：[_2])の添付ファイル(File：[_3])をAttachFileへの登録しました。',
    'MailPack: Entry:[_1] (ID：[_2]) upload file ([_3]) AttachFile save error.' => 'MailPack：エントリー「[_1]」(ID：[_2])の添付ファイル(File：[_3])をAttachFileへの登録に失敗しました。',
    'MailPack: Entry:[_1] (ID：[_2]) upload file ([_3]) file size error.' => 'MailPack：エントリー「[_1]」(ID：[_2])の添付ファイル(File：[_3])がサイズ制限を超えた為、登録出来ませんでした。',
    'MailPack: Entry:[_2] (ID：[_3]) save. for User:[_1] .' => 'MailPack：ユーザー：[_1]がエントリー「[_2]」(ID：[_3])を投稿しました。',
    'MailPack: Entry:[_1] save error.' => 'MailPack：エントリー「[_1]」の投稿に失敗しました。',
    'MailPack: Entry:[_1] send notification mail. count:([_2])' => 'MailPack：エントリー「[_1]」を通知メールで送信しました。([_2]件)',
    'MailPack: Entry:[_1] send notification mail. to:([_2])' => 'MailPack：エントリー「[_1]」を([_2])に通知メールで送信しました。',
    'MailPack: Entry:[_1] send error notification mail. to:([_2])' => 'MailPack：エントリー「[_1]」で([_2])への通知メールの送信に失敗しました。',
    'MailPack: The email address ([_1]) is not found. from to,cc' => 'MailPack：メールアドレス「[_1]」がTOとCCから見つかりません。',
    'MailPack: Setting Data(ID:[_1]) Add' => 'MailPack管理画面: メール投稿設定データ(ID:[_1]) を追加しました。',
    'MailPack: Setting Data(ID:[_1]) Update' => 'MailPack管理画面: メール投稿設定データ(ID:[_1]) を更新しました。',
    'MailPack: Setting Data(ID:[_1]) Delete' => 'MailPack管理画面: メール投稿設定データ(ID:[_1]) を削除しました。',
    'MailPack: Setting add error. same email address save' => 'MailPack管理画面: データの追加に失敗しました。既に登録されているメールアドレスです。',
    'error. same email address save' => 'エラー。既に登録されているメールアドレスです。',
    'Entry Email Settings' => 'メール投稿設定',
    'Email Address Settings' => '設定済みメールアドレス',
    'Add Email Address Settings' => 'アドレス設定追加',
    'Entry Email Address' => '投稿先メールアドレス',
    'POP3 Server Name' => 'POP3サーバー',
    'POP3 Server User' => 'ユーザ名',
    'POP3 Server Password' => 'パスワード',
    'MailPack Sets' => 'メール投稿設定',
    'thumbnail of [_1]' => '[_1]のサムネイル',
    'add entry email address settings' => '投稿先メールアドレスを追加する',
    'MailPack Template' => 'メールパックテンプレート',
    'POP over SSL need Mail::POP3Client' => 'POP over SSLを利用するには「Mail::POP3Client」モジュールが必要です。',
    'POP over SSL need IO::Socket::SSL' => 'POP over SSLを利用するには「IO::Socket::SSL」モジュールが必要です。',
    'MailPack: POP over SSL need Mail::POP3Client [_1]' => 'MailPack: POP over SSLを利用するには「Mail::POP3Client」モジュールが必要です。([_1])',
    'MailPack: POP over SSL need IO::Socket::SSL [_1]' => 'MailPack: POP over SSLを利用するには「IO::Socket::SSL」モジュールが必要です。([_1])',

## notification.tmpl
    'Mail threading control' => 'メールのスレッド制御',
    'Always a mail makes an entry' => 'メールを常に新しい記事として登録する',
    'Replied mail makes threaded comments for the original entry' => '返信されたメールを元の記事のツリー状のコメントとして登録する',
    'Replied mail makes a plain comment for the original entry' => '返信されたメールを元の記事の通常のコメントとして登録する',

    'notifies of input entry with mail' => 'メールが記事として登録されたことをメールで通知する',
    'notification email send to system administrator' => 'ブログに所属していないシステム管理者ユーザーにも通知をする',

    'notifies' => '通知する',
    "doesn't notify" => '通知しない',
    'prefix of email subject' => '通知メールの件名に付加する文言設定',

    'thumbnail max width' => '添付画像のサムネイル幅設定',
    'file insert point' => '添付ファイルの記事挿入位置',

    'Ahead of the entry text' => '記事本文の前に挿入',
    'After the entry text' => '記事本文の後に挿入',

    'post status default' => '登録ユーザーからのメール投稿時の公開設定',
    'amanuensis author post status default' => '非登録ユーザー(代理の投稿者)からのメール投稿時の公開設定',
    'Default Blog' => 'ブログの設定に従う',

    '*Notification will be similar to such a notification.' => '※通知先はコメントなどと同様の通知先となります。',
    'ex) MailPack: Posted a new article.' => '例) MailPack：新しい記事が投稿されました。',
    '*Sets the width of the thumbnail image file attached to e-mail.' => '※メールに添付された画像ファイルのサムネイルの幅を設定します。',

## mailpack_list.tmpl
    'Please Select Blog and Set Entry Email' => '投稿したいブログを選択し、送信先のメールアドレスを設定してください。',
    'delete email. not select' => '削除するメール投稿設定が選択されていません。',
    'delete email address ?' => 'メール投稿設定を削除してよろしいですか？',
    'Add Entry Email Setting' => '送信先メールアドレスの追加',
    'Entry Email Settings List' => '設定されたメールアドレス一覧',
    'delete email setting' => 'メール投稿設定を削除する',
    'Delete' => '削除',
    'Entry Email' => '送信先メールアドレス',
    'Entry Blog' => '投稿先ブログ',
    'Entry Category' => 'カテゴリ',
    'Entry Create_on' => '登録日',
    'Entry AuthorName' => '登録者',
    'Back To PluginPage' => 'プラグインページへ戻る',
    'edit data not find' => '編集データが見つかりません。データを確認してください。',

## mailpack_edit.tmpl
    'blog is not select' => 'ブログが選択されていません。',
    'email address is not input' => 'メールアドレスが入力されていません。',
    'email address is error' => 'メールアドレスの書式ではありません。',
    'pop3 server name is not input' => 'POP3サーバー名が入力されていません。',
    'pop3 server name input error' => 'POP3サーバー名は規定の文字以外は使用不可です。',
    'pop3 server user is not input' => 'ユーザー名が入力されていません。',
    'pop3 server password is not input' => 'パスワードが入力されていません。',
    'entry blog setting' => '投稿するブログの設定',
    'please select entry blog' => '投稿先のブログを選択して下さい。',
    'please select entry category' => '投稿記事に設定するカテゴリを選択して下さい。',
    'category not entry' => 'カテゴリー未登録',
    'mail server setting' => 'メールサーバー設定',

    'please input email address.(To)' => '送信先のメールアドレス(To)を入力して下さい。',
    '*If you are mailing a post which must have been registered in the mailing list email inbox.' 
       => '※送信先をメーリングリストとする場合は、受信ボックスのメールアドレスがメーリングリストに登録されている必要があります。',

    'please input pop3 server name.' => 'POP3サーバー名を入力して下さい 。',
    'please input pop3 server port.' => 'POP3サーバーのポート番号を入力してください。',
    'please check. when the pop3 server used ssl.' => 'POP3サーバーがSSLを使用している場合、チェックしてください。',

    'Inbox : please input pop3 server user name.' => '受信ボックス：POP3サーバーアカウントのユーザ名を入力して下さい。',
    'Inbox : please input password.' => '受信ボックス：POP3サーバーアカウントのパスワードを入力して下さい。',

    'Please select an author and how the sender.' => 'メール送信者と記事投稿者の設定を選択してください。',

    'If the sender to register user MT user\'s (email) Please specify a sender\'s email address.' 
      => 'メール送信者をMTに登録する場合はユーザーの「電子メール」に送信者のメールアドレスを設定してください。',

    'From the sender and the MT was registered as a user, the sender ignores unregistered'
     => 'メール送信者がMTのユーザとして登録されている場合のみ記事の登録を行う',
    'From the sender and the MT was registered as a user, the sender of an unregistered amanuensis author'
     => 'メール送信者がMTのユーザとして登録されていない場合でも、代理の投稿者で記事の登録を行う',
    'The all sender is amanuensis author' 
     => 'メール送信者をチェックせずに全て代理の投稿者で投稿する',

    'Please select amanuensis author.' => '代理の投稿者を選択してください。',

    'To do this, given site ([_1]) Please add a user who has rights to more than one author.' 
      => 'この設定を行うには、指定のサイト([_1])に1人以上の投稿者権限を持つユーザを追加してください。',

    'example' => '例',
    'Setting' => '設定',

    'Not set' => '未設定',

    'cancel setting' => '設定をやめる',
    'email address repetition' => 'メールアドレスが重複しています。',
    'email server no attestation. please setting again' => 'メールサーバーに認証できませんでした。設定を見直し、再度設定を行って下さい。',
    'email user repetition. please setting again' => 'メールアカウントが重複しています。設定を見直し、再度設定を行って下さい。',

    '*From the blogs in addition to setting selected on the screen ([_1]) Please also [_2]plug-in</a> settings.'
       => '※画面上の設定の他に、選択した投稿先ブログ「[_1]」の[_2]プラグイン</a>設定も行ってください。',

   'Note: This feature is not spam filtering capabilities.' 
       => '注意：この機能にはスパムメールをフィルタリングする機能はありません。',
   'Make posted an email from the sender is no guarantee of security is dangerous.' 
       => 'セキュリティ的に保障が無い送信者からのメールを投稿させることは危険です。',
   'May be stored on the server from malicious programs and scripts as attachments.' 
       => '添付ファイルなどから不正なプログラムやスクリプトなどがサーバーに保存される可能性があります。',
   'That is implemented on the mail server and spam filter, they are also a security guarantee enough, please make sure that incoming mail is not saved in the incorrect box.' 
       => 'メールサーバー側にスパムフィルター等が実装されているか、またセキュリティ面が十分に保障されていて、不正なメールが受信ボックスに保存されない事を確認してください。',
   'Damage by e-mail that was posted in the hope for this feature at your own risk.' 
       => 'この機能で投稿されたメールによって何らかの被害が発生した場合は自己責任において対応をお願いします。 ',

);

1;