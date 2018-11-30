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
				<td style="width: 10px; font-size: x-small; vertical-align: top">
					<span style="color: #98d1a9">■</span></td>
				<td style="text-align: left; color: #98d1a9; font-size: x-small" valign="top">
					<strong><span style="color: #000000">日ﾅﾚの特色</span></strong></td>
			</tr>
			<tr>
				<td style="text-align: right; font-size: x-small; vertical-align: top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#01">強力なﾊﾞｯｸｱｯﾌﾟ体制</a></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#02">働きながら､学びながら受けられるﾚｯｽﾝｼｽﾃﾑ</a></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#03">俳優訓練から人間形成･ｺﾐｭﾆｹｰｼｮﾝ能力の向上へ</a></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#04">首都圏をはじめ､仙台､名古屋､近畿圏でﾚｯｽﾝ受講可能</a></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#06">感性を広げる週2回ｸﾗｽ･週3回ｸﾗｽ</a></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					&nbsp;</td>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #ff6600">&gt;&gt;</span><a href="#07">社会で役立つｽｷﾙや人間力の向上をめざす､ｽﾀｰﾄｱｯﾌﾟｸﾗｽ</a></td>
			</tr>
		</tbody>
	</table>
</div>
<p>
	&nbsp;</p>
<p>
	<a id="01" name="01"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #4ca778"><strong>強力なﾊﾞｯｸｱｯﾌﾟ体制</strong></span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<p>
						当所の受講生で力量ありと判断された方はｸﾞﾙｰﾌﾟﾌﾟﾛﾀﾞｸｼｮﾝのﾏﾈｰｼﾞﾒﾝﾄの対象となり､ﾏｽｺﾐへのｾｰﾙｽ（売り込み）が行われます｡<br />
						【ｸﾞﾙｰﾌﾟﾌﾟﾛﾀﾞｸｼｮﾝ】<br />
						●ｱｰﾂﾋﾞｼﾞｮﾝ<br />
						高木渉､檜山修之､<br />
						ならはしみき､椎名へきる､<br />
						保志総一朗､鳥海浩輔､<br />
						水橋かおり､福島潤､<br />
						中村繪里子､下田麻美､<br />
						長谷川明子､藤田咲､<br />
						沼倉愛美､山下大輝　ほか所属<br />
						●ｱｲﾑｴﾝﾀｰﾌﾟﾗｲｽﾞ<br />
						高橋美佳子､釘宮理恵､<br />
						桑谷夏子､間島淳司､<br />
						斎藤千和､中原麻衣､<br />
						植田佳奈､下野紘､<br />
						高城元気､鈴木達央､<br />
						矢作紗友里､日笠陽子､<br />
						早見沙織､田村睦心､<br />
						内田真礼　ほか所属<br />
						●ｳﾞｨﾑｽ<br />
						森久保祥太郎､堀江由衣､<br />
						梶裕貴､新名彩乃､<br />
						山本希望､村瀬歩　ほか所属<br />
						●ｸﾚｲｼﾞｰﾎﾞｯｸｽ<br />
						奥田民義､大塚芳忠<br />
						山田みほ　ほか所属<br />
						●澪ｸﾘｴｰｼｮﾝ<br />
						木野智香､垣尾麻美<br />
						森田有美　ほか所属<br />
						●ｱﾗｲｽﾞﾌﾟﾛｼﾞｪｸﾄ<br />
						2015年3月設立</p>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="02" name="02"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #4ca778"><strong>働きながら､学びながら受けられるﾚｯｽﾝｼｽﾃﾑ</strong></span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					声優という職業は､決して誰にでもなれる職業ではありませんが､ﾚｯｽﾝを受けてみなければ､その資質が見えてこないという側面もあります｡また､一定のｶﾘｷｭﾗﾑを消化すれば資格が取れるというものではないため､ほぼ毎日のﾚｯｽﾝに数年間通うということは､たとえ本人の意思･意欲だとしても､あまりにも危険で負担が大きすぎるのではないかと当所では考えております｡<br />
					<br />
					そこで当所では､週1回3時間の演技ﾚｯｽﾝで､仕事をしながら､学校に通いながらでも､声優･俳優･ﾅﾚｰﾀｰをめざしていけるようなﾚｯｽﾝｼｽﾃﾑを組んでいます｡</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="03" name="03"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #4ca778"><strong>俳優訓練から人間形成･ｺﾐｭﾆｹｰｼｮﾝ能力の向上へ</strong></span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					俳優育成のｶﾘｷｭﾗﾑでは､人間形成における様々な要素の成長をみることができます｡<br />
					例えば､社交性･協調性･礼儀が身につき､観察力･洞察力･想像力などが養われます｡<br />
					これら俳優訓練の過程で培った経験により､事業で成功を収めたり､集団のﾘｰﾀﾞｰとして活躍している方もいるなど､声優業以外においてもﾚｯｽﾝが活かされています｡<br />
					昨今､ｺﾐｭﾆｹｰｼｮﾝ能力の重要性が再認識されている中において､学校や職場での集団生活､また､ﾌﾟﾚｾﾞﾝﾃｰｼｮﾝや就職活動などさまざまなｼﾁｭｴｰｼｮﾝに必要とされる能力を､演技を通して結果的に習得･向上させることができるのではないかと当所では考えております｡<br />
					ｴﾝﾀｰﾃｲﾒﾝﾄ業界以外で役立つ能力の向上等を目的とされる方､&ldquo;自分を変えたい&rdquo;という方につきましても､お気軽にﾚｯｽﾝを受講していただける環境づくりに今後も努めてまいります｡</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="04" name="04"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #4ca778"><strong>首都圏をはじめ､仙台､名古屋､近畿圏でﾚｯｽﾝ受講可能</strong></span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					1990年の開校以来､当所は多くの活躍する声優を育ててまいりました｡<br />
					代々木･池袋･お茶の水･立川･町田･大宮･柏･横浜･仙台･名古屋･京都･大阪･神戸に加え､2017年10月には千葉校を開校､さらに､2018年4月には､新たに難波校･天王寺校を開校いたしました｡<br />
					｢将来声優になりたい!｣｢演技を学びたい｣と希望しているみなさんにとって､これからもより通いやすい環境を提供してまいります｡</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="06" name="06"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #4ca778"><strong>感性を広げる週2回ｸﾗｽ･週3回ｸﾗｽ</strong></span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					昨今の声優業界では､しっかりした演技力はもちろんのこと､｢歌唱力｣や｢ｽﾃｰｼﾞﾝｸﾞ能力｣を求められることも多くなってきています｡そのような流れを考慮し､｢演技｣｢ﾎﾞｰｶﾙ｣のﾚｯｽﾝを行う､<a href="../course/twodays-threedays.php ">週2回ｸﾗｽ</a>､｢演技｣｢ﾎﾞｰｶﾙ｣｢ﾀﾞﾝｽ｣のﾚｯｽﾝを行う､<a href="../course/twodays-threedays.php ">週3回ｸﾗｽ</a>を開設｡『演じる』うえで､より広がった視野や感性を養っていくことを目的としています｡<br />
					週2回ｸﾗｽ･･･お茶の水校･名古屋校（※1）･大阪校にて開設<br />
					週3回ｸﾗｽ･･･代々木校（※2）にて開設<br />
					<br />
					※1,平成29年度より､名古屋校の週3回ｸﾗｽは､週2回ｸﾗｽに変更となりました｡<br />
					※2,平成29年度より､お茶の水校の週3回ｸﾗｽは､代々木校に統合されました｡</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: right; margin-top: 5px; font-size: x-small">
	<a href="#pagetop">&uarr;ﾍﾟｰｼﾞﾄｯﾌﾟへ</a></div>
