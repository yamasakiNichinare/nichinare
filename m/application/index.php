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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/application/img/application_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/application/img/application_tit.jpg'))); ?></div>

<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="width: 10px; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span></td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<strong>週1回ｸﾗｽ</strong></td>
			</tr>
			<tr>
				<td style="width: 10px; font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<strong>週2回ｸﾗｽ</strong></td>
			</tr>
			<tr>
				<td style="width: 10px; font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<strong>週3回ｸﾗｽ</strong></td>
			</tr>
			<tr>
				<td style="width: 10px; font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<strong>ﾅﾚｰﾀｰｾﾐﾅｰ</strong></td>
			</tr>
			<tr>
				<td style="width: 10px; font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<strong>ｽﾀｰﾄｱｯﾌﾟｸﾗｽ</strong></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#01">入所面接ｽｹｼﾞｭｰﾙ</a></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong style="color: #4ca778">入所お申し込み方法</strong><br />
					入所案内に同封されている弊所所定の入所申込書に必要事項をご記入いただき､写真を貼付のうえ､お申し込みください｡<br />
					追って､面接会場などの詳細をお送りいたします｡<br />
					<br />
					<a href="https://nichinare.com/m/request/form.cgi">&rArr;入所案内のお申し込みはこちら（無料）</a><br />
					<br />
					※入所審査料/無料<br />
					※受付対象年齢/中学3年生以上､40歳まで<br />
					※審査内容/筆記･実技(ｾﾘﾌ)･面接<br />
					<br />
					入所申込書の返却はできませんので､あらかじめご了承ください｡<br />
					入所後の受講料をあらかじめご確認ください｡<br />
					<br />
					<a href="http://nichinare.com/m/application/tuition.php">&rArr;受講料一覧はこちら</a></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="01" name="01"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong style="color: #4ca778">入所面接ｽｹｼﾞｭｰﾙ</strong></td>
			</tr>
		</tbody>
	</table>
	<table border="0" cellpadding="0" cellspacing="0">
		<tbody>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#yoyogi">代々木会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#ikebukuro">池袋会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#ochanomizu">お茶の水会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#tachikawa">立川会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#machida">町田会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#omiya">大宮会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#tokorozawa">所沢会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#chiba">千葉会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#kashiwa">柏会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#yokohama">横浜会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#sendai">仙台会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#nagoya">名古屋会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#kyoto">京都会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#osaka">大阪会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#namba">難波会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#tennoji">天王寺会場</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#kobe">神戸会場</a></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					2020年度4月生として受講を希望される方の入所面接を下記の日程で行います｡<br />
					ご希望の方は下記｢入所面接ｽｹｼﾞｭｰﾙ｣をご参照のうえ､お申し込みください｡<br />
					<span style="color:#ff8c00;">※ｽﾀｰﾄｱｯﾌﾟｸﾗｽの令和2年度（2020年度）4月生の面接は令和2年（2020年）1月より予定しております｡<br />
					<br />
					※どちらの会場で面接を受けられても､ご希望のﾚｯｽﾝ校をお選びいただけます｡<br />
					(例:代々木会場にて面接&rarr;大阪校へ入所)<br />
					※立川校･大宮校･横浜校の2019年度のﾚｯｽﾝにつきましては､金曜日･土曜日･日曜日のみの開講となっております｡<br />
					※町田校･千葉校･柏校･仙台校･難波校･天王寺校･神戸校の2019年度のﾚｯｽﾝにつきましては､土曜日･日曜日のみの開講となっております｡<br />
					※京都校の2019年度のﾚｯｽﾝにつきましては､月曜日･土曜日･日曜日のみの開講となっております｡</span></td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="yoyogi" name="yoyogi"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>代々木会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月17日（日）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：上記日程での入所面接をご希望の方は､弊所までお問い合わせください｡</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月23日（土･祝）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月13日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月1日（日）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月21日（木）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月14日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：12月4日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月22日（日）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：12月12日（木）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="ikebukuro" name="ikebukuro"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>池袋会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月24日（日）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月14日（木）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月1日（日）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月21日（木）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月15日（日）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：12月5日（木）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="ochanomizu" name="ochanomizu"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>お茶の水会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月30日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月20日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月28日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：12月18日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="tachikawa" name="tachikawa"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>立川会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月21日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：12月11日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="machida" name="machida"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>町田会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月16日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：上記日程での入所面接をご希望の方は､弊所までお問い合わせください｡</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月7日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月27日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="omiya" name="omiya"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>大宮会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月16日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：上記日程での入所面接をご希望の方は､弊所までお問い合わせください｡</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
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
	<a id="tokorozawa" name="tokorozawa"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>所沢会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="font-size: 80%">&nbsp;&nbsp;所沢会場での入所面接は､現在準備中です｡ お急ぎの方は､他会場の入所面接をご利用ください｡</span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="chiba" name="chiba"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>千葉会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;次回は2月を予定しております｡</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：---</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="kashiwa" name="kashiwa"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>柏会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月8日（日）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月28日（木）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="yokohama" name="yokohama"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>横浜会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月30日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月20日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月14日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：12月4日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="sendai" name="sendai"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>仙台会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月23日（土･祝）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月13日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月21日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：12月11日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
	<p>
		&nbsp;</p>
</div>
<p>
	<a id="nagoya" name="nagoya"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>名古屋会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月30日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月20日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月21日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：12月11日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
	<p>
		&nbsp;</p>
</div>
<p>
	<a id="kyoto" name="kyoto"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>京都会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;次回は1月を予定しております｡</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：---</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
	<p>
		&nbsp;</p>
</div>
<p>
	<a id="osaka" name="osaka"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>大阪会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月30日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月20日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月14日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：12月4日（水）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="namba" name="namba"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>難波会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月24日（日）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：11月14日（木）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月15日（日）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：12月5日（木）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="tennoji" name="tennoji"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>天王寺会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					12月22日（日）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：12月12日（木）</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="kobe" name="kobe"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span>神戸会場</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					11月16日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：上記日程での入所面接をご希望の方は､弊所までお問い合わせください｡</span></p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">※各締切日 必着</span></p>
				</td>
			</tr>
		</tbody>
	</table>
	<p>
		&nbsp;</p>
</div>
<p>
	&nbsp;</p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					【注意事項】<br />
					※面接をご希望の方は､｢入所案内｣に同封されております専用の申込書にてお申し込みください｡<br />
					※面接の場所や時間などの詳細につきましては､お申し込み後､面接日の<span style="color: #ff0000">7日前</span>までに郵送にてご連絡する予定となっております｡<br />
					※締め切り日が近づくにつれ､お申し込みが集中し､定員を超えてしまうことがあるため､面接日のご希望に添えなくなる可能性があります｡面接を希望される方はお早めにお申し込みください｡<br />
					※面接日は現時点での予定日とさせていただいておりますので､予告なく変更となる場合がございます｡<br />
					※予定定員を超えた場合､次回の面接日へと振り替えさせていただく可能性がございますので､あらかじめご了承ください｡</td>
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