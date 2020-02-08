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
<div style="background:#6cbd85; text-align:center;"><?php mtkk_image_tag(array('url' => '/m/course/img/course_tit.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/course/img/course_tit.jpg'))); ?></div>

<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="width: 10px; font-size: x-small" valign="top">
					<span style="color: #98d1a9">■</span></td>
				<td style="text-align: left; color: #4ca778; font-size: x-small" valign="top">
					<strong>ｽﾀｰﾄｱｯﾌﾟｸﾗｽ</strong></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					学校や職場､そして地域活動など現代の社会においては､さまざまなｽｷﾙ（※１）が必要とされています｡<br />
					演技のﾚｯｽﾝでは､｢お腹から大きな 声を出す｣｢聞き取りやすいかつ舌で相手に伝える｣｢しっかり挨拶をする｣｢大勢の前で自分の意見を言う｣｢他者の考えを汲みとる｣等々､社会でも活かせるさまざまな訓練が行われています｡<br />
					これまで弊所でも､長年にわたり育成･指導をしていくなかで､このような演技ﾚｯｽﾝを通し､受講者が社会で必要とされているさまざまなｽｷﾙを身につけ､声優･俳優としてだけでなく､多くのｼｰﾝで活躍する様子を目にしてまいりました｡<br />
					例えばﾚｯｽﾝのなかで､初めは大勢の前で発言することを恥ずかしいと感じていたことが､失敗しても問題ないと理解できれば､次第にさまざまなことに 積極的に取り組み､徐々に主体的に行動できるようになっていきます｡<br />
					また､他の受講者と協力して作業をすることで､協調性をはじめ､洞察力や 柔軟性､適応力､配慮､貢献､尊重といったことが養われ､なかにはﾘｰﾀﾞｰｼｯﾌﾟを発揮する方も出てきます｡<br />
					年齢や職業もさまざまなｸﾞﾙｰﾌﾟの 中で､日頃はあまり接点のない方々との出会いが､自然とｺﾐｭﾆｹｰｼｮﾝ能力を向上させ､また､視野を広げ､感性を刺激させるなど､人間としての成長につながっていくものと思われます｡<br />
					これらの経験を踏まえ､弊所ではより多くの方々に｢演技ﾚｯｽﾝ｣の場を提供させていただくことで､演技の楽しさはもちろんのこと､数多くのｽｷﾙのなかから､自分に足りていないものを補う一助にしていただけると考えております｡</td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					（※1）社会で必要とされているさまざまな能力の一例<br />
					礼儀　社会性　行動力　率先力　瞬発力　洞察力　判断力　決定力　想像力　創造力　集中力　記憶力　継続力　忍耐力　完遂力　読解力　探究心 柔軟性　論理性　適応力　主体性　自立性　積極性　ﾁｬﾚﾝｼﾞ精神　協調性　協力姿勢　ﾌｫﾛｰ力　利他心　計画性　改善意識　時間･行動管理 創意工夫　ｱｲﾃﾞｱ提案力　周辺観察力　情報収集力　自己分析力　自己PR作成･発表力　表現力　ﾌﾟﾚｾﾞﾝ力　ｵｰﾃﾞｨｼｮﾝ･面接対応力　度胸 自信　冷静さ　丁寧さ　ｺﾐｭﾆｹｰｼｮﾝ能力　ﾘｰﾀﾞｰｼｯﾌﾟ　配慮　貢献　尊重　目標設定姿勢　自己反省姿勢...etc<br />
					<br />
					<span style="color: #98d1a9">■</span><span style="color: #4ca778"><strong>さまざまなｼｰﾝで活かしたい方へ｡</strong></span><br />
					◎進学や就活､ｱﾙﾊﾞｲﾄなどの面接に<br />
					◎会議･集会などの会合に<br />
					◎接客や営業､ﾌﾟﾚｾﾞﾝなどのﾋﾞｼﾞﾈｽｼｰﾝに<br />
					◎ｽﾋﾟｰﾁや司会進行が必要なｲﾍﾞﾝﾄに<br />
					◎学校や学習塾､各種ｽｸｰﾙでの指導･ｺﾐｭﾆｹｰｼｮﾝに<br />
					◎幼稚園や保育園､ご家庭などでの読み聞かせに<br />
					◎演劇部･演劇ｻｰｸﾙなどの補講に<br />
					◎学校やｸﾗﾌﾞ活動､地域の交友関係に<br />
					<br />
					<br />
					●従来の｢声優ｽﾀｰﾃｨﾝｸﾞｾﾐﾅｰ｣をﾘﾆｭｰｱﾙしたｸﾗｽです｡<br />
					●ｸﾞﾙｰﾌﾟﾌﾟﾛﾀﾞｸｼｮﾝへの所属は原則ありません｡（所属審査なし）<br />
					●一部のﾚｯｽﾝ校を除き､平日での開設となります｡<br />
					●各校定員になり次第締め切らせていただきます｡また､定員に満たない場合は開設されない可能性があります｡<br />
					●決定したｸﾗｽは年度を通して｢同じ曜日の同じ時間帯｣に通っていただくこととなります｡<br />
					●年度終了後､より高いﾚﾍﾞﾙの演技をすることに興味を持たれ､声優･俳優をめざしたいと思われた方は､週1回ｸﾗｽ､週2回ｸﾗｽ､週3回ｸﾗｽの基礎科へｺｰｽ変更が可能です｡<br />
					●週1回ｸﾗｽ､週2回ｸﾗｽ､週3回ｸﾗｽの基礎科の年度終了後､本ｸﾗｽへのｺｰｽ変更が可能です｡<br />
					●年度途中でのｸﾗｽ変更は原則として受け付けておりません｡<br />
					●上記の※1の一例が受講者に必ず身につくということを保証するものではございません｡<br />
					●7月生での入所は､4月生に3ヶ月遅れて合流していただく形となります｡（一部ｸﾗｽが新設される場合があります）</td>
			</tr>
		</tbody>
	</table>
