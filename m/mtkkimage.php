<?php


$er = error_reporting();
error_reporting($er & ~E_NOTICE);


if(!defined('MG_JPEG')) define('MG_JPEG', 0x0001);
if(!defined('MG_GIF')) define('MG_GIF', 0x0002);
if(!defined('MG_PNG')) define('MG_PNG', 0x0008);


$mtkk_plugin_dir = '/usr/home/z304150/html/cmt/plugins/KeitaiKit';
$mtkk_temp_dir = '/usr/home/z304150/html/cmt/plugins/KeitaiKit/tmp';
$mtkk_iemoji_dir = '/usr/home/z304150/html/cmt/plugins/KeitaiKit/iemoji';


function detect_format($image) {
	$fp = fopen($image, 'rb');
	$head = fread($fp, 6);
	fclose($fp);
	
	if(preg_match('/^GIF8[79]a/', $head)) {
		$format = 'gif';
	} else if(preg_match('/^\x89PNG/', $head)) {
		$format = 'png';
	} else if(preg_match('/^\xFF\xD8/', $head)) {
		$format = 'jpeg';
	} else {
		$format = null;
	}
	
	return $format;
}


if(isset($_GET['mtkk_url']) && $_GET['mtkk_url']) {
	$url = urldecode($_GET['mtkk_url']);
	$carrier = isset($_GET['mtkk_carrier'])? $_GET['mtkk_carrier']: 'other';
	$sw = isset($_GET['mtkk_sw'])? $_GET['mtkk_sw']: null;
	$sh = isset($_GET['mtkk_sh'])? $_GET['mtkk_sh']: null;
	$c = isset($_GET['mtkk_c'])? $_GET['mtkk_c']: null;
	$img = isset($_GET['mtkk_img'])? $_GET['mtkk_img']: null;
	$w = isset($_GET['mtkk_w'])? $_GET['mtkk_w']: null;
	$h = isset($_GET['mtkk_h'])? $_GET['mtkk_h']: null;
	$fit = isset($_GET['mtkk_fit'])? $_GET['mtkk_fit']: null;
	$thumbnail = isset($_GET['mtkk_thumbnail'])? $_GET['mtkk_thumbnail']: 0;
	$copyright = isset($_GET['mtkk_copyright'])? $_GET['mtkk_copyright']: null;
	$maximize = isset($_GET['mtkk_maximize'])? $_GET['mtkk_maximize']: 0;
	$wallpaper = isset($_GET['mtkk_wallpaper'])? unserialize($_GET['mtkk_wallpaper']): null;
	$no_arrange = isset($_GET['mtkk_no_arrange'])? true: false;
	$cache_size = isset($_GET['mtkk_cache_size'])? $_GET['mtkk_cache_size']: 1024 * 100;
	$cache_expires = isset($_GET['mtkk_cache_expires'])? $_GET['mtkk_cache_expires']: null;
	$magnify = isset($_GET['mtkk_magnify'])? $_GET['mtkk_magnify']: null;
	$is_vga_screen = isset($_GET['mtkk_is_vga_screen'])? $_GET['mtkk_is_vga_screen']: 0;
	

	$mtkk_convert = '';
	$mtkk_identify = '';
	$mtkk_php_graphic = 'gd';
	$mtkk_cache_expires = '1209600';
	$mtkk_basic_auths = '';
	$mtkk_jpeg_quality = '75';
	$mtkk_php_graphic_url = '';
	$mtkk_document_root = '';
	$mtkk_graphic_debug_mode = false;
	$mtkk_cache_cleaning_prob = '0';
	$mtkk_download_proxy = '';
	$mtkk_download_adapter = 'php';
	$mtkk_http_host_var = 'HTTP_HOST';
	$mtkk_image_iconize_width = 0;
	$mtkk_image_iconize_height = 0;
	

	require_once($mtkk_plugin_dir . '/php/KeitaiGraphic.php');
	

	$kg = new KeitaiGraphic;
	$kg->convert = $mtkk_convert;
	$kg->identify = $mtkk_identify;
	$kg->temp_dir = $mtkk_temp_dir;
	$kg->php_graphic = $mtkk_php_graphic;
	$kg->cache_expires = $mtkk_cache_expires;
	$kg->basic_auths = $mtkk_basic_auths;
	$kg->jpeg_quality = $mtkk_jpeg_quality;
	$kg->php_graphic_url = $mtkk_php_graphic_url;
	$kg->document_root = $mtkk_document_root;
	$kg->cache_cleaning_prob = (int)$mtkk_cache_cleaning_prob;
	$kg->cache_size = $cache_size;
	$kg->download_proxy = $mtkk_download_proxy;
	$kg->download_adapter = $mtkk_download_adapter;
	$kg->http_host_var = $mtkk_http_host_var;
	$kg->image_iconize_width = $mtkk_image_iconize_width;
	$kg->image_iconize_height = $mtkk_image_iconize_height;
	$kg->is_vga_screen = $is_vga_screen? true: false;
	if($mtkk_graphic_debug_mode)
		$kg->debug_mode = true;
	

	if(isset($cache_expires))
		$kg->temp_cache_expires = $cache_expires;
	

	if($carrier == 'ez')
		$kg->cache_size_by_format['gif'] = 25 * 1024;
	

	if(!$no_arrange) {
		if(!$img) {
			if($carrier == 'i' || $carrier == 'ez')
				$img = MG_JPEG | MG_GIF;
			else if($carrier == 's')
				$img = MG_JPEG | MG_PNG;
			else
				$img = 0xFFFFFFFF;
		}
		

		if($c === null || $c >= 3)
			$c = 7;
		else
			$c = 1;
	}
	

	$maximize = $maximize? true: false;
	

	$cache = $kg->build_cache($url, $sw, $sh, $c, $img, $w, $h, $fit, $thumbnail, $copyright, $wallpaper, $maximize, $magnify);
	

	$image = "$mtkk_temp_dir/$cache";
}


if(isset($_GET['mtkk_image']) && $_GET['mtkk_image']) {
	$cache = $_GET['mtkk_image'];


	if(preg_match('/\.\./', $cache))
		exit(0);

	$image = "$mtkk_temp_dir/$cache";
}


if(isset($_GET['mtkk_emoji']) && $_GET['mtkk_emoji']) {
	$symbol = $_GET['mtkk_emoji'];


	if(preg_match('/\.\./', $symbol))
		exit(0);

	$image = "$mtkk_iemoji_dir/$symbol";
}


if($image) {

	if(!file_exists($image))
		exit(0);
	

	$format = detect_format($image);
	if($format == null)
		exit(0);
        

    $size = file_exists($image)? filesize($image): 0;
    

    $mtime = filemtime($image);
    $modified = gmdate("D, d M Y H:i:s" , $mtime) . " GMT";
	

	header("Content-Type: image/$format");
	header("Content-Length: $size");
	header("Last-Modified: $modified");


	if(isset($_GET['copyright']) && $_GET['copyright'] == 's')
		header('x-jphone-copyright: no-transfer');
	readfile($image);

	exit(0);
}

?>