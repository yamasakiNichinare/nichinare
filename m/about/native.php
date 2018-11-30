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
				<td style="width: 10px; font-size: 16px" valign="top">
					<span style="color: #98d1a9">■</span></td>
				<td style="text-align: left; font-size: 16px" valign="top">
					<span style="color: #000000"><strong>主な出身者一覧</strong></span></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 16px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong>出身者検索</strong></td>
			</tr>
		</tbody>
	</table>
	<table style="background: #666666">
		<tbody>
			<tr>
				<td style="background: #faf7c0">
					<div style="text-align: left; padding-bottom: 5px; padding-left: 5px; padding-right: 5px; font-size: x-small; padding-top: 5px">
						<a href="#a">あ行</a>　<a href="#ka">か行</a>　<a href="#sa">さ行</a>　<a href="#ta">た行</a>　<a href="#na">な行</a>　<a href="#ha">は行</a><br />
						<a href="#ma">ま行</a>　<a href="#ya">や行</a>　<a href="#ra">ら行</a>　<a href="#wa">わ行</a></div>
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
					※ｱｲｺﾝ説明<br />
					<span style="color: #6699ff">●</span>ｱｰﾂﾋﾞｼﾞｮﾝ所属者<br />
					<span style="color: #00cc99">●</span>ｱｲﾑｴﾝﾀｰﾌﾟﾗｲｽﾞ所属者<br />
					<span style="color: #ff6666">●</span>ｳﾞｨﾑｽ所属者<br />
					<span style="color: #ff9933">●</span>ｸﾚｲｼﾞｰﾎﾞｯｸｽ所属者<br />
					<span style="color: #9966ff">●</span>澪ｸﾘｴｰｼｮﾝ所属者<br />
					<span style="color: #a4c400">●</span>ｱﾗｲｽﾞﾌﾟﾛｼﾞｪｸﾄ所属者<br />
					<span style="color: #808080">●</span>その他事務所所属等</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					ｱﾆﾒ･ｹﾞｰﾑ･洋画･ﾗｼﾞｵなど､様々なﾌｨｰﾙﾄﾞで活躍する出身者｡</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<a id="a" name="a"></a>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong>■あ行</strong></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #6699ff">●</span>相田 さやか<br />
					ｶｰﾄﾞﾌｧｲﾄ!!ｳﾞｧﾝｶﾞｰﾄﾞ ｱｼﾞｱｻｰｷｯﾄ編(ｽｽﾞﾒ･ｴﾝﾄﾞｳ)<br />
					<span style="color: #00cc99">●</span>赤尾 ひかる<br />
					こみっくがｰるず(萌田薫子)<br />
					<span style="color: #808080">●</span>浅川 悠<br />
					ﾉﾌﾞﾅｶﾞﾝ(ｱｲｻﾞｯｸ･ﾆｭｰﾄﾝ)<br />
					<span style="color: #6699ff">●</span>浅倉 杏美<br />
					ﾊｲｽｸｰﾙD&times;D(ｱｰｼｱ･ｱﾙｼﾞｪﾝﾄ)<br />
					<span style="color: #ff9933">●</span>安部 憲人<br />
					世界一受けたい授業(ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #ff6666">●</span>阿部 里果<br />
					ｱｲﾄﾞﾙﾏｽﾀｰ ﾐﾘｵﾝﾗｲﾌﾞ！(真壁瑞希)<br />
					<span style="color: #00cc99">●</span>天崎 滉平<br />
					機動戦士ｶﾞﾝﾀﾞﾑ 鉄血のｵﾙﾌｪﾝｽﾞ(ﾀｶｷ･ｳﾉ)<br />
					<span style="color: #6699ff">●</span>天野 由梨<br />
					ｷﾗｷﾗ☆ﾌﾟﾘｷｭｱｱﾗﾓｰﾄﾞ(琴爪しの)<br />
					<span style="color: #00cc99">●</span>綾瀬 有<br />
					ﾌﾚｰﾑｱｰﾑｽﾞ･ｶﾞｰﾙ(ｽﾃｨﾚｯﾄ)<br />
					<span style="color: #00cc99">●</span>飯田友子<br />
					新あたしﾝち(しみちゃん)<br />
					<span style="color: #00cc99">●</span>石川 桃子<br />
					裏切りは僕の名前を知っている(ｿﾄﾞﾑ)<br />
					<span style="color: #6699ff">●</span>石塚 さより<br />
					ﾀﾞﾝﾎﾞｰﾙ戦機ｳｫｰｽﾞ(星原ﾋｶﾙ)<br />
					<span style="color: #ff6666">●</span>市川 太一<br />
					ｶﾌﾞｷﾌﾞ！（来栖黒悟）<br />
					<span style="color: #808080">●</span>伊月 ゆい<br />
					D.C.S.S.(水越萌)<br />
					<span style="color: #6699ff">●</span>井上 悟<br />
					機動戦士ｶﾞﾝﾀﾞﾑAGE(連邦軍ｵﾍﾟﾚｰﾀ)<br />
					<span style="color: #00cc99">●</span>岩井 映美里<br />
					ﾄﾐｶﾊｲﾊﾟｰﾚｽｷｭｰ ﾄﾞﾗｲﾌﾞﾍｯﾄﾞ 機動救急警察(春野かすみ)<br />
					<span style="color: #6699ff">●</span>岩崎 了<br />
					ｲﾅｽﾞﾏｲﾚﾌﾞﾝ GO ｸﾛﾉ･ｽﾄｰﾝ(錦龍馬)<br />
					<span style="color: #00cc99">●</span>岩澤 俊樹<br />
					剣王朝(陳監首)<br />
					<span style="color: #808080">●</span>岩見 聖次<br />
					AKBINGO!(ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #00cc99">●</span>岩山 ちひろ<br />
					ﾉﾌﾞﾅｶﾞ･ｻﾞ･ﾌｰﾙ（ｴｲ）<br />
					<span style="color: #00cc99">●</span>植田 佳奈<br />
					Fate/stay night(遠坂凛)<br />
					<span style="color: #6699ff">●</span>植原 みゆき<br />
					仙界伝･封神演義(賈氏)<br />
					<span style="color: #00cc99">●</span>内田 真礼<br />
					中二病でも恋がしたい！(小鳥遊六花)<br />
					<span style="color: #00cc99">●</span>内田 雄馬<br />
					BANANA FISH(ｱｯｼｭ･ﾘﾝｸｽ)<br />
					<span style="color: #ff6666">●</span>内村 史子<br />
					銃皇無尽のﾌｧﾌﾆｰﾙ(ﾚﾝ･ﾐﾔｻﾞﾜ)<br />
					<span style="color: #808080">●</span>内山 夕実<br />
					ﾃﾞｼﾞﾓﾝﾕﾆﾊﾞｰｽ ｱﾌﾟﾘﾓﾝｽﾀｰｽﾞ(新海ﾊﾙ)<br />
					<span style="color: #6699ff">●</span>梅原 裕一郎<br />
					銀河英雄伝説 Die Neue These 邂逅(ｼﾞｰｸﾌﾘｰﾄﾞ･ｷﾙﾋｱｲｽ)<br />
					<span style="color: #ff9933">●</span>江尻 拓己<br />
					ｱｲﾄﾞﾙ★ﾘｰｸﾞ(ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #6699ff">●</span>太田 五葵<br />
					ﾊﾞﾄﾙｽﾋﾟﾘｯﾂ ｿｰﾄﾞｱｲｽﾞ(ﾅｵﾔ)<br />
					<span style="color: #a4c400">●</span>太田 悠介<br />
					ﾚｺﾞ ﾈｯｸｽﾅｲﾂ（ｸﾚｲ･ﾓｰﾘﾝﾄﾝ）<br />
					<span style="color: #00cc99">●</span>大西 沙織<br />
					刀使ﾉ巫女(十条姫和)<br />
					<span style="color: #6699ff">●</span>岡本 嘉子<br />
					ﾓﾉｸﾛｰﾑ･ﾌｧｸﾀｰ(緋沼水絵)<br />
					<span style="color: #00cc99">●</span>小澤 亜李<br />
					Caligula -ｶﾘｷﾞｭﾗ-(守田鳴子)<br />
					<span style="color: #a4c400">●</span>小野寺 瑠奈<br />
					想いのかけら(杏子)<br />
					<span style="color: #808080">●</span>小峰 華子<br />
					ﾗﾌﾞﾗｲﾌﾞ！ｻﾝｼｬｲﾝ!!<br />
					<span style="color: #00cc99">●</span>折戸 ﾏﾘ<br />
					ｽﾗｯﾌﾟｱｯﾌﾟﾊﾟｰﾃｨｰ-ｱﾗﾄﾞ戦記-(ﾌﾟﾛﾍﾝ)</td>
			</tr>
		</tbody>
	</table>
	<a id="ka" name="ka"></a>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong>■か行</strong></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6666">●</span>梶 裕貴<br />
					進撃の巨人(ｴﾚﾝ･ｲｪｰｶﾞｰ)<br />
					<span style="color: #00cc99">●</span>花倉 洸幸<br />
					文豪ｽﾄﾚｲﾄﾞｯｸﾞｽ（宮沢賢治）<br />
					<span style="color: #808080">●</span>和 優希<br />
					魔女たちの22時(ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #ff9933">●</span>加藤 ﾙｲ<br />
					５ＬＤＫ(ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #6699ff">●</span>狩野 茉莉<br />
					＋ﾁｯｸ姉さん(姉さん)<br />
					<span style="color: #a4c400">●</span>鎌倉 有那<br />
					遊☆戯☆王VRAINS(別所ｴﾏ / ｺﾞｰｽﾄｶﾞｰﾙ)<br />
					<span style="color: #ff6666">●</span>河井 晴菜<br />
					ﾗﾌﾞﾗｲﾌﾞ！ｻﾝｼｬｲﾝ!!<br />
					<span style="color: #6699ff">●</span>河瀬 茉希<br />
					ひそねとまそたん(星野絵瑠)<br />
					<span style="color: #00cc99">●</span>神原 大地<br />
					ｱｲﾄﾞﾙﾏｽﾀｰSideM(伊集院北斗)<br />
					<span style="color: #ff6666">●</span>菊池 幸利<br />
					ﾚｺﾞ ﾈｯｸｽﾅｲﾂ(ﾗﾝｽ･ﾘｯﾁﾓﾝﾄﾞ)<br />
					<span style="color: #6699ff">●</span>木野 智香<br />
					鋼の錬金術師(母親役)<br />
					<span style="color: #00cc99">●</span>木野 双葉<br />
					ﾚｰｶﾝ！(顔なし霊)<br />
					<span style="color: #ff6666">●</span>木村 千咲<br />
					はるかなﾚｼｰﾌﾞ(大城あかり)<br />
					<span style="color: #6699ff">●</span>久保田 ひかり<br />
					名探偵ｺﾅﾝ<br />
					<span style="color: #808080">●</span>倉田 雅世<br />
					ﾌｧﾝﾀｼﾞｽﾀﾄﾞｰﾙ(鵜野みこと)<br />
					<span style="color: #ff9933">●</span>黒田 ひとみ<br />
					魔女たちの22時(ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #00cc99">●</span>桑谷 夏子<br />
					ﾛｰｾﾞﾝﾒｲﾃﾞﾝ(翠星石)<br />
					<span style="color: #808080">●</span>桑原 敬一<br />
					銀魂(篠原進之進)<br />
					<span style="color: #6699ff">●</span>河本 明子<br />
					ｱｽﾄﾛﾎﾞｰｲ鉄腕ｱﾄﾑ(ｴﾅ)<br />
					<span style="color: #6699ff">●</span>國分 和人<br />
					宇宙戦艦ﾔﾏﾄ2199(相原義一)</td>
			</tr>
		</tbody>
	</table>
	<a id="sa" name="sa"></a>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong>■さ行</strong></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #00cc99">●</span>斎藤 千和<br />
					魔法少女まどか☆ﾏｷﾞｶ(暁美ほむら)<br />
					<span style="color: #808080">●</span>斉藤 幸恵<br />
					♂ﾓｯﾄ!!恋愛主義♀(双葉成穂)<br />
					<span style="color: #6699ff">●</span>榊原 望<br />
					彩雲国物語の世界(ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #808080">●</span>佐久間 紅美<br />
					最近､妹のようすがちょっとおかしいんだが｡(明坂七海)<br />
					<span style="color: #00cc99">●</span>佐倉 綾音<br />
					新幹線変形ﾛﾎﾞ ｼﾝｶﾘｵﾝ THE ANIMATION(速杉ﾊﾔﾄ)<br />
					<span style="color: #6699ff">●</span>櫻庭 有紗<br />
					Just Because!(乾依子)<br />
					<span style="color: #6699ff">●</span>笹沼 尭羅<br />
					ｲﾅｽﾞﾏｲﾚﾌﾞﾝGOｸﾛﾉ･ｽﾄｰﾝ(ｳﾞｧﾝﾌｪﾆｰ･ｳﾞｧﾝﾌﾟ)<br />
					<span style="color: #00cc99">●</span>篠原 侑<br />
					ﾒﾙﾍﾝ･ﾒﾄﾞﾍﾝ(李雪蘭)<br />
					<span style="color: #808080">●</span>笹本 優子<br />
					ｺﾛｯｹ!(ﾒﾝﾁ)<br />
					<span style="color: #ff9933">●</span>佐藤 英恵<br />
					ｳﾘﾅﾘ社交ﾀﾞﾝｽ部(ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #6699ff">●</span>椎名 へきる<br />
					地獄少女 宵伽(山童)<br />
					<span style="color: #6699ff">●</span>志賀 克也<br />
					ﾊﾞﾄﾙｽﾋﾟﾘｯﾂ ｿｰﾄﾞｱｲｽﾞ(ｺｰﾈﾙ)<br />
					<span style="color: #ff6666">●</span>篠田 みなみ<br />
					亜人ちゃんは語りたい（町京子）<br />
					<span style="color: #6699ff">●</span>志乃宮 風子<br />
					名探偵ｺﾅﾝ(万田鈴)<br />
					<span style="color: #6699ff">●</span>清水 俊彦<br />
					ｽｺｰﾋﾟｵﾝ･ｷﾝｸﾞ(ﾉｱ)<br />
					<span style="color: #6699ff">●</span>下田 麻美<br />
					THE IDOLM@STER(双海亜美･真美)<br />
					<span style="color: #00cc99">●</span>下野 紘<br />
					うたの☆ﾌﾟﾘﾝｽさまっ♪(来栖翔)<br />
					<span style="color: #808080">●</span>下和田 ﾋﾛｷ<br />
					緋色の欠片(犬戒慎司)<br />
					<span style="color: #6699ff">●</span>白城 なお<br />
					ﾌﾞﾚｲﾌﾞｳｨｯﾁｰｽﾞ<br />
					<span style="color: #6699ff">●</span>菅原 祥子<br />
					ﾎﾟｹｯﾄﾓﾝｽﾀｰ(ﾐﾕｷ)<br />
					<span style="color: #00cc99">●</span>洲崎 綾<br />
					ｼﾄﾞﾆｱの騎士 第九惑星戦役(白羽衣つむぎ)<br />
					<span style="color: #00cc99">●</span>鈴木 達央<br />
					Free!(橘真琴)<br />
					<span style="color: #808080">●</span>鈴木 千尋<br />
					熱風海陸ﾌﾞｼﾛｰﾄﾞ(ﾏｴﾀﾞ=ｶｶﾞﾄ)<br />
					<span style="color: #808080">●</span>鈴村 健一<br />
					うたの☆ﾌﾟﾘﾝｽさまっ♪ﾏｼﾞLOVE2000%(聖川真斗)<br />
					<span style="color: #6699ff">●</span>須藤 沙織<br />
					怪盗ｼﾞｮｰｶｰ ｼｰｽﾞﾝ2(ﾕｲ)<br />
					<span style="color: #6699ff">●</span>諏訪 彩花<br />
					あっくんとｶﾉｼﾞｮ(片桐のん)<br />
					<span style="color: #ff9933">●</span>瀬名波 仁菜<br />
					魔女たちの22時(ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #00cc99">●</span>千本木 彩花<br />
					甲鉄城のｶﾊﾞﾈﾘ(無名)</td>
			</tr>
		</tbody>
	</table>
	<a id="ta" name="ta"></a>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong>■た行</strong></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6666">●</span>大地 葉<br />
					ﾍﾞｲﾌﾞﾚｰﾄﾞﾊﾞｰｽﾄ 超ｾﾞﾂ(蒼井常夏)<br />
					<span style="color: #00cc99">●</span>高城 元気<br />
					宇宙戦艦ﾔﾏﾄ2199(星名透)<br />
					<span style="color: #6699ff">●</span>高階 俊嗣<br />
					宇宙兄弟(伊東凛平)<br />
					<span style="color: #6699ff">●</span>高梨 謙吾<br />
					ｶﾞﾝﾊﾞﾚｰ部NEXT!(山内晶大)<br />
					<span style="color: #00cc99">●</span>髙野 麻美<br />
					ｱｲﾄﾞﾙﾏｽﾀｰ ｼﾝﾃﾞﾚﾗｶﾞｰﾙｽﾞ劇場(宮本ﾌﾚﾃﾞﾘｶ)<br />
					<span style="color: #6699ff">●</span>ﾀｶﾊｼ ｻｦﾘ<br />
					愛してると言って(ｳﾙﾁｪ)<br />
					<span style="color: #6699ff">●</span>高橋 めぐる<br />
					ﾌﾞﾚｲﾌﾞﾋﾞｰﾂ(風車響)<br />
					<span style="color: #00cc99">●</span>滝田 樹里<br />
					THE IDOLM@STER(音無小鳥)<br />
					<span style="color: #6699ff">●</span>瀧本 富士子<br />
					とある飛空士への恋歌(ｱﾒﾘｱ･ｾﾙﾊﾞﾝﾃｽ)<br />
					<span style="color: #6699ff">●</span>武内 健<br />
					坂本ですが？(まりお)<br />
					<span style="color: #6699ff">●</span>竹内 良太<br />
					魔法使いの嫁(ｴﾘｱｽ･ｴｲﾝｽﾞﾜｰｽ)<br />
					<span style="color: #6699ff">●</span>武田 幸史<br />
					黒子のﾊﾞｽｹ(岡村健一)<br />
					<span style="color: #00cc99">●</span>武田 羅梨沙 多胡<br />
					僕の彼女がﾏｼﾞﾒ過ぎるしょびっちな件(有山雫)<br />
					<span style="color: #808080">●</span>竹達 彩奈<br />
					けいおん!(中野梓)<br />
					<span style="color: #6699ff">●</span>橘 ひかり<br />
					ＤＴｴｲﾄﾛﾝ(ｴﾄﾞﾘｰ)<br />
					<span style="color: #6699ff">●</span>巽 悠衣子<br />
					探偵ﾁｰﾑKZ事件ﾉｰﾄ(立花彩)<br />
					<span style="color: #00cc99">●</span>伊達 忠智<br />
					政宗くんのﾘﾍﾞﾝｼﾞ(俵田ﾏｻﾙ)<br />
					<span style="color: #ff9933">●</span>田中 美幸<br />
					世界の村で発見！こんなところに日本人(ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #6699ff">●</span>谷口 淳志<br />
					ﾊﾞｯﾃﾘｰ（磯部悠哉）<br />
					<span style="color: #6699ff">●</span>谷口 夢奈<br />
					Code:Realize 〜創世の姫君〜(ｴﾃｨ)<br />
					<span style="color: #00cc98">●</span>田村 睦心<br />
					ﾓﾝｽﾀｰﾊﾝﾀｰ ｽﾄｰﾘｰｽﾞ RIDE ON(ﾘｭｰﾄ)<br />
					<span style="color: #808080">●</span>田村 ゆかり<br />
					魔法少女ﾘﾘｶﾙなのは(高町なのは)<br />
					<span style="color: #00cc98">●</span>丹沢 晃之<br />
					血界戦線 &amp; BEYOND(ﾇｽﾞﾙﾊﾞ)<br />
					<span style="color: #6699ff">●</span>近村 望実<br />
					神のみぞ知るｾｶｲ 女神篇(寺田京)<br />
					<span style="color: #6699ff">●</span>土屋 ﾄｼﾋﾃﾞ<br />
					ﾌｧｲ･ﾌﾞﾚｲﾝ 神のﾊﾟｽﾞﾙ(大門ｱｷﾗ)<br />
					<span style="color: #00cc99">●</span>続木 友子<br />
					ﾄﾞﾘﾌﾀｰｽﾞ（ﾏﾙｸ）<br />
					<span style="color: #00cc99">●</span>綱掛 裕美<br />
					双恋(桜月ﾕﾗ)<br />
					<span style="color: #6699ff">●</span>手塚 ちはる<br />
					陰陽大戦記(ｵｵｽﾐ)<br />
					<span style="color: #808080">●</span>東山 奈央<br />
					ﾆｾｺｲ(桐崎千棘)<br />
					<span style="color: #00cc99">●</span>利根 健太朗<br />
					ﾆﾙ･ｱﾄﾞﾐﾗﾘの天秤(葦切拓真)<br />
					<span style="color: #ff6666">●</span>泊 明日菜<br />
					ﾊﾟｽﾞﾄﾞﾗ(明石ﾀｲｶﾞ)<br />
					<span style="color: #6699ff">●</span>鳥海 浩輔<br />
					うたの☆ﾌﾟﾘﾝｽさまっ♪(愛島ｾｼﾙ)</td>
			</tr>
		</tbody>
	</table>
	<a id="na" name="na"></a>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong>■な行</strong></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff9933">●</span>永坂 みゆき<br />
					快脳！ﾏｼﾞかるﾊﾃﾅ(ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #6699ff">●</span>長嶝 高士<br />
					鬼灯の冷徹(閻魔大王)<br />
					<span style="color: #808080">●</span>中芝 綾<br />
					演技集団 我が街･｢命美わし｣<br />
					<span style="color: #00cc99">●</span>長縄 まりあ<br />
					はたらく細胞(血小板)<br />
					<span style="color: #00cc99">●</span>中原 麻衣<br />
					剣王朝(夜策冷)<br />
					<span style="color: #ff9933">●</span>中道 美穂子<br />
					ちはやふる(若宮詩暢)<br />
					<span style="color: #6699ff">●</span>中村 繪里子<br />
					ｺﾝｸﾘｰﾄ･ﾚﾎﾞﾙﾃｨｵ～超人幻想～(風郎太)<br />
					<span style="color: #6699ff">●</span>中村 公子<br />
					ｽﾍﾟｷｭﾀｸﾗｰ ｽﾊﾟｲﾀﾞｰﾏﾝ(ｻﾘｰ)<br />
					<span style="color: #00cc99">●</span>永塚 拓馬<br />
					Butlers〜千年百年物語〜(青葉蛍)<br />
					<span style="color: #00cc99">●</span>成家 義哉<br />
					花ざかりの君たちへ(ﾁｬ･ｳﾝｷﾞｮﾙ)<br />
					<span style="color: #6699ff">●</span>鳴瀬 まみ<br />
					THE SPEAK(ｴﾙｻ)<br />
					<span style="color: #ff6666">●</span>新名 彩乃<br />
					STAR DRIVER-輝きのﾀｸﾄ-(ﾜﾀﾅﾍﾞ･ｶﾅｺ)<br />
					<span style="color: #00cc99">●</span>仁後 真耶子<br />
					THE IDOLM@STER(高槻やよい)<br />
					<span style="color: #6699ff">●</span>新田 ひより<br />
					七つの美徳(ｶﾞﾌﾞﾘｴﾙ)<br />
					<span style="color: #6699ff">●</span>沼倉 愛美<br />
					ｶﾞﾝﾀﾞﾑﾋﾞﾙﾄﾞﾀﾞｲﾊﾞｰｽﾞ(ｱﾔﾒ)<br />
					<span style="color: #ff6666">●</span>野上 翔<br />
					ｱｲﾄﾞﾙﾏｽﾀｰ SideM(伊瀬谷四季)<br />
					<span style="color: #6699ff">●</span>野口 瑠璃子<br />
					SHOW BY ROCK!!#（ｱｲﾚｰﾝ）<br />
					<span style="color: #6699ff">●</span>野中 秀哲<br />
					ｹﾛﾛ軍曹(ｽﾈｰｸ)<br />
					<span style="color: #ff6666">●</span>野村 真悠華<br />
					ﾓﾝｽﾀｰ娘のいる日常(ｽｰ)</td>
			</tr>
		</tbody>
	</table>
	<a id="ha" name="ha"></a>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong>■は行</strong></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #6699ff">●</span>羽飼 まり<br />
					もののけ島のﾅｷ(ｺﾞｯﾁｰ)<br />
					<span style="color: #6699ff">●</span>萩 道彦<br />
					双恋(西本)<br />
					<span style="color: #ff6666">●</span>橋本 ちなみ<br />
					Lostorage conflated WIXOSS(穂村すず子)<br />
					<span style="color: #6699ff">●</span>長谷川 明子<br />
					THE IDOLM@STER(星井美希)<br />
					<span style="color: #00cc99">●</span>浜崎 奈々<br />
					ﾓﾝｽﾀｰﾊｲ こわｲｹｶﾞｰﾙｽﾞ（ﾄﾞﾗｷｭﾛｰﾗ）<br />
					<span style="color: #6699ff">●</span>濱野 大輝<br />
					遊☆戯☆王VRAINS(鬼塚豪/Go鬼塚)<br />
					<span style="color: #6699ff">●</span>林 大地<br />
					ﾍﾞｲﾌﾞﾚｰﾄﾞﾊﾞｰｽﾄ(南翠ﾕｰｺﾞ)<br />
					<span style="color: #808080">●</span>林原 めぐみ<br />
					ヱｳﾞｧﾝｹﾞﾘｦﾝ(綾波ﾚｲ)<br />
					<span style="color: #00cc99">●</span>早見 沙織<br />
					魔法つかいﾌﾟﾘｷｭｱ!(花海ことは/ｷｭｱﾌｪﾘｰﾁｪ)<br />
					<span style="color: #6699ff">●</span>早水 ﾘｻ<br />
					私がﾓﾃないのはどう考えてもお前らが悪い!(智子の母)<br />
					<span style="color: #6699ff">●</span>原田 ﾏｻｵ<br />
					NARUTO-ﾅﾙﾄ-疾風伝(篝)<br />
					<span style="color: #6699ff">●</span>原 由実<br />
					ｵｰﾊﾞｰﾛｰﾄﾞ(ｱﾙﾍﾞﾄﾞ)<br />
					<span style="color: #6699ff">●</span>春野　杏<br />
					ﾌﾞﾚﾝﾄﾞ･S(星川麻冬)<br />
					<span style="color: #ff6666">●</span>春村 奈々<br />
					超游世界<br />
					<span style="color: #6699ff">●</span>半場 友恵<br />
					鋼の錬金術師 FULLMETAL ALCHEMIST(ｸﾞﾚｲｼｱ･ﾋｭｰｽﾞ)<br />
					<span style="color: #00cc99">●</span>日笠 陽子<br />
					けいおん!(秋山澪)<br />
					<span style="color: #ff6666">●</span>東内 ﾏﾘ子<br />
					落第騎士の英雄譚(新宮寺黒乃)<br />
					<span style="color: #6699ff">●</span>檜山 修之<br />
					坂本ですが？(ｹﾝｹﾝ)<br />
					<span style="color: #00cc99">●</span>平田 宏美<br />
					THE IDOLM@STER(菊池真)<br />
					<span style="color: #6699ff">●</span>広瀬 裕也<br />
					はんだくん（相沢順一)<br />
					<span style="color: #6699ff">●</span>福島 潤<br />
					弱虫ﾍﾟﾀﾞﾙ(鳴子章吉)<br />
					<span style="color: #ff6666">●</span>福原 綾香<br />
					ｷｬﾌﾟﾃﾝ翼(第4作)(岬太郎)<br />
					<span style="color: #6699ff">●</span>藤井 美波<br />
					ｶﾞﾝﾀﾞﾑﾋﾞﾙﾄﾞﾌｧｲﾀｰｽﾞ(ﾔｻｶ･ﾏｵ)<br />
					<span style="color: #6699ff">●</span>藤田 彩<br />
					あらしのよるに(ﾙﾐ)<br />
					<span style="color: #6699ff">●</span>藤田 咲<br />
					ｷﾗｷﾗ☆ﾌﾟﾘｷｭｱｱﾗﾓｰﾄﾞ(琴爪ゆかり/ｷｭｱﾏｶﾛﾝ)<br />
					<span style="color: #ff6666">●</span>藤田 奈央<br />
					ﾌﾞﾚｲﾌﾞﾋﾞｰﾂ(渡辺晴彦)<br />
					<span style="color: #808080">●</span>藤田 麻美<br />
					ﾛｳきゅｰぶ!(和久井)<br />
					<span style="color: #6699ff">●</span>藤原 夏海<br />
					ﾒｼﾞｬｰｾｶﾝﾄﾞ(茂野大吾)<br />
					<span style="color: #6699ff">●</span>保志 総一朗<br />
					戦国BASARA(真田幸村)<br />
					<span style="color: #6699ff">●</span>細井 治<br />
					おおきく振りかぶって(青木毅彦)<br />
					<span style="color: #ff6666">●</span>堀江 由衣<br />
					魔法つかいﾌﾟﾘｷｭｱ！(十六夜ﾘｺ／ｷｭｱﾏｼﾞｶﾙ)<br />
					<span style="color: #808080">●</span>本多 陽子<br />
					ﾘﾄﾙﾊﾞｽﾀｰｽﾞ!(古式みゆき)<br />
					<span style="color: #00cc99">●</span>本渡 楓<br />
					かみさまみならい　ﾋﾐﾂのここたま（四葉こころ）<br />
					<span style="color: #ff9933">●</span>本丸 仁美<br />
					真相報道ﾊﾞﾝｷｼｬ！(ﾅﾚｰｼｮﾝ)</td>
			</tr>
		</tbody>
	</table>
	<a id="ma" name="ma"></a>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong>■ま行</strong></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #6699ff">●</span>前野 智昭<br />
					重神機ﾊﾟﾝﾄﾞｰﾗ(ﾚｵﾝ･ﾗｳ)<br />
					<span style="color: #808080">●</span>間島 淳司<br />
					ねじ巻き精霊戦記 天鏡のｱﾙﾃﾞﾗﾐﾝ(ﾏｼｭｰ･ﾃﾄｼﾞﾘﾁ)<br />
					<span style="color: #6699ff">●</span>又吉 愛<br />
					ｳｨｯﾁｸﾗﾌﾄﾜｰｸｽ(あい)<br />
					<span style="color: #808080">●</span>松岡 禎丞<br />
					ｿｰﾄﾞｱｰﾄ･ｵﾝﾗｲﾝ(ｷﾘﾄ)<br />
					<span style="color: #6699ff">●</span>松下 美由紀<br />
					十二国記(峯麟)<br />
					<span style="color: #6699ff">●</span>松田 健一郎<br />
					ﾌﾞﾗｯｸｸﾛｰﾊﾞｰ(ｺﾞｰﾄﾞﾝ･ｱｸﾞﾘｯﾊﾟ)<br />
					<span style="color: #6699ff">●</span>松田 颯水<br />
					若おかみは小学生!(ｳﾘ坊〈立売誠〉)<br />
					<span style="color: #808080">●</span>松田 利冴<br />
					ﾊｸﾒｲとﾐｺﾁ(ﾊｸﾒｲ)<br />
					<span style="color: #6699ff">●</span>水橋 かおり<br />
					終物語(忍野扇)<br />
					<span style="color: #808080">●</span>三石 琴乃<br />
					美少女戦士ｾｰﾗｰﾑｰﾝ(月野うさぎ／ｾｰﾗｰﾑｰﾝ)<br />
					<span style="color: #00cc99">●</span>嶺内 ともみ<br />
					ｽﾛｳｽﾀｰﾄ(十倉栄依子)<br />
					<span style="color: #808080">●</span>宮川 美保<br />
					Fate/Kaleid Liner ﾌﾟﾘｽﾞﾏ☆ｲﾘﾔ(ﾘｰｾﾞﾘｯﾄ)<br />
					<span style="color: #ff9933">●</span>宮崎　水希<br />
					わｸﾞﾙま！(ｹﾙﾋﾞﾑ)<br />
					<span style="color: #6699ff">●</span>武藤 志織<br />
					ﾉﾌﾞﾅｶﾞﾝ(小椋しお)<br />
					<span style="color: #ff6666">●</span>村瀬 歩<br />
					ﾊｲｷｭｰ!(日向翔陽)<br />
					<span style="color: #ff9933">●</span>村本 享太郎<br />
					ｻﾞ ｸｲｽﾞｼｮｳ(ﾄﾞﾗﾏ内ﾅﾚｰｼｮﾝ)<br />
					<span style="color: #6699ff">●</span>望月 健一<br />
					機動戦士ｶﾞﾝﾀﾞﾑAGE(ﾋﾞｼﾃﾞｨｱﾝ)<br />
					<span style="color: #808080">●</span>森 光冬<br />
					劇団青い森 全国巡業公演･｢山月記｣(祖渓)<br />
					<span style="color: #808080">●</span>森永 理科<br />
					みなみけ(ﾏｺﾄ)<br />
					<span style="color: #6699ff">●</span>門田 幸子<br />
					あそびにいくﾖ!(ｼﾞｬｯｸ)</td>
			</tr>
		</tbody>
	</table>
	<a id="ya" name="ya"></a>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong>■や行</strong></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6666">●</span>八代 拓<br />
					遊☆戯☆王ＶＲＡＩＮＳ(不霊夢)<br />
					<span style="color: #00cc99">●</span>柳田 淳一<br />
					ｶｰﾄﾞﾌｧｲﾄ!!ｳﾞｧﾝｶﾞｰﾄﾞG(安城ﾏﾓﾙ)<br />
					<span style="color: #00cc99">●</span>矢作 紗友里<br />
					ｼｭﾀｲﾝｽﾞ･ｹﾞｰﾄ ｾﾞﾛ(比屋定真帆)<br />
					<span style="color: #ff9933">●</span>山県 びわ<br />
					桃華月憚(鬼梗)<br />
					<span style="color: #6699ff">●</span>山崎 はるか<br />
					異能ﾊﾞﾄﾙは日常系のなかで(神崎灯代)<br />
					<span style="color: #6699ff">●</span>山下 大輝<br />
					弱虫ﾍﾟﾀﾞﾙ(小野田坂道)<br />
					<span style="color: #ff9933">●</span>山田 みほ<br />
					境界線上のﾎﾗｲｿﾞﾝ(ﾛﾊﾞｰﾄ･ﾀﾞｯﾄﾞﾘｰ)<br />
					<span style="color: #808080">●</span>山本 和孝<br />
					ﾑﾁｯｺものがたり(ﾏｲﾏｲｶﾌﾞﾘｼﾐｽﾞ)<br />
					<span style="color: #ff6666">●</span>山本 希望<br />
					妹さえいればいい｡(羽島千尋)<br />
					<span style="color: #808080">●</span>山本 麻里安<br />
					極上!!めちゃﾓﾃ委員長 (戸田菜花)<br />
					<span style="color: #ff6666">●</span>結名 美月<br />
					帰宅部活動記録（塔野花梨）<br />
					<span style="color: #ff6666">●</span>優木 かな<br />
					はるかなﾚｼｰﾌﾞ(大空遥)<br />
					<span style="color: #6699ff">●</span>行成 とあ<br />
					ぐらんぶる(浜岡梓)<br />
					<span style="color: #6699ff">●</span>吉住 梢<br />
					桜蘭高校ﾎｽﾄ部(宝積寺れんげ)<br />
					<span style="color: #00cc99">●</span>吉田 真弓<br />
					俺たちに翼はない(渡来明日香)<br />
					<span style="color: #808080">●</span>芳野 美樹<br />
					DEAR BOYS(秋吉夢津美)<br />
					<span style="color: #00cc99">●</span>佳村 はるか<br />
					うらら迷路帖(棗ﾉﾉ)<br />
					<span style="color: #6699ff">●</span>依田 菜津<br />
					BanG Dream![ﾊﾞﾝﾄﾞﾘ]</td>
			</tr>
		</tbody>
	</table>
	<a id="ra" name="ra"></a>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong>■ら行</strong></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #6699ff">●</span>Lynn<br />
					ﾒﾙﾍﾝ･ﾒﾄﾞﾍﾝ(ﾕｰﾐﾘｱ･ｶｻﾞﾝ)</td>
			</tr>
		</tbody>
	</table>
	<a id="wa" name="wa"></a>
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<strong>■わ行</strong></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #808080">●</span>若林 直美<br />
					THE IDOLM@STER(秋月律子)<br />
					<span style="color: #808080">●</span>渡辺 久美子<br />
					ｹﾛﾛ軍曹(ｹﾛﾛ軍曹)<br />
					<span style="color: #ff9933">●</span>渡部 恵子<br />
					THE IDOLM@STER MILLION LIVE!(周防桃子)<br />
					<span style="color: #6699ff">●</span>渡辺 拓海<br />
					12歳｡(ｴｲｺｰ)</td>
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