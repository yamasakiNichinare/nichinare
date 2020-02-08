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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/request/img/request_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/request/img/request_tit.jpg'))); ?></div>

<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#01">電話でのお申し込み方法</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#02">ﾊｶﾞｷでのお申し込み方法</a></td>
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
				<td style="width: 10px; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span></td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<strong>電話でのお申し込み方法</strong></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<a href="tel:03-3372-5671">TEL:03-3372-5671</a>にてお申し込みをお受けしております｡<br />
					弊所ｽﾀｯﾌにﾓﾊﾞｲﾙ版公式ｻｲﾄを見た旨をお伝えください｡<br />
					続いて､以下の内容をお伺いしますので､差し支えのない範囲でお答えください｡<br />
					<br />
					1.氏名<br />
					2.〒番号､住所<br />
					3.生年月日（年齢）<br />
					4.電話番号<br />
					5.職業(学年)<br />
					6.弊所を知ったきっかけ<br />
					<br />
					□受付時間<br />
					月～日曜 /&nbsp;10:00～19:00<br />
					<br />
					お電話をいただいてから､10日以内にお届けできるよう郵送させていただきます｡<br />
					<br />
					[個人情報保護について]<br />
					<span style="font-size: xx-small">資料請求にあたってご提供いただく皆様の個人情報につきましては､入所案内や入所関連情報の送付またはお電話でのご確認のみに使用し､ご本人様の承諾なしに第三者への提供は一切行いません｡なお､お申し込みいただきました書類は返却できませんので､あらかじめご了承ください｡</span><br />
					&rArr;<!--?php print setQueryString('../privacy/index.php'); ?--><a href="http://nichinare.com/m/privacy/index.php">詳しくはこちら</a></td>
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
				<td style="width: 10px; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span></td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<strong>ﾊｶﾞｷでのお申し込み方法</strong></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					ﾊｶﾞｷの裏面に以下の内容をお書きいただき､下記あて先までお送りください｡<br />
					<br />
					1.氏名(ﾌﾘｶﾞﾅ)<br />
					2.性別<br />
					3.〒番号､住所<br />
					4.生年月日(西暦表記)<br />
					5.電話番号<br />
					6.職業(学年)<br />
					7.弊所を知ったきっかけ<br />
					<br />
					□あて先□<br />
					〒151-0053<br />
					東京都渋谷区代々木1-22-1 代々木1丁目ﾋﾞﾙ 12F<br />
					<br />
					日本ﾅﾚｰｼｮﾝ演技研究所 入所ｾﾝﾀｰ<br />
					｢入所案内ｹｰﾀｲHP｣係<br />
					<br />
					[個人情報保護について]<br />
					<span style="font-size: xx-small">資料請求にあたってご提供いただく皆様の個人情報につきましては､入所案内や入所関連情報の送付またはお電話でのご確認のみに使用し､ご本人様の承諾なしに第三者への提供は一切行いません｡なお､お申し込みいただきました書類は返却できませんので､あらかじめご了承ください｡</span><br />
					&rArr;<a href="http://nichinare.com/m/privacy/index.php"><!--?php print setQueryString('../privacy/index.php'); ?-->詳しくはこちら</a></td>
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