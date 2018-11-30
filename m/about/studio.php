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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/about/img/about_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/about/img/about_tit.jpg'))); ?></div>

<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="width: 10px; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span></td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<span style="color: #000000"><strong>ﾚｯｽﾝｽﾀｼﾞｵ</strong></span></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#yoyogi">代々木校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#ikebukuro">池袋校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#ochanomizu">お茶の水校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#tachikawa">立川校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#machida">町田校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#omiya">大宮校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#chiba">千葉校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#kashiwa">柏校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#yokohama">横浜校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#sendai">仙台校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#nagoya">名古屋校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#kyoto">京都校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#osaka">大阪校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#namba">難波校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#tennoji">天王寺校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#kobe">神戸校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#emergency">非常用設備</a></td>
			</tr>
		</tbody>
	</table>
</div>
<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
	<tbody>
		<tr>
			<td style="text-align: left; font-size: x-small" valign="top">
				各校､最寄駅から通いやすい場所にﾚｯｽﾝｽﾀｼﾞｵを開設しています｡<br />
				各ｽﾀｼﾞｵ共にﾌﾛｰﾘﾝｸﾞ､鏡張りで､各種機材も用意し､充実したﾚｯｽﾝ環境の提供に努めています｡<br />
				<br />
				<span style="color:#ff0000;">※各校により､営業日･営業時間は異なりますので､詳しくは入所ｾﾝﾀｰまでお問い合わせください｡</span><br />
				<a href="http://nichinare.com/m/contact/index.php">&rArr;お問い合わせはこちら</a><br />
				<span style="color:#ff0000;">※各ｽﾀｼﾞｵの一般公開はしておりません｡</span></td>
		</tr>
	</tbody>