</div>
<br />
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<?php mtkk_image_tag(array('url' => '/m/course/img/flow_8.jpg', 'display' => 'browser', 'attr' => array('src' => '/m/course/img/flow_8.jpg'))); ?></td>
			</tr>
		</tbody>
	</table>
</div>
<div style="text-align: left">
	<table border="0" cellpadding="0" cellspacing="0" style="margin-top: 5px">
		<tbody>
			<tr>
				<td style="text-align: left; font-size: x-small" valign="top">
					<span style="color: #98d1a9">★</span><strong>開設校</strong><br />
					･代々木校<br />
					･池袋校<br />
					･お茶の水校<br />
					･名古屋校<br />
					･大阪校<br />
					･難波校<br />
					<br />
					<span style="color: #98d1a9">★</span><strong>受講対象年齢</strong><br />
					･中学卒業以上､40歳まで<br />
					<br />
					<span style="color: #98d1a9">★</span><strong>入所時期</strong><br />
					･4月（12ヶ月）･7月（9ヶ月）<br />
					<br />
					<span style="color: #98d1a9">★</span><strong>入所金</strong><br />
					･2万円(初年度のみ)<br />
					<br />
					<span style="color: #98d1a9">★</span><strong>年間受講料</strong><br />
					･4月生/12万円<br />
					└4月から翌年3月までの受講料となります｡<br />
					･7月生/9万円<br />
					└7月から翌年3月までの受講料となります｡<br />
					<br />
					※上記金額には消費税が含まれています｡<br />
					※年間受講料のみ分割納入可能｡<br />
					※2年目以降は年間受講料12万円のみのお支払いとなります｡<br />
					※弊所を一度退所し､令和2年度より再度入所される方につきましては､入所後の所定の手続きにより､再入所時の入所金の半額を返金（または受講料に充当）させていただきます｡<br />
					※定員により､入所いただけない場合があります｡<br />
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