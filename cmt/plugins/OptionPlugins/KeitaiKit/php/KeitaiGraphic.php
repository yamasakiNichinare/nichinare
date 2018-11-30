<?php


	if(!defined('MG_JPEG')) define('MG_JPEG', 0x0001);
	if(!defined('MG_GIF')) define('MG_GIF', 0x0002);
	if(!defined('MG_PNG')) define('MG_PNG', 0x0008);

	class KeitaiGraphic {

		var $debug_mode = false;

		var $debug_log = 3;

		var $debug_dest = 'debug.log';
		

		function report_log($log_title, $log_array) {
			if($log_title)
				array_unshift($log_array, "\n$log_title");
			array_push($log_array, "");
			error_log(join("\n", $log_array), $this->debug_log, $this->debug_dest);
		}


		var $convert;
		

		var $identify;
		

		var $temp_dir;
		



		var $php_graphic;
		

		var $cache_expires = 1209600;
		

		var $temp_cache_expires = null;
		

		var $basic_auths = '';
		

		var $jpeg_quality = 75;
		

		var $download_proxy = '';
		

		var $cache_size = 2147483647;
		

		var $cache_size_by_format = array();
		

		var $php_graphic_url;
		

		var $force_convert = false;
		

		var $document_root = '';
		

		var $cache_cleaning_prob = 0;
		

		var $last_format = '';
		

		var $last_error = '';
		

		var $with_ext = false;
		

		var $format = null;
		

		var $download_adapter = '';
		

		var $http_host_var = 'HTTP_HOST';
		

		var $is_secure = false;
		

		var $is_vga_screen = false;
		

		var $image_iconize_width = null;
		var $image_iconize_height = null;
		

		function clean_cache() {

			if($this->cache_cleaning_prob) {
				srand((double)microtime() * 1000000);
				if(rand(1, $this->cache_cleaning_prob) != 1)
					return;
			} else {
				return;
			}
			

			if($this->debug_mode)
				$logs = array("cleaning cache: start");


			$threshold = time() - $this->cache_expires;


			if($dir = opendir($this->temp_dir)) {

				while(($file = readdir($dir)) !== false) {

					$cache = $this->temp_dir . '/' . $file;


					if(is_file($cache) && filemtime($cache) < $threshold) {

						unlink($cache);
						if($this->debug_mode)
							array_push($logs, "delete: $file");
					}
				}
			}


			if($this->debug_mode)
				$this->report_log(__FUNCTION__, $logs);
		}
		



		function download_image($url, $basic_auth = true) {
			if($this->debug_mode) {
				$logs = array("download image");
				array_push($logs, "url: " . $url);
				if($this->download_proxy)
					array_push($logs, "proxy: " . $this->download_proxy);
				if($this->download_adapter)
					array_push($logs, "adapter: " . $this->download_adapter);
				$this->report_log(__FUNCTION__, $logs);
			}
			

			$url = str_replace(' ', '%20', $url);
			

			$auths = '';
			if($basic_auth && $this->basic_auths)
				$auths = '/' . $this->basic_auths;
				

			$adapter = strtolower($this->download_adapter);
			

			foreach(explode('/', $auths) as $auth) {
				$auth = explode(':', $auth, 2);
				$user = '';
				$pass = '';
				if(isset($auth[0])) $user = $auth[0];
				if(isset($auth[1])) $pass = $auth[1];
				
				if($adapter == 'curl') {

					$result = $this->download_by_curl($url, $user, $pass);
				} else if($adapter == 'http_request') {

					$result = $this->download_by_http_request($url, $user, $pass);
				} else {

					$result = $this->download_by_php($url, $user, $pass);
				}
				
				if(strlen($result) > 0)
					return $result;
				
				if($this->debug_mode) {
					array_push($logs, "failure to download $url");
					array_push($logs, "basic auth: $user:$pass");
					array_push($logs, "proxy: " . $this->download_proxy);
					array_push($logs, "error: " . $this->last_error);
					$this->report_log(__FUNCTION__, $logs);
				}
			}
			
			return '';
		}
		

		function download_by_curl($url, $user, $pass) {
			$result = '';
			

			$ch = curl_init();
			if(!$ch) {
				$this->last_error = 'Failure to init curl';
				return '';
			}


			curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
			curl_setopt($ch, CURLOPT_BINARYTRANSFER, 1);
			curl_setopt($ch, CURLOPT_FAILONERROR, 1);
			curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
			curl_setopt($ch, CURLOPT_TIMEOUT, 30);
			

			if($this->download_proxy) {
				curl_setopt($ch, CURLOPT_HTTPPROXYTUNNEL, 1);
				curl_setopt($ch, CURLOPT_PROXYUSERPWD, '');
				curl_setopt($ch, CURLOPT_PROXY, $this->download_proxy);
				$proxy = explode(':', $this->download_proxy, 2);
				if(isset($proxy[1]))
					curl_setopt($ch, CURLOPT_PROXYPORT, $proxy[1]);
			}
			

			if($user) {
				curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_ANY);
				curl_setopt($ch, CURLOPT_USERPWD, "$user:$pass");
			}
			

			curl_setopt($ch, CURLOPT_URL, $url);
			$result = curl_exec($ch);
			if(curl_errno($ch)) {
				$this->last_error = curl_error($ch);
				$result = '';
			}
			
			curl_close($ch);
			
			return $result;
		}
		

		function download_by_http_request($url, $user, $pass) {
			require_once('HTTP/Request.php');
			

			$req = new HTTP_Request($url);
			

			if($user) $req->setBasicAuth($user, $pass);
			

			if($this->download_proxy) {
				$proxy = explode(':', $this->download_proxy, 2);
				if(!isset($proxy[1])) $proxy[1] = 8080;
				$req->setProxy($proxy[0], $proxy[1]);
			}
			

			$req->setMethod(HTTP_REQUEST_METHOD_GET);
			$res = $req->sendRequest();
			if(PEAR::isError($res)) {

				$this->last_error = PEAR_Error::getMessage();
				return '';
			}
			
			if($req->getResponseCode() >= 400) {

				$this->last_error = $req->getResponseCode() . ' ' . $req->getResponseReason();
				return '';
			}

			return $req->getResponseBody();
		}
		

		function download_by_php($url, $user, $pass) {

			$context = null;
			if($this->download_proxy) {
				$context = stream_context_create(
					array('http' => array('proxy' => 'tcp://' . $this->download_proxy))
				);
			}


			$error_reporting = error_reporting();
			error_reporting(E_ERROR);


			$allow_url_fopen = ini_get('allow_url_fopen');
			if(!$allow_url_fopen) ini_set('allow_url_fopen', 1);


			$auth = null;
			if($user) $auth = $user;
			if($pass) $auth .= ":$pass";
			if($auth) $url = str_replace('://', "://$auth@", $url);


			$result = '';


			if($context)
				$result = @file_get_contents($url, false, $context);
			else
				$result = @file_get_contents($url);
			

			if(strlen($result) < 1 && $php_errormsg)
				$this->last_error = $php_errormsg;
			

			if(!$allow_url_fopen)
				ini_set('allow_url_fopen', $allow_url_fopen);
			

			error_reporting($error_reporting);
			
			return $result;
		}
		












		function build_cache($url, $sw, $sh, $c, $img, $w, $h, $fit = null, $thumbnail = 0, $copyright = null, $wallpaper = null, $maximize = false, $magnify = null) {

			$this->clean_cache();


			$wallpaper_serial = serialize($wallpaper);


			if($this->debug_mode) {
				$args = func_get_args();
				array_push($args, $this->cache_size);
				$logs = array("arguments: " . join(',', $args));
				array_push($logs, "graphic: " . $this->php_graphic);
				array_push($logs, "graphic url: " . $this->php_graphic_url);
				array_push($logs, "copyright : " . $copyright);
				array_push($logs, "wallpaper : " . $wallpaper_serial);
				array_push($logs, "maximize : " . ($maximize? 'true': 'false'));
				array_push($logs, "cache_expires : " . $this->cache_expires);
				if(isset($this->temp_cache_expires))
					array_push($logs, "temp_cache_expires : " . $this->temp_cache_expires);
			}


			$tmp = $this->temp_dir;
		

			$c = $c <= 2? 1: 7;
		


			$src_cache = "$tmp/" . md5("$url");
			

			$get_src_via_http = true;
			

			if(strpos($url, 'http://') !== 0 && strpos($url, 'https://') !== 0) {

				$protocol = 'http';
				if($this->is_secure)
					$protocol = 'https';
					

				$server = $_SERVER[$this->http_host_var];
				

				if(strpos($url, '/') !== 0) {
					$uri = $_SERVER['SCRIPT_NAME'];
					if(($pos = strrpos($uri, '/')) > 0) {
						$url = substr($uri, 0, $pos + 1) . $url;
					} else if(strlen($uri) == 0) {
						$url = "/$url";
					} else {
						$url = "/$uri/$url";
					}
				}
				

				if(strlen($this->document_root) > 0) {

					$base_path = $this->document_root;
					$sub_path = urldecode($url);


					$char = substr($base_path, -1, 1);
					if($char == '\\' || $char == '/')
						$base_path = substr($base_path, 0, -1);


					$char = substr($sub_path, 0, 1);
					if($char == '\\' || $char == '/')
						$sub_path = substr($sub_path, 1, strlen($sub_path) - 1);


					if(file_exists("$base_path/$sub_path")) {
						$src_cache = "$base_path/$sub_path";
						$get_src_via_http = false;
					}
				}


				$url = "$protocol://$server$url";
				
			} else if($this->document_root) {

				$path = null;

				$host = $_SERVER[$this->http_host_var];
				foreach(array('http', 'https') as $protocol) {
					$test = "$protocol://$host/";
					if(strpos($url, $test) === 0) {
						$path = substr($url, strlen($test));
						break;
					}
				}
				
				if($path) {
					$base_path = $this->document_root;


					$char = substr($base_path, -1, 1);
					if($char == '\\' || $char == '/')
						$base_path = substr($base_path, 0, -1);
					

					$path = "$base_path/$path";
					if(file_exists($path)) {
						$src_cache = $path;
						$get_src_via_http = false;
					} else if(file_exists(urldecode($path))) {

						$src_cache = urldecode($path);
						$get_src_via_http = false;
					}
				}
			}
			

			$original_id = "$url$sw$sh$c$img$w$h$fit$thumbnail" . ($copyright? $copyright: '') . ($this->jpeg_quality? $this->jpeg_quality: '') . "$wallpaper_serial" . $this->cache_size . "$maximize";
			$original_id .= $this->is_vga_screen;
			if(isset($this->image_iconize_width))
				$original_id .= $this->image_iconize_width;
			if(isset($this->image_iconize_height))
				$original_id .= $this->image_iconize_height;
			if($this->debug_mode) {
				array_push($logs, "original id: $original_id");
			}
			if($magnify) $original_id .= $magnify;


			$cache = md5($original_id);
			$dest_cache = "$tmp/$cache";
			

			if($this->format && $this->with_ext) {
				$ext = $this->format == 'jpeg'? 'jpg': $this->format;
				$dest_cache .= ".$ext";
			}
			


			$t = time();
			



			$src_filetime = file_exists($src_cache)? filemtime($src_cache): 0;
			$dest_filetime = file_exists($dest_cache)? filemtime($dest_cache): 0;


			$cache_expires = $this->cache_expires;
			if(isset($this->temp_cache_expires))
				$cache_expires = $this->temp_cache_expires;


			if($this->force_convert || !file_exists($dest_cache) || (file_exists($dest_cache) && filesize($dest_cache) == 0) || $src_filetime > $dest_filetime || $t - $dest_filetime > $cache_expires) {

				if($this->php_graphic == 'http' && $this->php_graphic_url) {

					$args = array('url' => $url, 'sw' => $sw, 'sh' => $sh, 'c' => $c, 'img' => $img, 'w' => $w, 'h' => $h,
						'fit' => $fit, 'thumbnail' => $thumbmail, 'copyright' => $copyright, 'wallpaper' => $wallpaper_serial, 'maximize' => $maximize? 1: 0, 'magnify' => $magnify);
					

					if($this->basic_auths)
						$args['kg_basic_auths'] = serialize($this->basic_auths);
					if($this->jpeg_quality)
						$args['kg_jpeg_quality'] = $this->jpeg_quality;
					if($this->cache_size)
						$args['kg_cache_size'] = $this->cache_size;
					if($this->cache_size_by_format)
						$args['kg_cache_size_by_format'] = serialize($this->cache_size_by_format);
					if(isset($this->image_iconize_width))
						$args['kg_image_iconize_width'] = $this->image_iconize_width;
					if(isset($this->image_iconize_height))
						$args['kg_image_iconize_height'] = $this->image_iconize_height;
					if($this->is_vga_screen)
						$args['kg_is_vga_screen'] = 1;
					

					$params = array();
					foreach($args as $key => $value) {
						if($value) {
							array_push($params, $key . "=" . urlencode($value));
						}
					}
					$request = $this->php_graphic_url;
					$request .= (strpos($this->php_graphic_url, '?') === false) ? '?': '&';
					$request .= join('&', $params);


					if($this->debug_mode) {
						array_push($logs, "original url: $url");
						array_push($logs, "download via: $request");
					}
					

					$contents = $this->download_image($request, false);


					if(strlen($contents) == 0) {
						if($this->debug_mode) {
							array_push($logs, "failure to download image: $request");
							$this->report_log(__FUNCTION__, $logs);
						}
						$this->last_error = 'Failure to get an image via API.';
						return '';
					}
					

					if($this->debug_mode) {
						array_push($logs, "downloaded image file: $dest_cache");
						array_push($logs, "downloaded image file size: " . strlen($contents));
					}

					$fp = fopen($dest_cache, "w");
					fwrite($fp, $contents);
					fclose($fp);
				} else {


				if($get_src_via_http && ($this->force_convert || !file_exists($src_cache) || (file_exists($src_cache) && filesize($src_cache) == 0) || $t - $src_filetime > $cache_expires)) {



					if($this->debug_mode)
						array_push($logs, "original image: $url");


					$contents = $this->download_image($url, true);
					

					if(strlen($contents) == 0) {
						if($this->debug_mode) {
							array_push($logs, "failure to download image: $url");
							$this->report_log(__FUNCTION__, $logs);
						}
						$this->last_error = 'Failure to download the original image.';
						return '';
					}
					

					if($this->debug_mode) {
						array_push($logs, "original image file: $src_cache");
						array_push($logs, "original image file size: " . strlen($contents));
					}

					$fp = fopen($src_cache, "w");
					fwrite($fp, $contents);
					fclose($fp);
				} else {

					if($this->debug_mode)
						array_push($logs, "original image file has existed: $src_cache");
				}
				

				if(!file_exists($src_cache)) {
					if($this->debug_mode) {
						array_push($logs, "no src cache: $src_cache");
						$this->report_log(__FUNCTION__, $logs);
					}
					$this->last_error = 'The original image does not exist.';
					return '';
				}
				

				$id = $this->identify($src_cache, $logs);
				$id['format'] = $this->detect_format($src_cache);
				
				if($id['w'] == 0 || $id['h'] == 0) {
					if($this->debug_mode) {
						array_push($logs, "failure to identify: " . var_export($id, true));
						$this->report_log(__FUNCTION__, $logs);
					}
					$this->last_error = 'Failure to identify the original image.';
					return '';
				}

				if($wallpaper) {

					$vmargin = $hmargin = 0;


					$cl = $wallpaper['left']? $wallpaper['left']: 0;
					if(substr($cl, -1, 1) == '%' && is_numeric($percent = substr($cl, 0, -1)))
						$cl = (int)($id['w'] * $percent / 100);
					if($cl < 0) $cl = 0;
					$ct = $wallpaper['top']? $wallpaper['top']: 0;
					if(substr($ct, -1, 1) == '%' && is_numeric($percent = substr($ct, 0, -1)))
						$ct = (int)($id['h'] * $percent / 100);
					if($ct < 0) $ct = 0;
					$cw = $wallpaper['width']? $wallpaper['width']: $id['w'];
					if(substr($cw, -1, 1) == '%' && is_numeric($percent = substr($cw, 0, -1)))
						$cw = (int)($id['w'] * $percent / 100);
					if($cl + $cw > $id['w']) $cw = $id['w'] - $cl;
					$ch = $wallpaper['height']? $wallpaper['height']: $id['h'];
					if(substr($ch, -1, 1) == '%' && is_numeric($percent = substr($ch, 0, -1)))
						$ch = (int)($id['h'] * $percent / 100);
					if($ct + $ch > $id['h']) $ch = $id['h'] - $ct;

					if($thumbnail && ($thumbnail < $sw || $thumbnail < $sh)) {

						if($sw >= $sh) {

							$sh = (int)($thumbnail * $sh / $sw);
							$sw = $thumbnail;
						} else {

							$sw = (int)($thumbnail * $sw / $sh);
							$sh = $thumbnail;
						}
					}


					if($wallpaper['style'] == 'fill') {

						if($ch / $cw < $sh / $sw) {

							$h = (int)($ch * $sw / $cw);
							$vmargin = (int)(($sh - $h) / 2);
						} else {

							$w = (int)($cw * $sh / $ch);
							$hmargin = (int)(($sw - $w) / 2);
						}
					} else {

						if($ch / $cw < $sh / $sw) {

							$w = (int)($sw * $ch / $sh);
							$cl += (int)(($cw - $w) / 2);
							$cw = $w;
						} else {

							$h = (int)($sh * $cw / $sw);
							$ct += (int)(($ch - $h) / 2);
							$ch = $h;
						}
					}
					

					$options['wallpaper'] = true;
					$options['left'] = $cl;
					$options['top'] = $ct;
					$options['width'] = $cw;
					$options['height'] = $ch;
					$options['fill'] = $wallpaper['fill'];
					$options['vmargin'] = $vmargin;
					$options['hmargin'] = $hmargin;
					$options['w'] = $w = $sw;
					$options['h'] = $h = $sh;
					$options['nodownsize'] = true;

				} else if($fit == 'noresize' || $fit == 'center' || $fit == 'left' || $fit == 'right') {

					$w = $id['w'];
					$h = $id['h'];
					

					if($sw != null && $id['w'] > $sw)
						$w = $sw;
				} else {

					if($thumbnail && ($thumbnail < $id['w'] || $thumbnail < $id['h'])) {

						if($id['w'] >= $id['h']) {

							$w = $thumbnail;
							$h = (int)($thumbnail * $id['h'] / $id['w']);
						} else {

							$w = (int)($thumbnail * $id['w'] / $id['h']);
							$h = $thumbnail;
						}
					} else {

						if($w == null)
							$w = $id['w'];
						else if(substr($w, -1, 1) == '%') {

							$percent = substr($w, 0, - 1);
							$percent = $percent / 100.0;
							if($percent > 0)
								$w = (int)($sw * $percent);
							else
								$w = $id['w'];
						}


						if($h == null) {
							if($w == $id['w'])
								$h = $id['h'];
							else
								$h = (int)($id['h'] * $w / $id['w']);
						} else if(substr($h, -1, 1) == '%') {

							$percent = substr($h, 0, - 1);
							$percent = $percent / 100.0;
							if($percent > 0)
								$h = (int)($sh * $percent);
							else
								$h = $id['h'];
						}
					}
					

					if(isset($magnify) && ($m = (int)$magnify)) {
						$w *= $m;
						$h *= $m;
					}


					if(!isset($magnifiy) && $this->is_vga_screen) {
						if((isset($this->image_iconize_width) && $w && $w <= $this->image_iconize_width)
								|| (isset($this->image_iconize_height) && $h && $h <= $this->image_iconize_height)) {
							$w *= 2;
							$h *= 2;
							$options['interpolate'] = 'nearest-neighbor';
						}
					}


					if($maximize && $sw != null && $sh != null && ($sw < $sh && $w > $h)) {
						$options['rotate'] = 90;
						if($h > $sw) {
							$w = (int)($w * $sw / $h);
							$h = $sw;
							unset($options['interpolate']);
						}
					} else if($sw!= null && $w > $sw) {

						$h = (int)($h * $sw / $w);
						$w = $sw;
						unset($options['interpolate']);
					}
				}
				

				if(($id['w'] != $w || $id['h'] != $h) && $w && $h) {
					$options['w'] = $w;
					$options['h'] = $h;
				}


				if($c == 1)
					$options['c'] = $c;
					

				if($this->format) {
					$options['format'] = $this->format;
				} else if($id['format'] == 'gif' && ($img & MG_GIF) == 0) {

					if(($img & MG_PNG) != 0)
						$options['format'] = 'png';
					else
						$options['format'] = 'jpeg';
				} else if($id['format'] == 'png' && ($img & MG_PNG) == 0) {

					if(($img & MG_GIF) != 0)
						$options['format'] = 'gif';
					else
						$options['format'] = 'jpeg';
				} else if($id['format'] == 'jpeg' && ($img & MG_JPEG) == 0) {

					if(($img & MG_PNG) != 0)
						$options['format'] = 'png';
					else
						$options['format'] = 'gif';
				}
				

				if($fit)
					$options['fit'] = $fit;
				

				$this->convert($src_cache, $dest_cache, $options, $id);
				

				if(!file_exists($dest_cache) || filesize($dest_cache) < 1) {
					if($this->debug_mode)
						$this->report_log(__FUNCTION__, $logs);
					$this->last_error = 'Failure to convert the image.';
					return '';
				}
				

				if($copyright) {

					$format = $options['format']? $options['format']: $id['format'];
					$result = $this->set_copyright($dest_cache, $format, $copyright);
					

					if($result !== true) {
						if($this->debug_mode) {
							array_push($logs, "set copyright faulure at: $result");
							$this->report_log(__FUNCTION__, $logs);
						}
						$this->last_error = 'Failure to set copyright.';
						return '';
					}
				}
				}
			} else {

				if($this->debug_mode)
					array_push($logs, "converted image file has existed: $dest_cache");
			}
			
			if($this->debug_mode)
				$this->report_log(__FUNCTION__, $logs);
			
			return $cache;
		}
		



		function detect_format($file) {
			if($this->debug_mode)
				$logs = array("file: $file");

			if(!file_exists($file)) {
				return null;
			}


			$fp = fopen($file, 'rb');
			$head = fread($fp, 6);
			fclose($fp);
			
			if(preg_match('/^GIF8[79]a/', $head)) {
				return 'gif';
			} else if(preg_match('/^\x89PNG/', $head)) {
				return 'png';
			} else if(preg_match('/^\xff\xd8/', $head)) {
				return 'jpeg';
			}
			
			if($this->debug_mode) {
				array_push($logs, "failure to detect: $head");
				$this->report_log(__FUNCTION__, $logs);
			}
			
			return null;
		}
		










		function convert($src, $dest, $options, $id = null) {
			if($this->debug_mode) {
				$logs = array("src: $src", "dest: $dest", "options: " . var_export($options, true) . "cache_size: " . $this->cache_size);
			}


			if($id == null) {
				$id = $this->identify($src);
				$id['format'] = $this->detect_format($src);
			}
			

			$dw = $sw = $id['w'];
			if(isset($options['w']) && $options['fit'] != 'noresize')
				$dw = $options['w'];
			
			$dh = $sh = $id['h'];
			if(isset($options['h']) && $options['fit'] != 'noresize')
				$dh = $options['h'];
			

			if(isset($options['format']))
				$format = $options['format'];
			else
				$format = $id['format'];
			

			if($this->debug_mode)
				array_push($logs, "use library: " . $this->php_graphic);


			$cache_size = $this->cache_size;

			if(isset($this->cache_size_by_format[$format]) && $this->cache_size_by_format[$format] < $cache_size)
				$cache_size = $this->cache_size_by_format[$format];
			$ow = $dw;
			$oh = $dh;
			$palettes = 256;
			$src_org = $src;
			$dest_org = $dest;
			for($rate = 1.0; $rate >= 0.2; $rate -= 0.2) {
				$src = $src_org;
				$dest = $dest_org;
				if(!$options['nodownsize']) {
					$dw = (int)($ow * $rate);
					$dh = (int)($oh * $rate);
				}
				$quality = (int)($this->jpeg_quality * $rate);

				if($this->php_graphic == 'gd') {

					

					$stream = file_get_contents($src);
					$src_im = imagecreatefromstring($stream);
					

					$dest_im = imagecreatetruecolor($dw, $dh);
					if($options['fill']) {
						$fill = $options['fill'];
						$fill = intval($fill, 16);
						$r = ($fill & 0xff0000) >> 16;
						$g = ($fill & 0x00ff00) >> 8;
						$b = ($fill & 0x0000ff);
					} else {
						$r = $g = $b = 255;
					}
					imagefilledrectangle($dest_im, 0, 0, $dw, $dh, imagecolorallocate($dest_im, $r ,$g ,$b));
					

					if($options['wallpaper']) {

						imagecopyresampled($dest_im, $src_im, 
							$options['hmargin'], $options['vmargin'], 
							$options['left'], $options['top'], 
							$dw - $options['hmargin'] * 2, $dh - $options['vmargin'] * 2, 
							$options['width'] , $options['height']);
					} else if($dw == $sw && $dh == $sh)
						imagecopy($dest_im, $src_im, 0, 0, 0, 0, $sw, $sh);
					else {
						if($options['fit'] == 'noresize')
							imagecopy($dest_img, $src_im, 0, 0, 0, 0, $sw, $sh);
						else if($options['fit'] == 'left' && $sw > $dw)
							imagecopy($dest_im, $src_im, 0, 0, 0, 0, $dw, $dh);
						else if($options['fit'] == 'right' && $sw > $dw)
							imagecopy($dest_im, $src_im, 0, 0, $sw - $dw, 0, $dw, $dh);
						else if($options['fit'] == 'center' && $sw > $dw)
							imagecopy($dest_im, $src_im, 0, 0, (int)(($sw - $dw) / 2), 0, $dw, $dh);
						else if($options['interpolate'] == 'nearest-neighbor')
							imagecopyresized($dest_im, $src_im, 0, 0, 0, 0, $dw, $dh, $sw, $sh);
						else
							imagecopyresampled($dest_im, $src_im, 0, 0, 0, 0, $dw, $dh, $sw, $sh);
					}
					

					if($options['c'] == 1) {
						imagetruecolortopalette($dest_im, true, 2);

						for($i = 0; $i < 2; $i++) {
							$c[$i] = imagecolorsforindex($dest_im, $i);
							$c[$i]['bright'] = ($c[$i]['red'] + $c[$i]['green'] + $c[$i]['blue']) / 3;
						}
						if($c[0]['bright'] > $c[1]['bright']) {
							imagecolorset($dest_im, 0, 0xff, 0xff, 0xff);
							imagecolorset($dest_im, 1, 0x00, 0x00, 0x00);
						} else {
							imagecolorset($dest_im, 1, 0xff, 0xff, 0xff);
							imagecolorset($dest_im, 0, 0x00, 0x00, 0x00);
						}
					}
					

					if($options['rotate']) {
						$rotate_im = imagerotate($dest_im, -$options['rotate'], 0);
						imagedestroy($dest_im);
						$dest_im = $rotate_im;
					}
					


					if($format == 'gif') {
						if($this->debug_mode)
							array_push($logs, "reduce: $palettes");
						imagetruecolortopalette($dest_im, true, $palettes);
						imagegif($dest_im, $dest);
					} else if($format == 'png') {
						if($this->debug_mode)
							array_push($logs, "reduce: $palettes");
						imagetruecolortopalette($dest_im, true, $palettes);
						imagepng($dest_im, $dest);
					} else {
						imagejpeg($dest_im, $dest, $quality);
					}
					
					imagedestroy($src_im);
					imagedestroy($dest_im);
				} else {

					$cleanup = array();
					

					$option = '';



					if($options['wallpaper']) {


						$convert = $this->convert;
						if(preg_match('/ /', $convert))
							$convert = "\"$convert\"";
						

						if($options['left'] != 0 || $options['top'] != 0
								|| $options['width'] != $id['w'] || $options['height'] != $id['h']) {
							$dest_tmp = "$dest-crop.bmp";
							$option = " -crop {$options['width']}x{$options['height']}+{$options['left']}+{$options['top']}";
							
							$execute = "$convert $option $src $dest_tmp";
							if($this->debug_mode) {
								array_push($logs, "command: $execute");
								exec($execute, $result);
								$logs = array_merge($logs, $result);
							} else {
								exec($execute);
							}
							
							if(file_exists($dest_tmp)) {
								array_push($cleanup, $dest_tmp);
								$src = $dest_tmp;
							}
						}
						

						$dest_tmp = "$dest-resize.bmp";
						$gw = $dw - $options['hmargin'] * 2;
						$gh = $dh - $options['vmargin'] * 2;
						$option = " -geometry {$gw}x{$gh}!";
						
						$execute = "$convert $option $src $dest_tmp";
						if($this->debug_mode) {
							array_push($logs, "command: $execute");
							exec($execute, $result);
							$logs = array_merge($logs, $result);
						} else {
							exec($execute);
						}
						
						if(file_exists($dest_tmp)) {
							array_push($cleanup, $dest_tmp);
							$src = $dest_tmp;
						}


						if($options['vmargin'] || $options['hmargin'])
							$option = "-mattecolor '#{$options['fill']}' -frame {$options['hmargin']}x{$options['vmargin']}+0+0";
		
					} else if($options['fit'] == 'left' && $dw < $sw) {
						$option .= " -crop {$dw}x{$dh}+0+0";
					} else if($options['fit'] == 'right' && $dw < $sw) {
						$ox = $sw - $dw;
						$option .= " -chop {$ox}x0+0+0";
					} else if($options['fit'] == 'center' && $dw < $sw) {
						$ox = ($sw - $dw) / 2;
						$option .= " -crop {$dw}x{$dh}+{$ox}+0";


						if($format == 'gif')
							$interbmp = true;
					} else if($dw != $sw || $dh != $sh) {
						if($options['interpolate'] == 'nearest-neighbor')
							$option .= " -sample {$dw}x{$dh}!";
						else
							$option .= " -geometry {$dw}x{$dh}!";
					}


					if($interbmp) {
						$dest_temp = "$dest.bmp";
						
						$convert = $this->convert;
						$execute = "$convert $option \"$src\" \"$dest_temp\"";
						if($this->debug_mode) {
							array_push($logs, "command: $execute");
							exec($execute, $result);
							$logs = array_merge($logs, $result);
						} else {
							exec($execute);
						}
						
						if(file_exists($dest_temp)) {
							array_push($cleanup, $dest_temp);
							$src = $dest_temp;
							$option = '';
						}
					}
					

					$option .= ' -interlace None';
					

					if($this->php_graphic != 'im5')
						$option .= ' -strip';
					

					if($options['c'] == 1) {

						$option .= ' -monochrome -dither';
					}


					if($format == 'jpeg' || $format == 'jpg') {
						$format = 'jpg';
						

						if($quality)
							$option .= " -quality " . $quality;



						$option .= ' -type TrueColor';
					}
					

					if($options['c'] > 1 && ($format == 'png' || $format == 'gif')) {
						$option .= " -colors $palettes";
					}
					

					if($options['rotate']) {
						$option .= ' -rotate ' . $options['rotate'];
					}
					

					$dest_temp = "$dest.$format";
					


					$convert = $this->convert;
					if(preg_match('/ /', $convert))
						$convert = "\"$convert\"";
					
					$execute = "$convert $option \"$src\" \"$dest_temp\"";
					if($this->debug_mode) {
						array_push($logs, "command: $execute");
						exec($execute, $result);
						$logs = array_merge($logs, $result);
					} else {
						exec($execute);
					}

					if(file_exists($dest))
						unlink($dest);
	
					if(file_exists($dest_temp))
						rename($dest_temp, $dest);
					

					foreach($cleanup as $clean) {
						if($this->debug_mode)
							array_push($logs, "clean up temporary file: $clean");
						unlink($clean);
					}
				}
				
				if($this->debug_mode)
					array_push($logs, "filesize: " . filesize($dest));
				

				if(file_exists($dest) && (filesize($dest) < $cache_size))
					break;
				

				$palettes /= 2;
			}
			

			$this->last_format = $format;
			
			if($this->debug_mode)
				$this->report_log(__FUNCTION__, $logs);
		}
		






		function identify($file) {
			if($this->debug_mode)
				$logs = array("file: $file");

			if($this->php_graphic == 'gd') {

				list($id['w'], $id['h'], $format) = getimagesize($file);
			} else {

				$identify = $this->identify;
				

				$identify = $this->identify;
				if(preg_match('/ /', $identify))
					$identify = "\"$identify\"";


				$execute = "$identify \"$file\"";
				if($this->debug_mode) {
					$sizes = exec($execute, $result);
					array_push($logs, "sizes: $sizes");
					$logs = array_merge($logs, $result);
				} else {
					$sizes = exec($execute);
				}
				$sizes = explode(' ', $sizes);
				


				for($i = 2; $i < count($sizes); $i++) {
					if(preg_match('/^([0-9]+)x([0-9]+)$/', $sizes[$i], $matches) || preg_match('/^([0-9]+)x([0-9]+)\+[0-9]+\+[0-9]+$/', $sizes[$i], $matches)) {
						$id['w'] = (int)$matches[1];
						$id['h'] = (int)$matches[2];
					}
				}
			}
			
			if($this->debug_mode) {
				array_push($logs, "identify: " . var_export($id, true));
				$this->report_log(__FUNCTION__, $logs);
			}
			
			return $id;
		}


		function set_copyright( $dest_cache, $format, $copyright ) {
			if($this->debug_mode) {
				$logs = array();
				array_push($logs, "dest_cache: $dest_cache");
				array_push($logs, "format: $format");
				array_push($logs, "copyright: $copyright");
				$this->report_log(__FUNCTION__, $logs);
			}


			srand( (double)microtime()*100000 );
			$copyright_cache = $dest_cache.rand().'.tmp';
			
			if(!copy($dest_cache, $copyright_cache))
				return __LINE__;
			
			if( $format == 'jpeg' || $format == 'jpg' ) {
				$result = $this->comment_jpeg( $copyright_cache, $copyright );
			} elseif( $format === 'gif') {
				$result = $this->comment_gif( $copyright_cache, $copyright );
			} elseif( $format === 'png') {
				$result = $this->comment_png( $copyright_cache, $copyright );
			}
			
			if($this->debug_mode && $result !== true) {
				array_push($logs, "comment image failure at: $result");
			}
			

			if($result === true)
				copy( $copyright_cache, $dest_cache );
			
			unlink( $copyright_cache );

			return true;
		}







		function comment_jpeg( $copyright_cache, $carrier ) {

			 $buff = '';
			 

			 $com_position = 0;
			 
			 if( $carrier == 'i' )
			 	$copyright = 'copy="NO"';
			 elseif ( $carrier == 'ez' ) 
			 	$copyright = 'kddi_copyright=on';
			 else
			 	return __LINE__;
			 
			 
			 if( !$ifp = fopen($copyright_cache, 'rb') )
			 	return  __LINE__;
			 

			 $i = 0;
			 


			 fseek( $ifp, 2 );
			 $i = 2;
			 
			 while( !feof($ifp) ) {
			 	 
			 	$str = fread($ifp, 1);
			 	$i++;
			 	
			 	if( $str == "\xFF" ) {
			 		$str = fread( $ifp, 1 );
			 		$i++;
			 		
			 		if( $str == "\xFE" ) {
			 		

				 		$com_position = $i;
				 		break;
				 			
				 	} elseif( $str == "\xD9" ) {

				 		break;
				 		
				 	} else {

				 		$size = array_sum(unpack('n', fread($ifp, 2)));

				 		
				 		$i += $size;
				 		fseek( $ifp, $size-2, SEEK_CUR );
				 	}
			 	}
			 }

			 fseek($ifp, 0);
			 

			 if( empty($com_position) ) {
				

			 	$buff .= fread($ifp, 4);
			 	

			 	$app_size = fread($ifp, 2);
			 	$buff .= $app_size;
			 	

			 	$app_size = array_sum(unpack('n', $app_size));
			 	

			 	$buff .= fread( $ifp, $app_size-2 );
			 	

				$buff .= pack( 'n*', 0xFFFE, strlen($copyright)+2 );
				$buff .= $copyright;


			 }else{
			 	

			 	$buff .= fread($ifp, $com_position);
			 		 	

			 	$com_size = array_sum(unpack('n', fread($ifp, 2)));
			 	

			 	fseek($ifp, $com_size-2, SEEK_CUR);
				

				$buff .= pack('n*', strlen($copyright)+2);
				$buff .= $copyright;
				
			 }
			 

		 	 $buff .= fread($ifp, filesize($copyright_cache));
			 fclose($ifp);
			 
			 

			 if( !$ofp = fopen( $copyright_cache, "wb" ) )
			 	return  __LINE__;
			 	
			 if( !flock( $ofp, LOCK_EX ) )
			 	return  __LINE__;
			 	
			 if( !fwrite( $ofp, $buff ) )
			 	return  __LINE__;
			 

			 return true;
		 }
		 
		 




		 function comment_gif( $copyright_cache, $carrier ){

			 $buff = "";
			 

			 $com_position = 0;

			 $com_size = 0;
			 
			 
			 if( $carrier == 'i' ) 
			 	$copyright = 'copy="NO"';
			 elseif( $carrier == 'ez' )
			 	$copyright = 'kddi_copyright=on';
			 else
			 	return  __LINE__;
			 	

			 if( !$ifp = fopen($copyright_cache, "rb") )
			 	return  __LINE__;
			 
			 

			 
			 $i = 0;
			 

			 fseek( $ifp, 10, SEEK_CUR);

			 $global_color = array_sum(unpack('C', fread( $ifp, 1 )));

			 fseek( $ifp, 2, SEEK_CUR );
			 

			 $sogct = 0;

			 if( $global_color & 0x80 ) {
			 	$sogct = $global_color & 0x07;
			 	$sogct = 3 * pow(2, ($sogct+1));

			 	fseek( $ifp, $sogct, SEEK_CUR );
			 }
			 $i = 13 + $sogct;
			
			 
			 while( !feof($ifp) ) {
			 	
			 	$str = fread($ifp, 1);
			 	$i++;
			 	

			 	if( $str == "\x21" ) {
			 		$str = fread($ifp, 1);
			 		$i++;
			 		

			 		if( $str == "\xFE" ) {
			 			$com_position = $i;
			 			
			 			$block_size = 1;
			 			while( $block_size ) {
			 				$block_size = array_sum(unpack('C', fread($ifp, 1)));

							$com_size += $block_size;
			 				
			 				if( empty($block_size) )
			 					break;
			 				else
			 					fseek( $ifp, $block_size, SEEK_CUR );
			 			}
			 			$com_size++;
						break;
			 			
			 			

			 		} elseif( $str == "\xF9" ) {

			 			fseek( $ifp, 6, SEEK_CUR ); 			
			 			$i += 6;
			 			

			 		} elseif( $str == "\x01" ) {

			 			fseek( $ifp, 13, SEEK_CUR );
			 			$i += 13;
			 			
			 			$pte_size = 0;
			 			$block_size = 1;
			 			while( $block_size ) {
			 				$block_size = array_sum(unpack('C', fread($ifp, 1)));

			 				$pte_size += $block_size;
			 				
			 				if( empty($block_size))
			 					break;
			 				else
			 					fseek( $ifp, $block_size, SEEK_CUR );
			 			}
						$i += ++$pte_size;
			 		

			 		} elseif( $str == "\xFF" ) {

			 			fseek( $ifp, 12, SEEK_CUR );
			 			$i += 12;
			 			
			 			$ae_size = 0;
			 			$block_size = 1;
			 			while( $block_size ) {
			 				$block_size = array_sum(unpack('C', fread($ifp, 1)));

			 				$ae_size += $block_size;
			 				
			 				if( empty($block_size) )
			 					break;
			 				else
			 					fseek( $ifp, $block_size, SEEK_CUR );
			 			}
						$i += ++$ae_size;

			 		}
			 	

			 	} elseif( $str == "\x2C" ) {
			 		

			 		fseek( $ifp, 8, SEEK_CUR );

			 		$local_color = array_sum(unpack('C', fread($ifp, 1)));
			 		

			 		if( $local_color & 0x80 ) {
			 			$solct = $local_color & 0x07;
			 			$solct = 3 * pow(2, $solct+1);
			 			fseek( $ifp, $solct, SEEK_CUR );
			 		}
			 		

			 		fseek( $ifp, 1, SEEK_CUR);
					$i = 10 + $solct;
					
					$ib_size = 0;
					$block_size = 1;
					while( $block_size ) {
						$block_size = array_sum(unpack('C', fread($ifp, 1)));
						$ib_size += $block_size;
						
						if( empty($block_size) )
							break;
						else
							fseek( $ifp, $block_size, SEEK_CUR );
					}
					$i += ++$ib_size;
			 		
			 	}
			 }
			 fseek( $ifp, 0 );
			 


			 if( $com_position ) {
			 	$buff .= fread( $ifp, $com_position );
			 	$buff .= pack('C', strlen($copyright)).$copyright;
			 	fseek( $ifp, $com_size, SEEK_CUR );
			 	
			 }else{

				 $buff .= fread( $ifp, 13 );

				 $buff .= fread( $ifp, $sogct );
			 	 $buff .= pack('nC', 0x21FE, strlen($copyright)) . $copyright . pack('x');
			 }
			 

			 $buff .= fread( $ifp, filesize($copyright_cache) );	 
			 fclose($ifp);
			 
			 

			 if( !$ofp = fopen( $copyright_cache, "wb" ) )
				return __LINE__;
			
			 if( !flock( $ofp, LOCK_EX ) )
			 	return __LINE__;
			 	
			 if( !fwrite( $ofp, $buff ) )
			 	return __LINE__;
			 
			 flock( $ofp, LOCK_UN );
			 fclose( $ofp );
			 
			 return true;
		}







		function comment_png( $copyright_cache, $carrier ) {
			
			$buff = "";
			
			$i_copyright = 'Copyright'.pack('x').'copy="NO"';
			$ez_copyright = 'Copyright'.pack('x').'kddi_copyright=on';
				
			if( $carrier == 'i' )
				$copyright = $i_copyright;
			elseif( $carrier == 'ez' )
				$copyright = $ez_copyright;
			else
				return __LINE__;
			
			if( !$ifp = fopen( $copyright_cache, "rb") )
				return __LINE__;
			

			$buff .= fread( $ifp, 33 );
			

			$addText = pack('N', 0x74455874).$copyright;
			$crcResource = $addText;
			$crc = pack('N', crc32($crcResource));
			
			

			$buff .= pack('N', strlen($copyright));
			$buff .= $addText;
			$buff .= $crc;
			

			while( !feof($ifp) ) {

			$chunk_size = fread( $ifp, 4 );
			

			$chunk_size_dec = @array_sum(unpack('N', $chunk_size));
			
			$str = fread( $ifp, $chunk_size_dec + 4 );
			$chunk_crc = fread( $ifp, 4 );
			

			if( substr($str, 4, 9) != 'Copyright' )
				$buff .= $chunk_size.$str.$chunk_crc;
			}
			fclose( $ifp );
			
			

			if( !$ofp = fopen( $copyright_cache, "wb" ) ) 
				return __LINE__;
			if( !flock( $ofp, LOCK_EX ) )
			 	return __LINE__;
					
			if( !fwrite( $ofp, $buff ) )
				return __LINE__;
			
			flock( $ofp, LOCK_UN );
			fclose( $ofp );
			
			return true;
		}
	}
?>