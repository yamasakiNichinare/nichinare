<?php
  // Copyright 2010 Google Inc. All Rights Reserved.

  $GA_ACCOUNT = "MO-26631444-1";
  $GA_PIXEL = "/ga.php";

  function googleAnalyticsGetImageUrl() {
    global $GA_ACCOUNT, $GA_PIXEL;
    $url = "";
    $url .= $GA_PIXEL . "?";
    $url .= "utmac=" . $GA_ACCOUNT;
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
    return str_replace("&", "&amp;", $url);
  }
?>

<?php
$mtkk_use_session = false;
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
$mtkk_php_graphic = 'gd';
$mtkk_content_type = 'application/xhtml+xml';
$mtkk_temp_dir = '/usr/home/z304150/html/cmt/plugins/KeitaiKit/tmp';
$mtkk_iemoji_dir = '/usr/home/z304150/html/cmt/plugins/KeitaiKit/iemoji';
$mtkk_cache_cleaning_prob = '0';
$mtkk_default_doctype = '';

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
<div style="font-size:x-small;">
<div style="text-align:center; margin-bottom:10px;"><?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/common/hd-tit.jpg', 'w' => '240', 'h' => '47', 'display' => 'browser', 'attr' => array('alt' => '声優･ﾅﾚｰﾀｰなら 日本ﾅﾚｰｼｮﾝ演技研究所', 'height' => '47', 'src' => 'http://nichinare.com/m/common/hd-tit.jpg', 'width' => '240'))); ?><br /><?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/common/hd-main.jpg', 'w' => '240', 'h' => '79', 'display' => 'browser', 'attr' => array('alt' => '働きながら､学びながら週1回の3時間ﾚｯｽﾝ!', 'height' => '79', 'src' => 'http://nichinare.com/m/common/hd-main.jpg', 'width' => '240'))); ?><br /><?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/common/hd-txt.gif', 'w' => '240', 'h' => '35', 'display' => 'browser', 'attr' => array('alt' => '東京（代々木）･立川校･大宮校･横浜校･大阪校･名古屋校', 'height' => '35', 'src' => 'http://nichinare.com/m/common/hd-txt.gif', 'width' => '240'))); ?></div>
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/news/img/news_tit.jpg', 'w' => '240', 'h' => '20', 'display' => 'browser', 'attr' => array('alt' => '最新情報', 'height' => '20', 'src' => '/m/news/img/news_tit.jpg', 'width' => '240'))); ?></div>

<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">

<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#98d1a9;">■</span></td>
<td valign="top" style="font-size:x-small; text-align:left;"><a href="http://nichinare.com/m/news/2012/03/0330-89.php">入所面接ｽｹｼﾞｭｰﾙ･3/30更新<br />今年度【最終】日程告知</a></td>
</tr>

</table>

<table border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;">

<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><a href="http://nichinare.com/m/news/2012/03/">⇒2012年3月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><a href="http://nichinare.com/m/news/2012/01/">⇒2012年1月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><a href="http://nichinare.com/m/news/2011/11/">⇒2011年11月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><a href="http://nichinare.com/m/news/2011/03/">⇒2011年3月</a></td>
</tr>

</table>




</div>

<div style="font-size:x-small; text-align:right; margin-top:5px;"><a href="#pagetop">↑ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<div style="font-size:x-small; text-align:left; margin-top:5px;"><a href="http://nichinare.com/m/index.php">←ﾄｯﾌﾟへ戻る</a></div>
<div style="background:#c9e7d2; text-align:center; font-size:x-small; margin-top:10px; padding:5px 0;">(C)日本ﾅﾚｰｼｮﾝ演技研究所</div>
</div>
<?php
  $googleAnalyticsImageUrl = googleAnalyticsGetImageUrl();
  echo '<img src="' . $googleAnalyticsImageUrl . '" />';?>
</body>
</html>
<?php if(isset($mtkk_smartphone)) { ob_end_flush(); } ?><?php ob_end_flush(); ?>