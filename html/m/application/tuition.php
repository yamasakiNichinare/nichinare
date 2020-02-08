<?php
  // UA
  $UA_ACCOUNT = "MO-26631444-2";
$UA_PIXEL = "/ua.php";

  function googleAnalyticsImageUrl() {
    global $UA_ACCOUNT, $UA_PIXEL;
    $url = "";
    $url .= $UA_PIXEL . "?";
    $url .= "utmac=" . $UA_ACCOUNT;
    $url .= "&utmn=" . rand(0, 0x7fffffff);

    $referer = $_SERVER["HTTP_REFERER"];
    $query = $_SERVER["QUERY_STRING"];
    $path = $_SERVER["REQUEST_URI"];

    if (empty($referer)) {
      $referer = "-";
    }
    $url .= "&utmr=" . urlencode($referer);

    if (!empty($path)) {
      $url .= "&utmp=" . urlencode($path);
    }

    $url .= "&guid=ON";

    return $url;
  }
?>
<?php
$mtkk_use_session = true;
$mtkk_jpeg_quality = '75';
$mtkk_graphic_debug_mode = false;
$mtkk_ivga = false;
$mtkk_php_graphic_url = '';
$mtkk_crawler_keywords = '';
$mtkk_doctype = true;
$mtkk_basic_auths = '';
$mtkk_xml_declaration = true;
$mtkk_image_convert_error = 'show';
$mtkk_paginated = false;
$mtkk_selector = 'mtkk_page';
$mtkk_image_script = 'https://nichinare.com/m/mtkkimage.php';
$mtkk_ixhtml = true;
$mtkk_download_adapter = 'php';
$mtkk_multi_servers = false;
$mtkk_emoji_size = '12';
$mtkk_layerer = 'mtkk_layer';
$mtkk_identify = '';
$mtkk_document_root = '';
$mtkk_plugin_dir = '/usr/home/z304150/html/cmt/plugins/KeitaiKit';
$mtkk_http_host_var = 'HTTP_HOST';
$mtkk_cache_expires = '1209600';
$mtkk_pc_redirect = '';
$mtkk_emoji_alt = 'img';
$mtkk_image_iconize_height = '0';
$mtkk_image_iconize_width = '0';
$mtkk_footer_bytes = '';
$mtkk_download_proxy = '';
$mtkk_disable_ua_camouflage = false;
$mtkk_convert = '';
$mtkk_php_encoding = 'UTF-8';
$mtkk_version = '1.62';
$mtkk_no_cache = '';
$mtkk_start_session = false;
$mtkk_php_graphic = 'gd';
$mtkk_content_type = 'application/xhtml+xml';
$mtkk_temp_dir = '/usr/home/z304150/html/cmt/plugins/KeitaiKit/tmp';
$mtkk_iemoji_dir = '/usr/home/z304150/html/cmt/plugins/KeitaiKit/iemoji';
$mtkk_cache_cleaning_prob = '0';
$mtkk_session_param = 'code';
$mtkk_default_doctype = '';
$mtkk_session_external_urls = array('https://nichinare.com/m/', 'https://nichinare.com/');

