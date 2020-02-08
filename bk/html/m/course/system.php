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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/course/img/course_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/course/img/course_tit.jpg'))); ?></div>

<div style="text-align:left;">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
		<tbody>
			<tr>
				<td style="font-size:x-small; width:10px;" valign="top">
					<span style="color:#98d1a9;">■</span></td>
				<td style="font-size:x-small; text-align:left; color:#4ca778;" valign="top">
					<strong>ﾚｯｽﾝ概要</strong></td>
			</tr>
			<tr>
				<td style="font-size:x-small;" valign="top">
					&nbsp;</td>
				<td style="font-size:x-small; text-align:left;" valign="top">
					<span style="color:#ff6600;">&gt;&gt;</span><a href="#kiso">基礎科(初級) </a></td>
			</tr>
			<tr>
				<td style="font-size:x-small;" valign="top">
					&nbsp;</td>
				<td style="font-size:x-small; text-align:left;" valign="top">
					<span style="color:#ff6600;">&gt;&gt;</span><a href="#honka">本科(中級)</a></td>
			</tr>
			<tr>
				<td style="font-size:x-small;" valign="top">
					&nbsp;</td>
				<td style="font-size:x-small; text-align:left;" valign="top">
					<span style="color:#ff6600;">&gt;&gt;</span><a href="#kenshu">研修科(上級)</a></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align:left;">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
		<tbody>
			<tr>
				<td style="font-size:x-small; text-align:left;" valign="top">
					◇演技ﾚｯｽﾝ未経験の方でも､基礎科から学んでいただけます｡<br />
					◇年に1度進級審査を行ない､年間査定と合わせて次年度の科を決定します｡<br />
					◇各科とも､在籍期間は原則として2年以内です｡</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	<a id="kiso" name="kiso"></a></p>
<div style="text-align:left;">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
		<tbody>
			<tr>
				<td style="font-size:x-small; text-align:left; text-decoration:underline;" valign="top">
					基礎科</td>
			</tr>
			<tr>
				<td style="font-size:x-small; text-align:left;" valign="top">
					ｽﾄﾚｯﾁ･発声･滑舌･腹式呼吸･朗読･ｾﾘﾌ･ｴﾁｭｰﾄﾞ基礎演技 など</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top:2px;">
		<tbody>
			<tr>
				<td style="font-size:x-small; text-align:left;" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/about/img/system_1.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/system_1.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/about/img/system_2.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/system_2.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="font-size:x-small; text-align:right; margin-top:5px;">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="honka" name="honka"></a></p>
<div style="text-align:left;">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
		<tbody>
			<tr>
				<td style="font-size:x-small; text-align:left; text-decoration:underline;" valign="top">
					本科(中級)</td>
			</tr>
			<tr>
				<td style="font-size:x-small; text-align:left;" valign="top">
					表現力･創造力を高めるためのﾚｯｽﾝ｡舞台台本などを使用したﾚｯｽﾝ など</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top:2px;">
		<tbody>
			<tr>
				<td style="font-size:x-small; text-align:left;" valign="top">
					<?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/system_img01_mb.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'system_img01_mb.jpg', 'height' => '72', 'src' => 'http://nichinare.com/m/system_img01_mb.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/about/img/system_4.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/system_4.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="font-size:x-small; text-align:right; margin-top:5px;">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="kenshu" name="kenshu"></a></p>
<div style="text-align:left;">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
		<tbody>
			<tr>
				<td style="font-size:x-small; text-align:left; text-decoration:underline;" valign="top">
					研修科</td>
			</tr>
			<tr>
				<td style="font-size:x-small; text-align:left;" valign="top">
					ﾌﾟﾛの心構え､舞台台本を使用したﾚｯｽﾝ､ｱﾌﾚｺ実習<br />
					ﾗｼﾞｵﾄﾞﾗﾏ制作の形式を取り入れたﾚｯｽﾝ など</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top:2px;">
		<tbody>
			<tr>
				<td style="font-size:x-small; text-align:left;" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/about/img/system_5.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/system_5.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/about/img/system_6.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/system_6.jpg', 'width' => '105'))); ?></td>
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