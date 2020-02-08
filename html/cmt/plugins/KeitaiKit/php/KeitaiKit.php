<?php



$mtkk_er = error_reporting();
error_reporting($mtkk_er & ~E_NOTICE & ~E_WARNING);

define('INT_MAX', 2147483647);
if(!defined('MG_JPEG')) define('MG_JPEG', 0x0001);
if(!defined('MG_GIF')) define('MG_GIF', 0x0002);
if(!defined('MG_PNG')) define('MG_PNG', 0x0008);
if(!defined('MG_NOVGA')) define('MG_NOVGA', 0x4000);
if(!defined('MG_RESOLUTIONS')) define('MG_RESOLUTIONS', 0x8000);
if(!defined('QVGA_WIDTH')) define('QVGA_WIDTH', 240);

define('I_EZ_MAX_WIDTH', 240);

$mtkk_emoji_sizes = array(
	'i'		=> array('width' => 12, 'height' => 12),
	'ez'	=> array('width' => 14, 'height' => 15),
	's'		=> array('width' => 15, 'height' => 15)
);


if(!isset($mtkk_ez_no_input_style)) $mtkk_ez_no_input_style = 'SH37,SH35';


$mtkk_xml_declaration_format = '<?xml version="1.0" encoding="%s"?>';
$mtkk_doctype_format = array(
	'i'		=> '<!DOCTYPE html PUBLIC "-//i-mode group (ja)//DTD XHTML i-XHTML(Locale/Ver.=ja/%0.1f) 1.0//EN" "i-xhtml_4ja_10.dtd">',
	'ez'	=> '<!DOCTYPE html PUBLIC "-//OPENWAVE//DTD XHTML 1.0//EN" "http://www.openwave.com/DTD/xhtml-basic.dtd">',
	's'		=> '<!DOCTYPE html PUBLIC "-//J-PHONE//DTD XHTML Basic 1.0 Plus//EN" "xhtml-basic10-plus.dtd">'
);


if(!isset($mtkk_http_host_var))
	$mtkk_http_host_var = 'HTTP_HOST';
	

if(isset($_GET['mtkk_redirect']) && $_GET['mtkk_redirect']) {
	$mtkk_redirect = urldecode($_GET['mtkk_redirect']);

	if(preg_match('#^https?://([^/]+)#', $mtkk_redirect, $matches)) {
		if(strtolower($matches[1]) == strtolower($_SERVER[$mtkk_http_host_var])) {
			header("Location: $mtkk_redirect");
			exit(0);
		}
	} else {
		header("Location: $mtkk_redirect");
		exit(0);
	}
}


$mtkk_is_secure = false;
if( (isset($_SERVER['HTTPS']) && strtolower($_SERVER['HTTPS']) == 'on')
		|| (isset($_SERVER['SERVER_PORT']) && $_SERVER['SERVER_PORT'] == 443)
		|| (isset($_SERVER['SSL_PROTOCOL']) && $_SERVER['SSL_PROTOCOL']) ) {
	$mtkk_is_secure = true;
}



$mtkk_ua = $_SERVER['HTTP_USER_AGENT'];
if(!$mtkk_disable_ua_camouflage && isset($_GET['mtkk_ua']) && $_GET['mtkk_ua'])
	$mtkk_ua = $_GET['mtkk_ua'];



ini_set('default_charset', 'Shift_JIS');
ini_set('mbstring.internal_encoding', isset($mtkk_php_encoding)? $mtkk_php_encoding: 'Shift_JIS');
ini_set('mbstring.script_encoding', isset($mtkk_php_encoding)? $mtkk_php_encoding: 'Shift_JIS');
$mtkk_convert_to_sjis = false;
$mtkk_php_is_not_sjis = (strtolower($mtkk_php_encoding) != 'shift_jis' && strtolower($mtkk_php_encoding) != 'sjis')? true: false;
$mtkk_maybe_smartphone = preg_match('/iPhone|Android/i', $mtkk_ua);
if($mtkk_maybe_smartphone || $mtkk_php_is_not_sjis) {
    $mtkk_convert_to_sjis = true;
	ob_start('mtkk_convert_to_sjis');
} else {
	ini_set('mbstring.http_output', 'Shift_JIS');
}


if(isset($_GET['mtkk_emoji_pc']))
    $mtkk_emoji_pc = $_GET['mtkk_emoji_pc'];




$mtkk_is_new_device = false;
$mtkk_up_version = 0;
if(preg_match('/^DoCoMo\/1\.0\/([^\/]+)/i', $mtkk_ua, $matches)
		|| preg_match('/^DoCoMo\/2\.0 ([^\(]+)/i', $mtkk_ua, $matches)) {
	$mtkk_carrier = 'i';
	if(preg_match('/^DoCoMo\/([0-9]+)/i', $mtkk_ua, $submatches) && $submatches[1] >= 2)
		$mtkk_is_new_device = true;
} else if(preg_match('/^KDDI\-([^ ]+)/i', $mtkk_ua, $matches)
		|| preg_match('/^UP\.Browser\/[^\-]+-([^ ]+)/i', $mtkk_ua, $matches)) {
	$mtkk_carrier = 'ez';
	if(preg_match('/UP\.Browser\/([^ ]+)/i', $mtkk_ua, $submatches)) {
		$mtkk_up_versions = explode('_', $submatches[1]);
		$mtkk_up_version = (float)array_pop($mtkk_up_versions);
		if($up_version >= 6) $mtkk_is_new_device = true;
	}
} else if(preg_match('/^SoftBank\/[^\/]+\/([^\/ ]+)/i', $mtkk_ua, $matches)
		|| preg_match('/^J\-PHONE\/[^\/]+\/([^\/ ]+)/i', $mtkk_ua, $matches)
		|| preg_match('/^Vodafone\/[^\/]+\/([^\/ ]+)/i', $mtkk_ua, $matches)
		|| preg_match('/^J\-EMULATOR\/[^\/]+\/([^\/ ]+)/i', $mtkk_ua, $matches)
		|| preg_match('/^MOT\-([^\/]+)\/80.2F.2E.MIB/i', $mtkk_ua, $matches)) {
	$mtkk_carrier = 's';
	if(preg_match('/^SoftBank/i', $mtkk_ua))
		$mtkk_is_new_device = true;
} else {
	$mtkk_carrier = null;
	$matches[1] = null;
}
$mtkk_model_id = $matches[1];


require_once('KeitaiDB.php');
$mtkk_kdb = new KeitaiDB("$mtkk_plugin_dir/db");
$mtkk_spec = $mtkk_kdb->findSpec($mtkk_carrier . $mtkk_model_id);
if($mtkk_carrier == null) {
	$mtkk_carrier = 'other';
	$mtkk_spec['format1'] = $mtkk_spec['format2'] = 0;
} else if($mtkk_spec['code'] == '') {
	if($mtkk_is_new_device) {
		if($mtkk_carrier == 'i') {

			$mtkk_spec['format1'] = 700;
			$mtkk_spec['format2'] = 210;
		} else if($mtkk_carrier == 'ez') {

			$mtkk_spec['format1'] = 620;
			$mtkk_spec['format2'] = 0;
		} else if($mtkk_carrier == 's') {

			$mtkk_spec['format1'] = 1100;
			$mtkk_spec['format2'] = 0;
		}
	} else {

		$mtkk_spec['format1'] = $mtkk_spec['format2'] = 0;
	}
}