require_once('/usr/home/z304150/html/cmt/plugins/KeitaiKit/php/KeitaiKit.php');
?><html>
<head>
<title>声優･ﾅﾚｰﾀｰなら 日本ﾅﾚｰｼｮﾝ演技研究所</title>
<meta name="description" content="" />
<meta name="keywords" content="声優,養成所,学校,ｽｸｰﾙ,日ﾅﾚ" />
<style type="text/css">
<![CDATA[
a:link{color:#005cb8;}
a:visited{color:#ad00b8;}
a:focus{color:;}
]]></style>
</head>

<body style="background:#ffffff;color:#444444;">
<a name="pagetop" id="pagetop"></a>
<div style="font-size:x-small;">
<div style="text-align:center; margin-bottom:10px;"><?php mtkk_image_tag(array('url' => 'https://nichinare.com/m/common/hd-tit.jpg', 'w' => '240', 'h' => '47', 'display' => 'browser', 'attr' => array('alt' => '声優･ﾅﾚｰﾀｰをめざすなら 日本ﾅﾚｰｼｮﾝ演技研究所', 'height' => '47', 'src' => 'https://nichinare.com/m/common/hd-tit.jpg', 'width' => '240'))); ?><br /><?php mtkk_image_tag(array('url' => 'https://nichinare.com/m/common/hd-main.jpg', 'w' => '240', 'h' => '79', 'display' => 'browser', 'attr' => array('alt' => '働きながら､学びながら週1回の3時間ﾚｯｽﾝ!', 'height' => '79', 'src' => 'https://nichinare.com/m/common/hd-main.jpg', 'width' => '240'))); ?><br /><?php mtkk_image_tag(array('url' => 'https://nichinare.com/m/common/hd-txt.gif', 'w' => '240', 'h' => '47', 'display' => 'browser', 'attr' => array('alt' => '代々木校･池袋校･お茶の水校･立川校･町田校･大宮校･千葉校･柏校･横浜校･仙台校･名古屋校･京都校･大阪校･難波校･天王寺校･神戸校', 'height' => '47', 'src' => 'https://nichinare.com/m/common/hd-txt.gif', 'width' => '240'))); ?></div>
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/application/img/application_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/application/img/application_tit.jpg'))); ?></div>

<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="width: 10px; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span></td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<strong>入所金･受講料等一覧</strong></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0">
		<tbody>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#01">週1回ｸﾗｽ</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#06">週2回ｸﾗｽ</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#02">週3回ｸﾗｽ</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#04">ﾅﾚｰﾀｰｾﾐﾅｰ</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#05">ｼﾞｭﾆｱ声優ｸﾗｽ</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#03">ｽﾀｰﾄｱｯﾌﾟｸﾗｽ</a></td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	<a id="01" name="01"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<strong><span style="color: #98d1a9">■</span>週1回ｸﾗｽ</strong><br />
						【開設校】<br />
						･代々木校<br />
						･池袋校<br />
						･お茶の水校<br />
						･立川校<br />
						･町田校<br />
						･大宮校<br />
						･千葉校<br />
						･柏校<br />
						･横浜校<br />
						･仙台校<br />
						･名古屋校<br />
						･京都校<br />
						･大阪校<br />
						･難波校<br />
						･天王寺校<br />
						･神戸校<br />
						･所沢校（2020年4月開校予定）<br />
						【受講対象年齢】<br />
						･中学卒業以上､<br />
						･40歳まで<br />
						【ﾚｯｽﾝ回数･時間】<br />
						･週1回･3時間<br />
						【初年度入所金】<br />
						･10万円<br />
						[仙台校は5万円となります(＊1.＊2)]<br />
						[高校生は5万円となります&lt;平成30年4月改定&gt;(＊3.＊4)]<br />
						【4月生･年間受講料】<br />
						･20万円（4月から翌年3月までの受講料となります）<br />
						<br />
						※上記金額には消費税が含まれています｡<br />
						※年間受講料のみ分割納入可能｡<br />
						※2年目以降は年間受講料20万円のみのお支払いとなります｡<br />
						※弊所を一度退所し､令和2年度より再度入所される方につきましては､入所後の所定の手続きにより､再入所時の入所金の半額を返金（または受講料に充当）させていただきます｡<br />
						＊1. ご要望の日時にｸﾗｽが開設されない場合がありますので､ご確認のうえお申し込みください｡<br />
						＊2. ﾚｯｽﾝ初日開始後に､他のﾚｯｽﾝ校から仙台校へ転校されても､入所金差額分は減額にはなりませんのでご注意ください｡<br />
						＊3. ﾚｯｽﾝ開始時点で､学校教育法に定められた全日制･定時制･通信制のいずれかの高等学校に在学されている方（または弊所がそれに相当すると認めた方）とさせていただきます｡<br />
						＊4. ｸﾗｽ確定後に所定の書類をご提出いただくこととなります｡</p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	<a id="06" name="06"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong><span style="color: #98d1a9">■</span>週2回ｸﾗｽ</strong><br />
					【開設校】<br />
					･お茶の水校<br />
					･名古屋校(＊)<br />
					･大阪校<br />
					【受講対象年齢】<br />
					･中学卒業以上､<br />
					･40歳まで<br />
					【ﾚｯｽﾝ回数･時間】<br />
					･週2回･合計6時間<br />
					【初年度入所金】<br />
					･10万円<br />
					[高校生は5万円となります&lt;平成30年4月改定&gt;(＊1.＊2)]<br />
					【4月生･年間受講料】<br />
					･36万円（4月から翌年3月までの受講料となります）<br />
					<br />
					＊平成29年度より､名古屋校の週3回ｸﾗｽは､週2回ｸﾗｽに変更となりました｡<br />
					※上記金額には消費税が含まれています｡<br />
					※年間受講料のみ分割納入可能｡<br />
					※2年目以降は年間受講料36万円のみのお支払いとなります｡<br />
					※弊所を一度退所し､令和2年度より再度入所される方につきましては､入所後の所定の手続きにより､再入所時の入所金の半額を返金（または受講料に充当）させていただきます｡<br />
					＊1. ﾚｯｽﾝ開始時点で､学校教育法に定められた全日制･定時制･通信制のいずれかの高等学校に在学されている方（または弊所がそれに相当すると認めた方）とさせていただきます｡<br />
					＊2. ｸﾗｽ確定後に所定の書類をご提出いただくこととなります｡</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	<a id="02" name="02"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong><span style="color: #98d1a9">■</span>週3回ｸﾗｽ</strong><br />
					【開設校】<br />
					･代々木校(＊)<br />
					【受講対象年齢】<br />
					･中学卒業以上､<br />
					･40歳まで<br />
					【ﾚｯｽﾝ回数･時間】<br />
					･週3回･合計9時間<br />
					【初年度入所金】<br />
					･10万円<br />
					[高校生は5万円となります&lt;平成30年4月改定&gt;(＊1.＊2)]<br />
					【4月生･年間受講料】<br />
					･50万円（4月から翌年3月までの受講料となります）<br />
					<br />
					＊平成29年度より､お茶の水校の週3回ｸﾗｽは､代々木校に統合されました｡<br />
					※上記金額には消費税が含まれています｡<br />
					※年間受講料のみ分割納入可能｡<br />
					※2年目以降は年間受講料50万円のみのお支払いとなります｡<br />
					※弊所を一度退所し､令和2年度より再度入所される方につきましては､入所後の所定の手続きにより､再入所時の入所金の半額を返金（または受講料に充当）させていただきます｡<br />
					＊1. ﾚｯｽﾝ開始時点で､学校教育法に定められた全日制･定時制･通信制のいずれかの高等学校に在学されている方（または弊所がそれに相当すると認めた方）とさせていただきます｡<br />
					＊2. ｸﾗｽ確定後に所定の書類をご提出いただくこととなります｡</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	<a id="04" name="04"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong><span style="color: #98d1a9">■</span>ﾅﾚｰﾀｰｾﾐﾅｰ</strong><br />
					【開設校】<br />
					･代々木校<br />
					･池袋校(＊)<br />
					･お茶の水校<br />
					･名古屋校<br />
					･大阪校<br />
					【受講対象年齢】<br />
					･中学卒業以上､<br />
					･40歳まで<br />
					【ﾚｯｽﾝ回数･時間】<br />
					･週1回･3時間<br />
					【初年度入所金】<br />
					･10万円<br />
					[高校生は5万円となります&lt;平成30年4月改定&gt;(＊1.＊2)]<br />
					【4月生･年間受講料】<br />
					･<del>20万円</del> &rArr; <span style="color:#ff0000;"><strong>16万円</strong></span>（4月から翌年3月までの受講料となります）<br />
					<span style="color:#ff8c00;">平成28年4月より､年間受講料改定｡</span><br />
					<br />
					＊平成29年度より､池袋校に新規開設いたしました｡<br />
					※上記金額には消費税が含まれています｡<br />
					※年間受講料のみ分割納入可能｡<br />
					※2年目以降は年間受講料16万円のみのお支払いとなります｡<br />
					※週1回ｸﾗｽ･週2回ｸﾗｽ･週3回ｸﾗｽとの並行受講の場合､当ｾﾐﾅｰの初年度入所金は必要ございません｡<br />
					※弊所を一度退所し､令和2年度より再度入所される方につきましては､入所後の所定の手続きにより､再入所時の入所金の半額を返金（または受講料に充当）させていただきます｡<br />
					＊1. ﾚｯｽﾝ開始時点で､学校教育法に定められた全日制･定時制･通信制のいずれかの高等学校に在学されている方（または弊所がそれに相当すると認めた方）とさせていただきます｡<br />
					＊2. ｸﾗｽ確定後に所定の書類をご提出いただくこととなります｡</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	<a id="05" name="05"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong><span style="color: #98d1a9">■</span>ｼﾞｭﾆｱ声優ｸﾗｽ</strong><br />
					【開設校】<br />
					･代々木校<br />
					･池袋校<br />
					･お茶の水校<br />
					･立川校<br />
					･町田校<br />
					･大宮校<br />
					･千葉校<br />
					･柏校<br />
					･横浜校<br />
					･仙台校<br />
					･名古屋校<br />
					･京都校<br />
					･大阪校<br />
					･難波校<br />
					･天王寺校<br />
					･神戸校<br />
					･所沢校（2020年4月開校予定）<br />
					【受講対象年齢】<br />
					･小学4年生から､<br />
					･中学3年生まで<br />
					【ﾚｯｽﾝ回数･時間】<br />
					･週1回･2時間<br />
					【ﾚｯｽﾝ曜日】<br />
					･日曜日（土曜日）<br />
					【初年度入所金】<br />
					･2万円<br />
					【受講料（月額）】<br />
					･7千円<br />
					<br />
					※上記金額には消費税が含まれています｡<br />
					※受講料は3ヶ月毎に3ヶ月分をまとめてのお支払いとなります｡<br />
					※2年目以降は受講料のみのお支払いとなります｡<br />
					※弊所を一度退所し､令和元年度より再度入所される方につきましては､入所後の所定の手続きにより､再入所時の入所金の半額を返金（または受講料に充当）させていただきます｡</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	<a id="03" name="03"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong><span style="color: #98d1a9">■</span>ｽﾀｰﾄｱｯﾌﾟｸﾗｽ</strong><br />
					【開設校】<br />
					･代々木校<br />
					･池袋校<br />
					･仙台校<br />
					･名古屋校<br />
					･大阪校<br />
					【受講対象年齢】<br />
					･中学卒業以上､<br />
					･40歳まで<br />
					【ﾚｯｽﾝ回数･時間】<br />
					･週1回･3時間<br />
					【入所時期】<br />
					･4月（12ヶ月）･7月（9ヶ月）<br />
					【初年度入所金】<br />
					･2万円<br />
					【4月生･年間受講料】<br />
					･12万円（4月から翌年3月までの受講料となります）<br />
					【7月生･年間受講料】<br />
					･9万円（7月から翌年3月までの受講料となります）<br />
					<br />
					※上記金額には消費税が含まれています｡<br />
					※年間受講料のみ分割納入可能｡<br />
					※2年目以降は年間受講料12万円のみのお支払いとなります｡<br />
					※弊所を一度退所し､令和2年度より再度入所される方につきましては､入所後の所定の手続きにより､再入所時の入所金の半額を返金（または受講料に充当）させていただきます｡</td>
			</tr>
		</tbody>
	</table>
</div>


<div style="font-size:x-small; text-align:right; margin-top:5px;"><a href="#pagetop">↑ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<div style="font-size:x-small; text-align:left; margin-top:5px;"><a href="/m/index.php">←ﾄｯﾌﾟへ戻る</a></div>
<div style="background:#c9e7d2; text-align:center; font-size:x-small; margin-top:10px; padding:5px 0;">(C)日本ﾅﾚｰｼｮﾝ演技研究所</div>
</div>
<?php

  $googleAnalyticsImageUrl = googleAnalyticsImageUrl();
  echo '<img src="' . $googleAnalyticsImageUrl . '" />';?>

</body>
</html>
<?php ob_end_flush(); ?><?php if(isset($mtkk_smartphone)) { ob_end_flush(); } ?><?php ob_end_flush(); ?>