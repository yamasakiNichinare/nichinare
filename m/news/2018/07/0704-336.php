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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/news/img/news_tit.jpg', 'w' => '240', 'h' => '20', 'display' => 'browser', 'attr' => array('alt' => '最新情報', 'height' => '20', 'src' => '/m/news/img/news_tit.jpg', 'width' => '240'))); ?></div>

<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#98d1a9;">■</span></td>
<td valign="top" style="font-size:x-small; text-align:left; color:#4ca778;"><strong>■１０月生 限定募集のお知らせ</strong></td>
</tr>
</table>
</div>

<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><div>
	１０月生 限定募集のお知らせ</div>
<div>
	&nbsp;</div>
<div>
	&nbsp;</div>
<div>
	１０月生は､前半の約３ヵ月に１日３時間&times;２ﾚｯｽﾝを受講していただくことで､従来の７月生と同じﾚｯｽﾝ回数を受講することができる､短期集中ﾚｯｽﾝのｸﾗｽとなります｡</div>
<div>
	ｽﾀｼﾞｵの都合上､限定的な募集となりますので､定員になり次第締め切らせていただきます｡</div>
<div>
	ご希望の方はお早めにお申し込みください｡</div>
<div>
	&nbsp;</div>
<div>
	&nbsp;</div>
<div>
	<a href="https://nichinare.com/m/application/index.php">【入所面接日程はこちら】</a></div>
<div>
	&nbsp;</div>
<div>
	<a href="https://nichinare.com/m/free/index.php">【無料体験ﾚｯｽﾝ日程はこちら】</a></div>
<div>
	&nbsp;</div>
<div>
	&nbsp;</div>
<div>
	&nbsp;</div>
<div>
	『平成30年度10月生 募集概要』</div>
<div>
	&nbsp;</div>
<div>
	【開設ｺｰｽ】</div>
<div>
	　週１回ｸﾗｽ（演技）</div>
<div>
	&nbsp;</div>
<div>
	【開設ｸﾗｽ】</div>
<div>
	　基礎科</div>
<div>
	&nbsp;</div>
<div>
	【受講対象年齢】</div>
<div>
	　中学卒業以上､40歳まで</div>
<div>
	&nbsp;</div>
<div>
	【ﾚｯｽﾝ期間】</div>
<div>
	　平成30年10月～平成31年3月（予定）</div>
<div>
	&nbsp;</div>
<div>
	【ﾚｯｽﾝ回数】</div>
<div>
	　10月～12月の3ヶ月間は､1日2ﾚｯｽﾝ（1ﾚｯｽﾝ3時間 &lt;30分間休憩あり&gt;）</div>
<div>
	　1月～3月の3ヶ月間は､1日1ﾚｯｽﾝ</div>
<div>
	&nbsp;</div>
<div>
	【年間受講料（税込）】</div>
<div>
	　１５０，０００円</div>
<div>
	　※10月～翌年3月までの受講料となります｡</div>
<div>
	&nbsp;</div>
<div>
	【入所金（税込）】</div>
<div>
	　１００，０００円</div>
<div>
	　※初年度のみとなります｡</div>
<div>
	　※仙台校の入所金は５０,０００円となります｡</div>
<div>
	　※高校生の入所金は５０,０００円となります｡</div>
<div>
	&nbsp;</div>
<div>
	【開設校詳細（ﾚｯｽﾝ曜日･時間）】</div>
<div>
	　■代々木校</div>
<div>
	　　① 月曜日 11:00～17:30</div>
<div>
	　　② 土曜日 11:00～17:30</div>
<div>
	　　③ 日曜日 14:30～21:00</div>
<div>
	&nbsp;</div>
<div>
	　■池袋校</div>
<div>
	　　① 水曜日 14:30～21:00</div>
<div>
	　　② 土曜日 14:30～21:00</div>
<div>
	&nbsp;</div>
<div>
	　■お茶の水校</div>
<div>
	　　① 土曜日 11:00～17:30</div>
<div>
	　　② 日曜日 14:30～21:00</div>
<div>
	&nbsp;</div>
<div>
	　■立川校</div>
<div>
	　　① 日曜日 14:30～21:00</div>
