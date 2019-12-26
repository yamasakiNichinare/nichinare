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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/free/img/free_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/free/img/free_tit.jpg'))); ?></div>

<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					日ﾅﾚで行っているﾚｯｽﾝの一部を実際に体験いただくことができます｡また､説明会も同時に行ないます｡<br />
					なお､ﾚｯｽﾝには参加せずに､ご見学いただくことも可能です｡</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left; margin-top: 5px">
	<?php mtkk_image_tag(array('url' => '/m/free/img/free_1.jpg', 'w' => '105', 'h' => '72', 'display' => 'browser', 'attr' => array('height' => '72', 'src' => '/m/free/img/free_1.jpg', 'width' => '105'))); ?></div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<br />
						<span style="color: #98d1a9">■</span>お申し込み方法<br />
						入所案内に同封されている弊所所定の申込書に必要事項をご記入いただき､写真を貼付のうえ､お申し込みください｡追って､ﾚｯｽﾝ会場などの詳細をお送りいたします｡<br />
						<a href="https://nichinare.com/m/request/form.cgi">&rArr;入所案内のお申し込みはこちら（無料）</a></p>
					<p>
						<span style="font-size: xx-small">※受付は先着順となっております｡定員になり次第締め切らせていただく場合がございますので､参加ご希望の方はお早めにお申し込みください｡<br />
						※詳細は､開催日の7日前までに郵送にてご案内いたします｡<br />
						※無料体験ﾚｯｽﾝへの出席は､お一人様につき1回のみとさせていただきます｡<br />
						※<a href="http://nichinare.com/m/course/jr.php">ｼﾞｭﾆｱ声優ｸﾗｽ</a>､および<a href="http://nichinare.com/m/course/narrater.php">ﾅﾚｰﾀｰｾﾐﾅｰ</a>の無料体験ﾚｯｽﾝは現在予定しておりません｡</span></p>
					<p>
						&nbsp;</p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<br />
					<span style="color: #98d1a9">■</span>内容<br />
					基礎科で行う全身を使った演技ﾚｯｽﾝなど<br />
					<br />
					<span style="color: #98d1a9">■</span>受付対象年齢<br />
					中学3年生以上､40歳まで<br />
					<br />
					<span style="color: #98d1a9">■</span>参加条件<br />
					心身ともに健康な方<br />
					<br />
					<span style="color: #98d1a9">■</span>各会場開催日<br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#yoyogi">代々木会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#ikebukuro">池袋会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#ochanomizu">お茶の水会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#tachikawa">立川会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#machida">町田会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#omiya">大宮会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#tokorozawa">所沢会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#chiba">千葉会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#kashiwa">柏会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#yokohama">横浜会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#sendai">仙台会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#nagoya">名古屋会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#kyoto">京都会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#osaka">大阪会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#namba">難波会場</a><br />
					<span style="color: #ff6600">&gt;&gt;</span><a href="#tennoji">天王寺会場</a><br />
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
					<span style="color:#ff0000;">※申込締切日を過ぎている日程につきましてもご案内可能な場合がございますので､ご希望の方はお問い合わせください｡</span></td>
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
					現在､予定しておりません｡その他の会場をご利用ください｡</td>
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
					11月17日（日）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：上記日程での参加をご希望の方は､弊所までお問い合わせください｡</span></p>
				</td>
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
					現在予定しておりません｡その他の会場をご利用ください｡</td>
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
					現在予定しておりません｡その他の会場をご利用ください｡</td>
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
					現在予定しておりません｡その他の会場をご利用ください｡</td>
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
					現在､予定しておりません｡その他の会場をご利用ください｡</td>
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
					現在予定しておりません｡その他の会場をご利用ください｡</td>
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
					現在予定しておりません｡その他の会場をご利用ください｡</td>
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
					現在予定しておりません｡その他の会場をご利用ください｡</td>
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
					11月16日（土）</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<span style="font-size: 80%">&nbsp;&nbsp;締切：上記日程での参加をご希望の方は､弊所までお問い合わせください｡</span></p>
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
					現在予定しておりません｡その他の会場をご利用ください｡</td>
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
					現在予定しておりません｡その他の会場をご利用ください｡</td>
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
					現在予定しておりません｡その他の会場をご利用ください｡</td>
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
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					※お問い合わせは<br />
					日ﾅﾚ入所ｾﾝﾀｰ<a href="tel:03-3372-5671">TEL:03-3372-5671</a>にお電話ください｡</td>
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