package KeitaiKit::ConfigTemplate;
use strict;


sub trial_expired {
	my ($enabled_prolong) = @_;
	my $template;
	
	$template = qq{
<div class="setting">
<span style="color: red"><MT_TRANS phrase="Trial has expired. Buy a license."></span><br />
<a class="purchase" href="http://www.ideamans.com/keitaikit/purchase.php"><MT_TRANS phrase="Buy KeitaiKit."></a>
</div>

};

	if($enabled_prolong) {

		$template .= qq{
<!-- Prolong trial button -->
<p><MT_TRANS phrase="KeitaiKit has largely updated since setup. You could prolong the trial for 30 days again."></p>
<div class="setting">
<div class="label">&nbsp;</div>
<div class="field">
<input type="button" onclick="location.href='<TMPL_VAR NAME=COMMAND_URL>?__mode=prolong_trial';" name="clear_cache" value="<MT_TRANS phrase="Prolong the trial">" />
</div>
</div>

};
	}

	$template .= qq{
<!-- License key -->
<p><MT_TRANS phrase="Enter the license key and e-mail."></p>
<div class="setting grouped">
<div class="label"><label for="mtkk_licensekey"><MT_TRANS phrase="License key">:</label></div>
<div class="field">
<input type="text" name="licensekey" id="mtkk_licensekey" value="<TMPL_VAR NAME=LICENSEKEY ESCAPE=HTML>" style="width: 95%" />
</div>
</div>

<!-- E-mail -->
<div class="setting grouped">
<div class="label"><label for="mtkk_mailaddress"><MT_TRANS phrase="E-mail">:</label></div>
<div class="field">
<input type="text" name="mailaddress" id="mtkk_mailaddress" value="<TMPL_VAR NAME=MAILADDRESS ESCAPE=HTML>" style="width: 95%" />
</div>
</div>

<!-- Register button -->
<div class="setting">
<div class="label"><label for="mtkk_register_license"><MT_TRANS phrase="Send this information and">:</label></div>
<div class="field">
<input type="button" onclick="location.href='<TMPL_VAR NAME=COMMAND_URL>?__mode=register&licensekey=' + licensekey.value + '&mailaddress=' + mailaddress.value;" name="clear_cache" value="<MT_TRANS phrase="Register the license">" />
</div>
</div>

};


	$template;
}