<div>
	&nbsp;</div>
<div>
	　■町田校</div>
<div>
	　　① 土曜日 11:00～17:30</div>
<div>
	&nbsp;</div>
<div>
	　■大宮校</div>
<div>
	　　① 日曜日 14:30～21:00</div>
<div>
	&nbsp;</div>
<div>
	　■横浜校</div>
<div>
	　　① 土曜日 14:30～21:00</div>
<div>
	&nbsp;</div>
<div>
	　■仙台校</div>
<div>
	　　① 土曜日 14:30～21:00</div>
<div>
	&nbsp;</div>
<div>
	　■名古屋校</div>
<div>
	　　① 土曜日 11:00～17:30</div>
<div>
	　　② 日曜日 14:30～21:00</div>
<div>
	&nbsp;</div>
<div>
	　■大阪校</div>
<div>
	　　① 水曜日 11:00～17:30</div>
<div>
	　　② 土曜日 14:30～21:00</div>
<div>
	　　③ 日曜日 11:00～17:30</div>
<div>
	&nbsp;</div>
<div>
	　■難波校</div>
<div>
	　　① 土曜日 14:30～21:00</div>
<div>
	&nbsp;</div>
<div>
	　■天王寺校</div>
<div>
	　　① 日曜日 11:00～17:30</div>
<div>
	&nbsp;</div>
<div>
	※ﾚｯｽﾝ校ごとに曜日･時間が異なりますのでご注意ください｡</div>
<div>
	※10月～翌年3月まで､通うﾚｯｽﾝ校･曜日は変わりません｡</div>
<div>
	※年間受講料のみ分割納付可能です｡</div>
<div>
	※弊所を一度退所し､平成30年度より再度入所される方につきましては､入所後の所定の手続きにより､再入所時の入所金の半額を返金（または受講料に充当）させていただきます｡</div>
<div>
	※各ｸﾗｽにおいてご希望の方が少数の場合､ｸﾗｽの開設を見送らせていただく場合がございますので､あらかじめご了承ください｡</div>
<div>
	&nbsp;</div>
<div>
	以上</div>
<div>
	&nbsp;</div>
<div>
	&nbsp;</div>
<div>
	【入所面接日程はこちら】</div>
<div>
	&nbsp;</div>
<div>
	&nbsp;</div>
<div>
	当ｸﾗｽについてご不明な点等がございましたら､お気軽に当所までお問い合わせください｡</div>
<div>
	&nbsp;</div>
<div>
	【お問い合わせ先】</div>
<div>
	　日本ﾅﾚｰｼｮﾝ演技研究所</div>
<div>
	　入所ｾﾝﾀｰ</div>
<div>
	　ＴＥＬ：03-3372-5671</div>
</td>
</tr>
</table>
</div>

<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;">

<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2018/11/'); ?>⇒2018年11月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2018/09/'); ?>⇒2018年9月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2018/07/'); ?>⇒2018年7月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2018/06/'); ?>⇒2018年6月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2018/05/'); ?>⇒2018年5月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2018/04/'); ?>⇒2018年4月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2018/03/'); ?>⇒2018年3月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2017/11/'); ?>⇒2017年11月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2017/09/'); ?>⇒2017年9月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2017/08/'); ?>⇒2017年8月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2017/07/'); ?>⇒2017年7月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2017/06/'); ?>⇒2017年6月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2017/03/'); ?>⇒2017年3月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2016/10/'); ?>⇒2016年10月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2016/09/'); ?>⇒2016年9月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2016/06/'); ?>⇒2016年6月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2016/01/'); ?>⇒2016年1月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2015/11/'); ?>⇒2015年11月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2015/07/'); ?>⇒2015年7月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2015/06/'); ?>⇒2015年6月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2015/04/'); ?>⇒2015年4月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2014/11/'); ?>⇒2014年11月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2014/03/'); ?>⇒2014年3月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2013/12/'); ?>⇒2013年12月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2013/04/'); ?>⇒2013年4月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2012/12/'); ?>⇒2012年12月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2011/11/'); ?>⇒2011年11月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2011/03/'); ?>⇒2011年3月</a></td>
</tr>

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