if($mtkk_carrier == 'i') {
    if(($mtkk_spec['img'] & MG_RESOLUTIONS) != 0 && preg_match('/TB[;\/](W[0-9]+H[0-9]+)/', $mtkk_ua, $matches)) {
        $mtkk_resolution_key = $matches[1];
        $mtkk_alt_spec = $mtkk_kdb->findSpec($mtkk_carrier . $mtkk_model_id . '_' . $mtkk_resolution_key);
        if($mtkk_alt_spec['code'])
            $mtkk_spec = $mtkk_alt_spec;
    }
    

    $mtkk_no_vga = ($mtkk_spec['img'] & MG_NOVGA)? true: false;
    if($mtkk_ivga && $mtkk_spec['format1'] >= 2000 && !$mtkk_no_vga) {
        $mtkk_spec['bw'] *= 2;
        $mtkk_spec['bh'] *= 2;
        $mtkk_is_vga_screen = true;
    }
}


if($mtkk_carrier == 's') {
    if($mtkk_spec['bw'] > QVGA_WIDTH) $mtkk_is_vga_screen = true;
    if(isset($_SERVER['HTTP_X_S_DISPLAY_INFO'])) {
        $mtkk_display_info = $_SERVER['HTTP_X_S_DISPLAY_INFO'];
        if(preg_match('/^([0-9]+)\*([0-9]+)/', $mtkk_display_info, $matches)) {
            $mtkk_spec['bw'] = (int)$matches[1];
            $mtkk_spec['bh'] = (int)$matches[2];
        }
    }
    if(isset($_SERVER['HTTP_X_JPHONE_DISPLAY'])) {
      $mtkk_jphone_display = $_SERVER['HTTP_X_JPHONE_DISPLAY'];
      if(preg_match('/^([0-9]+)\*([0-9]+)$/', $mtkk_jphone_display, $matches)) {
        $mtkk_spec['sw'] = (int)$matches[1];
        $mtkk_spec['sh'] = (int)$matches[2];
      }
    }
}


$mtkk_ez_cache = 0;
if($mtkk_carrier == 'ez' && isset($_SERVER['HTTP_X_UP_DEVCAP_MAX_PDU'])) {
	$mtkk_ez_cache = $mtkk_spec['cache'];
	if($_SERVER['HTTP_X_UP_DEVCAP_MAX_PDU'] >= 1024)
		$mtkk_spec['cache'] = $_SERVER['HTTP_X_UP_DEVCAP_MAX_PDU'] / 1024;
}


if($mtkk_carrier == 'ez' && $mtkk_up_version)
	$mtkk_spec['format1'] = $mtkk_up_version;


$mtkk_s_cache = 0;
if($mtkk_carrier == 's')
  $mtkk_s_cache = 48;


if(isset($mtkk_smartphone_enabled) && $mtkk_smartphone_enabled) {
	if(preg_match('/iPhone|iPod|Android/i', $mtkk_ua, $matches)) {
		$mtkk_device = strtolower($matches[0]);
		if($mtkk_device == 'iphone' || $mtkk_device == 'ipod') {

			$mtkk_smartphone['os'] = 'iPhone';
			if(preg_match('/iPhone OS ([0-9][0-9_]*)/', $mtkk_ua, $matches)) {
				$mtkk_digits = explode('_', $matches[1]);
				$mtkk_version = array_shift($mtkk_digits);
				if(count($mtkk_digits)) $mtkk_version .= '.' . join('', $mtkk_digits);
				$mtkk_smartphone['os_version'] = (float)$mtkk_version;
			} else {
				$mtkk_smartphone['os_version'] = 1;
			}
		}
		if($mtkk_device == 'android') {

			$mtkk_smartphone['os'] = 'Android';
			if(preg_match('/Android ([0-9][\.0-9]*)/', $mtkk_ua, $matches)) {
				$mtkk_smartphone['os_version'] = (float)$matches[1];
			} else {
				$mtkk_smartphone['os_version'] = 0;
			}
		}
		

		$mtkk_spec['bw'] = $mtkk_spec['sw'] = $mtkk_smartphone_screen_width;
		$mtkk_spec['bh'] = $mtkk_spec['sh'] = $mtkk_smartphone_screen_height;
		$mtkk_spec['cache'] = isset($mtkk_smartphone_cache_size) && $mtkk_smartphone_cache_size? (int)$mtkk_smartphone_cache_size: INT_MAX;

		ob_start('mtkk_smartphone_output');
	}
}


$mtkk_path = $_SERVER['SCRIPT_NAME'];
$mtkk_params = array();
foreach($_GET as $mtkk_name => $mtkk_value)
	array_push($mtkk_params, $mtkk_value? urlencode($mtkk_name) . '=' . urlencode($mtkk_value): urlencode($mtkk_name));
if(count($mtkk_params)) $mtkk_path .= '?' . join('&', $mtkk_params);
$mtkk_current_url = $mtkk_path;


if($mtkk_carrier == 'other' && !isset($mtkk_smartphone) && $mtkk_pc_redirect != '') {
	if(!preg_match('/\/mt-preview-[a-zA-Z0-9]+\./', $mtkk_path)) {
		header("Location: $mtkk_pc_redirect");
		exit(0);
	}
}


if($mtkk_is_secure) {
  if(isset($mtkk_ssl_image_script)) {
    $mtkk_image_script = $mtkk_ssl_image_script;
  } else {
    $mtkk_image_script = str_replace('http://', 'https://', $mtkk_image_script);
  }
}


if($mtkk_no_cache == 'all' || $mtkk_no_cache == $mtkk_carrier)
	header('Cache-Control: no-cache');


if(!$mtkk_content_type || $mtkk_carrier == 'other' || isset($mtkk_emoji_pc))
	$mtkk_content_type = 'text/html';


$mtkk_output_encoding = 'Shift_JIS';
if(isset($mtkk_smartphone) && isset($mtkk_smartphone_encoding))
  $mtkk_output_encoding = $mtkk_smartphone_encoding;

header("Content-Type: $mtkk_content_type; charset=" . $mtkk_output_encoding);


$mtkk_use_sjis_entities = false;


mtkk_output_xhtml_headers();

function mtkk_convert_to_sjis($buffer) {
  global $mtkk_php_encoding;
  global $mtkk_use_sjis_entities;
  global $mtkk_smartphone;
  global $mtkk_smartphone_encoding;
  
  $encoding = 'SJIS-WIN';
  if(isset($mtkk_smartphone) && isset($mtkk_smartphone_encoding) && strtolower($mtkk_smartphone_encoding) == 'utf-8') {
    $encoding = $mtkk_smartphone_encoding;
  }
  
  $encoding_lower = strtolower($encoding);
  $php_encoding_lower = strtolower($mtkk_php_encoding);
  if($encoding_lower == $php_encoding_lower || ($encoding_lower == 'sjis-win' && ($php_encoding_lower == 'sjis' || $php_encoding_lower == 'shift_jis'))) {

  } else {

    $buffer = mb_convert_encoding($buffer, $encoding, $mtkk_php_encoding);
  }
  
  if($mtkk_use_sjis_entities) {
    $cb = create_function('$m',
        '$r = ""; for($i=0;$i<strlen($m[1]);$i+=2){$r .= pack("C", hexdec(substr($m[1], $i, 2)));} return $r;');
    $buffer = preg_replace_callback('/&#x\[([0-9a-z]+)\];/i', $cb, $buffer);
  }
  
  return $buffer;
}