sub system_config {
	my $template;
	$template = qq{
<TMPL_IF NAME=IN_TRIAL>
<!-- Trial -->
<p><MT_TRANS phrase='<a class="purchase" href="http://www.ideamans.com/keitaikit/purchase.php">Buy KeitaiKit</a>'></p>
<div class="setting grouped">
<div class="label"><MT_TRANS phrase="Trial Days">:</div>
<div class="field"><MT_TRANS phrase="Rest"><TMPL_VAR NAME=REST_DAYS><MT_TRANS phrase="days"></div>
</div>
</TMPL_IF>

<!-- License Key -->
<p><MT_TRANS phrase="Enter the license key and e-mail."></p>
<div class="setting grouped">
<div class="label"><label for="mtkk_licensekey"><MT_TRANS phrase="License key">:</label></div>
<div class="field">
<input type="text" name="licensekey" id="mtkk_licensekey" value="<TMPL_VAR NAME=LICENSEKEY ESCAPE=HTML>" style="width: 95%" />
</div>
</div>

<!-- E-mail -->
<div class="setting grouped">
<div class="label"><label for="mtkk_mailaddress"><MT_TRANS phrase="E-mail">:</label></div>
<div class="field">
<input type="text" name="mailaddress" id="mtkk_mailaddress" value="<TMPL_VAR NAME=MAILADDRESS ESCAPE=HTML>" style="width: 95%" />
</div>
</div>

<!-- Register button -->
<div class="setting">
<div class="label"><label for="mtkk_register_license"><MT_TRANS phrase="Send this information and">:</label></div>
<div class="field">
<input type="button" onclick="location.href='<TMPL_VAR NAME=COMMAND_URL>?__mode=register&licensekey=' + licensekey.value + '&mailaddress=' + mailaddress.value;" name="clear_cache" value="<MT_TRANS phrase="Register the license">" />
</div>
</div>

<TMPL_IF NAME=LICENSEKEY>
<!-- Download spec database -->
<p><MT_TRANS phrase="Download the newest spec database."></p>
<div class="setting">
<div class="label"><label for="mtkk_download"><MT_TRANS phrase="Database">:</label></div>
<div class="field">
<input type="button" onclick="location.href='<TMPL_VAR NAME=COMMAND_URL>?__mode=download';" name="clear_cache" value="<MT_TRANS phrase="Download the newest version.">" /> (<MT_TRANS phrase="Current database is updated on">: <TMPL_VAR NAME=DB_DATE>)
</div>
</div>
</TMPL_IF>

<!-- Clear cache -->
<p><MT_TRANS phrase="To update image, clear all image cache."></p>
<div class="setting">
<div class="label"><label for="mtkk_clear_cache"><MT_TRANS phrase="Image cache">:</label></div>
<div class="field">
<input type="button" onclick="location.href='<TMPL_VAR NAME=COMMAND_URL>?__mode=clear_cache';" name="clear_cache" value="<MT_TRANS phrase="Clear image cache">" /><br />(<TMPL_VAR NAME=TEMP_DIR>)
</div>
</div>

<!-- Image cache -->
<p><MT_TRANS phrase="Enter the directory for image cache."></p>
<div class="setting grouped">
<div class="label"><label for="mtkk_temp_dir"><MT_TRANS phrase="Image cache">:</label></div>
<div class="field">
<input type="text" name="temp_dir" id="mtkk_temp_dir" value="<TMPL_VAR NAME=TEMP_DIR ESCAPE=HTML>" style="width: 95%" />
<TMPL_IF NAME=TEMP_DIR_NOT_WRITABLE>
<br /><span style="color:red;"><MT_TRANS phrase="This directory is not writable"></span>
</TMPL_IF>
<TMPL_IF NAME=TEMP_DIR_HAS_SPACE>
<br /><span style="color:red;"><MT_TRANS phrase="Enter the path not includes space"></span>
</TMPL_IF>
</div>
</div>

<!-- Cache expires -->
<div class="setting">
<div class="label"><label for="mtkk_cache_expires"><MT_TRANS phrase="Cache expires">:</label></div>
<div class="field">
<input type="text" name="cache_expires" id="mtkk_cache_expires" value="<TMPL_VAR NAME=CACHE_EXPIRES ESCAPE=HTML>" style="width: 40%" /> <MT_TRANS phrase="second(s)">
</div>
</div>

<!-- Graphic library -->
<p><MT_TRANS phrase="Select a graphic library. If you select ImageMagick, enter path for convert and identify command."></p>
<p><MT_TRANS phrase="If you select Web Service, enter URL for graphic web service."></p>
<div class="setting grouped">
<div class="label"><label for="mtkk_php_graphic"><MT_TRANS phrase="Library">:</label></div>
<div class="field">
<select name="php_graphic" id="mtkk_php_graphic">
	<option value="gd"<TMPL_IF NAME=PHP_GRAPHIC_GD> selected</TMPL_IF>>GD</option>
	<option value="im"<TMPL_IF NAME=PHP_GRAPHIC_IM> selected</TMPL_IF>><MT_TRANS phrase="ImageMagick Ver.6+"></option>
	<option value="im5"<TMPL_IF NAME=PHP_GRAPHIC_IM5> selected</TMPL_IF>><MT_TRANS phrase="ImageMagick Ver.5"></option>
	<option value="http"<TMPL_IF NAME=PHP_GRAPHIC_HTTP> selected</TMPL_IF>><MT_TRANS phrase="Web Service"></option>
</select>
</div>
</div>

<!-- Path for convert of ImageMagick -->
<div class="setting grouped">
<div class="label"><label for="mtkk_convert"><MT_TRANS phrase="convert command">:</label></div>
<div class="field">
<input type="text" name="convert" id="mtkk_convert" value="<TMPL_VAR NAME=CONVERT ESCAPE=HTML>" style="width: 95%" />
<TMPL_IF NAME=CONVERT_IS_NOT_EXECUTABLE>
<br /><span style="color:red;"><MT_TRANS phrase="This file is not executable"></span>
</TMPL_IF>
<TMPL_IF NAME=CONVERT_IS_DIR>
<br /><span style="color:red;"><MT_TRANS phrase="Enter the path for command include the file name"></span>
</TMPL_IF>
</div>
</div>

<!-- Path for identify of ImageMagick -->
<div class="setting grouped">
<div class="label"><label for="mtkk_identify"><MT_TRANS phrase="identify command">:</label></div>
<div class="field">
<input type="text" name="identify" id="mtkk_identify" value="<TMPL_VAR NAME=IDENTIFY ESCAPE=HTML>" style="width: 95%" />
<TMPL_IF NAME=IDENTIFY_IS_NOT_EXECUTABLE>
<br /><span style="color:red;"><MT_TRANS phrase="This file is not executable"></span>
</TMPL_IF>
<TMPL_IF NAME=IDENTIFY_IS_DIR>
<br /><span style="color:red;"><MT_TRANS phrase="Enter the path for command include the file name"></span>
</TMPL_IF>
</div>
</div>

<!-- URL for graphic web service -->
<div class="setting">
<div class="label"><label for="mtkk_php_graphic_url"><MT_TRANS phrase="Web service URL">:</label></div>
<div class="field">
<input type="text" name="php_graphic_url" id="mtkk_php_graphic_url" value="<TMPL_VAR NAME=PHP_GRAPHIC_URL ESCAPE=HTML>" style="width: 50%" /> 
<input type="button" value="<MT_TRANS phrase="Use trial web service">" onclick="php_graphic_url.value='http://service.keitaikit.jp/graphic.php'; return false;" />
<TMPL_IF NAME=PHP_GRAPHIC_URL_IS_EMPTY>
<br /><span style="color:red;"><MT_TRANS phrase="Enter URL for graphic web service."></span>
</TMPL_IF>
</div>
</div>

<!-- Smartphone settings -->
<p><span style="font-weight: bold;">[<MT_TRANS phrase="Smartphone Setting">]</span> <MT_TRANS phrase="Set the settings for viewing on smartphone."></p>
<div class="setting">
<div class="label"><label for="mtkk_smartphone_enabled"><MT_TRANS phrase="Smartphone features">:</label></div>
<div class="field">
<input type="radio" name="smartphone_enabled" id="mtkk_smartphone_enabled" value="1"<TMPL_IF NAME=SMARTPHONE_ENABLED> checked</TMPL_IF> 
    onclick="var div = getByID('mtkk_smartphone_settings'); if(div){ div.style.display='block'; }" /> <MT_TRANS phrase="Enabled">
<input type="radio" name="smartphone_enabled" id="mtkk_smartphone_enabled_no" value="0"<TMPL_UNLESS NAME=SMARTPHONE_ENABLED> checked</TMPL_UNLESS>  
    onclick="var div = getByID('mtkk_smartphone_settings'); if(div){ div.style.display='none'; }" /> <MT_TRANS phrase="Disabled">
</div>
</div>

<div id="mtkk_smartphone_settings" style="display:<TMPL_IF NAME=SMARTPHONE_ENABLED>block</TMPL_IF><TMPL_UNLESS NAME=SMARTPHONE_ENABLED>none</TMPL_UNLESS>;">

<!-- Smartphone screen -->
<div class="setting">
<div class="label"><label for="mtkk_smartphone_screen_width"><MT_TRANS phrase="Smartphone screen size">:</label></div>
<div class="field">
<input type="text" name="smartphone_screen_width" id="mtkk_smartphone_screen_width" value="<TMPL_VAR NAME=SMARTPHONE_SCREEN_WIDTH ESCAPE=HTML>" style="width: 4em;" />
<MT_TRANS phrase="x">
<input type="text" name="smartphone_screen_height" id="mtkk_smartphone_screen_height" value="<TMPL_VAR NAME=SMARTPHONE_SCREEN_HEIGHT ESCAPE=HTML>" style="width: 4em;" />
<MT_TRANS phrase="pixels">
</div>
</div>

<!-- Emoji for smartphone screen -->
<div class="setting">
<div class="label"><label for="mtkk_smartphone_emoji_dir"><MT_TRANS phrase="Emoji images directory for smartphone">:</label></div>
<div class="field">
<MT_TRANS phrase="KeitaiKit directory">/iemoji/<input type="text" name="smartphone_emoji_dir" id="mtkk_smartphone_emoji_dir" value="<TMPL_VAR NAME=SMARTPHONE_EMOJI_DIR ESCAPE=HTML>" style="width: 8em;" />/
</div>
</div>

<!-- Smartphone output filters -->
<p><span style="font-weight: bold;">[<MT_TRANS phrase="Smartphone Setting">]</span> <MT_TRANS phrase="Set output filters for viewing on smartphone."></p>

<div class="setting">
<div class="label"><label for="mtkk_smartphone_convert_kana"><MT_TRANS phrase="Katakana reconversion">:</label></div>
<div class="field">
<input type="radio" name="smartphone_convert_kana" id="mtkk_smartphone_convert_kana" value="1"<TMPL_IF NAME=SMARTPHONE_CONVERT_KANA> checked</TMPL_IF> /> <MT_TRANS phrase="Convert to zenkaku">
<input type="radio" name="smartphone_convert_kana" id="mtkk_smartphone_convert_kana_no" value="0"<TMPL_UNLESS NAME=SMARTPHONE_CONVERT_KANA> checked</TMPL_UNLESS> /> <MT_TRANS phrase="Not reconvert">
</div>
</div>

<div class="setting">
<div class="label"><label for="mtkk_smartphone_remove_style_all"><MT_TRANS phrase="style attributes">:</label></div>
<div class="field">
<div><input type="radio" name="smartphone_remove_style" id="mtkk_smartphone_remove_style_all" value="all"<TMPL_IF NAME=SMARTPHONE_REMOVE_STYLE_ALL> checked</TMPL_IF> /> <MT_TRANS phrase="Remove all"></div>
<div><input type="radio" name="smartphone_remove_style" id="mtkk_smartphone_remove_style_properties" value="properties"<TMPL_IF NAME=SMARTPHONE_REMOVE_STYLE_PROPERTIES> checked</TMPL_IF> />
    <label for="mtkk_smartphone_remove_css_properties"><MT_TRANS phrase="Remove following css properties"></label>:
    <input type="text" name="smartphone_remove_css_properties" id="mtkk_smartphone_remove_css_properties" value="<TMPL_VAR NAME=SMARTPHONE_REMOVE_CSS_PROPERTIES ESCAPE=HTML>" style="width: 30%" />
</div>
<div><input type="radio" name="smartphone_remove_style" id="mtkk_smartphone_remove_style_none" value="none"<TMPL_IF NAME=SMARTPHONE_REMOVE_STYLE_NONE> checked</TMPL_IF> /> <MT_TRANS phrase="Not remove"></div>
</div>
</div>

</div>

<!-- Jpeg compression quality -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Set Jpeg compression quality."></p>
<div class="setting">
<div class="label"><label for="mtkk_jpeg_quality"><MT_TRANS phrase="Jpeg quality">:</label></div>
<div class="field">
<input type="text" name="jpeg_quality" id="mtkk_jpeg_quality" value="<TMPL_VAR NAME=JPEG_QUALITY ESCAPE=HTML>" style="width: 30%" /> %
</div>
</div>

<!-- Default display -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Set standard display size for image conversion."></p>
<div class="setting">
<div class="label"><label for="mtkk_default_display"><MT_TRANS phrase="Standard display">:</label></div>
<div class="field">
<input type="radio" name="default_display" id="mtkk_default_screen_browser" value="browser"<TMPL_IF NAME=DEFAULT_DISPLAY_BROWSER> checked</TMPL_IF> /> <MT_TRANS phrase="Browser">
<input type="radio" name="default_display" id="mtkk_default_screen_screen" value="screen"<TMPL_IF NAME=DEFAULT_DISPLAY_SCREEN> checked</TMPL_IF> /> <MT_TRANS phrase="Screen">
</div>
</div>

<!-- Download adapter -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Select an adapter to download image."></p>
<p><MT_TRANS phrase="If it is not allowed allow_url_fopen in php.ini, select HTTP_Reqeust."></p>
<div class="setting grouped">
<div class="label"><label for="mtkk_download_adapter"><MT_TRANS phrase="Download">:</label></div>
<div class="field">
<select name="download_adapter" id="mtkk_download_adapter">
	<option value="php"<TMPL_IF NAME=DOWNLOAD_ADAPTER_PHP> selected</TMPL_IF>>PHP(file_get_contents)</option>
	<option value="http_request"<TMPL_IF NAME=DOWNLOAD_ADAPTER_HTTP_REQUEST> selected</TMPL_IF>>HTTP_Request</option>
</select>
</div>
</div>

<!-- PHP KeitaiKit dir -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Set the path of copied directory of KeitaiKit for PHP."></p>
<div class="setting">
<div class="label"><label for="mtkk_php_keitaikit_dir"><MT_TRANS phrase="KeitaiKit dir. for PHP">:</label></div>
<div class="field">
<input type="text" name="php_keitaikit_dir" id="mtkk_php_keitaikit_dir" value="<TMPL_VAR NAME=PHP_KEITAIKIT_DIR ESCAPE=HTML>" style="width: 95%" />
</div>
</div>

<!-- Cache cleaning probability -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Set the probability of auto cache cleaning when an image is converted."></p>
<div class="setting">
<div class="label"><label for="mtkk_cache_cleaning_frequency"><MT_TRANS phrase="Auto Cache Cleaning">:</label></div>
<div class="field">
<MT_TRANS phrase="at the probability one every "><input type="text" name="cache_cleaning_prob" id="mtkk_cache_cleaning_prob" value="<TMPL_VAR NAME=CACHE_CLEANING_PROB ESCAPE=HTML>" style="width: 20%" /><MT_TRANS phrase=" times">
</div>
</div>

<!-- Download proxy -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Enter Address:Port style proxy for image cache downloading if its needed."></p>
<div class="setting">
<div class="label"><label for="mtkk_download_proxy"><MT_TRANS phrase="HTTP Proxy">:</label></div>
<div class="field">
http://<input type="text" name="download_proxy" id="mtkk_download_proxy" value="<TMPL_VAR NAME=DOWNLOAD_PROXY ESCAPE=HTML>" style="width: 45%" />/ (<MT_TRANS phrase="Address:Port">)
</div>
</div>

<!-- Log comment detail -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Logging the detail information of comment from mobile device: user agent, input data size, etc."></p>
<div class="setting">
<div class="label"><label for="mtkk_log_comment_detail"><MT_TRANS phrase="Comment">:</label></div>
<div class="field">
<input type="radio" name="log_comment_detail" id="mtkk_log_comment_detail" value="1"<TMPL_IF NAME=LOG_COMMENT_DETAIL> checked</TMPL_IF> /> <MT_TRANS phrase="Logging the detail information">
<input type="radio" name="log_comment_detail" id="mtkk_log_comment_detail_off" value="0"<TMPL_UNLESS NAME=LOG_COMMENT_DETAIL> checked</TMPL_UNLESS> /> <MT_TRANS phrase="Not logging the detail information">
</div>
</div>

<!-- Default Blog -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Default blog to use when the blog context not exists."></p>
<div class="setting">
<div class="label"><label for="mtkk_log_comment_detail"><MT_TRANS phrase="Default Blog">:</label></div>
<div class="field">
<select name="default_blog_id" id="mtkk_default_blog_id">
	<TMPL_LOOP NAME=DEFAULT_BLOGS>
	<option value="<TMPL_VAR NAME=value>"<TMPL_IF NAME=selected> selected="selected"</TMPL_IF>><TMPL_VAR NAME=label></option>
	</TMPL_LOOP>
</select>
</div>
</div>

};


	$template;
}


