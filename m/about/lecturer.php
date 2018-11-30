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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/about/img/about_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/about/img/about_tit.jpg'))); ?></div>

<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="width: 10px; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span></td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<span style="color: #000000"><strong>講師一覧</strong></span></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#tokyo">代々木校･池袋校･お茶の水校･立川校･町田校･大宮校･千葉校･柏校･横浜校･仙台校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#osaka">京都校･大阪校･難波校･天王寺校･神戸校</a></td>
			</tr>
			<tr>
				<td style="font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#nagoya">名古屋校</a></td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	<a id="tokyo" name="tokyo"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #4ca778"><strong>■代々木校･池袋校･お茶の水校･立川校･町田校･大宮校･千葉校･柏校･横浜校･仙台校</strong></span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					◎演技<br />
					蒼波　樹里（俳優）<br />
					秋保　佐永子（声優･ﾅﾚｰﾀｰ）<br />
					朝倉　栄介（声優･俳優）<br />
					天野　由梨（俳優･声優）<br />
					荒川　大三朗（俳優･演出家）<br />
					荒山　昌子（俳優･劇作家･演出家）<br />
					有馬　瑞香（俳優･声優）<br />
					飯島　晶子（俳優･声優･ﾅﾚｰﾀｰ）<br />
					伊沢　弘（俳優･演出家）<br />
					石井　ゆかり（俳優･声優）<br />
					石井　一貴（声優･ﾅﾚｰﾀｰ）<br />
					井上　悟（俳優･声優）<br />
					岩崎　了（声優･俳優）<br />
					岩瀬　浩司（劇作家･演出家）<br />
					植原　みゆき（俳優･声優･ﾅﾚｰﾀｰ）<br />
					大杉　祐（演出家･作家）<br />
					太田　五葵（声優）<br />
					押田　浩幸（俳優･声優）<br />
					小沼　朝生（俳優･著述家）<br />
					小野　砂織（俳優）<br />
					狩野　茉莉（俳優･声優）<br />
					神田　和佳（俳優･声優･ﾅﾚｰﾀｰ）<br />
					神原　大地（声優）<br />
					菊池　幸利（俳優･声優）<br />
					河本　明子（声優･ﾅﾚｰﾀｰ）<br />
					坂木　崇彦（俳優）<br />
					榊原　望（声優･ﾅﾚｰﾀｰ）<br />
					笹木　彰人（映画監督･演出家）<br />
					佐野　和敏（俳優）<br />
					佐野　尚美（声優･ﾅﾚｰﾀｰ）<br />
					志賀　克也（俳優･声優）<br />
					志乃宮　風子（俳優･声優）<br />
					白貝　真理子（俳優）<br />
					白山　照彦（俳優）<br />
					菅原　淳一（俳優･声優）<br />
					鈴木　健太（演出家･俳優）<br />
					須藤　沙織（俳優･声優）<br />
					高城　元気（俳優･声優）<br />
					高橋　沙織（声優･俳優･ﾅﾚｰﾀｰ）<br />
					田毎　なつみ（声優･ﾅﾚｰﾀｰ）<br />
					田中　明生（俳優）<br />
					田村　健亮（声優･ﾅﾚｰﾀｰ）<br />
					近村　望実（声優･ﾅﾚｰﾀｰ）<br />
					土屋　ﾄｼﾋﾃﾞ（声優･ﾅﾚｰﾀｰ）<br />
					綱掛　裕美（声優･俳優）<br />
					鶴岡　修（俳優）<br />
					冨樫　真（俳優）<br />
					利根　健太朗（声優･俳優）<br />
					直井　修一（演出家）<br />
					中込　俊太郎（俳優･演出家）<br />
					長嶝　高士（俳優･声優）<br />
					中村　伸一（声優･俳優）<br />
					ならはし　みき（俳優･声優）<br />
					成家　義哉（俳優･声優･演出家）<br />
					鳴瀬　まみ（声優･俳優･ﾅﾚｰﾀｰ）<br />
					野中　秀哲（声優）<br />
					羽飼　まり（声優･ﾅﾚｰﾀｰ）<br />
					萩　道彦（俳優･声優）<br />
					早水　ﾘｻ（俳優･声優）<br />
					原田　ﾏｻｵ（声優･ﾅﾚｰﾀｰ）<br />
					春宮　茉由（声優･ﾅﾚｰﾀｰ）<br />
					疋田　涼子（声優･ﾅﾚｰﾀｰ）<br />
					一杉　佳澄（俳優･声優）<br />
					福島　潤（俳優･声優）<br />
					藤丸　亮（俳優･演出家･脚本家）<br />
					伏見　哲夫（俳優）<br />
					星野　充昭（俳優･声優）<br />
					細井　治（俳優･声優）<br />
					松下　美由紀（俳優･声優）<br />
					三留　奈奈（俳優）<br />
					三村　聡（俳優）<br />
					宮永　恵太（声優･俳優）<br />
					望月　健一（俳優･声優）<br />
					門田　幸子（声優･俳優･ﾅﾚｰﾀｰ）<br />
					吉住　梢（声優）<br />
					吉野　恵美子（俳優）<br />
					<br />
					◎ﾎﾞｰｶﾙ<br />
					秋山　信雄（ﾎﾞｲｽﾄﾚｰﾅｰ）<br />
					斉藤　ﾊﾙｺ（ﾎﾞｲｽﾄﾚｰﾅｰ）<br />
					畠　栄子（ﾎﾞｲｽﾄﾚｰﾅｰ･舞台女優）<br />
					吉村　敦子（ﾎﾞｲｽﾄﾚｰﾅｰ･舞台女優）<br />
					<br />
					◎ﾀﾞﾝｽ<br />
					伊賀　康成（振付師）<br />
					石川　ゆみ（ﾀﾞﾝｻｰ･振付師）<br />
					塩坪　和馬（ﾀﾞﾝｻｰ）<br />
					山見　竜次（ﾀﾞﾝｻｰ）</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="osaka" name="osaka"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #4ca778"><strong>■京都校･大阪校･難波校･天王寺校･神戸校</strong></span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					◎演技<br />
					旭 麻里（脚本家･演出家･振付師）<br />
					熱田　史枝（俳優･演出家･劇作家）<br />
					井之上 淳（俳優･演出家）<br />
					岡部 尚子（俳優･演出家）<br />
					垣尾 麻美（俳優･声優）<br />
					加島 幹也（映像監督）<br />
					川内田　有美（俳優･声優）<br />
					川枝 浩和（俳優）<br />
					北川 隆一（俳優･演出家）<br />
					草壁　晶子（俳優）<br />
					西前 忠久（俳優･声優）<br />
					斉藤 幸恵（俳優･声優）<br />
					下間 都代子（ﾅﾚｰﾀｰ･声優）<br />
					谷　省吾（俳優･演出家）<br />
					根井 保博（俳優）<br />
					秦 真由美（声優･ﾅﾚｰﾀｰ･俳優）<br />
					羽田　理映（ﾅﾚｰﾀｰ･女優）<br />
					早川　丈二（俳優）<br />
					東村 晃幸（俳優）<br />
					一柳 俊之（演出家）<br />
					堀部　由加里（俳優）<br />
					南　志保（俳優）<br />
					森田 有美（俳優･声優）<br />
					<br />
					◎ﾎﾞｰｶﾙ<br />
					田中　あつ子（歌手･女優）<br />
					山﨑 潤（ﾎﾞｰｶﾘｽﾄ･ﾎﾞｲｽﾄﾚｰﾅｰ）</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="nagoya" name="nagoya"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #4ca778"><strong>■名古屋校</strong></span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					◎演技<br />
					上田 定行（ﾅﾚｰﾀｰ･俳優）<br />
					小椋 美季（俳優･ﾅﾚｰﾀｰ）<br />
					黒河内　彩（俳優）<br />
					小松 肇（放送ﾀﾚﾝﾄ）<br />
					新納 貴子（俳優）<br />
					東方 るい（俳優）<br />
					中川 ひろき（俳優）<br />
					中根 江深（俳優･声優）<br />
					はせ ひろいち（劇作家･演出家）<br />
					松本 喜臣（俳優･劇作家･演出家）<br />
					山科 淳司（俳優）<br />
					<br />
					◎ﾎﾞｲｽﾄﾚｰﾆﾝｸﾞ<br />
					まほろば 遊（ﾎﾞｰｶﾙｲﾝｽﾄﾗｸﾀｰ･ｼﾝｶﾞｰｿﾝｸﾞﾗｲﾀｰ）<br />
					森　拓磨（ｻｳﾝﾄﾞｸﾘｴｰﾀｰ）<br />
					<br />
					※その他､臨時講師等､一部掲載していない講師もおります｡</td>
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