function mtkk_smartphone_output($buffer) {
  global $mtkk_php_encoding;
  global $mtkk_smartphone_convert_kana;
  global $mtkk_smartphone_remove_style;
  global $mtkk_smartphone_encoding;
  

  if($mtkk_smartphone_convert_kana)
    $buffer = mb_convert_kana($buffer, 'KV', $mtkk_php_encoding);


  if($mtkk_smartphone_remove_style == 'all')
    $buffer = preg_replace('/\sstyle="[^"]+"/', '', $buffer);
  else if($mtkk_smartphone_remove_style == 'properties')
    $buffer = preg_replace_callback('/\sstyle="([^"]+)"/', 'mtkk_smartphone_output_properties_callback', $buffer);

  return $buffer;
}

function mtkk_smartphone_output_properties_callback($matches) {
  global $mtkk_smartphone_remove_css_properties;
  

  $properties = explode(',', strtolower($mtkk_smartphone_remove_css_properties));
  for($i = 0; $i < count($properties); $i++)
    $properties[$i] = preg_replace('/\s/', '', $properties[$i]);
  

  $style = $matches[1];
  $new_style = '';
  $styles = explode(';', $style);
  for($i = 0; $i < count($styles); $i++) {
    list($property, $value) = explode(':', $styles[$i], 2);
    $property = preg_replace('/\s/', '', $property);
    if(array_search($property, $properties) === FALSE)
      $new_style .= $styles[$i] . ';';
  }
  
  return " style=\"$new_style\"";
}


function mtkk_output_xhtml_headers() {
	global $mtkk_xml_declaration_format;
	global $mtkk_doctype_format;
	global $mtkk_xml_declaration;
	global $mtkk_doctype;
	global $mtkk_carrier;
	global $mtkk_spec;
	global $mtkk_default_doctype;
	global $mtkk_output_encoding;
	

	$xhtml_headers = '';

	$xhtml_version = 0;
	if($mtkk_carrier == 'i' && $mtkk_spec['format2']) {
		$xhtml_version = $mtkk_spec['format2'];
		if($xhtml_version > 230) $xhtml_version = 230;
	} else if($mtkk_carrier == 'ez' && $mtkk_spec['format1'] >= 600) {
		$xhtml_version = $mtkk_spec['format1'];
	} else if($mtkk_carrier == 's' && $mtkk_spec['format1'] >= 1100) {
		$xhtml_version = $mtkk_spec['format1'];
	} else if($mtkk_carrier == 'other' && isset($mtkk_default_doctype) && $mtkk_default_doctype) {
		$xhtml_version = 1;
	}
	
	if($xhtml_version) {

		if($mtkk_xml_declaration) {
			$encoding = 'Shift_JIS';
			if(isset($mtkk_output_encoding) && $mtkk_output_encoding)
				$encoding = $mtkk_output_encoding;
			$xhtml_headers .= sprintf($mtkk_xml_declaration_format, $encoding) . "\n";
		}
		

		if($mtkk_doctype)
			if(isset($mtkk_doctype_format[$mtkk_carrier]))
				$xhtml_headers .= sprintf($mtkk_doctype_format[$mtkk_carrier], $xhtml_version / 100) . "\n";
			else if(isset($mtkk_default_doctype) && $mtkk_default_doctype)
				$xhtml_headers .= $mtkk_default_doctype . "\n";
	}
	
	echo $xhtml_headers;
}




function mtkk_sjis_emoji($carrier, $code, $extra, $force_img = false) {
	global $mtkk_carrier;
	global $mtkk_spec;
	global $mtkk_image_script;
	global $mtkk_iemoji_dir;
	global $mtkk_is_secure;
	global $mtkk_convert_to_sjis;
	global $mtkk_use_sjis_entities;
	global $mtkk_emoji_sizes;
	global $mtkk_is_vga_screen;
	
	if(!$force_img && ($mtkk_carrier == $carrier || ($mtkk_carrier == 's' && $carrier == 'w'))) {

		if($mtkk_carrier == 's' && $mtkk_spec['format1'] >= 600 && $mtkk_is_secure) {
			if($extra && isset($extra['unicode'])) {

				return sprintf('&#x%x;', $extra['unicode']);
			} else {

				return '';
			}
		} else if($carrier == 'w') {

			if($mtkk_convert_to_sjis) {
				$mtkk_use_sjis_entities = true;
				return sprintf('&#x[1b24%x0f];', $code);
			}
			return pack('CCnC', 0x1b, 0x24, $code, 0x0f);
		} else {

			if($mtkk_convert_to_sjis) {
				$mtkk_use_sjis_entities = true;
				return sprintf('&#x[%x];', $code);
			}
			return pack('n', $code);
		}
	} else {

		

		if($carrier == 'w') {
			$code = $extra['sjis'];
			$carrier = 's';
		}
		

		if($mtkk_spec['img'] & MG_GIF) {
			$format = 'gif';
		} else if($mtkk_spec['img'] & MG_PNG) {
			$format = 'png';
		} else {

			return '';
		}
		

		$code = sprintf('%x', $code);
		

		$file = "$carrier/$format/$code.$format";
		$path = "$mtkk_iemoji_dir/$file";
		$size = file_exists($path)? filesize($path): 0;


		$width = $mtkk_emoji_sizes[$carrier]['width'];
		$height = $mtkk_emoji_sizes[$carrier]['height'];
		

		if($mtkk_is_vga_screen) {
			$width *= 2;
			$height *= 2;
		}


		$src = "$mtkk_image_script?mtkk_size=$size&mtkk_emoji=$file";
		return "<img src=\"$src\" border=\"0\" width=\"$width\" height=\"$height\" />";
	}
	
	return '';
}



function mtkk_emoji_alt($emoji, $use_aa) {
	global $mtkk_carrier;
	global $mtkk_spec;
	global $mtkk_emoji_size;
	global $mtkk_emoji_alt;
	global $mtkk_image_script;
	global $mtkk_iemoji_dir;
	global $mtkk_is_vga_screen;
	global $mtkk_smartphone;
	global $mtkk_smartphone_emoji_dir;

	if(isset($emoji['aa']) && $emoji['aa'] && $use_aa) {
		return $emoji['aa'];
	} else if($mtkk_emoji_alt == 'text' && isset($emoji['text'])) {

		return $emoji['text'];
	} else {



		$symbol = $emoji['symbol'];


		if($mtkk_spec['img'] & MG_GIF) {
			$format = 'gif';
		} else if($mtkk_spec['img'] & MG_PNG) {
			$format = 'png';
		} else {

			return '';
		}
		

		$file = "$symbol.$format";

		if(isset($mtkk_smartphone) && $mtkk_smartphone && $mtkk_smartphone_emoji_dir)
			$file = "$mtkk_smartphone_emoji_dir/$file";
		$path = "$mtkk_iemoji_dir/$file";
		$filesize = file_exists($path)? filesize($path): 0;
		

		$width = $height = $mtkk_emoji_size;
		if($mtkk_is_vga_screen) {

			$width *= 2;
			$height *= 2;
		}
		$src = "$mtkk_image_script?mtkk_size=$filesize&mtkk_emoji=$file";
		return "<img src=\"$src\" width=\"$width\" height=\"$height\" border=\"0\" class=\"emoji emoji-$symbol\" />";
	}
}



