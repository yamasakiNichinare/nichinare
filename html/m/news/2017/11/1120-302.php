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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/news/img/news_tit.jpg', 'w' => '240', 'h' => '20', 'display' => 'browser', 'attr' => array('alt' => '最新情報', 'height' => '20', 'src' => '/m/news/img/news_tit.jpg', 'width' => '240'))); ?></div>

<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; width:10px;"><span style="color:#98d1a9;">■</span></td>
<td valign="top" style="font-size:x-small; text-align:left; color:#4ca778;"><strong>■『ｽﾀｰﾄｱｯﾌﾟｸﾗｽ』新規開設のお知らせ</strong></td>
</tr>
</table>
</div>

<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><p>
	社会で役立つｽｷﾙや人間力の向上を目的とした『ｽﾀｰﾄｱｯﾌﾟｸﾗｽ』２０１８年４月新規開設</p>
<p>
	当所では､これまで多くの受講者が演技のﾚｯｽﾝを通して､<span style="color:#800080;">｢ｺﾐｭﾆｹｰｼｮﾝ能力｣</span>をはじめ､<span style="color:#800080;">｢主体性｣</span>や<span style="color:#800080;">｢積極性｣｢協調性｣｢ﾘｰﾀﾞｰｼｯﾌﾟ｣</span>など､学校や職場で求められる多くのｽｷﾙを身につけ､大きく変化していく姿を長年にわたり見てまいりました｡これらの経験から､演技のﾌﾟﾛをめざす方だけでなく､<span style="color:#800080;">｢社会で役立つｽｷﾙの向上｣</span>や<span style="color:#800080;">｢人前で話すことが苦手｣｢緊張してしまう｣</span>といったことの克服など､<span style="color:#800080;">｢自信をつけたい方｣</span>も含め､より多くの方々に｢演技ﾚｯｽﾝ｣の効果を実感していただける場を提供してまいります｡<br />
	&nbsp;</p>
<p>
	※従来の｢声優ｽﾀｰﾃｨﾝｸﾞｾﾐﾅｰ｣をﾘﾆｭｰｱﾙしたｸﾗｽです｡<br />
	※ｸﾞﾙｰﾌﾟﾌﾟﾛﾀﾞｸｼｮﾝへの所属審査はありません｡<br />
	※一部のﾚｯｽﾝ校を除き､平日での開設となります｡<br />
	※各校定員になり次第締め切らせていただきます｡<br />
	※また､定員に満たない場合は開設されない可能性があります｡</p>
<p>
	[開設時期]<br />
	２０１８年４月<br />
	<br />
	[開設校]<br />
	当所全校<br />
	<br />
	[受講対象年齢]<br />
	中学卒業以上､40歳まで<br />
	<br />
	[ﾚｯｽﾝ回数]<br />
	週１回（演技）<br />
	<br />
	[ﾚｯｽﾝ時間]<br />
	３時間<br />
	<br />
	[入所金]<br />
	２万円<br />
	<br />
	[年間受講料]<br />
	１２万円</p>
<p>
	<a href="http://nichinare.com/m/course/start-up-course.php ">【ｽﾀｰﾄｱｯﾌﾟｸﾗｽのﾍﾟｰｼﾞはこちら】</a></p>
<p>
	ご不明な点等がございましたら､お気軽に当所までお問い合わせください｡<br />
	<br />
	【お問い合わせ先】<br />
	　日本ﾅﾚｰｼｮﾝ演技研究所<br />
	　入所ｾﾝﾀｰ<br />
	　ＴＥＬ：<a href="tel:03-3372-5671">03-3372-5671</a></p>
</td>
</tr>
</table>
</div>

<div style="text-align:left;">
<table border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;">

<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2019/07/'); ?>⇒2019年7月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2019/06/'); ?>⇒2019年6月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2019/03/'); ?>⇒2019年3月</a></td>
</tr>



<tr>
<td valign="top" style="font-size:x-small; text-align:left;"><?php print setQueryString('https://nichinare.com/m/news/2019/02/'); ?>⇒2019年2月</a></td>
</tr>



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