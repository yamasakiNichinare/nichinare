<?php
require_once('lib/JSON.php');
require_once('classes/aform.class.php');
require_once('classes/aform_field.class.php');


function smarty_modifier_aform( $entry_text ) {
    $entry_text = _replace_form($entry_text, '<\!--', '-->');
    $entry_text = _replace_form($entry_text, '\[\[', '\]\]');

    return $entry_text;
}


function _replace_form( $entry_text, $pattern_pre, $pattern_post ) {

    preg_match_all("/${pattern_pre}aform(\d+)${pattern_post}/", $entry_text, $matches);
    foreach ( $matches[1] as $match_no ){
        $aform_id = (int)$match_no;

        # get aform
        $aform_class = new AForm();
        $aforms = $aform_class->Find("aform_id = " . $aform_id);
        if( empty($aforms) ){
            $entry_text = preg_replace("/${pattern_pre}aform${match_no}${pattern_post}/i", "", $entry_text);
            continue;
        }
        $aform = $aforms[0];

        $buf = '';
        if( $aform->status == 2 ){	# published
            # generate form
            $buf = _generate_form_view($aform);
        }

        # replace
        $entry_text = preg_replace("/${pattern_pre}aform${match_no}${pattern_post}/i", $buf, $entry_text);
    }
    return $entry_text;
}


function _generate_form_view( $aform ) {

    global $mt;
    $ctx =& $mt->context();

    # get plugin path
    $plugin_paths = $mt->config('PluginPath');
    if( count($plugin_paths) == 0 ){
        return '';
    }

    $static_uri = $mt->config('staticwebpath');
    $blog = $ctx->stash('blog');
    if( preg_match("#^https://#", $blog->blog_site_url) ){
      $static_uri = preg_replace("#^http://#", "https://", $static_uri);
    }

    # get script url dir
    $script_url_dir = _get_script_url_dir();

    $plugin_config = $mt->db()->fetch_plugin_config('A-Form');
    $for_business = is_business();
    $checked_sn = (int)$plugin_config['checked_sn'];

    # set vars
    $vars =& $ctx->__stash['vars'];
    $vars['blog_id'] = $ctx->stash('blog_id');
    $vars['id'] = $aform->id;
    $vars['title'] = $aform->title;
    $vars['fields'] = _get_fields($aform->id);
    $vars['action_url'] = $script_url_dir . 'aform_engine.cgi';
    $vars['logger_url'] = $script_url_dir . 'aform_logger.cgi';
    $vars['checker_url'] = $script_url_dir . 'aform_checker.cgi';
    $vars['aform_url'] = $ctx->tag('EntryPermalink');
    $vars['charset'] = $mt->config('publishcharset');
    $vars['preview'] = 0;
    $vars['static_uri'] = $static_uri;
    $vars['hide_demo_warning'] = (!$for_business || $checked_sn);
    $vars['hide_powered_by'] = ($for_business || $checked_sn);
    $vars['check_immediate'] = $aform->check_immediate;

    $tmp_caching = $ctx->caching;
    $ctx->caching = false;
    $html = $ctx->fetch(_get_tmpl_file_path($plugin_paths[0], $aform->id, 'aform_form.tmpl'));
    $ctx->caching = $tmp_caching;
    return $html;
}


function _get_tmpl_file_path( $plugin_path, $aform_id, $filename ) {
    $plugin_tmpl_dir = $plugin_path . '/AForm/tmpl/';
    $tmpl = sprintf("%s%03d/%s", $plugin_tmpl_dir, $aform_id, $filename);
    if( ! file_exists($tmpl) ){
        // use default template if custom template not exists
        $tmpl = $plugin_tmpl_dir . $filename;
    }
    return $tmpl;
}


function _get_fields( $aform_id ) {

    $aform_field_class = new AFormField();
    $ary_aform_fields = $aform_field_class->Find("aform_field_aform_id = " . $aform_id . " order by aform_field_sort_order");

    $fields = array();
    foreach( $ary_aform_fields as $aform_field ){
        $param = array(
          id => $aform_field->id,
          type => $aform_field->type,
          label => $aform_field->label,
          is_necessary =>  $aform_field->is_necessary,
          options => $aform_field->options,
          use_default => $aform_field->use_default,
          default_label => $aform_field->default_label,
          privacy_link => $aform_field->privacy_link,
          is_replyed => $aform_field->is_replyed,
          input_example => $aform_field->input_example,
          max_length => $aform_field->max_length,
        );
        array_push($fields, $param);
    }
    return $fields;
}


function _get_script_url_dir() {

    global $mt;
    $plugin_config = $mt->db()->fetch_plugin_config('A-Form');
    $script_url_dir = $plugin_config['script_url_dir'];
    if( preg_match("#\/$#", $script_url_dir) ){
        $script_url_dir .= '/';
    }
    if( ! _url_check($script_url_dir) ){
        $script_url_dir = $mt->config('cgipath') . 'plugins/AForm/';
    }
    return $script_url_dir;
}


function _url_check( $url ) {
    # http:// or https://
    return preg_match("#^https?://[^/].*#i", $url);
}

function is_business() {
    global $mt;

    $plugin_paths = $mt->config('PluginPath');
    $key_file = $plugin_paths[0] . '/AForm/key/aform_nonprofitkey.txt';
    if( file_exists($key_file) ){
        return 0;
    }else{
        return 1;
    }
}

?>