function mtkk_emoji($emoji) {
	echo mtkk_emoji_code($emoji);
}





function mtkk_emoji_code($emoji) {
	global $mtkk_carrier;
	global $mtkk_spec;
	global $mtkk_emoji_pc;
	global $mtkk_is_secure;
	

	if($mtkk_emoji_pc) {
		if($mtkk_carrier == 'i') {

			$code = $emoji['i'];
			if($code)
				return mtkk_sjis_emoji('i', $code, array(), true);
		} else if($mtkk_carrier == 'ez') {

			require_once('KeitaiCode.php');
			$code = KeitaiCode::ez_number_to_sjis($emoji['ez']);
			if($code)
				return mtkk_sjis_emoji('ez', $code, array(), true);
		} else if($mtkk_carrier == 's') {

			require_once('KeitaiCode.php');
			$code = KeitaiCode::s_unicode_to_sjis($emoji['s']);

			if($code)
				return mtkk_sjis_emoji('s', $code, array(), true);
		}

		return mtkk_emoji_alt($emoji, false);
	}
	
	if($mtkk_carrier == 'i' && ($code = $emoji['i'])) {

		if($code >= 63921 || $mtkk_spec['format1'] >= 400) {

			if($mtkk_spec['pict'] == 1)
				return mtkk_emoji_alt($emoji, true);
			else
				return '&#x' . dechex($emoji['iu']) . ';';
		} else {

			return "&#$code;";
		}
	} else if($mtkk_carrier == 'ez' && ($code = $emoji['ez'])) {

		if($mtkk_spec['pict'] == 1 && $code >= 335)

			return mtkk_emoji_alt($emoji, true);

		return "<img localsrc=\"$code\" />";
	} else if($mtkk_carrier == 's' && ($code = $emoji['s'])) {

		if($mtkk_spec['pict'] == 1 && $code >= 58113)
			return mtkk_emoji_alt($emoji, true);

		if($mtkk_spec['format1'] >= 600 && $mtkk_is_secure) {

			return sprintf('&#x%x;', $code);
		} else {


			if($code >= 58625) { // #6
				$c1 = 0x51;
				$c2 = 0x21 + $code - 58625;
			} else if($code >= 58369) { // #5
				$c1 = 0x50;
				$c2 = 0x21 + $code - 58369;
			} else if($code >= 58113) { // #4
				$c1 = 0x4f;
				$c2 = 0x21 + $code - 58113;
			} else if($code >= 57857) { // #3
				$c1 = 0x46;
				$c2 = 0x21 + $code - 57857;
			} else if($code >= 57601) { // #2
				$c1 = 0x45;
				$c2 = 0x21 + $code - 57601;
			} else { // #1
				$c1 = 0x47;
				$c2 = 0x21 + $code - 57345;
			}
			return pack('CCCCC', 0x1b, 0x24, $c1, $c2, 0x0f);
		}
	} else {
		return mtkk_emoji_alt($emoji, false);
	}
}


function mtkk_build_url($cache_size, $url, $sw, $sh, $c, $img, $w, $h, $fit = null, $thumbnail = 0, $copyright = null, $wallpaper = null, $maximize = false, $cache_expires = null, $magnify = null) {
	global $mtkk_image_script;
	global $mtkk_is_vga_screen;

	$url = "$mtkk_image_script?mtkk_url=" . urlencode($url);
	if(isset($sw)) $url .= "&mtkk_sw=$sw";
	if(isset($sh)) $url .= "&mtkk_sh=$sh";
	if(isset($c)) $url .= "&mtkk_c=$c";
	if(isset($img)) $url .= "&mtkk_img=$img";
	if(isset($w)) $url .= "&mtkk_w=" . urlencode($w);
	if(isset($h)) $url .= "&mtkk_h=" . urlencode($h);
	if(isset($fit)) $url .= "&mtkk_fit=$fit";
	if(isset($thumbnail)) $url .= "&mtkk_thumbnail=$thumbnail";
	if(isset($copyright)) $url .= "&mtkk_copyright=$copyright";
	if($maximize) $url .= "&mtkk_maximize=1";
	if(isset($cache_expires)) $url .= "&mtkk_cache_expires=" . (int)$cache_expires;
	if(isset($magnify)) $url .= "&mtkk_magnify=" . $magnify;
	if(isset($wallpaper)) $url .= "&mtkk_wallpaper=" . urlencode(serialize($wallpaper));
	if(isset($cache_size)) $url .= "&mtkk_cache_size=$cache_size";
	if(isset($mtkk_is_vga_screen)) $url .= "&mtkk_is_vga_screen=$mtkk_is_vga_screen";
	$url .= "&mtkk_no_arrange=1";
	
	return $url;
}



