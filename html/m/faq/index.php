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
$mtkk_content_type = 'application/xhtml+xml';
$mtkk_php_graphic = 'gd';
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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/faq/img/faq_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/faq/img/faq_tit.jpg'))); ?></div>

<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						よくいただくご質問をQ&amp;A形式にまとめました｡<br />
						お問い合わせの前にご覧ください｡<br />
						<br />
						Q.<a href="#q1">声優や演技の勉強をしたことがないと入所できないのでしょうか？</a><br />
						Q.<a href="#q2">入所面接の筆記試験はどんな内容なのでしょうか？また､具体的にはどんな問題が出題されるのでしょうか？</a><br />
						Q.<a href="#q3">入所金と受講料以外に費用はかかりますか？</a><br />
						Q.<a href="#q4">学生寮はありますか？</a></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	&nbsp;</p>
<p>
	<a id="q2" name="q1"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #008000">Q.声優や演技の勉強をしたことがないと入所できないのでしょうか？</span><br />
					<br />
					A.<br />
					弊所は声優になるためのﾚｯｽﾝを基礎から行いますので､何の経験もない初心者の方でも入所できます｡<br />
					（※入所するには､入所面接に合格し､受講料をお振り込みいただく必要がございます）</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="q3" name="q2"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #008000">Q.入所面接の筆記試験はどんな内容なのでしょうか？また､具体的にはどんな問題が出題されるのでしょうか｡</span><br />
					<br />
					A.<br />
					筆記試験の内容は中学卒業までに学習する国語の問題となります（１５分程度）｡<br />
					具体的な問題については､試験内容になりますのでお答えできません｡</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="q4" name="q3"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #008000">Q.入所金と受講料以外に費用はかかりますか？</span><br />
					<br />
					A.<br />
					当ｻｲﾄや入所案内に記載されている入所金や受講料（ともに税込）以外の費用はかかりません｡<br />
					ﾚｯｽﾝで使用される教材費や施設費などは､すべて受講料に含まれています｡</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="q5" name="q4"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #008000">Q.学生寮はありますか？</span><br />
					<br />
					A.<br />
					残念ながら､ご用意しておりません｡</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="q6" name="q6"></a></p>


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