sub set_keitai_versions {
	my ($param, $not_selected, $ibrowser) = @_;


	my (@ihtml, @ixhtml, @ibrowser, @ezopenwave, %stype, $selected, @stype);
	

	@ihtml = (1..7, 7.1, 7.2);
	@ibrowser = (2);
	$selected = $param->{supported_format}{i};
	$param->{i_html_versions} = [
		{value => 0, label => $not_selected, selected => !$selected? 1: 0}, 
		(map {
			{value => int($_ * 100), label => sprintf('%0.1f', $_), selected => (int($_ * 100) == $selected)?1: 0}
		} @ihtml),
		(map {
		    {value => int($_ * 1000), label => sprintf('%s %0.1f', $ibrowser, $_), selected => (int($_ * 1000) == $selected)?1: 0}
		} @ibrowser) ];
    

	@ixhtml = (1, 1.1, 2.0, 2.1, 2.2, 2.3);
	$selected = $param->{supported_format}{ix};
	$param->{i_xhtml_versions} = [
		{value => 0, label => $not_selected, selected => !$selected? 1: 0}, 
		map {
			{value => int($_ * 100), label => sprintf('%0.1f', $_), selected => (int($_ * 100) == $selected)?1: 0}
		} @ixhtml ];


	@ezopenwave = (3.0, 6.0, 6.2);
	$selected = $param->{supported_format}{ez};
	$param->{ez_openwave_versions} = [
		{value => 0, label => $not_selected, selected => !$selected? 1: 0}, 
		map {
			{value => int($_ * 100), label => sprintf('%0.1f', $_), selected => (int($_ * 100) == $selected)?1: 0}
		} @ezopenwave];


	%stype = (200 => 'C2', 300 => 'C3', 400 => 'C4', 500 => 'P4(1)', 600 => 'P4(2)', 
		 700 => 'P5', 800 => 'P6', 900 => 'P7', 1000 => 'W', 1100 => '3GC');
	@stype = map {int($_ * 100)} (2..11);
	$selected = $param->{supported_format}{s};
	$param->{s_types} = [
		{value => 0, label => $not_selected, selected => !$selected? 1: 0}, 
		map {
			{value => $_, label => $stype{$_}, selected => ($_ == $selected)?1: 0}
		} @stype];

	1;
}