function mtkk_image($image) {
	global $mtkk_carrier;
	global $mtkk_smartphone;


	if($mtkk_carrier == 'other' && !(isset($mtkk_smartphone) || $mtkk_smartphone)) {
		echo $image['url'];
		return;
	}

	require_once('KeitaiGraphic.php');
	
	global $mtkk_convert;
	global $mtkk_identify;
	global $mtkk_temp_dir;
	global $mtkk_php_graphic;
	global $mtkk_spec;
	global $mtkk_image_script;
	global $mtkk_cache_expires;
	global $mtkk_basic_auths;
	global $mtkk_jpeg_quality;
	global $mtkk_download_proxy;
	global $mtkk_download_adapter;
	global $mtkk_php_graphic_url;
	global $mtkk_document_root;
	global $mtkk_graphic_debug_mode;
	global $mtkk_multi_servers;
	global $mtkk_cache_cleaning_prob;
	global $mtkk_http_host_var;
	global $mtkk_is_secure;
	global $mtkk_image_iconize_width;
	global $mtkk_image_iconize_height;
	global $mtkk_is_vga_screen;
	

	$kg = new KeitaiGraphic;
	$kg->convert = $mtkk_convert;
	$kg->identify = $mtkk_identify;
	$kg->temp_dir = $mtkk_temp_dir;
	$kg->php_graphic = $mtkk_php_graphic;
	$kg->cache_expires = $mtkk_cache_expires;
	$kg->basic_auths = $mtkk_basic_auths;
	$kg->jpeg_quality = $mtkk_jpeg_quality;
	$kg->cache_size = $mtkk_spec['cache'] * 1024 - 1024;
	$kg->download_proxy = $mtkk_download_proxy;
	$kg->download_adapter = $mtkk_download_adapter;
	$kg->php_graphic_url = $mtkk_php_graphic_url;
	$kg->document_root = $mtkk_document_root;
	$kg->cache_cleaning_prob = (int)$mtkk_cache_cleaning_prob;
	$kg->http_host_var = $mtkk_http_host_var;
	$kg->is_secure = $mtkk_is_secure;
	$kg->image_iconize_width = $mtkk_image_iconize_width;
	$kg->image_iconize_height = $mtkk_image_iconize_height;
	$kg->is_vga_screen = $mtkk_is_vga_screen;
	if($mtkk_graphic_debug_mode)
		$kg->debug_mode = true;
	

	if(isset($image['cache_expires']))
		$kg->temp_cache_expires = $image['cache_expires'];
	

	if($mtkk_carrier == 'ez')
		$kg->cache_size_by_format['gif'] = 25 * 1024;
	

	$copyright_arg = null;
	$copyright_url = null;
	if(isset($image['copyright']) && $image['copyright']) {
		if($mtkk_carrier == 'ez' || $mtkk_carrier == 'i') {
			$copyright_arg = $mtkk_carrier;
		} else if($mtkk_carrier == 's') {
			$copyright_url = '&copyright=' . $mtkk_carrier;
		}
	}
	

	$maximize = (isset($image['maximize']) && $image['maximize'])? true: false;
	

	$magnify = isset($image['magnify'])? $image['magnify']: null;
	

	$dw = $mtkk_spec['bw'];
	$dh = $mtkk_spec['bh'];
	if(isset($image['display']) && $image['display'] == 'screen') {
		$dw = $mtkk_spec['sw'];


		if($dw > I_EZ_MAX_WIDTH && ($mtkk_carrier == 'i' || $mtkk_carrier == 'ez')) {
			$dw = I_EZ_MAX_WIDTH;
		}
	}

	$cache = $kg->build_cache($image['url'],
		$dw, $dh, $mtkk_spec['colors'], $mtkk_spec['img'],
		isset($image['w'])? $image['w']: 0, isset($image['h'])? $image['h']: 0, isset($image['fit'])? $image['fit']: null, 0, $copyright_arg, null, $maximize, $magnify);
	

	$file = "$mtkk_temp_dir/$cache";
	$size = file_exists($file)? filesize($file): 0;
	

	$ext = $kg->last_format == 'jpeg'? 'jpg': $kg->last_format;
	if($mtkk_carrier == 's' && $image['copyright'])
		$ext = ($ext == 'jpg')? 'jpz': ($ext == 'png')? 'pnz': $ext;
	

	if($size) {
		if($mtkk_multi_servers) {

			$src = mtkk_build_url($kg->cache_size, $image['url'],
				$dw, $dh, $mtkk_spec['colors'], $mtkk_spec['img'],
				isset($image['w'])? $image['w']: 0, isset($image['h'])? $image['h']: 0, isset($image['fit'])? $image['fit']: null, 0, $copyright_arg, null, $maximize, 
				isset($image['cache_expires'])? $image['cache_expires']: null, isset($image['magnify'])? $image['magnify']: null);
			$src .= "&mtkk_size=$size";
		} else {

			$src = "$mtkk_image_script?mtkk_image=$cache&mtkk_size=$size";
		}
		if($copyright_url)
			$src .= $copyright_url;
		if($ext)
			$src .= "&ext=dummy.$ext";
	} else {
		$src = $image['url'];
	}
	

	echo $src;
}



function mtkk_build_image_tag($attr) {
	$html = '<img';


	if(isset($attr['width']) && substr($attr['width'], -1, 1) != '%')
		$attr['width'] = null;
	
	if(isset($attr['height']) && substr($attr['height'], -1, 1) != '%')
		$attr['height'] = null;


	foreach($attr as $name => $value)
		if(isset($value))
			$html .= " $name=\"$value\"";
	$html .= ' />';

	return $html;
}



