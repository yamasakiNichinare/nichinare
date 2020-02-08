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
<title>声優･ﾅﾚｰﾀｰをめざすなら 日本ﾅﾚｰｼｮﾝ演技研究所</title>
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

<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => 'img/top_tit01.jpg', 'w' => '240', 'h' => '20', 'display' => 'browser', 'attr' => array('alt' => '最新情報', 'height' => '20', 'src' => 'img/top_tit01.jpg', 'width' => '240'))); ?></div>
<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">

<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#98d1a9;">■</span></td>
<td valign="top" style="font-size:x-small; text-align:left;">

<a href="https://nichinare.com/m/news/2019/07/0704-350.php">NEW ■１０月生 限定募集のお知らせ</a>

</td>
</tr>

<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#98d1a9;">■</span></td>
<td valign="top" style="font-size:x-small; text-align:left;">

<a href="https://nichinare.com/m/application/index.php">NEW ■入所面接 申し込み受付中</a>
  

</td>
</tr>

<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#98d1a9;">■</span></td>
<td valign="top" style="font-size:x-small; text-align:left;">

<a href="https://nichinare.com/m/free/index.php">NEW ■無料体験ﾚｯｽﾝ 受付中</a>
  

</td>
</tr>

<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#98d1a9;">■</span></td>
<td valign="top" style="font-size:x-small; text-align:left;">

<a href="https://nichinare.com/m/application/index.php">■2019年度7月生､および2020年度4月生募集中</a>
  

</td>
</tr>

<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#98d1a9;">■</span></td>
<td valign="top" style="font-size:x-small; text-align:left;">

<a href="https://nichinare.com/m/application/index.php">■【追加】入所面接　臨時開催のお知らせ</a>
  

</td>
</tr>

</table>
</div>
<div style="text-align:right;"><span style="color:#ff6600;">⇒</span><a href="news/index.php">もっと見る</a></div>

<div style="background:#ff6600; text-align:center; margin-top:10px; padding:3px 0 3px 0;"><span style="color:#ffffff;">&gt;&gt; <a href="https://nichinare.com/m/request/form.cgi">資料請求【無料】</a> &lt;&lt;</span></div>

<div style="background:#6cbd85; text-align:center; margin-top:10px;"><?php mtkk_image_tag(array('url' => 'img/top_tit02.jpg', 'w' => '240', 'h' => '20', 'display' => 'browser', 'attr' => array('alt' => '日ﾅﾚについて', 'height' => '20', 'src' => 'img/top_tit02.jpg', 'width' => '240'))); ?></div>
<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><span style="color:#ff6600;">⇒</span><a href="about/index.php">日ﾅﾚの特色</a>｜<span style="color:#ff6600;">⇒</span><a href="about/step.php">入所までのｽﾃｯﾌﾟ</a>｜<span style="color:#ff6600;">⇒</span><a href="about/studio.php">ﾚｯｽﾝｽﾀｼﾞｵ</a>｜<span style="color:#ff6600;">⇒</span><a href="about/lecturer.php">講師一覧</a>｜<span style="color:#ff6600;">⇒</span><a href="about/native.php">主な出身者</a></td>
</tr>
</table>
</div>

<div style="background:#6cbd85; text-align:center; margin-top:10px;"><?php mtkk_image_tag(array('url' => 'img/top_tit03.jpg', 'w' => '240', 'h' => '20', 'display' => 'browser', 'attr' => array('alt' => 'ｺｰｽ紹介', 'height' => '20', 'src' => 'img/top_tit03.jpg', 'width' => '240'))); ?></div>
<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><span style="color:#ff6600;">⇒</span><a href="course/index.php">週1ｸﾗｽ</a>｜<span style="color:#ff6600;">⇒</span><a href="course/twodays-threedays.php">週2回･週3回ｸﾗｽ</a>｜<span style="color:#ff6600;">⇒</span><a href="course/jr.php">ｼﾞｭﾆｱ声優ｸﾗｽ</a>｜<span style="color:#ff6600;">⇒</span><a href="course/narrater.php">ﾅﾚｰﾀｰｾﾐﾅｰ</a>｜<span style="color:#ff6600;">⇒</span><a href="course/start-up-course.php">ｽﾀｰﾄｱｯﾌﾟｸﾗｽ</a></td>
</tr>
</table>
</div>

<div style="background:#6cbd85; text-align:center; margin-top:10px;"><?php mtkk_image_tag(array('url' => 'img/top_tit04.jpg', 'w' => '240', 'h' => '20', 'display' => 'browser', 'attr' => array('alt' => '入所方法/面接日程 ', 'height' => '20', 'src' => 'img/top_tit04.jpg', 'width' => '240'))); ?></div>
<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><span style="color:#ff6600;">⇒</span><a href="application/index.php">週1､週2､週3､ﾅﾚｰﾀｰ､ｽﾀｰﾄｱｯﾌﾟ</a>｜<span style="color:#ff6600;">⇒</span><a href="application/apply-jr.php">ｼﾞｭﾆｱ声優ｸﾗｽ</a>｜<span style="color:#ff6600;">⇒</span><a href="application/tuition.php">入所金･受講料等一覧</a></td>
</tr>
</table>
</div>

