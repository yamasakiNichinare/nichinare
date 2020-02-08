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

  // リクエストクエリー文字列取得
  function setQueryString($redirectURL) {
    $queryArray = array();
    $queryStringArray = array();
    if($_SERVER['REQUEST_METHOD'] == 'POST') {
      $queryArray = $_POST;
    } else {
      $queryArray = $_GET;
    }
    foreach($queryArray as $key => $value) {
      $keyChecked = stripslashes(htmlspecialchars($key, ENT_QUOTES));
      $valueChecked = stripslashes(htmlspecialchars($value, ENT_QUOTES));
      $queryStringArray[] = $keyChecked.'='.$valueChecked;
    }
    $queryString = implode('&', $queryStringArray);
    if(strlen($queryString) > 0) {
      $linkTag = '<a href="'.$redirectURL.'?'.$queryString.'">';
    } else {
      $linkTag = '<a href="'.$redirectURL.'">';
    }
    return $linkTag;
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
$mtkk_image_script = 'https://nichinare.com/m/test/mtkkimage.php';
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
<meta name="keywords" content="" />
<style type="text/css">
<![CDATA[
a:link{color:#005cb8;}
a:visited{color:#ad00b8;}
a:focus{color:;}
]]></style>
</head>

<body style="background:#ffffff;color:#444444;">
<div style="font-size:x-small;">
<div style="text-align:center; margin-bottom:10px;"><?php mtkk_image_tag(array('url' => '/m/common/hd-tit.jpg', 'w' => '240', 'h' => '47', 'display' => 'browser', 'attr' => array('alt' => '声優･ﾅﾚｰﾀｰなら 日本ﾅﾚｰｼｮﾝ演技研究所', 'height' => '47', 'src' => '/m/common/hd-tit.jpg', 'width' => '240'))); ?><br /><?php mtkk_image_tag(array('url' => '/m/common/hd-main.jpg', 'w' => '240', 'h' => '79', 'display' => 'browser', 'attr' => array('alt' => '働きながら､学びながら週1回の3時間ﾚｯｽﾝ!', 'height' => '79', 'src' => '/m/common/hd-main.jpg', 'width' => '240'))); ?><br /><?php mtkk_image_tag(array('url' => '/m/common/hd-txt.gif', 'w' => '240', 'h' => '16', 'display' => 'browser', 'attr' => array('alt' => '東京（代々木･立川）･大宮･横浜･大阪･名古屋', 'height' => '16', 'src' => '/m/common/hd-txt.gif', 'width' => '240'))); ?></div>

<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/img/top_tit01.jpg', 'w' => '240', 'h' => '20', 'display' => 'browser', 'attr' => array('alt' => '最新情報', 'height' => '20', 'src' => '/m/img/top_tit01.jpg', 'width' => '240'))); ?></div>
<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">

</table>
</div>
<div style="text-align:right;"><span style="color:#ff6600;">⇒</span><?php print setQueryString('news/index.php'); ?>もっと見る</a></div>

<div style="background:#ff6600; text-align:center; margin-top:10px; padding:3px 0 3px 0;"><span style="color:#ffffff;">&gt;&gt; <?php print setQueryString('https://nichinare.com/m/request/form.cgi'); ?>資料請求【無料】</a> &lt;&lt;</span></div>

<div style="background:#6cbd85; text-align:center; margin-top:10px;"><?php mtkk_image_tag(array('url' => '/m/img/top_tit02.jpg', 'w' => '240', 'h' => '20', 'display' => 'browser', 'attr' => array('alt' => '日ﾅﾚについて', 'height' => '20', 'src' => '/m/img/top_tit02.jpg', 'width' => '240'))); ?></div>
<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><span style="color:#ff6600;">⇒</span><?php print setQueryString('about/index.php'); ?>日ﾅﾚの特色</a>｜<span style="color:#ff6600;">⇒</span><?php print setQueryString('about/step.php'); ?>入所までのｽﾃｯﾌﾟ</a>｜<span style="color:#ff6600;">⇒</span><?php print setQueryString('about/studio.php'); ?>ﾚｯｽﾝｽﾀｼﾞｵ</a>｜<span style="color:#ff6600;">⇒</span><?php print setQueryString('about/lecturer.php'); ?>講師一覧</a>｜<span style="color:#ff6600;">⇒</span><?php print setQueryString('about/native.php'); ?>主な出身者</a></td>
</tr>
</table>
</div>

<div style="background:#6cbd85; text-align:center; margin-top:10px;"><?php mtkk_image_tag(array('url' => '/m/img/top_tit03.jpg', 'w' => '240', 'h' => '20', 'display' => 'browser', 'attr' => array('alt' => 'ｺｰｽ紹介', 'height' => '20', 'src' => '/m/img/top_tit03.jpg', 'width' => '240'))); ?></div>
<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><span style="color:#ff6600;">⇒</span><?php print setQueryString('course/index.php'); ?>週1ｸﾗｽ</a>｜<span style="color:#ff6600;">⇒</span><?php print setQueryString('course/threedays.php'); ?>週3ｸﾗｽ</a>｜<span style="color:#ff6600;">⇒</span><?php print setQueryString('course/jr.php'); ?>ｼﾞｭﾆｱ声優ｸﾗｽ</a>｜<span style="color:#ff6600;">⇒</span><?php print setQueryString('course/narrater.php'); ?>ﾅﾚｰﾀｰｾﾐﾅｰ</a>｜<span style="color:#ff6600;">⇒</span><?php print setQueryString('course/starting.php'); ?>声優ｽﾀｰﾃｨﾝｸﾞｾﾐﾅｰ</a></td>
</tr>
</table>
</div>

<div style="background:#6cbd85; text-align:center; margin-top:10px;"><?php mtkk_image_tag(array('url' => '/m/img/top_tit04.jpg', 'w' => '240', 'h' => '20', 'display' => 'browser', 'attr' => array('alt' => '入所方法/面接日程 ', 'height' => '20', 'src' => '/m/img/top_tit04.jpg', 'width' => '240'))); ?></div>
<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><span style="color:#ff6600;">⇒</span><?php print setQueryString('application/index.php'); ?>週1､週3､ﾅﾚｰﾀｰ</a>｜<span style="color:#ff6600;">⇒</span><?php print setQueryString('application/apply-jr.php'); ?>ｼﾞｭﾆｱ声優ｸﾗｽ</a>｜<span style="color:#ff6600;">⇒</span><?php print setQueryString('application/apply-jr.php#02'); ?>声優ｽﾀｰﾃｨﾝｸﾞｾﾐﾅｰ</a>｜<span style="color:#ff6600;">⇒</span><?php print setQueryString('application/tuition.php'); ?>入所金･受講料等一覧</a></td>
</tr>
</table>
</div>

<div style="text-align:left; margin:5px;"><?php mtkk_image_tag(array('url' => '/m/common/dotted-line.jpg', 'w' => '222', 'h' => '1', 'display' => 'browser', 'attr' => array('alt' => '', 'height' => '1', 'src' => '/m/common/dotted-line.jpg', 'width' => '222'))); ?></div>

<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#ff6600;">⇒</span></td>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/request/form.cgi'); ?>資料請求【無料】</a></td>
</tr>
</table>
</div>

<div style="text-align:left; margin:5px;"><?php mtkk_image_tag(array('url' => '/m/common/dotted-line.jpg', 'w' => '222', 'h' => '1', 'display' => 'browser', 'attr' => array('alt' => '', 'height' => '1', 'src' => '/m/common/dotted-line.jpg', 'width' => '222'))); ?></div>

<div style="text-align:left;"><?php print setQueryString('https://nichinare.com/m/request/form.cgi'); ?><?php mtkk_image_tag(array('url' => '/m/img/bnr_shiryo.jpg', 'w' => '220', 'h' => '52', 'display' => 'browser', 'attr' => array('alt' => '資料請求【無料】', 'border' => '0', 'height' => '52', 'src' => '/m/img/bnr_shiryo.jpg', 'width' => '220'))); ?></a></div>

<div style="text-align:left; margin:5px;"><?php mtkk_image_tag(array('url' => '/m/common/dotted-line.jpg', 'w' => '222', 'h' => '1', 'display' => 'browser', 'attr' => array('alt' => '', 'height' => '1', 'src' => '/m/common/dotted-line.jpg', 'width' => '222'))); ?></div>

<div style="text-align:left;"><?php print setQueryString('free/index.php'); ?><?php mtkk_image_tag(array('url' => '/m/img/top_bnr.jpg', 'w' => '220', 'h' => '52', 'display' => 'browser', 'attr' => array('alt' => '無料体験ﾚｯｽﾝ', 'border' => '0', 'height' => '52', 'src' => '/m/img/top_bnr.jpg', 'width' => '220'))); ?></a></div>
<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#ff6600;">⇒</span></td>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('lesson/index.php'); ?>ﾚｯｽﾝ見学</a></td>
</tr>
<tr>
<td valign="top" style="font-size:x-small;">└</td>
<td valign="top" style="font-size:x-small; text-align:left;">日ﾅﾚで通常行なっているﾚｯｽﾝを見学いただけます</td>
</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#ff6600;">⇒</span></td>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('faq/index.php'); ?>Q&amp;A</a></td>
</tr>
<tr>
<td valign="top" style="font-size:x-small;">└</td>
<td valign="top" style="font-size:x-small; text-align:left;">よくあるご質問をQ&amp;Aにまとめました｡</td>
</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#ff6600;">⇒</span></td>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('contact/index.php'); ?>お問い合わせ</a></td>
</tr>
<tr>
<td valign="top" style="font-size:x-small;">└</td>
<td valign="top" style="font-size:x-small; text-align:left;">お気軽にお問い合わせください｡</td>
</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#ff6600;">⇒</span></td>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('group/index.php'); ?>ｸﾞﾙｰﾌﾟﾌﾟﾛﾀﾞｸｼｮﾝ</a></td>
</tr>
<tr>
<td valign="top" style="font-size:x-small;">└</td>
<td valign="top" style="font-size:x-small; text-align:left;">日ﾅﾚのｸﾞﾙｰﾌﾟﾌﾟﾛﾀﾞｸｼｮﾝのご紹介です｡</td>
</tr>
</table>
</div>

<div style="background:#c9e7d2; text-align:center; font-size:x-small; margin-top:10px; padding:5px 0;"><a href="tel:03-3372-5671">TEL:03-3372-5671</a><br /><?php print setQueryString('/m/company/index.php'); ?>会社概要</a>｜<?php print setQueryString('/m/privacy/index.php'); ?>個人情報の取扱いについて</a><br /><br />(C)日本ﾅﾚｰｼｮﾝ演技研究所</div>
</div>
<?php
  $googleAnalyticsImageUrl = googleAnalyticsGetImageUrl();
  echo '<img src="' . $googleAnalyticsImageUrl . '" />';?>
</body>
</html>
<?php if(isset($mtkk_smartphone)) { ob_end_flush(); } ?><?php ob_end_flush(); ?>