<?php

$er = error_reporting();
error_reporting($er & ~E_NOTICE & ~E_WARNING);


require_once('KeitaiGraphic.php');

$kg = new KeitaiGraphic;
$kg->force_convert = true;

include('GraphicConfig.php');


if($value = $_GET['kg_basic_auths'])
	$kg->basic_auths = unserialize($value);
if($value = $_GET['kg_jpeg_quality'])
	$kg->jpeg_quality = $value;
if($value = $_GET['kg_cache_size'])
	$kg->cache_size = $value;
if($value = $_GET['kg_cache_size_by_format']) {
	$value = str_replace('\\"', '"', $value);
	$kg->cache_size_by_format = unserialize($value);
}
if($value = $_GET['wallpaper']) {
	$value = str_replace('\\"', '"', $value);
	$wallpaper = unserialize($value);
}
$maximize = false;
if($value = $_GET['maximize']) {
	$maximize = true;
}
if(isset($_GET['cache_expires']))
	$kg->temp_cache_expires = (int)$_GET['cache_expires'];
if(isset($_GET['kg_image_iconize_width']))
	$kg->image_iconize_width = (int)$_GET['image_iconize_width'];
if(isset($_GET['kg_image_iconize_height']))
	$kg->image_iconize_height = (int)$_GET['image_iconize_height'];
if(isset($_GET['kg_is_vga_screen']))
	$kg->is_vga_screen = $_GET['is_vga_screen']? true: false;


$cache = $kg->build_cache($_GET['url'], $_GET['sw'], $_GET['sh'], $_GET['c'], 
	$_GET['img'], $_GET['w'], $_GET['h'], $_GET['fit'], $_GET['thumbnail'], $_GET['copyright'], $wallpaper, $maximize, $_GET['magnify']);


if($cache) {
	$file = $kg->temp_dir . "/$cache";
	$format = $kg->detect_format($file);


	header("Content-Type: image/$format");
	readfile($file);
}
?>