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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/course/img/course_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/course/img/course_tit.jpg'))); ?></div>

<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="width: 10px; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span></td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<strong>週2回ｸﾗｽ･週3回ｸﾗｽ</strong></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					ﾏﾙﾁな活動が必要とされてきた声優業界に向けて､週2回ｸﾗｽでは､｢演技｣｢ﾎﾞｰｶﾙ｣のﾚｯｽﾝを週にそれぞれ3時間ずつ､合計6時間のﾚｯｽﾝを行います｡また､週3回ｸﾗｽでは､｢演技｣｢ﾎﾞｰｶﾙ｣｢ﾀﾞﾝｽ｣のﾚｯｽﾝを週にそれぞれ3時間ずつ､合計9時間行います｡<br />
					以下のように進級していくｼｽﾃﾑになっています｡</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left; padding-bottom: 5px; margin-top: 5px; padding-left: 0px; padding-right: 0px; background: #c0e8fa; padding-top: 5px">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					｢基礎科｣...初級ｸﾗｽ<br />
					&nbsp;&nbsp;&nbsp;&nbsp;&darr;<br />
					｢本 科｣...中級ｸﾗｽ<br />
					&nbsp;&nbsp;&nbsp;&nbsp;&darr;<br />
					｢研修科｣...上級ｸﾗｽ</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&rArr;</span><a href="system.php">ﾚｯｽﾝ概要【演技】はこちら</a></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					【ﾎﾞｰｶﾙ】</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p class="normal">
						発声･腹式呼吸等､声を出すことの基本を学び､音を聴き取る力を養います｡また､歌唱訓練を通して自分の声を知り､人前でも大きな声を出せる精神力を身に付けます｡さらに､詞を理解して喜怒哀楽を歌の中で表現できるようになることをめざし､表現力の向上と声のｺﾝﾄﾛｰﾙを学びます｡</p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					【ﾀﾞﾝｽ】</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p class="normal">
						基礎体力および筋力の向上はもちろん､音を聴き取る耳を鍛え､ﾘｽﾞﾑとﾉﾘ､ｽﾃｯﾌﾟ､ﾃｸﾆｯｸの反復練習を行っていくなかで､自分の身体を自在に操れる応用力を養います｡また､芝居における表現力をより豊かにするためにｽｷﾙｱｯﾌﾟを図り､自ら振付けられるようになることをめざします｡</p>
				</td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/course/img/flow_7.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/course/img/flow_7.jpg'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">★</span><strong>2019年度の週2回ｸﾗｽのﾚｯｽﾝ曜日</strong><br />
					･お茶の水校/大阪校<br />
					└①月･金<br />
					└②火･水<br />
					･名古屋校<br />
					└①水･木<br />
					└②水･金<br />
					└③木･金<br />
					<br />
					<span style="color: #98d1a9">★</span><strong>2019年度の週3回ｸﾗｽのﾚｯｽﾝ曜日</strong><br />
					･代々木校<br />
					└①月･水･金<br />
					└②火･木･土<br />
					<br />
					<strong>■週2回ｸﾗｽ概要</strong><br />
					<span style="color: #98d1a9">★</span><strong>開設校</strong><br />
					･お茶の水校/名古屋校(＊)/大阪校<br />
					<span style="color: #98d1a9">★</span><strong>受講対象年齢</strong><br />
					･中学卒業以上､40歳まで<br />
					<span style="color: #98d1a9">★</span><strong>入所金</strong><br />
					･10万円(初年度のみ)<br />
					[高校生は5万円となります&lt;平成30年4月改定&gt;(＊1.＊2)]<br />
					<span style="color: #98d1a9">★</span><strong>年間受講料</strong><br />
					･4月生/36万円<br />
					└4月から翌年3月までの受講料となります｡<br />
					<br />
					<strong>■週3回ｸﾗｽ概要</strong><br />
					<span style="color: #98d1a9">★</span><strong>開設校</strong><br />
					･代々木校(＊)<br />
					<span style="color: #98d1a9">★</span><strong>受講対象年齢</strong><br />
					･中学卒業以上､40歳まで<br />
					<span style="color: #98d1a9">★</span><strong>入所金</strong><br />
					･10万円(初年度のみ)<br />
					[高校生は5万円となります&lt;平成30年4月改定&gt;(＊1.＊2)]<br />
					<span style="color: #98d1a9">★</span><strong>年間受講料</strong><br />
					･4月生/50万円<br />
					└4月から翌年3月までの受講料となります｡<br />
					<br />
					＊平成29年度より､名古屋校の週3回ｸﾗｽは､週2回ｸﾗｽに変更となりました｡<br />
					＊平成29年度より､お茶の水校の週3回ｸﾗｽは､代々木校に統合されました｡<br />
					※上記金額には消費税が含まれています｡<br />
					※弊所を一度退所し､令和2年度より再度入所される方につきましては､入所後の所定の手続きにより､再入所時の入所金の半額を返金（または受講料に充当）させていただきます｡<br />
					＊1. ﾚｯｽﾝ開始時点で､学校教育法に定められた全日制･定時制･通信制のいずれかの高等学校に在学されている方（または弊所がそれに相当すると認めた方）とさせていただきます｡<br />
					＊2. ｸﾗｽ確定後に所定の書類をご提出いただくこととなります｡<br />
					<br />
					※当ｸﾗｽについてご不明な点等がございましたら､お気軽に弊所までお問い合わせください｡<br />
					日ﾅﾚ入所ｾﾝﾀｰ<a href="tel:03-3372-5671">TEL:03-3372-5671</a></td>
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