function mtkk_image_tag($image) {
	global $mtkk_carrier;
	global $mtkk_spec;
	global $mtkk_smartphone;
	global $mtkk_image_tag_alt_function;
	

	$keitai_attr = array('w' => 'width', 'h' => 'height');
	foreach($keitai_attr as $param => $attr) {
		if(isset($image['attr']['keitai:'.$attr])) {
			$image[$param] = $image['attr']['keitai:'.$attr];
			unset($image['attr']['keitai:'.$attr]);
		}
	}
	

	if(isset($image['url']) && substr($image['url'], 0, 1) == '$')
		$image['url'] = $image['attr']['src'] = $GLOBALS[substr($image['url'], 1)];


	if(isset($mtkk_image_tag_alt_function)) {
	  if(($result = $mtkk_image_tag_alt_function($image)) !== false) {
	    echo $result;
	    return;
	  }
	}


	if($mtkk_carrier == 'other' && !(isset($mtkk_smartphone) || $mtkk_smartphone)) {
		$image['attr']['src'] = $image['url'];
		echo mtkk_build_image_tag($image['attr']);
		return;
	}
	

	if($mtkk_spec['img'] == 0)
		return;

	require_once('KeitaiGraphic.php');
	
	global $mtkk_convert;
	global $mtkk_identify;
	global $mtkk_temp_dir;
	global $mtkk_php_graphic;
	global $mtkk_image_script;
	global $mtkk_cache_expires;
	global $mtkk_basic_auths;
	global $mtkk_jpeg_quality;
	global $mtkk_download_proxy;
	global $mtkk_download_adapter;
	global $mtkk_php_graphic_url;
	global $mtkk_document_root;
	global $mtkk_graphic_debug_mode;

	global $mtkk_link_images;
	global $mtkk_link_images_over;
	global $mtkk_link_images_format;
	global $mtkk_link_images_before;
	global $mtkk_link_images_after;
	global $mtkk_link_images_align;
	global $mtkk_link_images_thumbnail;
	global $mtkk_link_images_page;
	global $mtkk_link_images_caption;
	global $mtkk_multi_servers;
	global $mtkk_cache_cleaning_prob;
	global $mtkk_http_host_var;
	global $mtkk_is_secure;
	global $mtkk_image_iconize_width;
	global $mtkk_image_iconize_height;
	global $mtkk_is_vga_screen;
	

	$kg = new KeitaiGraphic;
	$kg->convert = $mtkk_convert;
	$kg->identify = $mtkk_identify;
	$kg->temp_dir = $mtkk_temp_dir;
	$kg->php_graphic = $mtkk_php_graphic;
	$kg->cache_expires = $mtkk_cache_expires;
	$kg->basic_auths = $mtkk_basic_auths;
	$kg->jpeg_quality = $mtkk_jpeg_quality;
	$kg->cache_size = $mtkk_spec['cache'] * 1024 - 1024;
	$kg->download_proxy = $mtkk_download_proxy;
	$kg->download_adapter = $mtkk_download_adapter;
	$kg->php_graphic_url = $mtkk_php_graphic_url;
	$kg->document_root = $mtkk_document_root;
	$kg->cache_cleaning_prob = (int)$mtkk_cache_cleaning_prob;
	$kg->http_host_var = $mtkk_http_host_var;
	$kg->is_secure = $mtkk_is_secure;
	$kg->image_iconize_width = $mtkk_image_iconize_width;
	$kg->image_iconize_height = $mtkk_image_iconize_height;
	$kg->is_vga_screen = $mtkk_is_vga_screen;
	if($mtkk_graphic_debug_mode)
		$kg->debug_mode = true;
	

	if(isset($image['cache_expires']))
		$kg->temp_cache_expires = $image['cache_expires'];
	

	if($mtkk_carrier == 'ez')
		$kg->cache_size_by_format['gif'] = 25 * 1024;
	

	$copyright_arg = null;
	$copyright_url = null;
	if($image['copyright']) {
		if($mtkk_carrier == 'ez' || $mtkk_carrier == 'i') {
			$copyright_arg = $mtkk_carrier;
		} else if($mtkk_carrier == 's') {
			$copyright_url = '&copyright=' . $mtkk_carrier;
		}
	}
	

	$maximize = $image['maximize']? true: false;
	

	$dw = $mtkk_spec['bw'];
	$dh = $mtkk_spec['bh'];
	if(isset($image['display']) && $image['display'] == 'screen') {
		$dw = $mtkk_spec['sw'];


		if($dw > I_EZ_MAX_WIDTH && ($mtkk_carrier == 'i' || $mtkk_carrier == 'ez')) {
			$dw = I_EZ_MAX_WIDTH;
		}
	}

	$image_url = '';
	if($image['wallpaper']) {

		$cache = $kg->build_cache($image['url'],
			$mtkk_spec['sw'], $mtkk_spec['sh'], $mtkk_spec['colors'], $mtkk_spec['img'],
			0, 0, null, 0, $copyright_arg, $image['wallpaper']);
		if($mtkk_multi_servers) {
			$image_url = mtkk_build_url($kg->cache_size, $image['url'],
				$mtkk_spec['sw'], $mtkk_spec['sh'], $mtkk_spec['colors'], $mtkk_spec['img'],
				0, 0, null, 0, null, $image['wallpaper'], false, 
				isset($image['cache_expires'])? $image['cache_expires']: null);
		}
	} else {

		$cache = $kg->build_cache($image['url'],
			$dw, $dh, $mtkk_spec['colors'], $mtkk_spec['img'],
			isset($image['w'])? $image['w']: 0, isset($image['h'])? $image['h']: 0, isset($image['fit'])? $image['fit']: null, 0, $copyright_arg, null, $maximize,
			isset($image['magnify'])? $image['magnify']: null);
		if($mtkk_multi_servers) {

			$image_url = mtkk_build_url($kg->cache_size, $image['url'],
				$dw, $dh, $mtkk_spec['colors'], $mtkk_spec['img'],
				isset($image['w'])? $image['w']: 0, isset($image['h'])? $image['h']: 0, isset($image['fit'])? $image['fit']: null, 0, $copyright_arg, null, $maximize,
				isset($image['cache_expires'])? $image['cache_expires']: null, isset($image['magnify'])? $image['magnify']: null);
		}
	}
	

	if(strlen($cache) < 1) {
		global $mtkk_image_convert_error;


		if($mtkk_image_convert_error != 'hide')
			echo '<p>' . $kg->last_error . '<br />';
			echo '<a href="' . $image['url'] . '">' . $image['url'] . '</a></p>';

		return;
	}
	

	$file = "$mtkk_temp_dir/$cache";
	$size = file_exists($file)? filesize($file): 0;
	

	$ext = $kg->last_format == 'jpeg'? 'jpg': $kg->last_format;
	if($mtkk_carrier == 's' && $image['copyright'])
		$ext = ($ext == 'jpg')? 'jpz': ($ext == 'png')? 'pnz': $ext;
	

	if($size) {
		if($mtkk_multi_servers) {
			$src = $href = $image_url;
			$src .= "&mtkk_size=$size";
		} else {
			$src = "$mtkk_image_script?mtkk_image=$cache&mtkk_size=$size";
			$href = "$mtkk_image_script?mtkk_image=$cache";
		}
		if($copyright_url) {
			$src .= $copyright_url;
			$href .= $copyright_url;
		}
		if($ext) {
			$src .= "&ext=dummy.$ext";
			$href .= "&ext=dummy.$ext";
		}
	} else {
		$src = $href = $image['url'];
	}
	

	if($mtkk_link_images) {
		$over = $mtkk_link_images_over;
		if(substr($over, -1, 1) == '%')
			$over = (int)($kg->cache_size * (int)substr($over, 0, -1) / 100);
		else if($over)
			$over = (int)$over;
		else
			$over = 0;
	
		if($size >= $over) {

			$format = $mtkk_link_images_format;
			if(!$format)
				$format = '%c(%k)';
			$find = array();
			$replace = array();
			
			$format_test = "$format/$mtkk_link_images_before/$mtkk_link_images_after/$mtkk_link_images_caption";
			

			if(strpos($format_test, '%t') !== FALSE) {

				$thumbnail = $mtkk_link_images_thumbnail;
				if(substr($thumbnail, -1, 1) == '%')
					$thumbnail = (int)($dw * (int)substr($thumbnail, 0, -1) / 100);
				else if($thumbnail)
					$thumbnail = (int)$thumbnail;
				else
					$thumbnail = 32;
				
				$thumbnail_cache = $kg->build_cache($image['url'],
					$dw, $dh, $mtkk_spec['colors'], $mtkk_spec['img'],
					0, 0, null, $thumbnail, $copyright_arg, $image['wallpaper']);
				

				$thumbnail_file = "$mtkk_temp_dir/$thumbnail_cache";
				$thumbnail_size = file_exists($thumbnail_file)? filesize($thumbnail_file): 0;
				

				$ext = $kg->last_format == 'jpeg'? 'jpg': $kg->last_format;
				if($mtkk_carrier == 's' && $image['copyright'])
					$ext = ($ext == 'jpg')? 'jpz': ($ext == 'png')? 'pnz': $ext;
				

				if($size) {
					if($mtkk_multi_servers) {

						$thumbnail_image['src'] = mtkk_build_url($kg->cache_size, $image['url'],
							$dw, $dh, $mtkk_spec['colors'], $mtkk_spec['img'],
							0, 0, null, $thumbnail, $copyright_arg, $image['wallpaper'], false,
							isset($image['cache_expires'])? $image['cache_expires']: null,
							isset($image['magnify'])? $image['magnify']: null);
						$thumbnail_image['src'] .= "&mtkk_size=$thumbnail_size";
					} else {

						$thumbnail_image['src'] = "$mtkk_image_script?mtkk_image=$thumbnail_cache&mtkk_size=$thumbnail_size";
					}
					if($copyright_url)
						$thumbnail_image['src'] .= $copyright_url;
					if($ext)
						$thumbnail_image['src'] .= "&ext=dummy.$ext";
				} else {
					$thumbnail_image['src'] = $image['url'];
				}
				
				array_push($find, '%t');
				array_push($replace, mtkk_build_image_tag($thumbnail_image));
			}
			

			if(strpos($format_test, '%n') !== FALSE) {
				array_push($find, '%n');
				array_push($replace, '<br />');
			}


			if(strpos($format_test, '%a') !== FALSE) {
				array_push($find, '%a');
				array_push($replace, isset($image['attr']['alt'])? $image['attr']['alt']: '');
			}


			if(strpos($format_test, '%b') !== FALSE) {
				array_push($find, '%b');
				array_push($replace, $size);
			}


			if(strpos($format_test, '%k') !== FALSE) {
				array_push($find, '%k');
				array_push($replace, sprintf('%0.1fkb', $size / 1024));
			}


			if(strpos($format_test, '%c') !== FALSE) {
				array_push($find, '%c');
				array_push($replace, mtkk_emoji_code(array('symbol'=>'camera', 'i' => 63714, 'iu' => 59009, 'ez' => 94, 's' => 57352, 'text' => '[IMAGE]')));
			}
			

			if(strpos($format_test, '%l') !== FALSE) {
				array_push($find, '%l');
				array_push($replace, mtkk_emoji_code(array('symbol'=>'search', 'i' => 63873, 'iu' => 59100, 'ez' => 119, 's' => 57620, 'text' => '[ZOOM]')));
			}
			if(strpos($format_test, '%s') !== FALSE) {
				array_push($find, '%s');
				array_push($replace, mtkk_emoji_code(array('symbol'=>'search', 'i' => 63873, 'iu' => 59100, 'ez' => 119, 's' => 57620, 'text' => '[ZOOM]')));
			}


			$label = str_replace($find, $replace, $format);
			$before = str_replace($find, $replace, $mtkk_link_images_before);
			$after = str_replace($find, $replace, $mtkk_link_images_after);
			

			if($mtkk_link_images_page) {
				global $mtkk_current_url;
				global $mtkk_php_encoding;

				# GETパラメータとして画像URL、キャプション、戻り先(現在のページURL)を追加
				$linked_image = urlencode($href);
				$linked_caption = urlencode(mb_convert_encoding(str_replace($find, $replace, $mtkk_link_images_caption), 'UTF-8', $mtkk_php_encoding));
				$linked_backto = urlencode($mtkk_current_url);
				
				# リンク先URLを変更
				$href = sprintf('%s?mtkk_linked_image=%s&mtkk_linked_caption=%s&mtkk_linked_backto=%s',
					$mtkk_link_images_page, $linked_image, $linked_caption, $linked_backto);
			}

			if($mtkk_link_images_align)
				echo "<div align=\"$mtkk_link_images_align\" style=\"text-align:$mtkk_link_images_align\">";
			if($before)
				echo $before;
			echo "<a href=\"$href\">$label</a>";
			if($after)
				echo $after;
			if($mtkk_link_images_align)
				echo "</div>";
			return;
		}
	}



	$image['attr']['src'] = $src;
	echo mtkk_build_image_tag($image['attr']);
	return;
}