</table>
<p>
	<a id="yoyogi" name="yoyogi"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					代々木校&nbsp;<span style="font-size:90%;">※平成26年4月より､東京校の名称を『代々木校』に変更いたしました｡</span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					ﾚｯｽﾝｽﾀｼﾞｵはすべて｢JR･代々木駅｣｢都営地下鉄大江戸線･代々木駅｣｢小田急線･南新宿駅｣から､徒歩約5分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/yoyogi_studio_mobile.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'yoyogi_studio_mobile.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => 'http://nichinare.com/m/yoyogi_studio_mobile.jpg', 'style' => '', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/about/img/studio_11.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_11.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/yoyogi2_building_mobile.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'yoyogi2_building_mobile.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/yoyogi2_building_mobile.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/New_yoyogi2_mobile_floor.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'New_yoyogi2_mobile_floor.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/New_yoyogi2_mobile_floor.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/studio_img01_g01.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'studio_img01_g01.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/studio_img01_g01.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/studio_img02_g01.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'studio_img02_g01.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/studio_img02_g01.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/center_img_g01.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('align' => 'top', 'alt' => 'center_img_g01.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/center_img_g01.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/yoyogi_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'yoyogi_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/yoyogi_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="ikebukuro" name="ikebukuro"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					池袋校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成28年4月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･池袋駅｣から､徒歩約3分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/ikebukuro_building_m.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'ikebukuro_building_m.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/ikebukuro_building_m.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/ikebukuro_studio_m.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'ikebukuro_studio_m.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/ikebukuro_studio_m.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/ikebukuro_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'ikebukuro_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/ikebukuro_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="ochanomizu" name="ochanomizu"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					お茶の水校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成26年4月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･御茶ﾉ水駅｣から､徒歩約2分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/ochanomizukou_mobile.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'ochanomizukou_mobile.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => 'http://nichinare.com/m/ochanomizukou_mobile.jpg', 'style' => '', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/lesson_studio_mobile.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'lesson_studio_mobile.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => 'http://nichinare.com/m/lesson_studio_mobile.jpg', 'style' => '', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/ochanomizu_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'ochanomizu_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/ochanomizu_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="tachikawa" name="tachikawa"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					立川校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成24年4月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･立川駅｣から､徒歩約5分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/about/img/studio_13.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_13.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/about/img/studio_14.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_14.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/tachikawa_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'tachikawa_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/tachikawa_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="machida" name="machida"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					町田校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成27年4月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢小田急線･町田駅｣から､徒歩約5分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/machida_building_mobile.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'machida_building_mobile.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => 'http://nichinare.com/m/machida_building_mobile.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/machida_studio_mobile.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'machida_studio_mobile.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => 'http://nichinare.com/m/machida_studio_mobile.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/machida_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'machida_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/machida_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="omiya" name="omiya"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					大宮校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成23年4月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは埼玉県の｢JR･大宮駅｣から､徒歩約5分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/about/img/studio_17.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_17.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/about/img/studio_18.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_18.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/omiya_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'omiya_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/omiya_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="chiba" name="chiba"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					千葉校<span style="color: #ff6600; text-decoration: none">&nbsp;NEW</span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成29年10月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･千葉駅東口｣から､徒歩約5分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/chiba_building_m.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'chiba_building_m.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/chiba_building_m.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/DSC04846.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'DSC04846.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/DSC04846.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/chiba_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'chiba_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/chiba_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="kashiwa" name="kashiwa"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					柏校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成25年7月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･柏駅｣から､徒歩約4分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/about/img/studio_30.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_30.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/about/img/studio_32.jpg', 'display' => 'browser', 'attr' => array('src' => 'http://nichinare.com/m/about/img/studio_32.jpg'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/kashiwa_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'kashiwa_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/kashiwa_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="yokohama" name="yokohama"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					横浜校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成24年4月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･横浜駅｣から､徒歩約5分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/about/img/studio_15.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_15.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/about/img/studio_19.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_19.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/yokohama_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'yokohama_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/yokohama_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="sendai" name="sendai"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					仙台校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成29年4月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･仙台駅｣から､徒歩約7分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/m_sendai_outside.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'm_sendai_outside.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/m_sendai_outside.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/m_sendai_studio.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'm_sendai_studio.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/m_sendai_studio.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/sendai_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'sendai_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/sendai_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="nagoya" name="nagoya"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					名古屋校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成7年開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢近鉄･名古屋駅｣から､徒歩約5分の場所にご用意しております｡<br />
					<span style="font-size: xx-small">※名古屋校は平成24年11月に移転いたしました｡</span></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/%E5%90%8D%E5%8F%A4%E5%B1%8B%E6%A0%A1%E5%86%99%E7%9C%9F_mobile.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => '名古屋校写真_mobile.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/%E5%90%8D%E5%8F%A4%E5%B1%8B%E6%A0%A1%E5%86%99%E7%9C%9F_mobile.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/about/img/studio_21.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_21.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/nagoya_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'nagoya_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/nagoya_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="kyoto" name="kyoto"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					京都校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成29年4月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･京都駅｣から､徒歩約5分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/m_kyoto_outside.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'm_kyoto_outside.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/m_kyoto_outside.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/m_kyoto_studio.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'm_kyoto_studio.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/m_kyoto_studio.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/kyoto_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'kyoto_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/kyoto_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="osaka" name="osaka"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					大阪校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成3年開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･大阪駅｣から､徒歩約5分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/about/img/studio_3.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_3.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/about/img/studio_4.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_4.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/osaka_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'osaka_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/osaka_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="namba" name="namba"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					難波校<span style="color: #ff6600; text-decoration: none">&nbsp;NEW</span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成30年4月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･難波駅直結｣の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/namba_outside_m.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'namba_outside_m.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/namba_outside_m.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/namba_studio_m.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'namba_studio_m.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/namba_studio_m.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/namba_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'namba_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/namba_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="tennoji" name="tennoji"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					天王寺校<span style="color: #ff6600; text-decoration: none">&nbsp;NEW</span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成30年4月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･天王寺駅｣から､徒歩約4分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/NEW_tennoji_outside_m.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'NEW_tennoji_outside_m.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/NEW_tennoji_outside_m.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/tennoji_studio_m.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'tennoji_studio_m.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => '/m/tennoji_studio_m.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/tennoji_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'tennoji_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/tennoji_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="kobe" name="kobe"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					神戸校</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					平成25年4月開校｡<br />
					ﾚｯｽﾝｽﾀｼﾞｵは｢JR･神戸駅｣から､徒歩約3分の場所にご用意しております｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/about/img/studio_27.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_27.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/about/img/studio_29.jpg', 'display' => 'browser', 'attr' => array('src' => 'http://nichinare.com/m/about/img/studio_29.jpg'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/kobe_m_1807.jpg', 'w' => '105', 'h' => '99', 'display' => 'browser', 'attr' => array('alt' => 'kobe_m_1807.jpg', 'class' => 'mt-image-none', 'height' => '99', 'src' => '/m/kobe_m_1807.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="emergency" name="emergency"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; color: #4ca778; font-size: x-small; text-decoration: underline" valign="top">
					非常時対応備品</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					万が一の災害時に備え､非常食や保存水等を各ｽﾀｼﾞｵに備蓄｡<br />
					各建物ごとにはAEDも設置しています｡</td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/about/img/studio_22.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_22.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/boukan_mobile.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('alt' => 'boukan_mobile.jpg', 'class' => 'mt-image-none', 'height' => '72', 'src' => 'http://nichinare.com/m/boukan_mobile.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/about/img/studio_24.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_24.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/about/img/studio_26.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_26.jpg', 'width' => '105'))); ?></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 2px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/about/img/studio_25.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_25.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?><?php mtkk_image_tag(array('url' => '/m/about/img/studio_10.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/about/img/studio_10.jpg', 'width' => '105'))); ?><?php mtkk_image_tag(array('url' => '/m/common/spacer.gif', 'w' => '5', 'h' => '5', 'display' => 'browser', 'attr' => array('height' => '5', 'src' => '/m/common/spacer.gif', 'width' => '5'))); ?></td>
			</tr>
		</tbody>
	</table>
	<br />
	<span style="color:#ff0000;">※非常用設備は､施設により､一部備品等の内容が異なる場合がございます｡</span></div>


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