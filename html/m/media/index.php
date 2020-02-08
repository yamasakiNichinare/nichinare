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
$mtkk_image_script = 'http://nichinare.com/m/mtkkimage.php';
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
$mtkk_session_external_urls = array('http://nichinare.com/m/', 'https://nichinare.com/');

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
<div style="text-align:center; margin-bottom:10px;"><?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/common/hd-tit.jpg', 'w' => '240', 'h' => '47', 'display' => 'browser', 'attr' => array('alt' => '声優･ﾅﾚｰﾀｰなら 日本ﾅﾚｰｼｮﾝ演技研究所', 'height' => '47', 'src' => 'http://nichinare.com/m/common/hd-tit.jpg', 'width' => '240'))); ?><br /><?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/common/hd-main.jpg', 'w' => '240', 'h' => '79', 'display' => 'browser', 'attr' => array('alt' => '働きながら､学びながら週1回の3時間ﾚｯｽﾝ!', 'height' => '79', 'src' => 'http://nichinare.com/m/common/hd-main.jpg', 'width' => '240'))); ?><br /><?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/common/hd-txt.gif', 'w' => '240', 'h' => '35', 'display' => 'browser', 'attr' => array('alt' => '代々木校･お茶の水校･立川校･町田校･大宮校･柏校･横浜校･大阪校･神戸校･名古屋校', 'height' => '35', 'src' => 'http://nichinare.com/m/common/hd-txt.gif', 'width' => '240'))); ?></div>
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/media/img/media_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/media/img/media_tit.jpg'))); ?></div>

<div style="text-align:left;">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
		<tbody>
			<tr>
				<td style="font-size:x-small; width:10px;" valign="top">
					<span style="color:#98d1a9;">■</span></td>
				<td style="font-size:x-small; text-align:left; color:#4ca778;" valign="top">
					<strong>ﾋﾞﾃﾞｵ『声優演技入門』のご紹介</strong></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align:left;">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
		<tbody>
			<tr>
				<td style="font-size:x-small; text-align:left;" valign="top">
					俳優･声優を目指す人の自主ﾚｯｽﾝ用参考資料として､日ﾅﾚが制作したﾋﾞﾃﾞｵ｢声優演技入門｣を販売しています｡<br />
					<br />
					◎価格 10,000円(消費税･送料込み)<br />
					<br />
					◎VHSﾋﾞﾃﾞｵ<br />
					90分2本組(計180分)<br />
					<br />
					☆第1巻/基礎編<br />
					声優とは?<br />
					発声･呼吸法､ｽﾄﾚｯﾁ､ｾﾞﾛのﾎﾟｼﾞｼｮﾝ､ｲﾒｰｼﾞﾄﾚｰﾆﾝｸﾞ等を解説<br />
					<br />
					☆第2巻/応用編<br />
					ｲﾝﾄﾈｰｼｮﾝ､動作の理由づけ､ｷｬﾗｸﾀｰ･声の質を変えて演じる､ｼﾅﾘｵを使った立ち稽古､ｼﾅﾘｵのｴﾁｭｰﾄﾞ等を解説<br />
					<br />
					<br />
					<strong>■購入方法</strong><br />
					販売元まで申込書をお取り寄せください｡<br />
					現金書留または銀行振込みでの受付となります｡<br />
					<br />
					【お申し込み先･販売元】<br />
					<strong>ｴｲ ｱﾝﾄﾞ ｼﾞｰ</strong><br />
					〒140-0013 東京都品川区南大井6-28-11-5F<br />
					TEL:03-5753-7811</td>
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