<div style="text-align:left; margin:5px;"><?php mtkk_image_tag(array('url' => 'common/dotted-line.jpg', 'w' => '222', 'h' => '1', 'display' => 'browser', 'attr' => array('alt' => '', 'height' => '1', 'src' => 'common/dotted-line.jpg', 'width' => '222'))); ?></div>

<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#ff6600;">⇒</span></td>
<td valign="top" style="font-size:x-small; text-align:left;"><a href="https://nichinare.com/m/request/form.cgi">資料請求【無料】</a></td>
</tr>
</table>
</div>

<div style="text-align:left; margin:5px;"><?php mtkk_image_tag(array('url' => 'common/dotted-line.jpg', 'w' => '222', 'h' => '1', 'display' => 'browser', 'attr' => array('alt' => '', 'height' => '1', 'src' => 'common/dotted-line.jpg', 'width' => '222'))); ?></div>

<div style="text-align:left;"><a href="https://nichinare.com/m/request/form.cgi"><?php mtkk_image_tag(array('url' => 'img/bnr_shiryo.jpg', 'w' => '220', 'h' => '52', 'display' => 'browser', 'attr' => array('alt' => '資料請求【無料】', 'border' => '0', 'height' => '52', 'src' => 'img/bnr_shiryo.jpg', 'width' => '220'))); ?></a></div>

<div style="text-align:left; margin:5px;"><?php mtkk_image_tag(array('url' => 'common/dotted-line.jpg', 'w' => '222', 'h' => '1', 'display' => 'browser', 'attr' => array('alt' => '', 'height' => '1', 'src' => 'common/dotted-line.jpg', 'width' => '222'))); ?></div>

<div style="text-align:left;"><a href="free/index.php"><?php mtkk_image_tag(array('url' => 'img/top_bnr.jpg', 'w' => '220', 'h' => '52', 'display' => 'browser', 'attr' => array('alt' => '無料体験ﾚｯｽﾝ', 'border' => '0', 'height' => '52', 'src' => 'img/top_bnr.jpg', 'width' => '220'))); ?></a></div>
<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#ff6600;">⇒</span></td>
<td valign="top" style="font-size:x-small; text-align:left;"><a href="lesson/index.php">ﾚｯｽﾝ見学</a></td>
</tr>
<tr>
<td valign="top" style="font-size:x-small;">└</td>
<td valign="top" style="font-size:x-small; text-align:left;">日ﾅﾚで通常行なっているﾚｯｽﾝを見学いただけます</td>
</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#ff6600;">⇒</span></td>
<td valign="top" style="font-size:x-small; text-align:left;"><a href="faq/index.php">Q&amp;A</a></td>
</tr>
<tr>
<td valign="top" style="font-size:x-small;">└</td>
<td valign="top" style="font-size:x-small; text-align:left;">よくあるご質問をQ&amp;Aにまとめました｡</td>
</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#ff6600;">⇒</span></td>
<td valign="top" style="font-size:x-small; text-align:left;"><a href="contact/index.php">お問い合わせ</a></td>
</tr>
<tr>
<td valign="top" style="font-size:x-small;">└</td>
<td valign="top" style="font-size:x-small; text-align:left;">お気軽にお問い合わせください｡</td>
</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#ff6600;">⇒</span></td>
<td valign="top" style="font-size:x-small; text-align:left;"><a href="group/index.php">ｸﾞﾙｰﾌﾟﾌﾟﾛﾀﾞｸｼｮﾝ</a></td>
</tr>
<tr>
<td valign="top" style="font-size:x-small;">└</td>
<td valign="top" style="font-size:x-small; text-align:left;">日ﾅﾚのｸﾞﾙｰﾌﾟﾌﾟﾛﾀﾞｸｼｮﾝのご紹介です｡</td>
</tr>
</table>
</div>

<div style="text-align:left; margin:5px;"><?php mtkk_image_tag(array('url' => 'common/dotted-line.jpg', 'display' => 'browser', 'attr' => array('alt' => '', 'src' => 'common/dotted-line.jpg'))); ?></div>
<div style="text-align:left;"><a href="https://nichinare.com/oshirase/jukou/index.cgi"><?php mtkk_image_tag(array('url' => 'img/bnr_oshirase.gif', 'w' => '220', 'h' => '26', 'display' => 'browser', 'attr' => array('alt' => '受講生専用ｻｲﾄ', 'border' => '0', 'height' => '26', 'src' => 'img/bnr_oshirase.gif', 'width' => '220'))); ?></a></div>

<div style="background:#c9e7d2; text-align:center; font-size:x-small; margin-top:10px; padding:5px 0;"><a href="tel:03-3372-5671">TEL:03-3372-5671</a><br /><a href="company/index.php">会社概要</a>｜<a href="privacy/index.php">個人情報の取扱いについて</a><br /><br />(C)日本ﾅﾚｰｼｮﾝ演技研究所</div>
</div>
<?php

  $googleAnalyticsImageUrl = googleAnalyticsImageUrl();
  echo '<img src="' . $googleAnalyticsImageUrl . '" />';?>

</body>
</html>
<?php ob_end_flush(); ?><?php if(isset($mtkk_smartphone)) { ob_end_flush(); } ?><?php ob_end_flush(); ?>