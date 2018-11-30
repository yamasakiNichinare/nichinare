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
					<strong>ﾅﾚｰﾀｰｾﾐﾅｰ</strong></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: center">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					ﾅﾚｰﾀｰの仕事を様々な角度から研究･訓練していくのが｢ﾅﾚｰﾀｰｾﾐﾅｰ｣です｡<br />
					ﾚｯｽﾝは週1回3時間｡社会人の方などは夜間ｸﾗｽで受講して頂く事も可能です｡<br />
					<br />
					当ｾﾐﾅｰのｼｽﾃﾑ<br />
					ﾅﾚｰｼｮﾝ･朗読などを中心にﾎﾞｲｽｻﾝﾌﾟﾙの収録を含めたﾚｯｽﾝを年間を通して行います｡<br />
					週1回ｸﾗｽや週2回ｸﾗｽ､週3回ｸﾗｽとの並行受講も可能で､それらの演技ｸﾗｽと同様にｸﾞﾙｰﾌﾟﾌﾟﾛﾀﾞｸｼｮﾝへの所属をめざす､｢関連会社ｵｰﾃﾞｨｼｮﾝ｣への推薦が行われます｡<br />
					初心者の方は､まず週1回ｸﾗｽ･週2回ｸﾗｽ･週3回ｸﾗｽ､いずれかの｢基礎科｣にて発声･かつ舌等の基礎を少なくとも1年間学んでいただきます｡年度末の進級審査の結果､進級された方のみﾅﾚｰﾀｰｾﾐﾅｰに編入可能となります｡なお､他の養成所や劇団･専門学校等で演技の経験がすでにある方は､ﾅﾚｰﾀｰｾﾐﾅｰから入所をご希望いただくことが可能です｡</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						<?php mtkk_image_tag(array('url' => '/m/course/img/flow_4.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/course/img/flow_4.jpg'))); ?></p>
					<p>
						※平成24年度まで開設しておりました｢初級ｸﾗｽ｣と｢上級ｸﾗｽ｣は､平成25年度より､統合させていただきました｡</p>
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
					<p>
						<span style="color: #98d1a9">★</span><strong>開設校</strong><br />
						･代々木校<br />
						･池袋校(＊)<br />
						･お茶の水校<br />
						･名古屋校<br />
						･大阪校<br />
						<br />
						<span style="color: #98d1a9">★</span><strong>受講対象年齢</strong><br />
						･中学卒業以上､40歳まで<br />
						<br />
						<span style="color: #98d1a9">★</span><strong>入所金</strong><br />
						･10万円(初年度のみ)<br />
						[高校生は5万円となります&lt;平成30年4月改定&gt;(＊1.＊2)]<br />
						<br />
						<span style="color: #98d1a9">★</span><strong>年間受講料</strong><br />
						･4月生/<del>20万円</del> &rArr; <span style="color:#ff0000;"><strong>16万円</strong></span><br />
						└4月から翌年3月までの受講料となります｡<br />
						<span style="color:#ff8c00;">平成28年4月より､年間受講料を上記のとおり改定させていただきます｡</span><br />
						<br />
						＊平成29年度より､池袋校に新規開設いたしました｡<br />
						※上記金額には消費税が含まれています｡<br />
						※当所を一度退所し､平成31年度より再度入所される方につきましては､入所後の所定の手続きにより､再入所時の入所金の半額を返金（または受講料に充当）させていただきます｡<br />
						＊1. ﾚｯｽﾝ開始時点で､学校教育法に定められた全日制･定時制･通信制のいずれかの高等学校に在学されている方（または当所がそれに相当すると認めた方）とさせていただきます｡<br />
						＊2. ｸﾗｽ確定後に所定の書類をご提出いただくこととなります｡<br />
						<br />
						※当ｾﾐﾅｰについてご不明な点等がございましたら､お気軽に当所までお問い合わせください｡<br />
						日ﾅﾚ入所ｾﾝﾀｰ<a href="tel:03-3372-5671">TEL:03-3372-5671</a></p>
				</td>
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