sub blog_config {
	my ($jsp_support) = @_;
	my $template;
	
	$template = qq{
<style type="text/css">
<!--
.keitaikit-spinner {
	background-repeat: no-repeat;
	background-position: left center;
	background-image: url("<TMPL_VAR NAME=SPINNER_RIGHT>");
	padding-left: <TMPL_VAR NAME=SPINNER_SIZE>px;
}
-->
</style>
<script type="text/javascript">
<!--
function keitaikit_toggle(id, spinner) {
	var div = getByID(id);
	var a = getByID(spinner);
	if(div && a) {
		if(div.style.display != 'block') {
			div.style.display = 'block';
			a.style.backgroundImage = 'url("<TMPL_VAR NAME=SPINNER_BOTTOM>")';
		} else {
			div.style.display = 'none';
			a.style.backgroundImage = 'url("<TMPL_VAR NAME=SPINNER_RIGHT>")';
		}
	}
	return false;
}

function keitaikit_show(id, show) {
	var div = getByID(id);
	if(div) {
		if(show) {
			div.style.display = 'block';
		} else {
			div.style.display = 'none';
		}
	}
	return false;
}

-->
</script>
<!-- Prebuilding module -->
<p><MT_TRANS phrase="Select prebuilding module for mobile templates."></p>
<div class="setting">
<div class="label"><label for="mtkk_prebuilding_module"><MT_TRANS phrase="Setting module">:</label></div>
<div class="field">
<select name="prebuilding_module" id="mtkk_prebuilding_module">
	<TMPL_LOOP NAME=PREBUILDING_MODULES>
	<option value="<TMPL_VAR NAME=value>"<TMPL_IF NAME=selected> selected="selected"</TMPL_IF><TMPL_IF NAME=disabled> disabled="disabled" style="color: white; background-color: #444444;"</TMPL_IF>><TMPL_VAR NAME=label></option>
	</TMPL_LOOP>
</select>
</div>
</div>

<!-- Redirection for PC devices -->
<p><MT_TRANS phrase="Enter URL for no mobile devices."></p>
<div class="setting">
<div class="label"><label for="mtkk_pc_redirect"><MT_TRANS phrase="Redirect to">:</label></div>
<div class="field">
<input type="text" name="pc_redirect" id="mtkk_pc_redirect" value="<TMPL_VAR NAME=PC_REDIRECT ESCAPE=HTML>" style="width: 95%" />
</div>
</div>

<!-- Katakana processing -->
<p><MT_TRANS phrase="Select a Katakana conversion."></p>
<div class="setting">
<div class="label"><label for="mtkk_hankaku"><MT_TRANS phrase="Katakana conversion">:</label></div>
<div class="field">
<select name="hankaku" id="mtkk_hankaku">
	<option value="all"<TMPL_IF NAME=HANKAKU_ALL> selected</TMPL_IF>><MT_TRANS phrase="Convert to hankaku anytime"></option>
	<option value="no"<TMPL_IF NAME=HANKAKU_NO> selected</TMPL_IF>><MT_TRANS phrase="Not convert to hankaku"></option>
	<option value="mobile"<TMPL_IF NAME=HANKAKU_MOBILE> selected</TMPL_IF>><MT_TRANS phrase="Convert to hankaku only if mobile(NOT RECOMMENDED)"></option>
</select>
</div>
</div>

<!-- Emoji processing -->
<p><MT_TRANS phrase="Select a way to replace emoji when show in not suitable device."><p>
<div class="setting grouped">
<div class="label"><label for="mtkk_emoji_alt"><MT_TRANS phrase="Emoji replace">:</label></div>
<div class="field">
<select name="emoji_alt" id="mtkk_emoji_alt">
	<option value="img"<TMPL_IF NAME=EMOJI_ALT_IMG> selected</TMPL_IF>><MT_TRANS phrase="Replace to an image"></option>
	<option value="text"<TMPL_IF NAME=EMOJI_ALT_TEXT> selected</TMPL_IF>><MT_TRANS phrase="Replace to text"></option>
</select>
</div>
</div>

<!-- Emoji image size -->
<div class="setting grouped">
<div class="label"><label for="mtkk_emoji_img_size"><MT_TRANS phrase="Size of emoji image">:</label></div>
<div class="field">
<input type="text" name="emoji_img_size" id="mtkk_emoji_img_size" value="<TMPL_VAR NAME=EMOJI_IMG_SIZE ESCAPE=HTML>" style="width: 20%" /> <MT_TRANS phrase="pixels">
</div>
</div>

<!-- AA mapping -->
<div class="setting">
<div class="label"><label for="mtkk_emoji_aa"><MT_TRANS phrase="AA mapping">:</label></div>
<div class="field">
<textarea name="emoji_aa" id="mtkk_emoji_aa" style="width: 60%; height: 4em;"><TMPL_VAR NAME=EMOJI_AA ESCAPE=HTML></textarea> <MT_TRANS phrase='Enter "symbol=AA" for each lines.'>
</div>
</div>

<!-- Accept or deny emoji in comment -->
<p><MT_TRANS phrase="Accept or deny emoji in the comment."></p>
<div class="setting">
<div class="label"><label for="mtkk_accept_comment_emoji"><MT_TRANS phrase="Emoji in comment">:</label></div>
<div class="field">
<input type="radio" name="accept_comment_emoji" id="mtkk_accept_comment_emoji" value="1"<TMPL_IF NAME=ACCEPT_COMMENT_EMOJI> checked</TMPL_IF> /> <MT_TRANS phrase="Accept.">
<input type="radio" name="accept_comment_emoji" id="mtkk_accept_comment_emoji_off" value="0"<TMPL_UNLESS NAME=ACCEPT_COMMENT_EMOJI> checked</TMPL_UNLESS> /> <MT_TRANS phrase="Deny">
</div>
</div>


<!-- Jpeg compression quality -->
<p><MT_TRANS phrase="Set Jpeg compression quality."></p>
<div class="setting">
<div class="label"><label for="mtkk_jpeg_quality"><MT_TRANS phrase="Jpeg quality">:</label></div>
<div class="field">
<input type="text" name="jpeg_quality" id="mtkk_jpeg_quality" value="<TMPL_VAR NAME=JPEG_QUALITY ESCAPE=HTML>" style="width: 30%" /> %
</div>
</div>

<!-- Default display -->
<p><MT_TRANS phrase="Set standard display size for image conversion."></p>
<div class="setting">
<div class="label"><label for="mtkk_default_display"><MT_TRANS phrase="Standard display">:</label></div>
<div class="field">
<input type="radio" name="default_display" id="mtkk_default_screen_system" value=""<TMPL_IF NAME=DEFAULT_DISPLAY_SYSTEM> checked</TMPL_IF> /> <MT_TRANS phrase="Apply the system setting">
<input type="radio" name="default_display" id="mtkk_default_screen_browser" value="browser"<TMPL_IF NAME=DEFAULT_DISPLAY_BROWSER> checked</TMPL_IF> /> <MT_TRANS phrase="Browser">
<input type="radio" name="default_display" id="mtkk_default_screen_screen" value="screen"<TMPL_IF NAME=DEFAULT_DISPLAY_SCREEN> checked</TMPL_IF> /> <MT_TRANS phrase="Screen">
</div>
</div>

<!-- Image convert error -->
<p><MT_TRANS phrase="How to show the error occured when convert image."></p>
<div class="setting">
<div class="label"><label for="mtkk_image_convert_error_show"><MT_TRANS phrase="Image conversion error">:</label></div>
<div class="field">
<input type="radio" name="image_convert_error" id="mtkk_image_convert_error_show" value="show"<TMPL_IF NAME=IMAGE_CONVERT_ERROR_SHOW> checked</TMPL_IF> /> <MT_TRANS phrase="Show error message"> 
<input type="radio" name="image_convert_error" id="mtkk_image_convert_error_hide" value="hide"<TMPL_IF NAME=IMAGE_CONVERT_ERROR_HIDE> checked</TMPL_IF> /> <MT_TRANS phrase="Show nothing">
</div>
</div>

<!-- Image copyright -->
<p><MT_TRANS phrase="Copyright protection for images. Protection for each of images can be set by style attribute."></p>
<div class="setting">
<div class="label"><label for="mtkk_image_copyright"><MT_TRANS phrase="Image copyright">:</label></div>
<div class="field">
<input type="radio" name="image_copyright" id="mtkk_image_copyright" value="1"<TMPL_IF NAME=IMAGE_COPYRIGHT> checked</TMPL_IF> /> <MT_TRANS phrase="Protect">
<input type="radio" name="image_copyright" id="mtkk_image_copyright_off" value="0"<TMPL_UNLESS NAME=IMAGE_COPYRIGHT> checked</TMPL_UNLESS> /> <MT_TRANS phrase="Not protect">
</div>
</div>

<!-- Image as icon size -->
<p><MT_TRANS phrase="When an image smaller than the following size displayed on a high resolution screen, expand the image."></p>
<div class="setting">
<div class="label"><label for="mtkk_image_iconize_width"><MT_TRANS phrase="Display As An Icon">:</label></div>
<div class="field">
<input type="text" name="image_iconize_width" id="mtkk_image_iconize_width" value="<TMPL_VAR NAME=IMAGE_ICONIZE_WIDTH>" size="4" style="width:10%;" />
<MT_TRANS phrase="x">
<input type="text" name="image_iconize_height" id="mtkk_image_iconize_height" value="<TMPL_VAR NAME=IMAGE_ICONIZE_HEIGHT>" size="4" style="width:10%;"  /> <MT_TRANS phrase="pixels equals or is smaller than">
</div>
</div>

<!-- Supported devices -->
<p><MT_TRANS phrase="Set supported devices on this blog."></p>

<div class="setting grouped">
<div class="label"><label for="mtkk_supported_i"><MT_TRANS phrase="i-mode">:</label></div>
<div class="field">
<MT_TRANS phrase="HTML version"> <select name="supported_i" id="mtkk_supported_i">
	<TMPL_LOOP NAME=I_HTML_VERSIONS>
	<option value="<TMPL_VAR NAME=value>"<TMPL_IF NAME=selected> selected</TMPL_IF>><TMPL_VAR NAME=label></option>
	</TMPL_LOOP>
</select> <MT_TRANS phrase="or larger">
<MT_TRANS phrase="XHTML version"> <select name="supported_ix" id="mtkk_supported_ix">
	<TMPL_LOOP NAME=I_XHTML_VERSIONS>
	<option value="<TMPL_VAR NAME=value>"<TMPL_IF NAME=selected> selected</TMPL_IF>><TMPL_VAR NAME=label></option>
	</TMPL_LOOP>
</select> <MT_TRANS phrase="or larger">
</div>
</div>

<div class="setting grouped">
<div class="label"><label for="mtkk_supported_ez"><MT_TRANS phrase="EZweb">:</label></div>
<div class="field">
<MT_TRANS phrase="OpenWave browser version"> <select name="supported_ez" id="mtkk_supported_ez">
	<TMPL_LOOP NAME=EZ_OPENWAVE_VERSIONS>
	<option value="<TMPL_VAR NAME=value>"<TMPL_IF NAME=selected> selected</TMPL_IF>><TMPL_VAR NAME=label></option>
	</TMPL_LOOP>
</select> <MT_TRANS phrase="or larger">
</div>
</div>

<div class="setting grouped">
<div class="label"><label for="mtkk_supported_s"><MT_TRANS phrase="Softbank">:</label></div>
<div class="field">
<MT_TRANS phrase="Softbank Type"> <select name="supported_s" id="mtkk_supported_s">
	<TMPL_LOOP NAME=S_TYPES>
	<option value="<TMPL_VAR NAME=value>"<TMPL_IF NAME=selected> selected</TMPL_IF>><TMPL_VAR NAME=label></option>
	</TMPL_LOOP>
</select> <MT_TRANS phrase="or later">
</div>
</div>

<!-- Exception devices -->
<p><MT_TRANS phrase="If you want to set exception, see below."></p>
<p><a href="#" class="keitaikit-spinner" id="keitaikit-supported-exception-spinner" onclick="return keitaikit_toggle('keitaikit-supported-exception', 'keitaikit-supported-exception-spinner')"><MT_TRANS phrase="Excepted devices"></a></p>

<div id="keitaikit-supported-exception" style="display: none">

<p><MT_TRANS phrase="Set i-mode models separated with comma.">
<a href="http://www.nttdocomo.co.jp/service/imode/make/content/spec/useragent/index.html" target="_blank"><MT_TRANS phrase="See about i-mode models."></a></p>

<div class="setting grouped">
<div class="label"><label for="mtkk_supported_i_include"><MT_TRANS phrase="Including">:</label></div>
<div class="field">
<input type="text" name="supported_i_include" id="mtkk_supported_i_include" style="width: 80%" value="<TMPL_VAR NAME=SUPPORTED_I_INCLUDE>" />
</div>
</div>
<div class="setting grouped">
<div class="label"><label for="mtkk_supported_i_exclude"><MT_TRANS phrase="Excluding">:</label></div>
<div class="field">
<input type="text" name="supported_i_exclude" id="mtkk_supported_i_exclude" style="width: 80%" value="<TMPL_VAR NAME=SUPPORTED_I_EXCLUDE>" />
</div>
</div>

<p><MT_TRANS phrase="Set EZweb device type separated with comma.">
<a href="http://www.au.kddi.com/ezfactory/tec/spec/4_4.html" target="_blank"><MT_TRANS phrase="See about EZweb device type."></a></p>

<div class="setting grouped">
<div class="label"><label for="mtkk_supported_ez_include"><MT_TRANS phrase="Including">:</label></div>
<div class="field">
<input type="text" name="supported_ez_include" id="mtkk_supported_ez_include" style="width: 80%" value="<TMPL_VAR NAME=SUPPORTED_EZ_INCLUDE>" />
</div>
</div>
<div class="setting grouped">
<div class="label"><label for="mtkk_supported_i_exclude"><MT_TRANS phrase="Excluding">:</label></div>
<div class="field">
<input type="text" name="supported_ez_exclude" id="mtkk_supported_ez_exclude" style="width: 80%" value="<TMPL_VAR NAME=SUPPORTED_EZ_EXCLUDE>" />
</div>
</div>

<p><MT_TRANS phrase="Set Softbank models separated with comma.">
<a href="http://creation.mb.softbank.jp/terminal/index.html" target="_blank"><MT_TRANS phrase="See about Softbank models."></a></p>

<div class="setting grouped">
<div class="label"><label for="mtkk_supported_s_include"><MT_TRANS phrase="Including">:</label></div>
<div class="field">
<input type="text" name="supported_s_include" id="mtkk_supported_s_include" style="width: 80%" value="<TMPL_VAR NAME=SUPPORTED_S_INCLUDE>" />
</div>
</div>
<div class="setting grouped">
<div class="label"><label for="mtkk_supported_s_exclude"><MT_TRANS phrase="Excluding">:</label></div>
<div class="field">
<input type="text" name="supported_s_exclude" id="mtkk_supported_s_exclude" style="width: 80%" value="<TMPL_VAR NAME=SUPPORTED_S_EXCLUDE>" />
</div>
</div>

</div>
<div class="setting"></div>

<!-- Advanced Setting -->
<p><MT_TRANS phrase="Following settings is advanced."></p>
<p><a href="#" class="keitaikit-spinner" id="keitaikit-advanced-settings-spinner" onclick="return keitaikit_toggle('keitaikit-advanced-settings', 'keitaikit-advanced-settings-spinner')"><MT_TRANS phrase="Advanced Setting"></a></p>

<div id="keitaikit-advanced-settings" style="display: none">

<!-- Graphic debug mode -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Dump log when an image is converted. The debug log will append to the file named debug.log, be careful to disable after you get the log."></p>
<div class="setting grouped">
<div class="label"><label for="mtkk_graphic_debug_mode"><MT_TRANS phrase="Debug mode">:</label></div>
<div class="field">
<input type="radio" name="graphic_debug_mode" id="mtkk_graphic_debug_mode" value="1"<TMPL_IF NAME=GRAPHIC_DEBUG_MODE> checked</TMPL_IF> /> <MT_TRANS phrase="Enabled"> 
<input type="radio" name="graphic_debug_mode" id="mtkk_graphic_debug_mode" value="0"<TMPL_UNLESS NAME=GRAPHIC_DEBUG_MODE> checked</TMPL_UNLESS> /> <MT_TRANS phrase="Disabled">
</div>
</div>

<!-- Basic auth -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Enter the basic authorization user name and password pairs for image cache downloading."></p>
<div class="setting">
<div class="label"><label for="mtkk_basic_auths"><MT_TRANS phrase="Basic auth">:</label></div>
<div class="field">
<textarea name="basic_auths" id="mtkk_basic_auths" style="width: 40%; height: 4em;"><TMPL_VAR NAME=BASIC_AUTHS ESCAPE=HTML></textarea> <MT_TRANS phrase="Enter 'user:pass' for each lines.">
</div>
</div>

<!-- Drop HTML indent -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Drop HTML indent to shrink data size."></p>
<div class="setting">
<div class="label"><label for="mtkk_drop_html_indent"><MT_TRANS phrase="Drop HTML indent">:</label></div>
<div class="field">
<input type="radio" name="drop_html_indent" id="mtkk_drop_html_indent" value="1"<TMPL_IF NAME=DROP_HTML_INDENT> checked</TMPL_IF> /> <MT_TRANS phrase="Enabled">
<input type="radio" name="drop_html_indent" id="mtkk_drop_html_indent_off" value="0"<TMPL_UNLESS NAME=DROP_HTML_INDENT> checked</TMPL_UNLESS> /> <MT_TRANS phrase="Disabled">
</div>
</div>

<!-- UA camouflage -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Enable and disable User Agent camouflage by mtkk_ua parameter."></p>
<div class="setting">
<div class="label"><label for="mtkk_disable_ua_camouflage"><MT_TRANS phrase="User Agent camouflage">:</label></div>
<div class="field">
<input type="radio" name="disable_ua_camouflage" id="mtkk_disable_ua_camouflage" value="0"<TMPL_UNLESS NAME=DISABLE_UA_CAMOUFLAGE> checked</TMPL_UNLESS> /> <MT_TRANS phrase="Enabled(For debugging)"><br />
<input type="radio" name="disable_ua_camouflage" id="mtkk_disable_ua_camouflage" value="1"<TMPL_IF NAME=DISABLE_UA_CAMOUFLAGE> checked</TMPL_IF> /> <MT_TRANS phrase="Disabled(For running)">
</div>
</div>

<!-- Mobile gateway -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Enter URL for mobile gateway that used for non mobile links. Then enter head part of urls to except from geteway."></p>
<div class="setting grouped">
<div class="label"><label for="mtkk_mobile_gateway"><MT_TRANS phrase="Mobile gateway">:</label></div>
<div class="field">
<input type="text" name="mobile_gateway" id="mtkk_mobile_gateway" value="<TMPL_VAR NAME=MOBILE_GATEWAY ESCAPE=HTML>" style="width: 60%" /> 
<input type="button" value="<MT_TRANS phrase="Use GWT">" onclick="mobile_gateway.value='http://www.google.com/gwt/n?u=';" />
</div>
<div class="field">
<input type="checkbox" name="mobile_gateway_encode_url" id="mtkk_mobile_gateway_encode_url" value="1"<TMPL_IF NAME=MOBILE_GATEWAY_ENCODE_URL> checked="checked"</TMPL_IF> /> <MT_TRANS phrase="Encode url parameter.">
</div>
</div>

<!-- Exception URLs -->
<div class="setting">
<div class="label"><label for="mtkk_mobile_gateway_exception"><MT_TRANS phrase="Exception URL">:</label></div>
<div class="field">
<textarea name="mobile_gateway_exception" id="mtkk_mobile_gateway_exception" style="width: 70%; height: 6em;"><TMPL_VAR NAME=MOBILE_GATEWAY_EXCEPTION ESCAPE=HTML></textarea> <MT_TRANS phrase="ex. http://domain/">
</div>
</div>

<!-- Paging parameter -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Enter the pagination GET parameter name."></p>
<div class="setting grouped">
<div class="label"><label for="mtkk_selector"><MT_TRANS phrase="Pagination param">:</label></div>
<div class="field">
<input type="text" name="selector" id="mtkk_selector" value="<TMPL_VAR NAME=SELECTOR ESCAPE=HTML>" style="width: 40%" />
</div>
</div>

<!-- Layering parameter -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Enter the layer GET parameter name."></p>
<div class="setting">
<div class="label"><label for="mtkk_layerer"><MT_TRANS phrase="Layer param">:</label></div>
<div class="field">
<input type="text" name="layerer" id="mtkk_layerer" value="<TMPL_VAR NAME=LAYERER ESCAPE=HTML>" style="width: 40%" />
</div>
</div>

<!-- Session link -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Set to keep session link in this blog. And if you keep session link, set parameter name, if start new session and external urls."></p>
<div class="setting grouped">
<div class="label"><label for="mtkk_use_session"><MT_TRANS phrase="Session link">:</label></div>
<div class="field">
<input type="radio" name="use_session" id="mtkk_use_session" value="1"<TMPL_IF NAME=USE_SESSION> checked</TMPL_IF> onclick="keitaikit_show('keitaikit-session-settings', true);" /> <MT_TRANS phrase="Enabled"> 
<input type="radio" name="use_session" id="mtkk_use_session" value="0"<TMPL_UNLESS NAME=USE_SESSION> checked</TMPL_UNLESS> onclick="keitaikit_show('keitaikit-session-settings', false);" /> <MT_TRANS phrase="Disabled">
</div>
</div>

<!-- Session settings -->
<div id="keitaikit-session-settings" <TMPL_UNLESS NAME=USE_SESSION>style="display: none;"</TMPL_UNLESS>>

<!-- Session name -->
<div class="setting grouped">
<div class="label"><label for="mtkk_session_param"><MT_TRANS phrase="Session param">:</label></div>
<div class="field">
<input type="text" name="session_param" id="mtkk_session_param" value="<TMPL_VAR NAME=SESSION_PARAM ESCAPE=HTML>" style="width: 40%" />
</div>
</div>

<!-- Start new session -->
<div class="setting grouped">
<div class="label"><label for="mtkk_start_session"><MT_TRANS phrase="New session">:</label></div>
<div class="field">
<input type="radio" name="start_session" id="mtkk_start_session" value="1"<TMPL_IF NAME=START_SESSION> checked</TMPL_IF> /> <MT_TRANS phrase="Start new PHP session"><br />
<input type="radio" name="start_session" id="mtkk_start_session" value="0"<TMPL_UNLESS NAME=START_SESSION> checked</TMPL_UNLESS> /> <MT_TRANS phrase="Do not start new PHP session">
</div>
</div>

};


	$template .= qq{
<!-- URLs for JSP style session link -->
<div class="setting grouped">
<div class="label"><label for="mtkk_session_jsp_urls"><MT_TRANS phrase="JSP style URLs">:</label></div>
<div class="field">
<textarea name="session_jsp_style_urls" id="mtkk_session_jsp_style_urls" style="width: 70%; height: 6em;"><TMPL_VAR NAME=SESSION_JSP_STYLE_URLS ESCAPE=HTML></textarea> <MT_TRANS phrase="ex. http://domain/">
</div>
</div>
} if $jsp_support;

	$template .= qq{
<!-- External URLs for session link -->
<div class="setting">
<div class="label"><label for="mtkk_session_external_urls"><MT_TRANS phrase="External URLs">:</label></div>
<div class="field">
<textarea name="session_external_urls" id="mtkk_session_external_urls" style="width: 70%; height: 6em;"><TMPL_VAR NAME=SESSION_EXTERNAL_URLS ESCAPE=HTML></textarea> <MT_TRANS phrase="ex. http://domain/">
</div>
</div>

</div>

<!-- PHP Encoding parameter -->
<TMPL_IF NAME=IS_MT5>
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="PHP internal and script encoding is same as PublishCharset on Movable Type 5 or later."></p>
<div class="setting">
<div class="label"><label for="mtkk_php_encoding_dummy"><MT_TRANS phrase="PHP Encode">:</label> </div>
<div class="field">
<input type="text" name="php_encoding_dummy" id="mtkk_php_encoding_dummy" value="<TMPL_VAR NAME=PUBLISH_CHARSET ESCAPE=HTML>" style="width: 40%" disabled="disabled" />
<input type="hidden" name="php_encoding" id="mtkk_php_encoding" value="<TMPL_VAR NAME=PHP_ENCODING ESCAPE=HTML>" />
</div>
</div>
<TMPL_ELSE>
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Set PHP internal and script encoding(Shift_JIS, EUC-JP or UTF-8)."></p>
<div class="setting">
<div class="label"><label for="mtkk_php_encoding"><MT_TRANS phrase="PHP Encode">:</label></div>
<div class="field">
<input type="text" name="php_encoding" id="mtkk_php_encoding" value="<TMPL_VAR NAME=PHP_ENCODING ESCAPE=HTML>" style="width: 40%" />
</div>
</div>
</TMPL_IF>

<!-- Local directory -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Set the DocumentRoot path of web server to refer local images directly. If you set the path, KeitaiKit tries to find the image on local directory at first. If the image will generated dynamicaly, it does not work well. If you set blank, the local directory does not be refered."></p>
<div class="setting">
<div class="label"><label for="mtkk_document_root"><MT_TRANS phrase="DocumentRoot">:</label></div>
<div class="field">
<input type="text" name="document_root" id="mtkk_document_root" value="<TMPL_VAR NAME=DOCUMENT_ROOT ESCAPE=HTML>" style="width: 60%" />
<input type="button" value="<MT_TRANS phrase="Use site path">" onclick="document_root.value='<TMPL_VAR NAME=BLOG_ROOT ESCAPE=HTML>';" />
<TMPL_IF NAME=IDENTIFY_IS_NOT_EXECUTABLE>
<br /><span style="color:red;"><MT_TRANS phrase="This directory does not exist"></span>
</TMPL_IF>
</div>
</div>

<!-- Image Script -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="Set path and url of the image convert PHP script if you change."></p>
<div class="setting grouped">
<div class="label"><label for="mtkk_image_script_path"><MT_TRANS phrase="Output Path">:</label></div>
<div class="field">
<input type="text" name="image_script_path" id="mtkk_image_script_path" value="<TMPL_VAR NAME=IMAGE_SCRIPT_PATH ESCAPE=HTML>" style="width: 60%" /> <MT_TRANS phrase="(Include file name)">
</div>
</div>

<div class="setting">
<div class="label"><label for="mtkk_image_script_url"><MT_TRANS phrase="URL">:</label></div>
<div class="field">
<input type="text" name="image_script_url" id="mtkk_image_script_url" value="<TMPL_VAR NAME=IMAGE_SCRIPT_URL ESCAPE=HTML>" style="width: 60%" />
</div>
</div>

<!-- Multi Server -->
<p><span style="color: red; font-weight: bold;">[<MT_TRANS phrase="Advanced Setting">]</span> <MT_TRANS phrase="If you use KeitaiKit on multi web servers behind load barancer, select the following option."></p>
<div class="setting grouped">
<div class="label"><label for="mtkk_multi_servers"><MT_TRANS phrase="Web Server">:</label></div>
<div class="field">
<input type="radio" name="multi_servers" id="mtkk_multi_servers" value="0"<TMPL_UNLESS NAME=MULTI_SERVERS> checked</TMPL_UNLESS> /> <MT_TRANS phrase="One web server"> 
<input type="radio" name="multi_servers" id="mtkk_multi_servers" value="1"<TMPL_IF NAME=MULTI_SERVERS> checked</TMPL_IF> /> <MT_TRANS phrase="Multi web servers">
</div>
</div>

<!-- charset -->
<input type="hidden" name="charset" id="mtkk_charset" value="<TMPL_VAR NAME=CHARSET ESCAPE=HTML>" style="width: 20%" />

</div>
<div class="setting"></div>

};


	$template;
}

1;