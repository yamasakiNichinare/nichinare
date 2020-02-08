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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/privacy/img/privacy_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/privacy/img/privacy_tit.jpg'))); ?></div>

<div style="text-align:left;">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top:5px;">
		<tbody>
			<tr>
				<td style="font-size:x-small; text-align:left;" valign="top">
					株式会社日本ﾅﾚｰｼｮﾝ演技研究所は､入所案内や入所関連情報などをご案内差し上げるにあたり､ﾕｰｻﾞｰの皆様の個人情報をご提供いただく場合がございます｡ご提供いただいた個人情報につきましては､以下の内容にて厳重な管理を行います｡<br />
					<br />
					<br />
					<strong>個人情報の取得･保護･管理について</strong><br />
					<br />
					当社は､個人情報の取得の際には､ﾕｰｻﾞｰの皆様に対し取得目的を明らかにいたします｡<br />
					取得した個人情報については､外部からの不正ｱｸｾｽ､個人情報の紛失､破壊､漏えい､改ざんなどの予防並びに是正に努め､適切な管理を行うとともに､外部への流出を防ぐため､最大限の注意を払います｡<br />
					また､取得した個人情報は目的以外の利用及び提供はいたしません｡<br />
					<br />
					<br />
					<strong>ﾃﾞｰﾀの保護について</strong><br />
					<br />
					当社Webｻｲﾄでは､ﾕｰｻﾞｰの皆様の個人情報を収集する際に､入力ﾍﾟｰｼﾞにおいてSSL(Secure Sockets Layer)暗号化技術を用いております｡<br />
					<br />
					<br />
					<strong>ｸｯｷｰ(Cookie)情報などの取り扱いについて</strong><br />
					<br />
					当社ｻｲﾄでは､『ﾔﾌｰ株式会社をはじめとする第三者(以下､第三者)』の提供する広告配信ｻｰﾋﾞｽを利用する場合があり､これに関連して当該第三者が､当社ｻｲﾄを訪問された方のｸｯｷｰ情報(訪問･行動履歴)などを取得し､利用する場合がございます｡<br />
					これらは､ご利用のﾌﾞﾗｳｻﾞからのｱｸｾｽ状況を把握することによってｻｲﾄ改善に役立てる目的にのみ使用しており､ﾌﾟﾗｲﾊﾞｼｰを侵害するものではございません｡<br />
					また､当該第三者によって取得されたｸｯｷｰ情報などは､当該第三者のﾌﾟﾗｲﾊﾞｼｰﾎﾟﾘｼｰに従って取り扱われます｡<br />
					ｸｯｷｰ情報などを利用する当該第三者配信広告は､当該第三者のWebｻｲﾄ内に設けられたｵﾌﾟﾄｱｳﾄﾍﾟｰｼﾞにて配信を停止することができます｡<br />
					<br />
					※ｸｯｷｰとは<br />
					ﾕｰｻﾞｰがｻｲﾄにｱｸｾｽする際にWebﾌﾞﾗｳｻﾞを通してﾕｰｻﾞｰの端末にﾌｧｲﾙ(情報)を格納し､次回ﾕｰｻﾞｰが同一のｻｲﾄにｱｸｾｽする際にﾕｰｻﾞｰを識別できるようにする技術のことです｡ﾌﾞﾗｳｻﾞの設定によりｸｯｷｰの受け入れを停止することもできます｡<br />
					当社で使用するｸｯｷｰには､ﾕｰｻﾞｰの情報(氏名､生年月日､住所､電話番号､ﾒｰﾙｱﾄﾞﾚｽ､ｸﾚｼﾞｯﾄｶｰﾄﾞ情報など)は含まれておりません｡<br />
					<br />
					<br />
					&lt;お問い合わせ窓口&gt;<br />
					TEL : 03-3372-5671<br />
					受付日時:月～日/10:00～19:00<br />
					〒151-0053<br />
					東京都渋谷区代々木1-22-1　代々木1丁目ﾋﾞﾙ 12F<br />
					株式会社 日本ﾅﾚｰｼｮﾝ演技研究所</td>
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