function mtkk_hankaku($kana, $only_mobile) {
	global $mtkk_carrier;
	

	if(($only_mobile && $mtkk_carrier != 'other') || !$only_mobile)
		$kana = mb_convert_kana($kana, 'k', 'SJIS-WIN');

	echo $kana;
}


$mtkk_session_id = null;
if($mtkk_use_session && $mtkk_session_param) {
	$mtkk_session_id = $_GET[$mtkk_session_param];
	if($mtkk_session_id) {

		session_id($mtkk_session_id);
		session_start();
	} else if($mtkk_start_session) {

		session_start();
		$mtkk_session_id = session_id();
	}
}


if($mtkk_paginated) {
	$mtkk_max_page = 1;
	$mtkk_current_page = (isset($_GET[$mtkk_selector]) && preg_match('/^[0-9]+$/', $_GET[$mtkk_selector]))? $_GET[$mtkk_selector]: 1;
	$mtkk_path = preg_replace("/&?$mtkk_selector=[^&]+/", '', $mtkk_path);
	ob_start("mtkk_paginate");
} else if($mtkk_use_session && $mtkk_session_id) {

	ob_start('mtkk_session_link');
}


$mtkk_path .= strpos($mtkk_path, '?') < 1? '?': '';
$mtkk_path .= substr($mtkk_path, -1, 1) != '?'? '&': '';


function mtkk_paginate($buffer) {
	global $mtkk_max_page;
	global $mtkk_page_num;
	global $mtkk_current_page;
	global $mtkk_spec;
	global $mtkk_ez_cache;
	global $mtkk_s_cache;
	global $mtkk_footer_bytes;
	global $mtkk_max_bytes;
	global $mtkk_max_sections;
	global $mtkk_paginate_order;
	global $mtkk_php_encoding;
	global $mtkk_smartphone;
	global $mtkk_smartphone_encoding;
	global $mtkk_crawler_keywords;
	global $mtkk_ua;
	
	$is_crawler = false;
	if($mtkk_crawler_keywords && $mtkk_ua) {
		$ua = strtolower($mtkk_ua);
		$keywords = preg_split('/\s*,\s*/', $mtkk_crawler_keywords);
		foreach($keywords as $keyword) {
			if(strpos($ua, strtolower($keyword)) !== false) {
				$is_crawler = true;
				break;
			}
		}
	}
	

	if($is_crawler) return $buffer;
	

	$cache = (int)($mtkk_spec['cache'] * 1024);
	if($mtkk_max_bytes != 0 && $mtkk_max_bytes <= $cache)
		$cache = $mtkk_max_bytes;
	if($cache <= 0)
		$cache = INT_MAX;


	$text_cache = INT_MAX;
	if($mtkk_ez_cache)
		$text_cache = (int)($mtkk_ez_cache * 1024);
	else if($mtkk_s_cache)
		$text_cache = (int)($mtkk_s_cache * 1024);
		

	$max_sections = $mtkk_max_sections;
	if($max_sections <= 0)
		$max_sections = INT_MAX;


	$reverse = ($mtkk_paginate_order == 'reverse')? true: false;
	

	$last_encoding = 'SJIS-WIN';
	$php_encoding = strtolower($mtkk_php_encoding);
	if($php_encoding == 'sjis' || $php_encoding == 'shift_jis')
		$php_encoding = 'SJIS-WIN';
	
	if(isset($mtkk_smartphone) && isset($mtkk_smartphone_encoding))
		$last_encoding = $mtkk_smartphone_encoding;

	$buffers = explode('<!--mtkk-->', $buffer);
	$buffer_top = array_shift($buffers);
	$count_text_init = $count_init = strlen(mb_convert_encoding($buffer_top, $last_encoding, $php_encoding)) + (int)$mtkk_footer_bytes;
	if(preg_match_all('/mtkk_size=([0-9]+)/', $buffer_top, $matches))
		for($j = 0; $j < count($matches[1]); $j++)
			$count_init += $matches[1][$j];
	
	$count = $count_init;
	$count_text = $count_text_init;
	$buffer = '';
	$section = 0;
	$section_size = 0;
	$buffer_count = count($buffers);
	for($i = 0; $i < $buffer_count; $i++) {
		$b = $buffers[$reverse? $buffer_count - 1 - $i: $i];

		if(preg_match('/^\s+$/', $b)) continue;


		if($section_size == 0) {
			$section_text_size = $section_size = strlen(mb_convert_encoding($b, $last_encoding, $php_encoding));
			if(preg_match_all('/mtkk_size=([0-9]+)/', $b, $matches))
				for($j = 0; $j < count($matches[1]); $j++)
					$section_size += $matches[1][$j];
		}
		

		if($section == 0 || ($count + $section_size < $cache && $count_text + $section_text_size < $text_cache && $section < $max_sections)) {
			if($mtkk_max_page == $mtkk_current_page) {
				if($reverse)
					$buffer = $b . $buffer;
				else
					$buffer .= $b;
			}
			$count += $section_size;
			$count_text += $section_text_size;
			$section_size = 0;
			$section++;
		} else {
			$mtkk_max_page++;
			$count = $count_init;
			$count_text = $count_text_init;
			$section = 0;
			$i--;
		}
	}
	
	$result = $buffer_top . $buffer;


	global $mtkk_use_session;
	global $mtkk_session_id;
	if($mtkk_use_session && $mtkk_session_id) {
		global $mtkk_session_param;
		global $mtkk_session_external_urls;
		global $mtkk_session_jsp_style_urls;

		mtkk_replace_session_link($result, $mtkk_session_id, $mtkk_session_param, $mtkk_session_external_urls, $mtkk_session_jsp_style_urls);
	}
	
	return $result;
}


