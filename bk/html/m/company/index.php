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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/company/img/company_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/company/img/company_tit.jpg'))); ?></div>

<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						社 名<br />
						株式会社 日本ﾅﾚｰｼｮﾝ演技研究所<br />
						<br />
						所在地<br />
						&lt;入所ｾﾝﾀｰ/事務局本部&gt;<br />
						東京都渋谷区代々木1-22-1　代々木1丁目ﾋﾞﾙ 12F<br />
						&lt;本社&gt;<br />
						東京都渋谷区代々木1-14-3<br />
						<br />
						TEL:<br />
						03-3372-5671<br />
						<br />
						FAX:<br />
						03-3372-5675<br />
						<br />
						設 立<br />
						1990年2月2日<br />
						<br />
						資本金<br />
						10,000万円<br />
						<br />
						代表者<br />
						代表取締役社長 木村文彦<br />
						<br />
						事業内容<br />
						声優､俳優など､ﾀﾚﾝﾄ養成所の運営および関連事業<br />
						芸能人のﾏﾈｰｼﾞﾒﾝﾄ事業<br />
						ﾃﾚﾋﾞ､ﾗｼﾞｵ番組ｿﾌﾄの企画､制作<br />
						CDなど音楽や音声原盤の企画､制作､販売<br />
						ﾋﾞﾃﾞｵ､DVDなど映像ｿﾌﾄの企画､制作､販売<br />
						書籍､出版物の企画､制作､販売<br />
						劇団の運営および演劇上演事業<br />
						ｲﾝﾀｰﾈｯﾄ関連事業の企画､制作､運営<br />
						<br />
						関連会社<br />
						株式会社ｱｰﾂﾋﾞｼﾞｮﾝ<br />
						株式会社ｱｲﾑｴﾝﾀｰﾌﾟﾗｲｽﾞ<br />
						株式会社ｸﾚｲｼﾞｰﾎﾞｯｸｽ<br />
						株式会社ｳﾞｨﾑｽ<br />
						株式会社ｱﾗｲｽﾞﾌﾟﾛｼﾞｪｸﾄ<br />
						株式会社澪ｸﾘｴｰｼｮﾝ<br />
						<br />
						ｱｸｾｽ<br />
						<?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/0526NN_map_m_HP%E7%94%A8.jpg', 'w' => '222', 'h' => '174', 'display' => 'browser', 'attr' => array('alt' => '0526NN_map_m_HP用.jpg', 'class' => 'mt-image-none', 'height' => '174', 'src' => 'http://nichinare.com/m/0526NN_map_m_HP%E7%94%A8.jpg', 'style' => '', 'width' => '222'))); ?></p>
					<p>
						<?php mtkk_image_tag(array('url' => 'http://nichinare.com/m/center_img.jpg', 'w' => '226', 'h' => '177', 'display' => 'browser', 'attr' => array('alt' => 'center_img.jpg', 'class' => 'mt-image-none', 'height' => '177', 'src' => 'http://nichinare.com/m/center_img.jpg', 'style' => '', 'width' => '226'))); ?></p>
					<p>
						･JR山手線､総武線｢代々木駅｣西口より徒歩3分<br />
						･都営地下鉄大江戸線｢代々木駅｣A1出口より徒歩3分<br />
						･小田急線｢南新宿駅｣より徒歩6分<br />
						･東京ﾒﾄﾛ副都心線｢北参道駅｣より徒歩7分</p>
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