<p>
	<a id="07" name="07"></a></p>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #4ca778"><strong>社会で役立つｽｷﾙや人間力の向上をめざす､ｽﾀｰﾄｱｯﾌﾟｸﾗｽ</strong></span></td>
			</tr>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					当所では､これまで多くの受講者が演技のﾚｯｽﾝを通して､｢ｺﾐｭﾆｹｰｼｮﾝ能力｣をはじめ､｢主体性｣や｢積極性｣｢協調性｣｢ﾘｰﾀﾞｰｼｯﾌﾟ｣など､学校や職場で求められる多くのｽｷﾙを身につけ､大きく変化していく姿を長年にわたり見てまいりました｡<br />
					これらの経験から､演技のﾌﾟﾛをめざす方だけでなく､｢社会で役立つｽｷﾙの向上｣や｢人前で話すことが苦手｣｢緊張してしまう｣といったことの克服など､｢自信をつけたい方｣も含め､より多くの方々に｢演技ﾚｯｽﾝ｣の効果を実感していただける場を提供してまいります｡<br />
					※従来の｢声優ｽﾀｰﾃｨﾝｸﾞｾﾐﾅｰ｣をﾘﾆｭｰｱﾙしたｸﾗｽです｡<br />
					<a href="../course/start-up-course.php ">※ｽﾀｰﾄｱｯﾌﾟｸﾗｽの詳細はこちら</a></td>
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