function mtkk_input_style($style, $extra_style = '') {
	global $mtkk_carrier;
	global $mtkk_ixhtml;
	global $mtkk_model_id;
	global $mtkk_ez_no_input_style;
	
	if($mtkk_carrier == 's') {

		$modes = array(1 => 'hiragana', 'katakana' => 'hankakukana', 2 => 'hankakukana', 3 => 'alphabet', 4 => 'numeric');
		echo ' mode="' . (isset($modes[$style])? $modes[$style]: $style) . '"';
	} else {

		$istyles = array('hiragana' => 1, 'katakana' => 2, 'hankakukana' => 2, 'alphabet' => 3, 'numeric' => 4);
		echo ' istyle="' . (isset($istyles[$style])? $istyles[$style]: $style) . '"';
	}
	

	$no_input_style = array();
	if($mtkk_carrier == 'ez')
		$no_input_style = preg_split('/\s*,\s*/', $mtkk_ez_no_input_style);
	

	if(($mtkk_carrier == 'i' && isset($mtkk_ixhtml) && $mtkk_ixhtml) || ($mtkk_carrier == 'ez' && array_search($mtkk_model_id, $no_input_style) === false)) {
		$modes = array(1 => 'hiragana', 'tatakana' => 'hankakukana', 2 => 'hankakukana', 3 => 'alphabet', 4 => 'numeric');
		$style = isset($modes[$style])? $modes[$style]: $style;
	    $styles = array(
            'hiragana' =>    '-wap-input-format:&quot;*&lt;ja:h&gt;&quot;;-wap-input-format:*M;',
            'hankakukana' => '-wap-input-format:&quot;*&lt;ja:hk&gt;&quot;;-wap-input-format:*M;',
            'alphabet' =>    '-wap-input-format:&quot;*&lt;ja:en&gt;&quot;;-wap-input-format:*m;',
            'numeric' =>     '-wap-input-format:&quot;*&lt;ja:n&gt;&quot;;-wap-input-format:*N;'
	    );
	    echo ' style="' . (isset($styles[$style])? $styles[$style]: $style) . $extra_style . '"';
	}
}


function mtkk_layer_link($layer) {
	global $mtkk_path;
	global $mtkk_layerer;


	$path = preg_replace("/$mtkk_leyerer=[^&]+&?/", '', $mtkk_path);
	if($layer != '')
		$path .= "&$mtkk_layerer=$layer";
	
	return $path;
}


function mtkk_current_url($reject_session = true) {

	global $mtkk_http_host_var;
	global $mtkk_is_secure;

	$host = $_SERVER[$mtkk_http_host_var];
	$url = ($mtkk_is_secure ? 'https': 'http') . '://' . $host;
	if(isset($_SERVER['REQUEST_URI'])) {
		$url .= $_SERVER["REQUEST_URI"];
	} else {
		$url .= $_SERVER['SCRIPT_NAME'];
		if($_SERVER['QUERY_STRING'])
			$url .= '?' . $_SERVER['QUERY_STRING'];
	}
	global $mtkk_use_session;
	global $mtkk_session_param;
	if($reject_session && $mtkk_use_session && $mtkk_session_param) {
		$url = preg_replace("/$mtkk_session_param=[^&]+&/", '', $url);
		$url = preg_replace("/[?&]$mtkk_session_param=[^&]+$/", '', $url);
	}
	return $url;
}


function mtkk_replace_session_link(&$html, $session_id, $session_name, $external_urls, $jsp_style_urls) {
	$result = '';
	

	$session = "$session_name=$session_id";
	

	while(TRUE) {

		$follow = stristr($html, '<a');
		if($follow === FALSE)
			break;

		$result .= substr($html, 0, strlen($html) - strlen($follow));
		$html = $follow;


		if(!preg_match('/^<a\s/i', $follow)) {
			$result .= substr($html, 0, 2);
			$html = substr($html, 2);
			continue;
		}


		$follow = stristr($html, '>');
		if($follow === FALSE)
			break;

		$a = substr($html, 0, strlen($html) - strlen($follow));
		$html = $follow;
		

		if(preg_match('/\shref=["\']([^"\']+)["\']/i', $a, $matches)) {
			$link = $matches[1];

			if(!preg_match("/$session/", $link)) {
				$protocol = strpos($link, ':') !== FALSE? TRUE: FALSE;
				if((!$protocol && substr($link, 0, 1) != '#') || ($protocol && preg_match('/^https?:/i', $link))) {

					$external = preg_match('/^https?:/i', $link)? TRUE: FALSE;
					if($external) {
						foreach($external_urls as $url) {
							if(strpos($link, $url) !== FALSE) {
								$external = FALSE;
								break;
							}
						}
					}
					

					if(!$external) {

						$jsp_style = preg_match('/(\.jsp)($|\\?|#)/', $link)? TRUE: FALSE;
						if(!$jsp_style && isset($jsp_style_urls) && is_array($jsp_style_urls)) {
							foreach($jsp_style_urls as $url) {
								if(strpos($link, $url) !== FALSE) {
									$jsp_style = TRUE;
									break;
								}
							}
						}
						

						if($jsp_style)
							$session_link = preg_replace('/($|\\?|#)/i', ";$session\\1", $link, 1);
						else if(strpos($link, '?') !== FALSE)
							$session_link = preg_replace('/\\?/', "?$session&", $link, 1);
						else
							$session_link = preg_replace('/($|#)/', "?$session\\1", $link, 1);

						$a = str_replace($link, $session_link, $a);
					}
				}
			}
		}
		
		$result .= $a;
	}
	
	$result .= $html;
	
	$html = $result;
}


function mtkk_session_link($buffer) {
	global $mtkk_session_id;
	global $mtkk_session_param;
	global $mtkk_session_external_urls;
	global $mtkk_session_jsp_style_urls;
	mtkk_replace_session_link($buffer, $mtkk_session_id, $mtkk_session_param, $mtkk_session_external_urls, $mtkk_session_jsp_style_urls);
	
	return $buffer;
}


function mtkk_session_include($php) {

	$ob_handlers = ob_list_handlers();
	foreach($ob_handlers as $ob_handler) {
		if(preg_match('/^mtkk_/', $ob_handler)) {
			$custom_handler = true;
			break;
		}
	}


	include($php);
	


	if($custom_handler)
		ob_start($ob_handler);

}

?>