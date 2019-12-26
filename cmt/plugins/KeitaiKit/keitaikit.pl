

package MT::Plugin::KeitaiKit;
use vars qw( $VERSION $OLD_VERSION $URL %FORMATS %OPTIONS $I_EZ_MAX_WIDTH $IS_MT5 $XML_DECLARATION %DOCTYPE $QVGA_WIDTH $EMOJI_SIZES $INT_MAX );
$VERSION = '1.62';
$OLD_VERSION = '1.30';
$URL = 'http://secure.ideamans.com/register.php';
%FORMATS = (MG_JPEG => 0x0001, MG_GIF => 0x0002, MG_PNG => 0x0008, MG_NOVGA => 0x4000, MG_RESOLUTIONS => 0x8000);
%OPTIONS = ();
$I_EZ_MAX_WIDTH = 240;
$XML_DECLARATION = '<?xml version="1.0" encoding="%s"?>';
%DOCTYPE = (
    i   => '<!DOCTYPE html PUBLIC "-//i-mode group (ja)//DTD XHTML i-XHTML(Locale/Ver.=ja/%0.1f) 1.0//EN" "i-xhtml_4ja_10.dtd">',
    ez  => '<!DOCTYPE html PUBLIC "-//OPENWAVE//DTD XHTML 1.0//EN" "http://www.openwave.com/DTD/xhtml-basic.dtd">',
    s   => '<!DOCTYPE html PUBLIC "-//J-PHONE//DTD XHTML Basic 1.0 Plus//EN" "xhtml-basic10-plus.dtd">',
);
$QVGA_WIDTH = 240;
$EMOJI_SIZES = {
    i   => {width => 12, height => 12},
    ez  => {width => 14, height => 15},
    s   => {width => 15, height => 15},
};
$INT_MAX = 2147483647;


use LWP::UserAgent;
use HTML::TagParser;
use Digest::Crc32;
use MT;
use MT::Blog;
use MT::Template;
use MT::Template::Context;
$IS_MT5 = MT->version_number >= 5? 1: 0;
if($IS_MT5) {
	require Lingua::JA::Regular::Unicode;
} else {
	use Unicode::Japanese qw(PurePerl);
}
use String::Multibyte;
use MT::I18N;
use KeitaiCode;

require KeitaiDB;


use strict;


use base qw(MT::Plugin);


my $kdb;
my $emoji_aa;


my $plugin = MT::Plugin::KeitaiKit->new({
	name => 'KeitaiKit',
	version => $VERSION,
	description => (MT->version_number !~ /^3\.2/)?
		"<MT_TRANS phrase=\"Support for building and managing mobile contents.\">":
		convert_from_utf8('携帯電話向けコンテンツの構築と運用を支援します'),
	doc_link => 'http://mt.keitaikit.jp/',
	author_name => "ideaman's Inc.", 
	author_link => 'http://www.ideamans.com/',
	l10n_class => 'KeitaiKit::L10N',
	config_template => \&_hdr_config_template,
	settings => new MT::PluginSettings([
	    ['temp_dir'],
	    ['php_graphic'],
	    ['download_adapter', { Default => 'php' } ],
	    ['convert', { Default => '[discovery]' } ],
	    ['identify', { Default => '[discovery]' } ],
	    ['hankaku'],
	    ['emoji_alt'],
	    ['emoji_img_size'],
	    ['charset'],
	    ['selector'],
	    ['layerer'],
	    ['licensekey'],
	    ['setuptime'],
	    ['pc_redirect'],
	    ['disable_ua_camouflage'],
	    ['cache_expires'],
	    ['mailaddress'],
	    ['emoji_aa'],
	    ['prebuilding_module'],
	    ['drop_html_indent'],
	    ['basic_auths'],
	    ['jpeg_quality'],
	    ['php_encoding'],
	    ['setupversion'],
	    ['download_proxy'],
	    ['mobile_gateway'],
	    ['mobile_gateway_exception', { Default => '[discovery]'} ],
	    ['mobile_gateway_encode_url', { Default => 1 } ],
	    ['php_graphic_url'],
	    ['image_copyright'],
	    ['document_root'],
	    ['supported_format'],
	    ['supported_include'],
	    ['supported_exclude'],
	    ['graphic_debug_mode'],
	    ['image_convert_error'],
	    ['use_session'],
	    ['session_param'],
	    ['session_external_urls'],
	    ['start_session'],
	    ['session_jsp_style_urls'],
	    ['image_script_path'],
	    ['image_script_url'],
	    ['multi_servers'],
	    ['cache_cleaning_prob'],
	    ['accept_comment_emoji'],
	    ['php_keitaikit_dir'],
	    ['log_comment_detail'],
	    ['default_display'],
	    ['default_blog_id'],
	    ['image_iconize_width'],
	    ['image_iconize_height'],
	    ['crawler_keywords', { Default => '' } ],
	    ['smartphone_enabled', { Default => 1 } ],
	    ['smartphone_screen_width', { Default => 320 } ],
	    ['smartphone_screen_height', { Default => 480 } ],
	    ['smartphone_emoji_dir', { Default => 'typecast' } ],
	    ['smartphone_remove_style', { Default => 'all' } ],
	    ['smartphone_remove_css_properties', { Default => 'font-size' } ],
	    ['smartphone_convert_kana', { Default => 1 } ],
	    ['smartphone_cache_size', { Default => 1024 } ],
	    ['smartphone_encoding', { Default => 'UTF-8' } ],
	]),
});

sub instance {
	$plugin;
}

sub url {
	$URL;
}

MT->add_plugin($plugin);


sub translate {
	my $self = shift;


	return $self->SUPER::translate(@_) if MT->version_number !~ /^3\.2/;
	

	unless($self->{__j10n_handle}) {
		require KeitaiKit::J10N;
		$self->{__j10n_handle} = KeitaiKit::J10N->get_handle('ja');
	}
	my ($format, @args) = @_;
	my $enc = MT->instance->config('PublishCharset');
	my $str;
	if ($enc =~ m/utf-?8/i) {
		$str = $self->{__j10n_handle}->maketext($format, @args);
	} else {
		$str = MT::I18N::encode_text($self->{__j10n_handle}->maketext($format, map {MT::I18N::encode_text($_, $enc, 'utf-8')} @args), 'utf-8', $enc);
	}
	if(!defined $str) {
		$str = MT->translate(@_);
	}
	$str;
}

sub translate_templatized {
    my $self = shift;
    

    return $self->SUPER::translate_templatized(@_) if MT->version_number !~ /^3\.2/;


    my($text) = @_;
    $text =~ s!(<MT_TRANS(?:\s+((?:\w+)\s*=\s*(["'])(?:<[^>]+?>|[^\3]+?)+?\3))+?\s*/?>)!
        my($msg, %args) = ($1);
        while ($msg =~ /\b(\w+)\s*=\s*(["'])((?:<[^>]+?>|[^\2])*?)\2/g) {  #"
            $args{$1} = $3;
        }
        $args{params} = '' unless defined $args{params};
        my @p = map MT::Util::decode_html($_),
            split /\s*%%\s*/, $args{params};
        @p = ('') unless @p;
        my $translation = $self->translate($args{phrase}, @p);
        $translation =~ s/([\\'])/\\$1/sg if $args{escape};
        $translation;
    !ge;
    $text;
}




sub discover_command {
	my ($command) = @_;
	
	if($^O ne 'MSWin32') {

		my $which = `which --skip-alias $command` || '';
		my @which = split(/\n/, $which);
		return $which[0] if -e $which[0] && -x $which[0];
	}
}


sub default_blog {
	my $config = $plugin->get_config_hash;
	my $blog_id = $config->{default_blog_id};
	my $blog = MT::Blog->load($blog_id) if $blog_id;
	$blog;
}


sub _hdr_config_template {
	my $self = shift;
	my ($param, $scope) = @_;
	
	use KeitaiKit::ConfigTemplate;
	my $template;
	

	if($IS_MT5) {
		$param->{is_mt5} = 1 if $IS_MT5;
		$param->{publish_charset} = MT->instance->config('PublishCharset');
	}
	

	if($scope eq 'system') {

		my $mt_path = MT->instance->mt_dir;
		my $plugin_dir = File::Spec->catdir($mt_path, $self->envelope);


		$param->{temp_dir} = File::Spec->catdir($plugin_dir, '/tmp/') unless $param->{temp_dir};
		$param->{php_graphic} = 'gd' unless $param->{php_graphic};
		$param->{cache_expires} = 1209600 unless $param->{cache_expires};
		$param->{jpeg_quality} ||= 75;
		$param->{setupversion} ||= $OLD_VERSION;
		$param->{cache_cleaning_frequency} ||= 0;
		

		$param->{convert} = discover_command('convert') if $param->{convert} && $param->{convert} eq '[discovery]';
		$param->{identify} = discover_command('identify') if $param->{identify} && $param->{identify} eq '[discovery]';
		

		if($param->{php_graphic} eq 'gd') {
			$param->{php_graphic_gd} = 1;
		} elsif($param->{php_graphic} eq 'im5') {
			$param->{php_graphic_im5} = 1;
		} elsif($param->{php_graphic} eq 'http') {
			$param->{php_graphic_http} = 1;
		} else {
			$param->{php_graphic_im} = 1;
		}
		
		if($param->{download_adapter} eq 'curl') {
			$param->{download_adapter_curl} = 1;
		} elsif($param->{download_adapter} eq 'http_request') {
			$param->{download_adapter_http_reqeust} = 1;
		} else {
			$param->{download_adapter_php} = 1;
		}
		
		$param->{default_display_browser} = 1 if $param->{default_display} ne 'screen';
		$param->{default_display_screen} = 1 if $param->{default_display} eq 'screen';
		

		if($param->{php_graphic} eq 'im' || $param->{php_graphic} eq 'im5') {
			$param->{temp_dir_has_space} = 1 if $param->{temp_dir} =~ /\s/;
			$param->{convert_is_not_executable} = 1 unless -x $param->{convert};
			$param->{convert_is_dir} = 1 if -d $param->{convert};
			$param->{identify_is_not_executable} = 1 unless -x $param->{identify};
			$param->{identify_is_dir} = 1 if -d $param->{identify};
		}
		

		if($param->{php_graphic} eq 'http') {
			$param->{php_graphic_url_is_empty} = 1 unless $param->{php_graphic_url};
		}
		


		$param->{temp_dir_not_writable} = 1 unless -w $param->{temp_dir};
		

		my $cmd_url = MT::App->instance->mt_path;
		$cmd_url .= '/' unless m!/$!;
		$cmd_url .= $self->envelope . '/keitaikit.cgi';
		$cmd_url =~ s/\/\//\//g;
		$param->{command_url} = $cmd_url;
		

		if($param->{setuptime}) {
			my $rest_days = 60 - int((time - $param->{setuptime}) / (3600 * 24));
			unless($param->{licensekey}) {
				if($rest_days > 0) {
					$param->{in_trial} = 1;
					$param->{rest_days} = $rest_days;
				} else {

					my $enabled_prolong = $param->{setupversion} < $OLD_VERSION? 1: 0;
					$template = KeitaiKit::ConfigTemplate::trial_expired($enabled_prolong);


					$template = $self->translate_templatized($template) if MT->version_number =~ /^3\.2/;
					return $template;
				}
			}
		}
		

		my $db_path = File::Spec->catfile($plugin_dir, '/db/spec.db');
		my ($sec, $min, $hour, $day, $mon, $year) = localtime((stat($db_path))[9]);
		$year += 1900;
		$mon += 1;
		$param->{db_date} = "$year/$mon/$day $hour:$min";
		

		my @default_blogs = ( { value => 0, label => $self->translate('Not Selected'), selected => !$param->{default_blog_id}? 1: 0} );;
		my $blogs_terms = MT->instance->config('DefaultBlogs')? {id => [split(/\s*,\s*/, MT->instance->config('DefaultBlogs'))]}: {};
		my @blogs = MT::Blog->load($blogs_terms, {limit => MT->instance->config('DefaultBlogsLimit') || 50});
		foreach my $b (@blogs) {
			push @default_blogs, { value => $b->id, label => $b->name, selected => ($param->{default_blog_id} == $b->id)? 1: 0 };
		}
		$param->{default_blogs} = \@default_blogs;
		

		my $smartphone_remove_style = lc($param->{smartphone_remove_style} || 'all');
		if($smartphone_remove_style eq 'all') {
			$param->{smartphone_remove_style_all} = 1;
		} elsif($smartphone_remove_style eq 'properties') {
			$param->{smartphone_remove_style_properties} =  1;
		} else {
			$param->{smartphone_remove_style_none} = 1;
		}
		if(defined($param->{smartphone_encoding})) {
			$param->{smartphone_encoding_sjis} = lc($param->{smartphone_encoding}) eq 'shift_jis'? 1: 0;
			$param->{smartphone_encoding_utf8} = $param->{smartphone_encoding_sjis}? 0: 1;
		}
		

		$template = KeitaiKit::ConfigTemplate::system_config;
		

		$template = $self->translate_templatized($template) if MT->version_number =~ /^3\.2/;
		return $template;
	} else {
		if(my $blog = MT->instance->blog) {

			$param->{charset} = 'sjis' unless $param->{charset};
			$param->{hankaku} = 'all' unless $param->{hankaku};
			$param->{emoji_alt} = 'img' unless $param->{emoji_alt};
			$param->{emoji_img_size} = 12 unless $param->{emoji_img_size};
			$param->{selector} = 'mtkk_page' unless $param->{selector};
			$param->{layerer} = 'mtkk_layer' unless $param->{layerer};
			$param->{php_encoding} = 'Shift_JIS' unless $param->{php_encoding};
			$param->{document_root} = '' unless $param->{document_root};
			$param->{blog_root} = $blog->site_path;
			$param->{blog_root} =~ s/\\/\\\\/g;
			$param->{graphic_debug_mode} = 0 unless defined($param->{graphic_debug_mode});
			$param->{image_convert_error} = 'show' unless $param->{image_convert_error};
			$param->{use_session} = 0 unless defined($param->{use_session});
			$param->{session_param} = 'session_id' unless $param->{session_param};
			$param->{start_session} = 1 unless defined($param->{start_session});
			$param->{session_external_urls} = '' unless $param->{session_external_urls};
			if($OPTIONS{jsp_support}) {
				$param->{session_jsp_style_urls} = '' unless $param->{session_jsp_style_urls};
			}
			

			my $static_uri = MT::App->instance->static_path;
			$static_uri =~ s![\\/]$!!;
			if(MT->version_number =~ /^3\.2/) {
				$param->{spinner_right} = "$static_uri/images/spinner-right.gif";
				$param->{spinner_bottom} = "$static_uri/images/spinner-bottom.gif";
				$param->{spinner_size} = 8;
			} else {
				$param->{spinner_right} = "$static_uri/images/spinner-big-right.gif";
				$param->{spinner_bottom} = "$static_uri/images/spinner-big-bottom.gif";
				$param->{spinner_size} = 12;
			}
			

			$param->{hankaku_all} = 1 if $param->{hankaku} eq 'all';
			$param->{hankaku_no} = 1 if $param->{hankaku} eq 'no';
			$param->{hankaku_mobile} = 1 if $param->{hankaku} eq 'mobile';
			
			$param->{emoji_alt_text} = 1 if $param->{emoji_alt} eq 'text';
			$param->{emoji_alt_img} = 1 if $param->{emoji_alt} eq 'img';
			
			$param->{image_convert_error_show} = 1 if $param->{image_convert_error} ne 'hide';
			$param->{image_convert_error_hide} = 1 if $param->{image_convert_error} eq 'hide';
			
			$param->{default_display_browser} = 1 if $param->{default_display} eq 'browser';
			$param->{default_display_screen} = 1 if $param->{default_display} eq 'screen';
			$param->{default_display_system} = 1 unless $param->{default_display};
			

			$param->{mobile_gateway_exception} = $blog->site_url if $param->{mobile_gateway_exception} && $param->{mobile_gateway_exception} eq '[discovery]';
			

			my @blogs = MT::Blog->load();
			my %blog_names = ();
			foreach my $b (@blogs) {
				$blog_names{$b->id} = $b->name;
			}
			

			my @modules = ( { value => 0, label => $self->translate('Not Selected'), selected => $param->{prebuilding_module} == 0? 1: 0} );
			my @terms_blog_ids = ($blog->id, 0);
			if($param->{prebuilding_module}) {
			    if(my $current_module = MT::Template->load($param->{prebuilding_module})) {
			        push @terms_blog_ids, $current_module->blog_id;
			    }
			}
			my $module_blogs = MT->instance->config('KeitaiPrebuildingModuleBlogs') || '';
			if($module_blogs) {
			    if(lc($module_blogs) eq 'all') {
			        @terms_blog_ids = ();
			    } else {
			        push @terms_blog_ids, split(/\s*,\s*/, $module_blogs);
			    }
			}
			my $terms = @terms_blog_ids? {blog_id => \@terms_blog_ids}: {};
			my @tmpls = MT::Template->load($terms, {sort => 'blog_id'});
			foreach my $tmpl (@tmpls) {
				push @modules, { value => $tmpl->id, label => $tmpl->name, selected => $param->{prebuilding_module} == $tmpl->id? 1: 0 }
					if $tmpl->blog_id == $blog->id && ($tmpl->type eq 'custom' || $tmpl->type eq 'module') && $tmpl->blog;
			}
			push @modules, { value => 0, label => $self->translate('Select from other blogs:'), selected => 0, disabled => 1};
			foreach my $tmpl (@tmpls) {
				my $blog_name = $tmpl->blog_id == 0? $self->translate('Global'):
					($blog_names{$tmpl->blog_id} || $self->translate('Unknown blog'));
				push @modules, { value => $tmpl->id, label => $blog_name . ' / ' . $tmpl->name, selected => $param->{prebuilding_module} == $tmpl->id? 1: 0 }
					if $tmpl->blog_id != $blog->id && ($tmpl->type eq 'custom' || $tmpl->type eq 'module');
			}
			$param->{prebuilding_modules} = \@modules;
			

			if($param->{document_root}) {
				$param->{document_root_not_found} = 1
					unless -e $param->{document_root_not_found};
			}
			

			KeitaiKit::ConfigTemplate::set_keitai_versions($param, $self->translate('Not Selected'), $self->translate('i-mode Browser'));
			


			foreach my $carrier ('i', 'ez', 's') {
				$param->{"supported_${carrier}_include"} = $param->{"supported_include"}{$carrier};
				$param->{"supported_${carrier}_exclude"} = $param->{"supported_exclude"}{$carrier};
			}
		}


		$template = KeitaiKit::ConfigTemplate::blog_config($OPTIONS{jsp_support});


		$template = $self->translate_templatized($template) if MT->version_number =~ /^3\.2/;
		return $template;
	}
}


sub save_config {
	my $self = shift;
	my ($param, $scope) = @_;
	
	if($scope eq 'system') {

		unless($param->{setuptime}) {
			$param->{setuptime} = time;
			$param->{setupversion} = $VERSION;
		}
	} else {

		$param->{supported_format}{$_} = $param->{"supported_$_"} foreach ('i', 'ix', 'ez', 's');


		foreach my $carrier ('i', 'ez', 's') {
			$param->{"supported_include"}{$carrier} = $param->{"supported_${carrier}_include"};
			$param->{"supported_exclude"}{$carrier} = $param->{"supported_${carrier}_exclude"};
		}
	}

	return $self->SUPER::save_config(@_);
}




sub build_base_post {
    my $config = $plugin->get_config_hash;
    

    my $licensekey = $config->{licensekey};
    my $mailaddress = $config->{mailaddress};
    

    my $mt_path = MT::App->instance->mt_path;
    my $ping_path = $mt_path;
    $ping_path .= '/' unless m!/$!;
    $ping_path .= $plugin->envelope . '/';
    my $mt_dir = MT->instance->mt_dir;
    

    my %post = (
        licenseKey => $licensekey,
        systemLocation => $mt_path,
        mailAddress => $mailaddress,
	platform => 'mt',
	ping => $ping_path,
	hint => $mt_dir,
    );
    
    return \%post;
}

sub encode_mapping {
	my $mapping = {'shift_jis' => 'sjis', 'euc-jp' => 'euc', 'utf-8' => 'utf8'};
	$mapping->{lc($_[0])} || lc($_[0]);
}

sub encode_reverse_mapping {
	my $mapping = { sjis => 'Shift_JIS', euc => 'EUC-JP', utf8 => 'UTF-8' };
	$mapping->{lc($_[0])} || lc($_[0]);
}

sub internal_charset {
	encode_mapping(MT->instance->config('PublishCharset')) || 'utf8';
}


sub convert_from_utf8 {
   my ($message) = @_;
   

   return $message if $IS_MT5;
   

   if(defined($OPTIONS{I18N}) && $OPTIONS{I18N} eq 'MTK') {
       $message = MT::I18N::encode_text($message, 'UTF-8', MT->instance->config('PublishCharset'));
   } else {
       my $internal = internal_charset;
       $message = Unicode::Japanese->new($message, 'utf8')->$internal if $internal ne 'utf8';
   }

   $message;
}


sub convert_to_utf8 {
    my ($message) = @_;
    

    return $message if $IS_MT5;
    

    if(defined($OPTIONS{I18N}) && $OPTIONS{I18N} eq 'MTK') {
        $message = MT::I18N::encode_text($message, MT->instance->config('PublishCharset'), 'UTF-8');
    } else {
        my $internal = internal_charset;
        $message = Unicode::Japanese->new($message, $internal)->utf8 if $internal ne 'utf8';
    }
    
    $message;
}


sub is_dynamic {
	if($ENV{MOD_PERL}) {
		return MT::App->instance->{apache}->subprocess_env('MTKK_DYNAMIC')? 1: 0;
	} else {
		return $ENV{MTKK_DYNAMIC}? 1: 0;
	}
}


sub register_license {

    my $config = $plugin->get_config_hash;
    

    my $self = shift;
    my ($licensekey, $mailaddress) = @_;
    
    my $rpost = $self->build_base_post;
    $rpost->{licenseKey} = $licensekey;
    $rpost->{mailAddress} = $mailaddress;
    

    return ('error',  $self->translate('The license key is not entered.')) unless $rpost->{licenseKey};
    

    my $query = $URL . '?action=registerKeitaiKit';
    

    my $ua = LWP::UserAgent->new(parse_head => 0);
    $ua->proxy('http', 'http://' . $config->{download_proxy}. '/') if $config->{download_proxy};
    my $response = $ua->post($query, $rpost);
    

    return ('error', $self->translate('Failure to connect to the server.'))
        unless $response->is_success || $response->headers->header('X-Result');
	

    my $result = $response->headers->header('X-Result');
    my $message = convert_from_utf8($response->headers->header('X-Message'));
    

    utf8::decode($message) if $IS_MT5;
    

    if($result ne 'error') {

	my $config = $self->get_config_hash;
	$config->{licensekey} = $licensekey;
	$config->{mailaddress} = $mailaddress;
	$self->SUPER::save_config($config);
    }
    
    return ($result, $message);
}


sub download_spec_db {

    my $config = $plugin->get_config_hash;


    my $self = shift;
    my $rpost = $self->build_base_post;
    

    my $query = $URL . '?action=downloadKeitaiKitSpecDB';
    

    my $ua = LWP::UserAgent->new(parse_head => 0);
    $ua->proxy('http', 'http://' . $config->{download_proxy} . '/') if $config->{download_proxy};
    my $response = $ua->post($query, $rpost);
    

    return ('error', $self->translate('Failure to connect to the server.'))
        unless $response->is_success || $response->headers->header('X-Result');
	

    my $result = $response->headers->header('X-Result') || 'error';
    my $message = convert_from_utf8($response->headers->header('X-Message')) || '';
    

    utf8::decode($message) if $IS_MT5;
    

    if($result eq 'penalty' || $message =~ /ライセンス違反/) {
        delete $config->{licensekey};
        delete $config->{mailaddress};
        $self->SUPER::save_config($config);
		$result = 'error';
    }
    
    return ($result, $message) if $result eq 'error';


    my $bin = $response->content;
    

    my @dbs = ();
    

    my $mt_dir = MT->instance->mt_dir;
    my $standard_db = File::Spec->catfile($mt_dir, $self->envelope, '/db/spec.db');
    push @dbs, $standard_db;
    

    if($config->{php_keitaikit_dir}) {
        my $php_db = File::Spec->catfile($config->{php_keitaikit_dir}, '/db/spec.db');
        push @dbs, $php_db;
    }
    
    foreach my $db (@dbs) {

        return ('error', $self->translate('Database file is not writable') . ":$db")
            unless -w $db;
        

        my $response_crc32 = $response->headers->header('X-CRC32');
        $response_crc32 = 4294967296 + $response_crc32 if $response_crc32 < 0;
        my $bin_crc32 = Digest::Crc32->strcrc32($bin);
        my $current_crc32 = Digest::Crc32->filecrc32($db);
        

        return ('error', $self->translate('Downloaded file is not correct.') . ":$message")
            if $response_crc32 != $bin_crc32;
        

        if($current_crc32 != $bin_crc32) {

            open(F, ">$db");
            binmode(F);
            print(F $bin);
            close(F);
        }
    }
    

    return ($result, $self->translate('Database file has updated') . ":$message")
        if($result eq 'warning');
    

    return ($result, $self->translate('Database file has updated') . ":$message");
}


sub clear_cache {

    my $config = $plugin->get_config_hash();
    my $temp_dir = $config->{temp_dir};
    

    opendir(TEMP, $temp_dir);
    my @caches = readdir(TEMP);
    closedir(TEMP);
    
    foreach (@caches) {
	my $path = File::Spec->catdir($temp_dir, $_);
        unlink($path) if -f $path;
    }
}


sub prolong_trial {
    my $self = shift;
    my ($result, $message);


	$result = 'error';
	$message = $self->translate('The trial for this version has expired.');

	my $config = $self->get_config_hash;
	if(!defined($config->{setupversion}) || $config->{setupversion} < $OLD_VERSION) {


		$config->{setupversion} = $VERSION;
		$config->{setuptime} = time - (3600 * 24 * 15);
		$self->SUPER::save_config($config);


		$result = 'complete';
		$message = '';
	}
    
    return ($result, $message);
}


my ($_add_container_tag, $_add_tag, $_add_global_filter, $_add_conditional_tag);
my $_plugin_registry = $MT::plugin_registry;
if( $IS_MT5 ) {
	$_plugin_registry->{tags} ||= {};
	$_add_container_tag = sub { $_plugin_registry->{tags}{block}{$_[0]} = $_[1]; };
	$_add_tag = sub { $_plugin_registry->{tags}{function}{$_[0]} = $_[1]; };
	$_add_global_filter = sub { $_plugin_registry->{tags}{modifier}{$_[0]} = $_[1]; };
	$_add_conditional_tag = sub { $_plugin_registry->{tags}{block}{$_[0] . '?'} = $_[1]; };
} else {
	$_add_container_tag = sub { MT::Template::Context->add_container_tag(@_); };
	$_add_tag = sub { MT::Template::Context->add_tag(@_); };
	$_add_global_filter = sub { MT::Template::Context->add_global_filter(@_); };
	$_add_conditional_tag = sub { MT::Template::Context->add_conditional_tag(@_); };
}


&$_add_container_tag(KeitaiKit => \&_hdr_KeitaiKit);
&$_add_tag(KeitaiEmoji => \&_hdr_KeitaiEmoji);
&$_add_container_tag(KeitaiElse => \&_hdr_KeitaiElse);
&$_add_global_filter(keitai_words => \&_hdr_KeitaiWords);
&$_add_container_tag(KeitaiLinkImages => \&_hdr_KeitaiLinkImages);
&$_add_container_tag(KeitaiIfLinkedImageParam => \&_hdr_KeitaiIfLinkedImageParam);
&$_add_tag(KeitaiLinkedImageParam => \&_hdr_KeitaiLinkedImageParam);
&$_add_tag(KeitaiLinkedImageTag => \&_hdr_KeitaiLinkedImageTag);
&$_add_container_tag(KeitaiLinkTel => \&_hdr_KeitaiLinkTel);
&$_add_global_filter(keitai_link_tel => \&_hdr_KeitaiLinkTel_filter);
&$_add_container_tag(KeitaiCond => \&_hdr_KeitaiCond);
&$_add_global_filter(keitai_cond => \&_hdr_KeitaiCond_filter);
&$_add_conditional_tag(IfCommentEmojiAllowed => \&_hdr_IfCommentEmojiAllowed);


&$_add_container_tag(PCEmoji => \&_hdr_PCEmoji);
&$_add_global_filter(pc_emoji => \&_hdr_PCEmoji_filter);
&$_add_global_filter(unescape_emoji => \&_hdr_UnescapeEmoji_filter);


&$_add_global_filter(unescape_unicode => \&_hdr_unescape_unicode);


&$_add_container_tag(KeitaiIfEnv => \&_hdr_KeitaiIfEnv);


&$_add_container_tag(KeitaiPaginate => \&_hdr_KeitaiPaginate);
&$_add_tag(KeitaiPaginateBreak => \&_hdr_KeitaiPaginateBreak);


&$_add_container_tag(KeitaiIfMultiplePages => \&_hdr_KeitaiIfMultiplePages);
&$_add_container_tag(KeitaiIfHasNextPage => \&_hdr_KeitaiIfHasNextPage);
&$_add_container_tag(KeitaiIfHasPreviousPage => \&_hdr_KeitaiIfHasPreviousPage);
&$_add_tag(KeitaiCurrentPageNum => \&_hdr_KeitaiCurrentPageNum);
&$_add_tag(KeitaiNextPageNum => \&_hdr_KeitaiNextPageNum);
&$_add_tag(KeitaiPreviousPageNum => \&_hdr_KeitaiPreviousPageNum);
&$_add_tag(KeitaiFirstPageNum => \&_hdr_KeitaiFirstPageNum);
&$_add_tag(KeitaiLastPageNum => \&_hdr_KeitaiLastPageNum);
&$_add_tag(KeitaiNextPageLink => \&_hdr_KeitaiNextPageLink);
&$_add_tag(KeitaiPreviousPageLink => \&_hdr_KeitaiPreviousPageLink);
&$_add_tag(KeitaiFirstPageLink => \&_hdr_KeitaiFirstPageLink);
&$_add_tag(KeitaiLastPageLink => \&_hdr_KeitaiLastPageLink);

&$_add_container_tag(KeitaiPages => \&_hdr_KeitaiPages);
&$_add_container_tag(KeitaiIfPagesCurrent => \&_hdr_KeitaiIfPagesCurrent);
&$_add_tag(KeitaiPagesNum => \&_hdr_KeitaiPagesNum);
&$_add_container_tag(KeitaiPagesSeparator => \&_hdr_KeitaiPagesSeparator);
&$_add_tag(KeitaiPagesLink => \&_hdr_KeitaiPagesLink);


&$_add_container_tag(KeitaiIfLayer => \&_hdr_KeitaiIfLayer);
&$_add_tag(KeitaiLayerLink => \&_hdr_KeitaiLayerLink);


&$_add_tag(KeitaiModel => \&_hdr_KeitaiModel);
&$_add_container_tag(KeitaiIfCarrier => \&_hdr_KeitaiIfCarrier);
&$_add_container_tag(KeitaiIfQVGA => \&_hdr_KeitaiIfQVGA);
&$_add_container_tag(KeitaiIfMonochrome => \&_hdr_KeitaiIfMonochrome);
&$_add_container_tag(KeitaiIfColor => \&_hdr_KeitaiIfColor);
&$_add_container_tag(KeitaiIfHighColor => \&_hdr_KeitaiIfHighColor);
&$_add_container_tag(KeitaiIfFlash => \&_hdr_KeitaiIfFlash);
&$_add_container_tag(KeitaiIfImage => \&_hdr_KeitaiIfImage);
&$_add_container_tag(KeitaiIfMovie => \&_hdr_KeitaiIfMovie);
&$_add_container_tag(KeitaiIfModel => \&_hdr_KeitaiIfModel);
&$_add_container_tag(KeitaiIfEnv => \&_hdr_KeitaiIfEnv);
&$_add_container_tag(KeitaiIfGeneration => \&_hdr_KeitaiIfGeneration);
&$_add_container_tag(KeitaiIfiXHTML => \&_hdr_KeitaiIfiXHTML);
&$_add_container_tag(KeitaiIfGeneralCSS => \&_hdr_KeitaiIfGeneralCSS);
&$_add_container_tag(KeitaiIfSupported => \&_hdr_KeitaiIfSupported);
&$_add_container_tag(KeitaiIfKeitaiKitVersion => \&_hdr_KeitaiIfKeitaiKitVersion);
&$_add_container_tag(KeitaiIfColoredTable => \&_hdr_KeitaiIfColoredTable);
&$_add_container_tag(KeitaiIfSmartphone => \&_hdr_KeitaiIfSmartphone);


&$_add_container_tag(KeitaiKitSysTmpl => \&_hdr_KeitaiKitSysTmpl);
&$_add_tag(KeitaiEmojiSysTmpl => \&_hdr_KeitaiEmojiSysTmpl);
if(MT->version_number >= 4.1) {

	&$_add_container_tag(IfKeitaiSysTmpl => \&MT::Template::Context::_hdlr_pass_tokens);
	&$_add_container_tag(IfKeitaiLoggedInSysTmpl => \&MT::Template::Context::_hdlr_pass_tokens);
} else {

	&$_add_conditional_tag(IfKeitaiSysTmpl => \&_hdr_IfKeitaiSysTmpl);
	&$_add_conditional_tag(IfKeitaiLoggedInSysTmpl => \&_hdr_IfKeitaiLoggedInSysTmpl);
}
&$_add_conditional_tag(IfKeitaiCarrierSysTmpl => \&_hdr_IfKeitaiCarrierSysTmpl);
&$_add_tag(KeitaiErrStrSysTmpl => \&_hdr_KeitaiErrStrSysTmpl);
&$_add_container_tag(KeitaiImageSysTmpl => \&_hdr_KeitaiImageSysTmpl);
&$_add_tag(KeitaiInputStyleSysTmpl => \&_hdr_KeitaiInputStyleSysTmpl);
&$_add_conditional_tag(IfKeitaiiXHTMLSysTmpl => \&_hdr_IfKeitaiiXHTMLSysTmpl);
&$_add_conditional_tag(IfKeitaiGeneralCSSSysTmpl => \&_hdr_IfKeitaiGeneralCSSSysTmpl);
&$_add_conditional_tag(IfKeitaiKitVersionSysTmpl => \&_hdr_IfKeitaiKitVersionSysTmpl);
&$_add_tag(SearchString => \&_hdr_SearchString) if MT->version_number >= 4.2;
&$_add_conditional_tag(IfKeitaiSmartphone => \&_hdr_IfKeitaiSmartphone);


&$_add_tag(KeitaiSearchScript => \&_hdr_KeitaiSearchScript);
&$_add_tag(KeitaiCommentScript => \&_hdr_KeitaiCommentScript);
&$_add_tag(KeitaiCommentStaticSysTmpl => \&_hdr_KeitaiCommentStaticSysTmpl);


&$_add_container_tag(KeitaiLineGroup => \&_hdr_KeitaiLineGroup);
&$_add_tag(KeitaiLineNode => \&_hdr_KeitaiLineNode);
&$_add_container_tag(KeitaiCycle => \&_hdr_KeitaiCycle);
&$_add_tag(KeitaiCycleValue => \&_hdr_KeitaiCycleValue);
&$_add_tag(KeitaiInclude => \&_hdr_KeitaiInclude);
&$_add_tag(KeitaiIncludeArg => \&_hdr_KeitaiIncludeArg);
&$_add_container_tag(KeitaiFunctionDef => \&_hdr_KeitaiFunctionDef);
&$_add_tag(KeitaiFunction => \&_hdr_KeitaiFunction);
&$_add_container_tag(KeitaiBlockHeader => sub {&_hdr_KeitaiBlockDef(1, @_);});
&$_add_container_tag(KeitaiBlockFooter => sub {&_hdr_KeitaiBlockDef(0, @_);});
&$_add_container_tag(KeitaiBlock => \&_hdr_KeitaiBlock);
&$_add_tag(KeitaiInputStyle => \&_hdr_KeitaiInputStyle);


&$_add_container_tag(KeitaiIfAddToFavoritesEnabled => \&_hdr_KeitaiIfAddToFavoritesEnabled);
&$_add_tag(KeitaiAddToFavoritesLink => \&_hdr_KeitaiAddToFavoritesLink);
&$_add_container_tag(KeitaiIfSendToFriendEnabled => \&_hdr_KeitaiIfSendToFriendEnabled);
&$_add_tag(KeitaiSendToFriendLink => \&_hdr_KeitaiSendToFriendLink);


&$_add_tag(KeitaiSupportedModels => \&_hdr_KeitaiSupportedModels);


&$_add_tag(KeitaiSessionID => \&_hdr_KeitaiSessionID);
&$_add_tag(KeitaiSessionIDSysTmpl => \&_hdr_KeitaiSessionIDSysTmpl);
&$_add_tag(KeitaiSessionName => \&_hdr_KeitaiSessionName);
&$_add_tag(KeitaiSessionNameSysTmpl => \&_hdr_KeitaiSessionNameSysTmpl);
&$_add_tag(KeitaiSessionInclude => \&_hdr_KeitaiSessionInclude);


&$_add_tag(KeitaiTagColor => \&_hdr_KeitaiTagColor);
&$_add_tag(KeitaiTagFontSize => \&_hdr_KeitaiTagFontSize);
&$_add_tag(KeitaiTagSearchLink => \&_hdr_KeitaiTagSearchLink);




sub _hdr_KeitaiKit {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	my $run_callbacks = MT->instance->config('KeitaiRunCallbacks') || 0;
	$ctx->stash('mtkk_run_callbacks', $run_callbacks);
	

	if( $run_callbacks && MT->version_number >= 4.0) {
		$ctx->error('');
		MT->run_callbacks('keitaikit_init', 1, $ctx, 'MTKeitaiKit');
		return if $ctx->errstr;
	}
	

	my $included = $args->{included} || 0;
	my $ixhtml = $args->{ixhtml} || 0;
	my $ivga = $args->{ivga} || 0;
	my $no_cache = $args->{no_cache} || '';
	

	local $ENV{MTKK_DYNAMIC} = 0;
	$cond->{IfKeitaiSysTmpl} = 0 if MT->version_number >= 4.1;
	

	my $old_dynamic;
	if($ENV{MOD_PERL}) {
		$old_dynamic = MT::App->instance->{apache}->subprocess_env('MTKK_DYNAMIC');
		MT::App->instance->{apache}->subprocess_env('MTKK_DYNAMIC', 0);
	}
	


	my $mt = MT->instance;
	my $mt_path = $mt->mt_dir;
	

	my $blog = $ctx->stash('blog');
	unless($blog) {
		if($blog = default_blog) {
			$ctx->stash('blog', $blog);
			$ctx->stash('blog_id', $blog->id);
		}
	};
	my $blog_path = $blog->site_path;
	my $blog_url = $blog->site_url;
	my $blog_id = $blog->id;
	$blog_url .= '/' if $blog_url !~ /\/$/;
	

	my $system_config = $plugin->get_config_hash;
	my $blog_config = $plugin->get_config_hash("blog:$blog_id");


	$blog_config->{php_encoding} = MT->instance->config('PublishCharset') if $IS_MT5;
	


	return $ctx->error($plugin->translate('Setup Keitaikit at plugins list before use [_1]', 'MTKeitaiKit'))
		unless $system_config->{setuptime};
		

	return $ctx->error($plugin->translate('Trial has expired. Buy a license.'))
		unless time - $system_config->{setuptime} < 3600 * 24 * 60 || $system_config->{licensekey};
	

	return $ctx->error($plugin->translate('Setting of ImageMagick is incorrect. See plugins list.'))
		if ($system_config->{php_graphic} eq 'im' || $system_config->{php_graphic} eq 'im5') && (!-x $system_config->{convert} || -d $system_config->{convert}
							     || !-x $system_config->{identify} || -d $system_config->{identify});


	return $ctx->error($plugin->translate('Image cache directory is not writable.'))
		unless -w $system_config->{temp_dir};
	

	my $document_root = '';
	if($ctx->stash('mtkk_assume_document_root')) {
	    $document_root = $blog_path;
	} elsif($blog_config->{document_root}) {
		return $ctx->error($plugin->translate('DocumentRoot does not exist.'))
			unless -e $blog_config->{document_root};
	    $document_root = $blog_config->{document_root};
	}
	

	my $plugin_dir = File::Spec->catdir($mt_path, $plugin->envelope);
	my $php_keitaikit_dir = $system_config->{php_keitaikit_dir} || $plugin_dir;
	

	my $selector = $args->{selector} || $blog_config->{selector} || 'mtkk_page';
	

	my $layerer = $args->{layerer} || $blog_config->{layerer} || 'mtkk_layer';
	

	my $xml_declaration = $args->{xml_declaration} || 0;
	my $doctype = $args->{doctype} || 0;
	my $default_doctype = MT->instance->config('KeitaiDefaultDoctype') || '';
	

	$kdb = KeitaiDB->new("$plugin_dir/db") unless $kdb;
	

	unless(defined($emoji_aa)) {
		$emoji_aa = {};
		if($blog_config->{emoji_aa}) {
			foreach (split(/[\r\n]+/, $blog_config->{emoji_aa})) {
				$emoji_aa->{$1} = $2 if(/^([a-zA-Z0-9]+)=(.+)/);
			}
		}
	}
	

	$ctx->stash('mtkk_paginated', undef);
	$ctx->stash('mtkk_selector', $selector);
	$ctx->stash('mtkk_layerer', $layerer);
	$ctx->stash('mtkk_in_keitaikit', 1);
	$ctx->stash('mtkk_default_display', 
		$blog_config->{default_display} || $system_config->{default_display} || 'browser' );
	

	my $prebuilding_module = $ctx->stash('mtkk_prebuilding_module') || $blog_config->{prebuilding_module} || 0;
	if($prebuilding_module) {
		if(my $tmpl = MT::Template->load($prebuilding_module)) {
			my $local_token = $builder->compile($ctx, $tmpl->text);
			defined(my $prebuild = $builder->build($ctx, $local_token)) ||
				return $ctx->error($plugin->translate('An error occurred in prebuilding module') . ': ' . $ctx->errstr);
		}
	}


	defined(my $result = $builder->build($ctx, $tokens, $cond)) ||
		return $ctx->error($ctx->errstr);
		

	if( $run_callbacks && MT->version_number >= 4.0) {
		$ctx->error('');
		MT->run_callbacks('keitaikit_post_build_inner', 1, $ctx, 'MTKeitaiKit', \$result);
		return if $ctx->errstr;
	}
	
	$ctx->stash('mtkk_in_keitakit', undef);
	

	$result =~ s/^\s+//;


	my $header = '';
	my $footer = '';


	if(!$included) {

		

		my %vars;
		$vars{plugin_dir} = $php_keitaikit_dir;
		$vars{temp_dir} = $system_config->{temp_dir} || File::Spec->catdir($php_keitaikit_dir, 'temp');
		$vars{iemoji_dir} = File::Spec->catdir($php_keitaikit_dir, 'iemoji');
		$vars{image_script} = $blog_config->{image_script_url} || ($blog_url . 'mtkkimage.php');
		$vars{php_graphic} = $system_config->{php_graphic} || 'gd';
		$vars{download_adapter} = $system_config->{download_adapter} || 'php';
		$vars{convert} = $system_config->{convert};
		$vars{identify} = $system_config->{identify};
		$vars{paginated} = $ctx->stash('mtkk_paginated')? 'true': 'false';
		$vars{selector} = $selector;
		$vars{layerer} = $layerer;
		$vars{xml_declaration} = $xml_declaration? 'true': 'false';
		$vars{doctype} = $doctype? 'true': 'false';
		$vars{default_doctype} = $default_doctype;
		$vars{pc_redirect} = $args->{pc_redirect} || $blog_config->{pc_redirect};
		$vars{disable_ua_camouflage} = $blog_config->{disable_ua_camouflage}? 'true': 'false';
		$vars{footer_bytes} = $ctx->stash('mtkk_footer_bytes');
		$vars{cache_expires} = $system_config->{cache_expires} || 1209600;
		$vars{basic_auths} = $blog_config->{basic_auths} || '';
		$vars{basic_auths} =~ s/\n/\//g;
		$vars{basic_auths} =~ s/'/\\'/g;
		$vars{jpeg_quality} = $blog_config->{jpeg_quality} || $system_config->{jpeg_quality} || 75;
		$vars{crawler_keywords} = $system_config->{crawler_keywords} || '';
		$vars{php_encoding} = $blog_config->{php_encoding} || 'Shift_JIS';
		$vars{download_proxy} = $system_config->{download_proxy} || '';
		$vars{php_graphic_url} = $system_config->{php_graphic_url} || '';
		$vars{document_root} = $document_root;
		$vars{document_root} =~ s/\\/\\\\/g;
		$vars{content_type} = $ixhtml? 'application/xhtml+xml': 'text/html';
		$vars{ixhtml} = $ixhtml? 'true': 'false';
		$vars{ivga} = $ivga? 'true': 'false';
		$vars{no_cache} = $no_cache;
		$vars{version} = $VERSION;
		$vars{graphic_debug_mode} = $blog_config->{graphic_debug_mode}? 'true': 'false';
		$vars{image_convert_error} = $blog_config->{image_convert_error} || 'show';
		$vars{use_session} = $blog_config->{use_session}? 'true': 'false';
		if($blog_config->{use_session}) {
			$vars{session_param} = $blog_config->{session_param};
			$vars{start_session} = $blog_config->{start_session}? 'true': 'false';
		}
		$vars{multi_servers} = $blog_config->{multi_servers}? 'true': 'false';
		if($blog_config->{cache_cleaning_prob} && $blog_config->{cache_cleaning_prob} =~ /[0-9]+/) {
			$vars{cache_cleaning_prob} = $&;
		} elsif($system_config->{cache_cleaning_prob} =~ /[0-9]+/) {
			$vars{cache_cleaning_prob} = $&;
		} else {
			$vars{cache_cleaning_prob} = 0;
		}
		$vars{http_host_var} = MT->instance->config('HttpHostVar') || 'HTTP_HOST';
		$vars{image_iconize_width} = length($blog_config->{image_iconize_width})? $blog_config->{image_iconize_width}: (MT->instance->config('KeitaiImageIconizeWidth') || 0);
		$vars{image_iconize_height} = length($blog_config->{image_iconize_height})? $blog_config->{image_iconize_height}: (MT->instance->config('KeitaiImageIconizeHeight') || 0);
		if(my $no_input_style = MT->instance->config('KeitaiEZNoInputStyle')) {
			$vars{ez_no_input_style} = $no_input_style;
		}
		

		if($system_config->{smartphone_enabled}) {
			$vars{smartphone_enabled} = 'true';
			$vars{smartphone_cache_size} = $system_config->{smartphone_cache_size} || 1024;
			$vars{smartphone_screen_width} = $system_config->{smartphone_screen_width} || 320;
			$vars{smartphone_screen_height} = $system_config->{smartphone_screen_height} || 480;
			$vars{smartphone_remove_style} = $args->{smartphone_remove_style} || $system_config->{smartphone_remove_style} || 'none';
			$vars{smartphone_remove_css_properties} = $args->{smartphone_remove_css_properties} || $system_config->{smartphone_remove_css_properties} || '';
			$vars{smartphone_emoji_dir} = $system_config->{smartphone_emoji_dir} || 'typecast';
			$vars{smartphone_convert_kana} = $system_config->{smartphone_convert_kana}? 'true': 'false';
			$vars{smartphone_encoding} = $system_config->{smartphone_encoding} || 'UTF-8';
		}



		$vars{emoji_alt} = $args->{emoji_alt} || $blog_config->{emoji_alt} || 'img';


		$vars{emoji_size} = $args->{emoji_size} || $blog_config->{emoji_img_size} || 12;
		


		foreach my $var (keys %vars) {
			my $value = $vars{$var};
			if($value && ($value eq 'true' || $value eq 'false')) {

				$header .= "\$mtkk_$var = $value;\n";
			} elsif(defined($value)) {

				$value =~ s/'/\\'/g;
				$header .= "\$mtkk_$var = '$value';\n";
			} else {
				$header .= "\$mtkk_$var = '';\n";
			}
		}
		

		if($blog_config->{use_session}) {
			$header .= "\$mtkk_session_external_urls = array(";
			my @urls = ($blog_url, split(/[\r\n]+/, $blog_config->{session_external_urls}));
			$header .= join(', ', map("'$_'", grep(/.+/, @urls)));
			$header .= ");\n";
			

			if($OPTIONS{jsp_support}) {
				$header .= "\$mtkk_session_jsp_style_urls = array(";
				my @urls = split(/[\r\n]+/, $blog_config->{session_jsp_style_urls});
				$header .= join(', ', map("'$_'", grep(/.+/, @urls)));
				$header .= ");\n";
			}
		}

		$header = "<?php\n$header\n";


		my $php_dir = File::Spec->catdir($php_keitaikit_dir, 'php');
		my $require = File::Spec->catfile($php_dir, 'KeitaiKit.php');
	 
		$header .= "require_once('$require');\n";


		if($vars{php_encoding} ne 'Shift_JIS' && $vars{php_encoding} ne 'SJIS') {
			$footer = "<?php ob_end_flush(); ?>" . $footer;
		}
		

        $footer = q{<?php if(isset($mtkk_smartphone)) { ob_end_flush(); } ?>} . $footer;


		if($blog_config->{use_session}) {
			$footer = '<?php ob_end_flush(); ?>' . $footer;
		}
	

		$header .= '?>';
		

		if(!defined($ctx->stash('mtkk_image_php_output'))) {

			my $mtkkimage = $blog_config->{image_script_path} || File::Spec->catfile($blog_path, 'mtkkimage.php');
			my $mtkkimage_org = File::Spec->catfile($plugin_dir, 'php/mtkkimage.php');
			

			my $mtkkimage_php = '';
			open(FPI, "<$mtkkimage_org");
			while(<FPI>) {
				s/\$mtkk_temp_dir = '';/"\$mtkk_temp_dir = '$vars{temp_dir}';"/e;
				s/\$mtkk_iemoji_dir = '';/"\$mtkk_iemoji_dir = '$vars{iemoji_dir}';"/e;
				s/\$mtkk_plugin_dir = '';/"\$mtkk_plugin_dir = '$vars{plugin_dir}';"/e;
				s/\$mtkk_convert = '';/"\$mtkk_convert = '$vars{convert}';"/e;
				s/\$mtkk_identify = '';/"\$mtkk_identify = '$vars{identify}';"/e;
				s/\$mtkk_php_graphic = '';/"\$mtkk_php_graphic = '$vars{php_graphic}';"/e;
				s/\$mtkk_download_proxy = '';/"\$mtkk_download_proxy = '$vars{download_proxy}';"/e;
				s/\$mtkk_download_adapter = '';/"\$mtkk_download_adapter = '$vars{download_adapter}';"/e;
				s/\$mtkk_cache_expires = '';/"\$mtkk_cache_expires = '$vars{cache_expires}';"/e;
				s/\$mtkk_basic_auths = '';/"\$mtkk_basic_auths = '$vars{basic_auths}';"/e;
				s/\$mtkk_jpeg_quality = '';/"\$mtkk_jpeg_quality = '$vars{jpeg_quality}';"/e;
				s/\$mtkk_php_graphic_url = '';/"\$mtkk_php_graphic_url = '$vars{php_graphic_url}';"/e;
				s/\$mtkk_document_root = '';/"\$mtkk_document_root = '$vars{document_root}';"/e;
				s/\$mtkk_graphic_debug_mode = false;/"\$mtkk_graphic_debug_mode = true;"/e if $blog_config->{graphic_debug_mode};
				s/\$mtkk_cache_cleaning_prob = '';/"\$mtkk_cache_cleaning_prob = '$vars{cache_cleaning_prob}';"/e;
				s/\$mtkk_http_host_var = 'HTTP_HOST';/"\$mtkk_http_host_var = '$vars{http_host_var}';"/e;
				s/\$mtkk_image_iconize_width = null;/"\$mtkk_image_iconize_width = $vars{image_iconize_width};"/e;
				s/\$mtkk_image_iconize_height = null;/"\$mtkk_image_iconize_height = $vars{image_iconize_height};"/e;
				

				$mtkkimage_php .= $_;
			}
			close(FPI);
			

			my $fmgr = $blog->file_mgr;
			my @pathes = File::Spec->splitpath($mtkkimage);
			pop @pathes;
			my $mtkkimage_dir = File::Spec->catdir(@pathes);
			$fmgr->mkpath($mtkkimage_dir);
			

			unlink($mtkkimage) if $fmgr->exists($mtkkimage);
			defined($fmgr->put_data($mtkkimage_php, $mtkkimage))
				or return $ctx->error($plugin->translate("Writing to '[_1]' failed: [_2]", $mtkkimage, $fmgr->errstr));
			

			$ctx->stash('mtkk_image_php_output', 1);
		}
	}
	


	my $hankaku = $args->{hankaku} || $blog_config->{hankaku} || 'all';


	my $opt = $hankaku eq 'all'? 'h': '';


	my $replace = replace_php($ctx, \$result, $blog_config, $opt);
	return unless($replace);



	my $encode_to = encode_mapping($blog_config->{php_encoding}) || 'sjis';
	

	if($IS_MT5) {

		$result = Lingua::JA::Regular::Unicode::katakana_z2h($result) if $opt eq 'h';
	} else {

		convert_encoding(\$result, $encode_to, 0, $opt);
	}
	

	escape_sjis_php_literal(\$result) if $encode_to eq 'sjis';
	

	replace_katakana_php(\$result, $encode_to)
		if $hankaku eq 'mobile';


	$result = $header . $result . $footer;
	

	$result =~ s/^\s+//g if $blog_config->{drop_html_indent};
	$result =~ s/(\r?\n)\s+/$1/g if $blog_config->{drop_html_indent};
	

	if($ENV{MOD_PERL}) {
		MT::App->instance->{apache}->subprocess_env('MTKK_DYNAMIC', $old_dynamic);
	}
	
	$result;
}


sub replace_pc_emoji {
	my ($entity, $script) = @_;
	my $emoji = '';


	if($entity =~ /^(i|ez|s|w)([0-9a-f]+)$/i) {
		my ($carrier, $code) = ($1, lc($2));
		

		if($carrier eq 'w') {
			$code = sprintf('%x', KeitaiCode::s_webcode_to_sjis(hex($code)));
			$carrier = 's';
		}
		

		$emoji = "$carrier/gif/$code.gif";
	} elsif(KeitaiDB::isEmoji($entity)) {

		$emoji = "$entity.gif";
	} else {

		return "&$entity;"
	}
	

	qq{<img src="$script?mtkk_emoji=$emoji" class="mtkk_emoji" />};
}


sub _hdr_PCEmoji_filter {
	my ($text, $arg, $ctx) = @_;
	my $script_url;
	

	if($arg) {

		$script_url = $arg;
	} else {

		unless($script_url = $ctx->stash('mtkk_image_script_url')) {

			my $blog = $ctx->stash('blog') || default_blog;
			my $blog_id = $blog->id;
			my $blog_config = $plugin->get_config_hash("blog:$blog_id");
			

			unless($script_url = $blog_config->{image_script_url}) {

				my $blog_url = $blog->site_url;
				$blog_url .= '/' if $blog_url !~ m!/$!;
				$script_url = $blog_url . 'mtkkimage.php';
			}
			

			my $script_path = $blog_config->{image_script_path} || File::Spec->catfile($blog->site_path, 'mtkkimage.php');
			

			my $fmgr = $blog->file_mgr;
			unless($fmgr->exists($script_path)) {

				use MT::Builder;
				use MT::Template::Context;
				
				my $build = MT::Builder->new;
				my $ctx = MT::Template::Context->new;
				$ctx->stash('blog', $blog);


				my $tokens = $build->compile($ctx, '<MTKeitaiKit></MTKeitaiKit>')
					or return $ctx->error($plugin->translate('An error occurred in an image conversion script creation') . ': ' . $build->errstr);
				defined(my $out = $build->build($ctx, $tokens))
					or return $ctx->error($plugin->translate('An error occurred in an image conversion script creation') . ': ' . $ctx->errstr);
			}
			

			$ctx->stash('mtkk_image_script_url', $script_url);
		}

	}


	$text =~ s/&([^;]+);/&replace_pc_emoji($1, $script_url);/ieg;
	
	
	
	$text;
}


sub _hdr_UnescapeEmoji_filter {
	my ($text, $arg, $ctx) = @_;
	
	$text =~ s/&amp;(i|ez|s|w)([0-9a-f]+);/&$1$2;/ig;
	
	$text;
}


sub _hdr_PCEmoji {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	my $image_script = $args->{image_script} || '';
	

	defined(my $result = $builder->build($ctx, $tokens, $cond)) ||
		return $ctx->error($ctx->errstr);


	_hdr_PCEmoji_filter($result, $image_script, $ctx);
}


sub _hdr_unescape_unicode {
	my ($text, $arg, $ctx) = @_;
	$text =~ s/\&\#(\d+);/
		MT::I18N::encode_text(pack("H*", sprintf("%X",$1)), 'ucs2', undef);
	/egx;
	$text;
}


sub convert_encoding {
	my ($rresult, $encode_to, $encode_from, $opt) = @_;
	$opt ||= '';
	
	return if $encode_to eq $encode_from && !$opt;
	

	unless($encode_from) {
	    $encode_from = internal_charset;
	}
	



	if(defined($OPTIONS{I18N}) && $OPTIONS{I18N} eq 'MTK') {
	    $$rresult = MT::I18N::encode_text($$rresult, MT->instance->config('PublishCharset'), 'Shift_JIS');
	    my $s = Unicode::Japanese->new($$rresult, 'sjis');
	    $s->z2hKana if $opt eq 'h';
	    $s->h2zKana if $opt eq 'z';
	    $$rresult = $s->sjis;
	    return 0;
    }

	my $s = Unicode::Japanese->new($$rresult, $encode_from);
	$s->z2hKana if $opt eq 'h';
	$s->h2zKana if $opt eq 'z';
	$$rresult = $s->$encode_to;
	
	0;
}


sub replace_php {
	my ($ctx, $rresult, $blog_config, $opt) = @_;
	my $run_callbacks = $ctx->stash('mtkk_run_callbacks');
	


	my $html = HTML::TagParser->new($$rresult);
	my @list = $html->getElementsByTagName( 'img' );
	my @changed_img = ();
	my @changed_a = ();


	my $no_convert_img_attributes = MT->instance->config('NoConvertImgAttributes');


	foreach my $elem ( @list ) {
		my $attr = $elem->attributes || {};
		

		my $src = $attr->{'keitai:src'} || $attr->{src};
		my $html = '';


		if($run_callbacks && MT->version_number >= 4.0) {
			$ctx->error('');
			$html = MT->run_callbacks('keitaikit_replace_img', 0, $ctx, 'MTKeitaiKit', $src, $attr);
			return if !defined($html) || $ctx->errstr;


			$html = undef if $html == 1;
		}
		

		unless($html) {


		my $src = $attr->{'keitai:src'} || $attr->{src};
		my $width = $attr->{width};
		my $height = $attr->{height};
		my $style = $attr->{style};
		my $keitai_style = $attr->{'keitai:style'};
		my $fit;
		my $conv;
		my $copyright = $blog_config->{image_copyright} || 'off';
		my ($link_over, $link_format, $link_before, $link_after, $link_align, $link_thumbnail, $link_page, $link_caption);
		my ($wallpaper_style, $wallpaper_fill);
		my $maximize = 'off';
		my $display = $ctx->stash('mtkk_default_display');
		my $cache_expires;
		my $magnify;
		

		if($keitai_style) {
			$keitai_style = $1 if $keitai_style =~ /^\s*(.+)\s*$/;
			foreach (split(/\s*;\s*/, $keitai_style)) {
				my @style = split(/\s*:\s*/, $_);
				my $prop = lc($style[0]);
				next unless $prop && defined($style[1]);
				$fit = lc($style[1]) if ($prop eq 'crop' || $prop eq 'fit');
				$conv = lc($style[1]) if $prop eq 'convert';
				$copyright = lc($style[1]) if $prop eq 'copyright';
				$link_over = $style[1] if $prop eq 'link-over' && $style[1] =~ /^[0-9]+%?$/;
				$link_format = $style[1] if $prop eq 'link-format';
				$link_before = $style[1] if $prop eq 'link-before';
				$link_after = $style[1] if $prop eq 'link-after';
				$link_align = lc($style[1]) if $prop eq 'link-align';
				$link_thumbnail = $style[1] if $prop eq 'link-thumbnail' && $style[1] =~ /^[0-9]+%?$/;
				$link_page = $style[1] if $prop eq 'link-page';
				$link_caption = $style[1] if $prop eq 'link-caption';
				$wallpaper_style = lc($style[1]) if $prop eq 'wallpaper-style';
				if($prop eq 'wallpaper-fill' && $style[1] =~ /^#?([0-9a-f]{6})$/i) {
					$wallpaper_fill = lc($1);
				}
				$maximize = lc($style[1]) if $prop eq 'maximize';
				$display = lc($style[1]) if $prop eq 'display';
				$cache_expires = $style[1] if $prop eq 'cache-expires' && $style[1] =~ /^[0-9]+$/;
				$magnify = $style[1] if $style[0] eq 'magnify';
			}
		}
		
		if($style) {
			$style = $1 if $style =~ /^\s*(.+)\s*$/;
			foreach (split(/\s*;\s*/, $style)) {
				my @style = split(/\s*:\s*/, $_);
				my $prop = lc($style[0]);
				next unless $prop && defined($style[1]);
				$fit = lc($style[1]) if ($prop eq 'keitai-crop' || $prop eq 'keitai-fit');
				$conv = lc($style[1]) if $prop eq 'keitai-convert';
				$copyright = lc($style[1]) if $prop eq 'keitai-copyright';
				$link_over = $style[1] if $prop eq 'keitai-link-over' && $style[1] =~ /^[0-9]+%?$/;
				$link_format = $style[1] if $prop eq 'keitai-link-format';
				$link_before = $style[1] if $prop eq 'keitai-link-before';
				$link_after = $style[1] if $prop eq 'keitai-link-after';
				$link_align = lc($style[1]) if $prop eq 'keitai-link-align';
				$link_thumbnail = $style[1] if $prop eq 'keitai-link-thumbnail' && $style[1] =~ /^[0-9]+%?$/;
				$link_page = lc($style[1]) if $prop eq 'keitai-link-page';
				$link_caption = $style[1] if $prop eq 'keitai-link-caption';
				$wallpaper_style = lc($style[1]) if $prop eq 'keitai-wallpaper-style';
				if($prop eq 'keitai-wallpaper-fill' && $style[1] =~ /^#?([0-9a-f]{6})$/i) {
					$wallpaper_fill = lc($1);
				}
				$maximize = lc($style[1]) if $prop eq 'keitai-maximize';
				$display = lc($style[1]) if $prop eq 'keitai-display';
				$cache_expires = $style[1] if $prop eq 'keitai-cache-expires' && $style[1] =~ /^[0-9]+$/;
				$magnify = $style[1] if $style[0] eq 'keitai-magnify';
			}
		}
		

		$copyright = ($copyright eq '0' || $copyright eq 'no' || $copyright eq 'off')? 0: 1;
		

		$maximize = ($maximize eq '0' || $maximize eq 'no' || $maximize eq 'off')? 0: 1;
		

		my $use_link = 0;
		my $link_images = 'false';
		if(defined($link_over) || $link_format || $link_thumbnail) {
			$use_link = 1;
			$link_images = 'true';
			$link_over ||= 0;
			$link_format ||= '%c(%k)';
			$link_before ||= '';
			$link_after ||= '';
			$link_align ||= '';
			$link_thumbnail ||= '32';

			if($link_page =~ /url\((.*?)\)/) {
				$link_page = $1;
			}
			$link_page ||= '';
			$link_caption ||= '';
		}
		

		my $use_wallpaper = 0;
		if($wallpaper_style || $wallpaper_fill) {
			$use_wallpaper = 1;
			$wallpaper_style ||= $wallpaper_fill? 'fill': 'chop';
			$wallpaper_fill ||= 'ffffff';
		}
		

		if($conv && $conv eq 'no') {

			$html .= "<img";
			foreach my $key ( sort keys %$attr ) {
				my $value = $no_convert_img_attributes? $attr->{$key}: convert_to_utf8($attr->{$key});
				$value =~ s/'/\\'/g if $key ne 'src'; # '
				$html .= " $key=\"$value\"" if $key ne '/';
			}
			$html .= " />";
		} else {

			if($use_link) {
				$html .= "<?php\n";


				$html .= "\$mtkk_link_images_before = \$mtkk_link_images;\n";
				$html .= "\$mtkk_link_images_over_before = \$mtkk_link_images_over;\n";
				$html .= "\$mtkk_link_images_format_before = \$mtkk_link_images_format;\n";
				$html .= "\$mtkk_link_images_before_before = \$mtkk_link_images_before;\n";
				$html .= "\$mtkk_link_images_after_before = \$mtkk_link_images_after;\n";
				$html .= "\$mtkk_link_images_align_before = \$mtkk_link_images_align;\n";
				$html .= "\$mtkk_link_images_thumbnail_before = \$mtkk_link_images_thumbnail;\n";
				$html .= "\$mtkk_link_images_page_before = \$mtkk_link_images_page;\n";
				$html .= "\$mtkk_link_images_caption_before = \$mtkk_link_images_caption;\n";


				$html .= "\$mtkk_link_images = $link_images;\n";
				$html .= "\$mtkk_link_images_over = '$link_over';\n";
				$html .= "\$mtkk_link_images_format = '$link_format';\n";
				$html .= "\$mtkk_link_images_after = '$link_after';\n";
				$html .= "\$mtkk_link_images_before = '$link_before';\n";
				$html .= "\$mtkk_link_images_align = '$link_align';\n";
				$html .= "\$mtkk_link_images_thumbnail = '$link_thumbnail';\n";
				$html .= "\$mtkk_link_images_page = '$link_page';\n";
				$html .= "\$mtkk_link_images_caption = '$link_caption';\n";

				$html .= "?>";
			}


			$html .= "<?php mtkk_image_tag(array('url' => '$src'";
			$html .= ", 'w' => '$width'" if $width;
			$html .= ", 'h' => '$height'" if $height;
			$html .= ", 'fit' => '$fit'" if $fit;
			$html .= ", 'copyright' => 1" if $copyright;
			$html .= ", 'maximize' => true" if $maximize;
			$html .= ", 'display' => '$display'" if $display;
			$html .= ", 'cache_expires' => (int)'$cache_expires'" if defined($cache_expires);
			$html .= ", 'magnify' => '$magnify'" if defined($magnify);
			$html .= ", 'attr' => array(";
			my @attrs;
			foreach my $key ( sort keys %$attr ) {
				if($key ne '/') {
					my $value = $no_convert_img_attributes? $attr->{$key}: convert_to_utf8($attr->{$key});
					$value =~ s/'/\\'/g; # '
					push @attrs, qq('$key' => '$value');
				}
			}
			$html .= join(', ', @attrs);
			$html .= ')';


			if($use_wallpaper) {
				$html .= ", 'wallpaper' => array(";
				$html .= " 'style' => '$wallpaper_style', 'fill' => '$wallpaper_fill')";
			}

			$html .= ")); ?>";
			

			if($use_link) {
				$html .= "<?php\n";
				$html .= "\$mtkk_link_images = \$mtkk_link_images_before;\n";
				$html .= "\$mtkk_link_images_over = \$mtkk_link_images_over_before;\n";
				$html .= "\$mtkk_link_images_format = \$mtkk_link_images_format_before;\n";
				$html .= "\$mtkk_link_images_before = \$mtkk_link_images_before_before;\n";
				$html .= "\$mtkk_link_images_after = \$mtkk_link_images_after_before;\n";
				$html .= "\$mtkk_link_images_align = \$mtkk_link_images_align_before;\n";
				$html .= "\$mtkk_link_images_thumbnail = \$mtkk_link_images_thumbnail_before;\n";
				$html .= "\$mtkk_link_images_page = \$mtkk_link_images_page_before;\n";
				$html .= "\$mtkk_link_images_caption = \$mtkk_link_images_caption_before;\n";
				$html .= "?>";
			}
		}
		

		}
		
		push(@changed_img, convert_from_utf8($html));
	}


	my $cont = 0;
	$$rresult =~s/<\s*img\s(.*?)[^\?]>/{defined($changed_img[$cont])? $changed_img[$cont++]: $&};/iseg;
	

	$$rresult =~ s/<\s*a\s+([^>]*?)href="([^"]+\.)(jpg|jpeg|gif|png)"/{
	    qq{<a ${1}href="<?php mtkk_image(array('url' => '$2$3')); ?>"};
	}/iemg;
	

	$$rresult =~ s/background="([^"]+)"/'background="' . &replace_if_image_noresize($1) . '"'/ieg; #"
	

	$$rresult =~ s/url\s*\(([^\)]+)\)/'url(' . &replace_if_image_noresize($1) . ')'/ieg unless $OPTIONS{NO_CONVERT_CSS_URL};
	

	$$rresult =~ s/\xee(\x98[\xbe-\xbf]|\x99[\x80-\xbf]|\x9a[\x80-\xba]|\x9b[\x8e-\xbf]|\x9c[\x80-\xbf]|\x9d[\x80-\x97])/&lookup_emoji($1);/eg
		if internal_charset eq 'utf8';
	

	$$rresult =~ s/&([a-z0-9]+);/&lookup_emoji_entity($1);/ieg;

	1;
}


sub replace_katakana_php {
	my ($rresult, $charset) = @_;


	my @source = split(/<\?|\?>/, $$rresult);
	$$rresult = '';
	my $i = 0;
	foreach (@source) {
		if($i++ % 2) {
			$$rresult .= '<?' . $_ . '?>';
		} else {
			if($charset eq 'sjis') {
				$$rresult .= replace_sjis_katakana($_, "<?php mtkk_hankaku('", "', true); ?>");
			} elsif($charset eq 'euc') {
				$$rresult .= replace_euc_katakana($_, "<?php mtkk_hankaku('", "', true); ?>");
			} else {
				s/(?:\xe3(\x82[\xa1-\xbf]|\x83[\x80-\xb4\xbc]))+/<?php mtkk_hankaku(\'$&', true)\; ?>/g;
				$$rresult .= $_;
			}
		}
	}
	
	0;
}


sub replace_euc_katakana {
	my ($euc, $pre, $post) = @_;
	my ($res, $buf, $inkana, $iskana);
	
	foreach (split //, $euc) {
		if($buf) {
			$buf .= $_;
			$iskana = ($buf =~ /\xa5[\xa1-\xf6]|\xa1[\xbc\xb3\xb4]/)? 1: 0;
			$res .= $pre if !$inkana && $iskana;
			$res .= $post if $inkana && !$iskana;
			$res .= $buf;
			undef $buf;
			$inkana = $iskana;
		} elsif(/[\xa1-\xfe]/) {
			$buf = $_;
		} else {
			$res .= $post if $inkana;
			$inkana = 0;
			$res .= $_;
		}
	}
	
	$res;
}


sub replace_sjis_katakana {
	my ($sjis, $pre, $post) = @_;
	my ($res, $buf, $inkana, $iskana);
	
	foreach (split //, $sjis) {
		if($buf) {
			$buf .= $_;
			$iskana = ($buf =~ /(?:\x83[\x40-\x96]|\x81[\x5B\x4A\x4B\x52\x53])/)? 1: 0;
			$res .= $pre if !$inkana && $iskana;
			$res .= $post if $inkana && !$iskana;
			$res .= $buf;
			undef $buf;
			$inkana = $iskana;
		} elsif(/[\x81-\x9f\xe0-\xef]/) {
			$buf = $_;
		} else {
			$res .= $post if $inkana;
			$inkana = 0;
			$res .= $_;
		}
	}
	
	$res;
}


sub escape_sjis_php_literal {
	my ($rresult) = @_;

	my $original = $$rresult;
	$$rresult = '';


	my ($state_xhtml, $state_php, $state_literal) = (1, 2, 3);
	my $state = $state_xhtml;
	my ($ch0, $ch1, $last_quote, $buffer);
	my ($pos0, $pos1) = (0, 0);
	my $len = length($original);

	while ($pos1 < $len) {
		if($state == $state_xhtml) {

			$pos1 = index($original, '<?', $pos0);
			if($pos1 < 0) {
				$$rresult .= substr($original, $pos0, $len - $pos0);
				last;
			}
			

			$$rresult .= substr($original, $pos0, $pos1 - $pos0);
			

			$pos0 = $pos1;
			$pos1 += 2;
			

			$buffer = '<?';
			$ch0 = substr($original, $pos1++, 1);
			$state = $state_php;
		} elsif($state == $state_php) {
			$ch1 = substr($original, $pos1++, 1);
			if($ch0 eq '?' && $ch1 eq '>') {

				$$rresult .= $buffer;
				$$rresult .= '?>';
				$buffer = $ch1 = $ch0 = '';
				$pos0 = $pos1;


				$state = $state_xhtml;
 			} elsif($ch0 ne '\\' && ($ch1 eq "'" || $ch1 eq '"')) {
				$last_quote = $ch1;


				$buffer .= $ch0 . $ch1;
				$$rresult .= $buffer;
				$buffer = '';
				$ch0 = '';


				$state = $state_literal;
			} else {
				$buffer .= $ch0;
				$ch0 = $ch1;
			}
		} else { # $state_literal
			$ch1 = substr($original, $pos1++, 1);
			my $code0 = ord($ch0);
 			if($ch0 ne '\\' && $ch1 eq $last_quote) {

				$buffer .= $ch0;
				$$rresult .= $buffer;
				$buffer = $ch1;
				$ch0 = '';


				$last_quote = '';
				$state = $state_php;
			} elsif(((0x81 <= $code0 && $code0 <= 0x9f) || (0xe0 <= $code0 && $code0 <= 0xfc)) && $ch1 eq '\\') {

				$buffer .= $ch0 . '\\\\';
				$ch0 = '';
			} else {
				$buffer .= $ch0;
				$ch0 = $ch1;
			}
		}
	}
	
	$buffer .= $ch0;
	$$rresult .= $buffer;
	
	0;
}


sub replace_if_image_noresize {
	$_ = shift;
	if(/(.jpg|.jpeg|.gif|.png)$/i) {
		return "<?php mtkk_image(array('url' => '$_', 'fit' => 'noresize')); ?>";
	} else {
		return $_;
	}
}


sub lookup_emoji {
	my $gaiji = shift;
	

	$gaiji = unpack('n', $gaiji);
	my $symbol = $kdb->findIEmoji($gaiji);
	my $emoji = $kdb->findEmoji($symbol);


	emoji_php($emoji);
}


sub lookup_emoji_entity {
	my $symbol = shift;
	

	if($symbol =~ /^(i|ez|s|w)([0-9a-fA-F]{4})$/) {
		my $extra = 'null';

		if($1 eq 's') {

			my $unicode = KeitaiCode::s_sjis_to_unicode(hex($2));
			if($unicode) {
				$extra = sprintf("array('unicode' => 0x%x)", $unicode);
			}
		} elsif($1 eq 'w') {

			my $sjis = KeitaiCode::s_webcode_to_sjis(hex($2));
			my $unicode = KeitaiCode::s_webcode_to_unicode(hex($2));
			if($sjis && $unicode) {
				$extra = sprintf("array('sjis' => 0x%x, 'unicode' => 0x%x)", $sjis, $unicode);
			}
		}
		

		return "<?php echo mtkk_sjis_emoji('$1', 0x$2, $extra); ?>";
	}
	
	my $emoji = $kdb->findEmoji($symbol);
	return "&$symbol;" if $emoji->{isjis} == 0;
	
	emoji_php($emoji);
}


sub _hdr_KeitaiEmoji {
	my ($ctx, $args, $cond) = @_;
	

	my $symbol = build_value($ctx, $args->{'symbol'});
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiEmoji', 'symbol')) if !defined($symbol) || $symbol eq '';
	

	return _hdr_KeitaiEmojiSysTmpl(@_) if is_dynamic;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiEmoji', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');
	

	my $emoji = $kdb->findEmoji($symbol);
	

	$emoji->{isjis} = eval($args->{isjis}) if $args->{isjis};
	$emoji->{iuni} = eval($args->{iuni}) if $args->{iuni};
	$emoji->{ez} = eval($args->{ez}) if $args->{ez};
	$emoji->{s} = eval($args->{s}) if $args->{s};
	$emoji->{text} = $args->{text} if $args->{text};
	

	emoji_php($emoji);
}


sub emoji_php {
	my $emoji = shift;
	my $symbol = defined($emoji->{symbol})? $emoji->{symbol}: '';
	my $isjis = $emoji->{isjis} || '0';
	my $iuni = $emoji->{iuni} || '0';
	my $ez = $emoji->{ez} || '0';
	my $s = $emoji->{s} || '0';
	my $text = defined($emoji->{text})? convert_from_utf8($emoji->{text}): '';
	my $aa = defined($emoji_aa->{$emoji->{symbol}})? $emoji_aa->{$emoji->{symbol}}: '';
	

	utf8::decode($text) if $IS_MT5;

	"<?php mtkk_emoji(array('symbol' => '$symbol', 'i' => $isjis, 'iu' => $iuni, 'ez' => $ez, 's' => $s, 'text' => '$text', 'aa' => '$aa')); ?>";
}


sub _hdr_KeitaiWords {
	my ($text, $arg, $ctx) = @_;
	
	return $ctx->error($plugin->translate('Set integer except for 0 to [_2] attribute of  [_1]', '', 'keitai_words'))
		unless $arg =~ /^[1-9][0-9]*$/;
	
	eval {
		$text = convert_to_utf8($text);
		my $mb = String::Multibyte->new('UTF8');
		$text = $mb->substr($text, 0, $arg);
		$text = MT::Util::remove_html($text);
		$text =~ s/(\r?\n)+/ /g;
		$text = convert_from_utf8($text);
	};
	
	$text;
}


sub _hdr_KeitaiLinkTel {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	defined(my $result = $builder->build($ctx, $tokens, $cond)) ||
		return $ctx->error($ctx->errstr);


	_hdr_KeitaiLinkTel_filter($result, $args->{class}, $ctx);
}


sub _hdr_KeitaiLinkTel_filter {
	my ($text, $arg, $ctx) = @_;
	

	$arg ||= 'tel';
	

	$text =~ s/<span([^<>]+)class="$arg"([^<>]*)>([^<>]+)<\/span>/eval{
		my ($a1, $a2, $l, $t) = ($1, $2, $3, $3);
		$l =~ s![^0-9]+!!g;
		qq(<span${a1}class="$arg"${a2}><a href="tel:$l">$t<\/a><\/span>);
	}/eg;
	
	$text;
}


sub _hdr_KeitaiCond {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	defined(my $result = $builder->build($ctx, $tokens, $cond)) ||
		return $ctx->error($ctx->errstr);


	_hdr_KeitaiCond_filter($result, $args->{tag}, $ctx);
}


sub _hdr_KeitaiCond_filter {
	my ($text, $arg, $ctx) = @_;
	

	my $blog_config = $plugin->get_config_hash("blog:" . $ctx->stash('blog_id'));
	my $gateway = $blog_config->{mobile_gateway};
	my @gateway_exception = ();
	@gateway_exception = split(/[\r\n]+/, $blog_config->{mobile_gateway_exception})
		if $blog_config->{mobile_gateway_exception};
	my $encode_url = $blog_config->{mobile_gateway_encode_url};
	


	my $html = HTML::TagParser->new($text);
	my @list = $html->getElementsByTagName('a');
	my @replace_from = ();
	my @replace_to = ();


	use MT::Util;
	foreach my $elem ( @list ) {
		my $attr = $elem->attributes;
		

		my $href = convert_from_utf8($attr->{href});
		my $keitai_href = convert_from_utf8($attr->{'keitai:href'});
		next unless $href;
		

		if(!$keitai_href && $gateway) {
			if($href =~ /^https?:/) {

				$keitai_href = $gateway . ($encode_url? MT::Util::encode_url($href): $href);
				

				foreach my $exception (@gateway_exception) {
					if(substr($href, 0, length($exception)) eq $exception) {
						$keitai_href = $href;
						last;
					}
				}
			} else {

				$keitai_href = $href;
			}
		}
		

		if($keitai_href) {

		    $href =~ s![\\\*\+\.\?\{\}\(\)\[\]\^\$\-\|]!\\$&!g;
			push(@replace_from, $href);
			push(@replace_to, $keitai_href);
		}
	}
	

	my $new = '';
	my $i = 0;
	while($i < @replace_from && $text =~ m!(\s)href="$replace_from[$i]"!) {
		$new .= $` . $1 . 'href="' . $replace_to[$i++] . '"';
		$text = $';	#'
	}
	$text = $new . $text;
	

	$arg ||= 'keitai';


	$text =~ s/<$arg>\s*<!--\s*//sg;
	$text =~ s/\s*-->\s*<\/$arg>//sg;


	$i = 1;
	my @text = split(/<\/?no$arg>/, $text);
	join('', grep($i++ % 2, @text));
}


sub _hdr_KeitaiLinkImages {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	return $ctx->error($plugin->traslate('[_1] cant be used inside [_2]', 'MTKeitaiLinkImages', 'MTKeitaiLinkImages'))
		if $ctx->stash('mtkk_link_images');
	

	my $over = $args->{over} || '0';
	return $ctx->error($plugin->translate('Set positive integer or percentage to [_2] attribute of [_1]', 'MTKeitaiLineImage', 'over'))
		unless $over =~ /^[0-9]+%?$/;
	

	my $format = $args->{format} || '%c(%k)';
	

	my $before = $args->{before} || '';
	my $after = $args->{after} || '';
	

	my $align = $args->{align} || '';
	

	my $page = $args->{page} || '';
	my $caption = $args->{caption} || '';
	
	my $thumbnail = $args->{thumbnail} || '32';
	return $ctx->error($plugin->translate('Set positive integer or percentage to [_2] attribute of [_1]', 'MTKeitaiLineImage', 'thumbnail'))
		unless $thumbnail =~ /^[0-9]+%?$/;
	

	$ctx->stash('mtkk_link_images', 1);
	defined(my $result = $builder->build($ctx, $tokens, $cond)) ||
		return $ctx->error($ctx->errstr);
	$ctx->stash('mtkk_link_images', undef);
	

	my $php;
	$format =~ s/'/\\'/g; #'
	$php = '<?php $mtkk_link_images = true; ';
	$php .= '$mtkk_link_images_over = \'' . $over . '\'; ';
	$php .= '$mtkk_link_images_format = \'' . $format . '\'; ';
	$php .= '$mtkk_link_images_before = \'' . $before . '\'; ';
	$php .= '$mtkk_link_images_after = \'' . $after . '\'; ';
	$php .= '$mtkk_link_images_thumbnail = \'' . $thumbnail . '\'; ';
	$php .= '$mtkk_link_images_align = \'' . $align . '\'; ';
	$php .= '$mtkk_link_images_page = \'' . $page . '\'; ';
	$php .= '$mtkk_link_images_caption = \'' . $caption . '\'; ';
	$php .= '?>';
	$php .= $result;
	$php .= '<?php $mtkk_link_images = false; ?>';
	
	$php;
}


sub _hdr_KeitaiIfLinkedImageParam {
	my ($ctx, $args, $cond) = @_;
	

	my $param = $args->{name} || 'image';

	my $if = sprintf(q{isset($_GET['mtkk_linked_%s']) && $_GET['mtkk_linked_%s']}, $param, $param);
	write_php_if('MTKeitaiIfLikedImageParam', $if, $ctx, $args, $cond);
}


sub _hdr_KeitaiLinkedImageParam {
	my ($ctx, $args, $cond) = @_;


	my $param = $args->{name} || 'image';

	if($param eq 'caption') {
		sprintf(q{<?php echo isset($_GET['mtkk_linked_%s'])? mb_convert_encoding(htmlspecialchars($_GET['mtkk_linked_%s'], ENT_QUOTES), $mtkk_php_encoding, 'UTF-8'): ''?>}, $param, $param);
	} else {
		sprintf(q{<?php echo isset($_GET['mtkk_linked_%s'])? htmlspecialchars($_GET['mtkk_linked_%s'], ENT_QUOTES): ''?>}, $param, $param);
	}
}


sub _hdr_KeitaiLinkedImageTag {
	my ($ctx, $args, $cond) = @_;
	

	if(defined($args->{'keitai:style'})) {
		$args->{'keitai:style'} .= ';' if $args->{'keitai:style'} && $args->{'keitai:style'} !~ /;\s*$/;
		$args->{'keitai:style'} .= 'convert:no;';
	} else {
		$args->{'keitai:style'} = 'convert:no;';
	}
	

	my $params = '';
	foreach my $key ( keys %$args ) {
		if($key ne 'src' && $key ne '@') {
			my $value = $args->{$key};
			$value =~ s/"/\\"/g;
			$params .= qq( $key="$value");
		}
	}
	
	sprintf(q{<img src="<?php echo isset($_GET['mtkk_linked_image'])? htmlspecialchars($_GET['mtkk_linked_image'], ENT_QUOTES): ''?>"%s />}, $params);
}


sub _hdr_KeitaiElse {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	my $depth = $ctx->stash('mtkk_if_nest_depth');
	

	return $ctx->error($plugin->translate('Use [_1] inside a tag starts by [_2]', 'MTKeitaiElse', 'MTKeitaiIf')) unless $depth;
	

	my $else = $ctx->stash('mtkk_if_nest_else') || {};
	

	return $ctx->error($plugin->translate('MTKeitaiElse tag can be used one time inside a tag starts by MTKeitaiIf')) if($else->{$depth});
	

	$else->{$depth} = 1;
	$ctx->stash('mtkk_if_nest_else', $else);



	defined(my $result = $builder->build($ctx, $tokens, $cond)) || return $ctx->error($ctx->errstr);
	
	"<?php } else { ?>$result";
}


sub _hdr_KeitaiPaginate {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiPaginate', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');
	



	my $footer_bytes = $args->{footer_bytes} || 1024;
	$ctx->stash('mtkk_footer_bytes', $footer_bytes);





	my $break_tags = defined($args->{break_tags})? $args->{break_tags}: 'p,div';
	



	my $max_bytes = $args->{max_bytes} || 0;
	



	my $max_sections = $args->{max_sections} || 0;
	


	my $order = $args->{order} || '';
	

	$ctx->stash('mtkk_paginating', 1);	


	defined(my $result = $builder->build($ctx, $tokens, $cond)) ||
		return $ctx->error($ctx->errstr);
		

	$ctx->stash('mtkk_paginating', undef);
	$ctx->stash('mtkk_paginated', 1);


	if($break_tags) {
		my @tags = split(/\s*,\s*/, $break_tags);
		foreach my $tag (@tags) {
			if($tag =~ /^_/) {
				$tag = substr($tag, 1);
				$result =~ s/<$tag[^>]*>/<!--mtkk-->$&<!--mtkk-->/ig;
			} else {
				$result =~ s/<\/$tag[^>]*>/$&<!--mtkk-->/ig;
			}
		}
	}
	

	$result =~ s/^\s*<!\-\-mtkk\-\->//s;
	$result =~ s/<!\-\-mtkk\-\->\s*$//s;
	$result =~ s/<!\-\-mtkk\-\->\s*<!\-\-mtkk\-\->/<!--mtkk-->/s;
	

	'<!--mtkk--><?php $mtkk_max_bytes = ' . $max_bytes . '; $mtkk_max_sections = ' . $max_sections . '; $mtkk_paginate_order = "' . $order . '"; ?>' . $result . '<?php ob_end_flush(); if($mtkk_use_session && $mtkk_session_id) { ob_start(\'mtkk_session_link\'); } ?>';
}


sub _hdr_KeitaiPaginateBreak {
	my $ctx = shift;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiPaginateBreak', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginating');
	

	"<!--mtkk-->";
}


sub _hdr_KeitaiIfLayer {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiIfLayer', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');


	my $layer = $args->{'layer'};
	

	my $depth = $ctx->stash('mtkk_if_nest_depth') || 0;
	$ctx->stash('mtkk_if_nest_depth', $depth + 1);
	defined(my $result = $builder->build($ctx, $tokens, $cond)) || return $ctx->error($ctx->errstr);
	my $else = $ctx->stash('mtkk_if_nest_else');
	delete $else->{$depth + 1};
	$ctx->stash('mtkk_if_nest_else', $else);
	$ctx->stash('mtkk_if_nest_depth', $depth);


	my $layerer = $ctx->stash('mtkk_layerer');
	if($layer) {
		return '<?php if ( isset($_GET["' . $layerer . '"]) && $_GET["' . $layerer . '"] == "' . $layer . '" ) { ?>' . $result . '<?php } ?>';
	} else {
		return '<?php if ( !isset($_GET["' . $layerer . '"]) ) { ?>' . $result . '<?php } ?>';
	}
}


sub _hdr_KeitaiLayerLink {
	my ($ctx, $args, $cond) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiLayerLink', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');


	my $layer = $ctx->stash('layer');
	
	"<?php echo(mtkk_layer_link('$layer')); ?>";
}


sub _hdr_KeitaiIfMultiplePages {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiIfMultiplePages', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');
	

	my $depth = $ctx->stash('mtkk_if_nest_depth') || 0;
	$ctx->stash('mtkk_if_nest_depth', $depth + 1);
	defined(my $result = $builder->build($ctx, $tokens, $cond)) || return $ctx->error($ctx->errstr);
	my $else = $ctx->stash('mtkk_if_nest_else');
	delete $else->{$depth + 1};
	$ctx->stash('mtkk_if_nest_else', $else);
	$ctx->stash('mtkk_if_nest_depth', $depth);


	'<?php if ( $mtkk_max_page > 1 ) { ?>' . $result . '<?php } ?>';
}


sub _hdr_KeitaiIfHasNextPage {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiIfHasNextPage', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');
	

	my $depth = $ctx->stash('mtkk_if_nest_depth') || 0;
	$ctx->stash('mtkk_if_nest_depth', $depth + 1);
	defined(my $result = $builder->build($ctx, $tokens, $cond)) || return $ctx->error($ctx->errstr);
	my $else = $ctx->stash('mtkk_if_nest_else');
	delete $else->{$depth + 1};
	$ctx->stash('mtkk_if_nest_else', $else);
	$ctx->stash('mtkk_if_nest_depth', $depth);


	return $result = '<?php if ( $mtkk_current_page < $mtkk_max_page ) { ?>' . $result . '<?php } ?>';
}


sub _hdr_KeitaiIfHasPreviousPage {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiIfHasPreviousPage', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');
	

	my $depth = $ctx->stash('mtkk_if_nest_depth') || 0;
	$ctx->stash('mtkk_if_nest_depth', $depth + 1);
	defined(my $result = $builder->build($ctx, $tokens, $cond)) || return $ctx->error($ctx->errstr);
	my $else = $ctx->stash('mtkk_if_nest_else');
	delete $else->{$depth + 1};
	$ctx->stash('mtkk_if_nest_else', $else);
	$ctx->stash('mtkk_if_nest_depth', $depth);


	return $result = '<?php if ( $mtkk_current_page > 1 ) { ?>' . $result . '<?php } ?>';
}


sub _hdr_KeitaiCurrentPageNum {

	'<?php echo($mtkk_current_page); ?>';
}


sub _hdr_KeitaiNextPageNum {
	my $ctx = shift;
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiNextPageNum', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');


	'<?php echo($mtkk_current_page < $mtkk_max_page? $mtkk_current_page + 1: $mtkk_max_page); ?>';
}


sub _hdr_KeitaiPreviousPageNum {
	my $ctx = shift;
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiPreviousPageNum', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');


	'<?php echo($mtkk_current_page > 1 ? $mtkk_current_page - 1: 1); ?>';
}


sub _hdr_KeitaiFirstPageNum {
	my $ctx = shift;
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiFirstPageNum', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');


	'1';
}


sub _hdr_KeitaiLastPageNum {
	my $ctx = shift;
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiLastPageNum', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');


	'<?php echo($mtkk_max_page); ?>';
}


sub _hdr_KeitaiNextPageLink {
	my $ctx = shift;
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiNextPageLink', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');


	'<?php echo($mtkk_path); ?>' . $ctx->stash('mtkk_selector') . '=<?php echo($mtkk_current_page < $mtkk_max_page? $mtkk_current_page + 1: $mtkk_max_page); ?>';
}


sub _hdr_KeitaiPreviousPageLink {
	my $ctx = shift;
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiPreviousPageLink', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');


	'<?php echo($mtkk_path); ?>' . $ctx->stash('mtkk_selector') . '=<?php echo($mtkk_current_page > 1? $mtkk_current_page - 1: 1); ?>';
}


sub _hdr_KeitaiFirstPageLink {
	my $ctx = shift;
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiFirstPageLink', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');


	'<?php echo($mtkk_path); ?>' . $ctx->stash('mtkk_selector') . '=1';
}


sub _hdr_KeitaiLastPageLink {
	my $ctx = shift;
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiLastPageLink', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');


	'<?php echo($mtkk_path); ?>' . $ctx->stash('mtkk_selector') . '=<?php echo($mtkk_max_page); ?>';
}


sub _hdr_KeitaiPages {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	return $ctx->error($plugin->translate('Use [_1] after [_2]', 'MTKeitaiPages', 'MTKeitaiPaginate')) unless $ctx->stash('mtkk_paginated');


	return $ctx->error($plugin->traslate('[_1] cant be used inside [_2]', 'MTKeitaiPages', 'MTKeitaiPages')) if $ctx->stash('mtkk_paging');
	$ctx->stash('mtkk_paging', 1);
	


	my $step = $args->{step} || 1;
	
	return $ctx->error($plugin->translate('Set integer except for 0 to [_2] attribute of  [_1]', 'MTKeitaiPages', 'step')) if $step !~ /^\-?[1-9][0-9]*$/;
	$ctx->stash('mtkk_step', $step);


	defined(my $result = $builder->build($ctx, $tokens, $cond)) || return $ctx->error($ctx->errstr);

	$ctx->stash('mtkk_paging', undef);


	return $result = "<?php for(\$mtkk_pages_it = 1; \$mtkk_pages_it <= \$mtkk_max_page; \$mtkk_pages_it += $step) { ?>$result<?php } ?>" if $step > 0;
	return $result = "<?php for(\$mtkk_pages_it = \$mtkk_max_page; \$mtkk_pages_it >= 1; \$mtkk_pages_it += $step) { ?>$result<?php } ?>";
}


sub _hdr_KeitaiPagesNum {
	my $ctx = shift;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiPagesNum', 'MTKeitaiPages')) unless $ctx->stash('mtkk_paging');
	
	'<?php echo($mtkk_pages_it); ?>';
}


sub _hdr_KeitaiPagesSeparator {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');


	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiPagesSeparator', 'MTKeitaiPages')) unless $ctx->stash('mtkk_paging');
	

	defined(my $result = $builder->build($ctx, $tokens, $cond)) || return $ctx->error($ctx->errstr);


	return '<?php if ($mtkk_pages_it < $mtkk_max_page  ) { ?>' . $result . '<?php } ?>' if $ctx->stash('mtkk_step') > 0;
	'<?php if ($mtkk_pages_it > 1 ) { ?>' . $result . '<?php } ?>';
}


sub _hdr_KeitaiPagesLink {
	my $ctx = shift;


	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiPagesLink', 'MTKeitaiPages')) unless $ctx->stash('mtkk_paging');


	'<?php echo($mtkk_path); ?>' . $ctx->stash('mtkk_selector') . '=<?php echo($mtkk_pages_it); ?>';
}


sub _hdr_KeitaiIfPagesCurrent {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');


	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiIfPagesCurrent', 'MTKeitaiPages')) unless $ctx->stash('mtkk_paging');
	

	my $depth = $ctx->stash('mtkk_if_nest_depth') || 0;
	$ctx->stash('mtkk_if_nest_depth', $depth + 1);
	defined(my $result = $builder->build($ctx, $tokens, $cond)) || return $ctx->error($ctx->errstr);
	my $else = $ctx->stash('mtkk_if_nest_else');
	delete $else->{$depth + 1};
	$ctx->stash('mtkk_if_nest_else', $else);
	$ctx->stash('mtkk_if_nest_depth', $depth);


	'<?php if($mtkk_pages_it == $mtkk_current_page) { ?>' . $result . '<?php } ?>';
}


sub _hdr_KeitaiModel {
	"<?php echo(mb_convert_encoding(\$mtkk_spec['model']? \$mtkk_spec['model']: 'Unknown', 'SJIS-WIN', 'UTF-8')); ?>";
}


sub write_php_if {
	my ($tag, $if, $ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', $tag, 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');
	

	my $depth = $ctx->stash('mtkk_if_nest_depth') || 0;
	$ctx->stash('mtkk_if_nest_depth', $depth + 1);
	defined(my $result = $builder->build($ctx, $tokens, $cond)) || return $ctx->error($ctx->errstr);
	my $else = $ctx->stash('mtkk_if_nest_else');
	delete $else->{$depth + 1};
	$ctx->stash('mtkk_if_nest_else', $else);
	$ctx->stash('mtkk_if_nest_depth', $depth);


	"<?php if($if) { ?>$result<?php } ?>";
}	


sub _hdr_KeitaiIfCarrier {
	my ($ctx, $args, $cond) = @_;
	

	my $in = $args->{in};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiIfCarrier', 'in')) unless $in;
	
	my @carriers = split(/\s*,\s*/, $in);
	my $if = "in_array(\$mtkk_carrier, array('" . join("','", @carriers) . "'))";

	write_php_if('MTKeitaiIfCarrier', $if, $ctx, $args, $cond);
}


sub _hdr_KeitaiIfQVGA {
	write_php_if('MTKeitaiIfQVGA', '$mtkk_spec[\'sw\'] >= 240 && $mtkk_spec[\'sh\'] >= 320', @_);
}


sub _hdr_KeitaiIfWidth {
	my ($ctx, $args, $cond) = @_;
	

	my $width = $args->{width};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiIfWidth', 'width')) unless $width;
	return $ctx->error($plugin->translate('Set positive integer to [_2] attribute of  [_1]', 'MTKeitaiIfWidth', 'width')) if $width !~ /[0-9]+/;
	
	my $if = "\$mtkk_spec[\'bw\'] >= $width";
	write_php_if('MTKeitaiIfWidth', $if, @_);
}


sub _hdr_KeitaiIfMonochrome {
	write_php_if('MTKeitaiIfMonochrome', '$mtkk_spec[\'colors\'] < 3', @_);	
}


sub _hdr_KeitaiIfColor {
	write_php_if('MTKeitaiIfColor', '$mtkk_spec[\'colors\'] >= 3', @_);
}


sub _hdr_KeitaiIfHighColor {
	write_php_if('MTKeitaiIfHighColor', '$mtkk_spec[\'colors\'] > 4', @_);
}


sub _hdr_KeitaiIfFlash {
	my ($ctx, $args, $cond) = @_;
	

	my $version = $args->{version} || 1.00;
	$version = int($version * 100) || 100;
	
	write_php_if('MTKeitaiIfFlash', '$mtkk_spec[\'flashv\'] >= ' . $version, @_);
}


sub _hdr_KeitaiIfImage {
	my ($ctx, $args, $cond) = @_;
	

	my $format = $args->{format};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiIfImage', 'format')) unless $format;
	

	my %formats = (Jpeg => 0x01, GIF => 0x02, AGIF => 0x04, PNG256 => 0x08, PNG => 0x10);
	$format = $formats{$format} || 0;
	
	write_php_if('MTKeitaiIfImage', '$mtkk_spec[\'img\'] & ' . $format, @_);
}


sub _hdr_KeitaiIfMovie {
	my ($ctx, $args, $cond) = @_;
	

	my $format = $args->{format};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiIfMovie', 'format')) unless $format;
	

	my %formats = (MP4 => 0x01, '3GPP2' => 0x02, AMC => 0x04);
	$format = $formats{$format} || 0;
	
	write_php_if('MTKeitaiIfImage', '$mtkk_spec[\'mov\'] & ' . $format, @_);
}


sub _hdr_KeitaiIfModel {
	my ($ctx, $args, $cond) = @_;
	

	my $reg = $args->{reg} || $args->{regex};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiIfModel', 'reg')) unless $reg;
	

	my $blog_config = $plugin->get_config_hash("blog:" . $ctx->stash('blog_id'));
	my $encoding = $blog_config->{php_encoding} || 'SJIS';
	

	if($IS_MT5) {
		$encoding = MT->instance->config('PublishCharset');
	}
	
	write_php_if('MTKeitaiIfModel', "preg_match('/$reg/', mb_convert_encoding(\$mtkk_spec[\'model\'], '$encoding', 'UTF-8'))", @_);
}


sub _hdr_KeitaiIfGeneration {
	my ($ctx, $args, $cond) = @_;
	

	my @if;
	

	if($args->{s}) {
		my %s = ('C2' => 200, 'C3' => 300, 'C4' => 400, 'P4(1)' => 500, 'P4(2)' => 600
			 , 'P5' => 700, 'P6' => 800, 'P7' => 900, 'W'=> 1000, '3GC' => 1100);
		$args->{s} = $s{$args->{s}} if exists $s{$args->{s}};
	}

	push @if, "(\$mtkk_carrier == 'i' && \$mtkk_spec['format1'] >= " . $args->{i} * 100 . ")" if $args->{i};
	push @if, "(\$mtkk_carrier == 'i' && \$mtkk_spec['format2'] >= " . $args->{ix} * 100 . ")" if $args->{ix};
	push @if, "(\$mtkk_carrier == 'ez' && \$mtkk_spec['format1'] >= " . $args->{ez} * 100 . ")" if $args->{ez};
	push @if, "(\$mtkk_carrier == 's' && \$mtkk_spec['format1'] >= " . $args->{s} . ")" if $args->{s};
	

	my $if = join(' || ', @if);
	
	return $ctx->error($plugin->translate('[_1] requires at least any attribute in [_2]', 'MTKeitaiIfGeneration', 'i, ix, ez, s')) unless $if;
	
	write_php_if('MTKeitaiIfGeneration', $if, @_);
}


sub _hdr_KeitaiIfColoredTable {
	my ($ctx, $args, $cond) = @_;
	

	my %args = ( i => '6', ix => '1', ez => '6', s => 'C3' );
	

	_hdr_KeitaiIfGeneration($ctx, \%args, $cond);
}


sub _hdr_KeitaiIfiXHTML {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	my $if = "\$mtkk_carrier == 'i' && \$mtkk_spec['format2'] >= 100";
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiIfiXHTML', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');
	

	my $depth = $ctx->stash('mtkk_if_nest_depth') || 0;
	$ctx->stash('mtkk_if_nest_depth', $depth + 1);
	defined(my $result = $builder->build($ctx, $tokens, $cond)) || return $ctx->error($ctx->errstr);
	my $else = $ctx->stash('mtkk_if_nest_else');
	delete $else->{$depth + 1};
	$ctx->stash('mtkk_if_nest_else', $else);
	$ctx->stash('mtkk_if_nest_depth', $depth);
	

	$result =~ s/^\s+//;


	"<?php if($if) { header('Content-Type: application/xhtml+xml'); \$mtkk_ixhtml = true; ?>$result<?php } ?>";
}


sub _hdr_KeitaiIfGeneralCSS {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	my @if;
	
	push @if, "(\$mtkk_carrier == 'other')";
	push @if, "(\$mtkk_carrier == 'ez' && \$mtkk_spec['format1'] >= 600)";
	push @if, "(\$mtkk_carrier == 's' && \$mtkk_spec['format1'] >= 1000)";
	

	my $if = join(' || ', @if);
	
	write_php_if('MTKeitaiIfGeneralCSS', $if, @_);
}


sub _hdr_KeitaiIfSupported {
	my ($ctx, $args, $cond) = @_;
	

	my $blog = $ctx->stash('blog');
	my $blog_id = $blog->id;
	my $blog_config = $plugin->get_config_hash("blog:$blog_id");
	

	my @if;
	

	my @carrier = qw/i i ez s/;
	my @format = qw/format1 format2 format1 format1/;
	my @arg = qw/i ix ez s/;


	for(my $i = 0; $i < @carrier; $i++) {
		my ($carrier, $format, $arg) = ($carrier[$i], $format[$i], $arg[$i]);
		if($blog_config->{supported_format} && $blog_config->{supported_format}{$arg}) {

			my $include = $blog_config->{supported_include}{$carrier};
			my $exclude = $blog_config->{supported_exclude}{$carrier};
			

			my @include = map { "'$_'" } split(/\s*,\s*/, $include);
			my @exclude = map { "'$_'" } split(/\s*,\s*/, $exclude);
			$include = join(',', @include);
			$exclude = join(',', @exclude);

			my $if = "(\$mtkk_carrier == '$carrier' && ";
			$if .= "(\$mtkk_spec['$format'] >= " . $blog_config->{supported_format}{$arg};


			$if .= " || in_array(\$mtkk_model_id, array($include))" if $include;
			
			$if .= ")";
			

			$if .= " && !in_array(\$mtkk_model_id, array($exclude))" if $exclude;
			
			$if .= ")";
			

			push @if, $if;
		}
	}


	my $if = join(' || ', @if) || 'true';
	
	write_php_if('MTKeitaiIfSupported', $if, @_);
}


sub _hdr_KeitaiIfKeitaiKitVersion {
	my ($ctx, $args, $cond) = @_;
	

	my $over = $args->{over};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiIfKeitaiKitVersion', 'over')) unless $over;
	
	write_php_if('MTKeitaiIfKeitaiKitVersion', "\$mtkk_version >= $over", @_);
}


sub _hdr_KeitaiIfEnv {
	my ($ctx, $args, $cond) = @_;
	

	my $if = $args->{cond};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiIfEnv', 'cond')) unless $if;
	

	$if =~ s/&gt;/>/g;
	$if =~ s/&lt;/</g;
	
	write_php_if('MTKeitaiIfEnv', $if, @_);
}


sub _hdr_KeitaiEnv {
	my ($ctx, $args, $cond) = @_;
	

	my $value = $args->{value};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiEnv', 'value')) unless $value;
	
	"<?php echo($value); ?>";
}


sub _remove_css_properties {
    my ($properties_hash, $style) = @_;
    
    my @styles = split(/;/, $style);
    my $new_style = '';
    foreach my $s (@styles) {
        my ($property, $value) = split(/:/, $s, 2);
        $property =~ s/\s//g;
        $new_style .= "$s;" unless $properties_hash->{lc($property)};
    }
    
    qq{ style="$new_style"};
}


sub _hdr_KeitaiKitSysTmpl {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	my $run_callbacks = MT->instance->config('KeitaiRunCallbacks') || 0;
	$ctx->stash('mtkk_run_callbacks', $run_callbacks);
	

	if( $run_callbacks && MT->version_number >= 4.0 ) {
		$ctx->error('');
		MT->run_callbacks('keitaikit_init', 1, $ctx, 'MTKeitaiKitSysTmpl');
		return if $ctx->errstr;
	}
	
	my $result;
	

	$cond = { %$cond, IfKeitaiSysTmpl => is_dynamic } if MT->version_number >= 4.1;
	$cond = { %$cond, IfKeitaiLoggedInSysTmpl => (MT->instance->user? 1: 0) } if MT->version_number >= 4.1;
	

	if(is_dynamic || $args->{dynamic}) {

	    $ctx->{__handlers}{keitaiifsmartphone} = $ctx->{__handlers}{ifkeitaismartphone};
	


		my $mt = MT->instance;
		my $mt_path = $mt->mt_dir;
		

		my $blog = $ctx->stash('blog');
		unless($blog) {
			if($blog = default_blog) {
				$ctx->stash('blog', $blog);
				$ctx->stash('blog_id', $blog->id);
			}
		};
		my $blog_path = $blog->site_path;
		my $blog_url = $blog->site_url;
		my $blog_id = $blog->id;
		$blog_url .= '/' if $blog_url !~ /\/$/;
		

		my $system_config = $plugin->get_config_hash;
		my $blog_config = $plugin->get_config_hash("blog:$blog_id");
		$ctx->stash('mtkk_blog_config', $blog_config);
		

		return $ctx->error($plugin->traslate('Setup Keitaikit at plugins list before use [_1]', 'MTKeitaiKitSysTmpl'))
			unless $system_config->{setuptime};
			
		return $ctx->error($plugin->translate('Trial has expired. Buy a license.'))
			unless time - $system_config->{setuptime} < 3600 * 24 * 60 || $system_config->{licensekey};
	

		my $plugin_dir = File::Spec->catdir($mt_path, $plugin->envelope);
		

		$kdb = KeitaiDB->new("$plugin_dir/db") unless $kdb;
		

		if($ENV{MOD_PERL}) {
			$_ = MT::App->instance->{apache}->subprocess_env('HTTP_USER_AGENT');
		} else {
			$_ = $ENV{HTTP_USER_AGENT};
		}
		my $carrier;
		my $model_id = '';
		my $spec;
		if(/^DoCoMo\/1\.0\/([^\/]+)/i || /^DoCoMo\/2\.0 ([^\(]+)/i) {
			$carrier = 'i';
			$model_id = $1;
			$spec = $kdb->findSpec("$carrier$1");


			if(($spec->{img} & $FORMATS{MG_RESOLUTIONS}) != 0 && /TB[;\/](W[0-9]+H[0-9]+)/) {
			    my $key = $1;
			    my $alt_spec = $kdb->findSpec("$carrier${model_id}_$key");
			    $spec = $alt_spec if $alt_spec->{code};
			}
		} elsif(/^KDDI\-([^ ]+)/i) {
			$carrier = 'ez';
			$model_id = $1;
			$spec = $kdb->findSpec("$carrier$1");
			
			if(/UP\.Browser\/([^ ]+)/i) {
				my @up_versions = split(/_/, $1);
				$spec->{format1} = sprintf('%f', pop @up_versions);
			}
		} elsif(/^SoftBank\/[^\/]+\/([^\/]+)/i || /^J\-PHONE\/[^\/]+\/([^\/]+)/i || /^Vodafone\/[^\/]+\/([^\/]+)/i || /^J\-EMULATOR\/[^\/]+\/([^\/]+)/i || /^MOT\-([^\/]+)\/80.2F.2E.MIB/i) {
			$carrier = 's';
			$model_id = $1;
			$spec = $kdb->findSpec("$carrier$1");
			$ctx->stash('mtkk_is_vga_screen', 1) if $spec->{bw} > $QVGA_WIDTH;
			

			my $display_info;
			my $jphone_display;
			if($ENV{MOD_PERL}) {
			    $display_info = MT::App->instance->{apache}->subprocess_env('HTTP_X_S_DISPLAY_INFO');
			    $jphone_display = MT::App->instance->{apache}->subprocess_env('HTTP_X_JPHONE_DISPLAY');
			} else {
			    $display_info = $ENV{HTTP_X_S_DISPLAY_INFO};
			    $jphone_display = $ENV{HTTP_X_JPHONE_DISPLAY};
			}
			

			if($display_info) {
			    if($display_info =~ /^([0-9]+)\*([0-9]+)/) {
			        $spec->{bw} = $1;
			        $spec->{bh} = $2;
			    }
			}
			if($jphone_display) {
			    if($jphone_display =~ /^([0-9]+)\*([0-9]+)$/) {
			        $spec->{sw} = $1;
			        $spec->{sh} = $2;
			    }
			}
			
		} else {
			$carrier = 'other';
			$spec = $kdb->findSpec;


			if($system_config->{smartphone_enabled}) {
				my $ua = $_;
				my $smartphone = {};
				if($ua =~ /iPhone|iPod|Android/i) {
					my $device = lc($&);
					if($device eq 'iphone' || $device eq 'ipod') {

						$smartphone->{os} = 'iPhone';
						if($ua =~ /iPhone OS ([0-9][0-9_]*)/) {
							my @digits = split(/_/, $1);
							my $version = shift @digits;
							$version .= '.' . join('', @digits) if @digits;
							$smartphone->{os_version} = $version;
						} else {
							$smartphone->{os_version} = 1;
						}
					}
					if($device eq 'android') {

						$smartphone->{os} = 'Android';
						if($ua =~ /Android ([0-9][\.0-9]*)/) {
							$smartphone->{os_version} = $1;
						} else {
							$smartphone->{os_version} = 0;
						}
					}
					
					$ctx->stash('mtkk_smartphone', $smartphone);
					$ctx->stash('mtkk_emoji_subpath', $system_config->{smartphone_emoji_dir});
					

					$spec->{cache} = $system_config->{mtkk_smartphone_cache_size} || $INT_MAX;
					$spec->{sw} = $spec->{bw} = $system_config->{mtkk_smartphone_screen_width} || 320;
					$spec->{sh} = $spec->{bh} = $system_config->{mtkk_smartphone_screen_height} || 480;
				}
			}
		}
		

		if($carrier eq 'ez') {

			my $ez_cache;
			if($ENV{MOD_PERL}) {
				$ez_cache = MT::App->instance->{apache}->subprocess_env('HTTP_X_UP_DEVCAP_MAX_PDU');
			} else {
				$ez_cache = $ENV{HTTP_X_UP_DEVCAP_MAX_PDU};
			}
			$spec->{cache} = $ez_cache / 1024 if $ez_cache && $ez_cache >= 1024;
		}
		

		if($args->{ixhtml} && $carrier ne 'other') {

			$ctx->stash('mtkk_ixhtml', 1);


			if($ENV{MOD_PERL}) {
				MT::App->instance->{apache}->subprocess_env('MTKK_iXHTML', 1);
			} else {
				$ENV{MTKK_iXHTML} = 1;
			}
		}
		

		if($args->{ivga}) {
			$ctx->stash('mtkk_ivga', 1);
			my $no_vga = ($spec->{img} & $FORMATS{MG_NOVGA})? 1: 0;
			if($carrier eq 'i' && $spec->{format1} >= 2000 && !$no_vga) {
				$spec->{bw} *= 2;
				$spec->{bh} *= 2;
				$ctx->stash('mtkk_is_vga_screen', 1);
			}
		}
		

		if(my $no_cache = $args->{no_cache}) {
		    if($no_cache eq 'all' || $no_cache eq $carrier) {

    			if($ENV{MOD_PERL}) {
    				MT::App->instance->{apache}->subprocess_env('MTKK_CACHE_CONTROL', 'no-cache');
    			} else {
    				$ENV{MTKK_CACHE_CONTROL} = 'no-cache';
    			}
    		}
		}
		
		$ctx->stash('mtkk_carrier', $carrier);
		$ctx->stash('mtkk_model_id', $model_id);
		$ctx->stash('mtkk_spec', $spec);
		$ctx->stash('mtkk_copyright', $blog_config->{image_copyright});
		


		$ctx->stash('mtkk_emoji_alt', $args->{emoji_alt} || $blog_config->{emoji_alt} || 'img');
	

		$ctx->stash('mtkk_emoji_size', $args->{emoji_size} || $blog_config->{emoji_img_size} || 12);
		

		my $image_script_url = $blog_config->{image_script_url} || ($blog_url . 'mtkkimage.php');
		$ctx->stash('mtkk_image_script', $image_script_url);
		

		$ctx->stash('mtkk_default_display', 
			$blog_config->{default_display} || $system_config->{default_display} || 'browser' );
		
		$ctx->stash('mtkk_in_keitaikit_systmpl', 1);
		

		my $old_search_script;
		if($ctx->{config} && ($old_search_script = $ctx->{config}->SearchScript)) {
			$ctx->{config}->SearchScript(&_hdr_KeitaiSearchScript);
		}
		

		if(MT->version_number >= 4.2) {
			my $string = $ctx->stash('search_string');
			

			$ctx->stash('mtkk_search_string', $string);
			

			unless($IS_MT5) {
				convert_encoding(\$string, 'sjis', internal_charset);
				$ctx->stash('search_string', $string);
			}
		}
		

		my @fixed_handlers;
		if($IS_MT5) {
			require MT::Template::Handler;
			foreach my $tag_to_fix (qw(nextlink previouslink)) {
				if(my $hdlr = $ctx->{__handlers}{$tag_to_fix}) {
					$ctx->{__handlers}{$tag_to_fix} = MT::Template::Handler->new(
						sub {
							my ($ctx) = @_;
							my $old_charset = MT->instance->config->PublishCharset('Shift_JIS');
							my $res = $ctx->super_handler(@_);
							MT->instance->config->PublishCharset($old_charset);
							$res;
						}, 0, $hdlr
					);
					push @fixed_handlers, $tag_to_fix;
				}
			}
		}
		

		my $prebuilding_module = $ctx->stash('mtkk_prebuilding_module') || $blog_config->{prebuilding_module} || 0;
		if($prebuilding_module) {
			if(my $tmpl = MT::Template->load($prebuilding_module)) {
				my $local_token = $builder->compile($ctx, $tmpl->text);
				defined(my $prebuild = $builder->build($ctx, $local_token)) ||
					return $ctx->error($plugin->translate('An error occurred in prebuilding module') . ': ' . $ctx->errstr);
			}
		}
	

		defined($result = $builder->build($ctx, $tokens, $cond)) ||
			return $ctx->error($ctx->errstr);


		foreach my $tag_to_fix (@fixed_handlers) {
			my $hdlr = $ctx->{__handlers}{$tag_to_fix};
			$ctx->{__handlers}{$tag_to_fix}->super;
		}



    	if( $run_callbacks && MT->version_number >= 4.0) {
    		$ctx->error('');
    		MT->run_callbacks('keitaikit_post_build_inner', 1, $ctx, 'MTKeitaiKitSysTmpl', \$result);
    		return if $ctx->errstr;
    	}
    	
		$ctx->stash('mtkk_in_keitaikit_systmpl', undef);
		

		$result =~ s/^\s+//;
		

		$ctx->{config}->SearchScript($old_search_script) if $old_search_script;
		

		$result =~ s/^\s+//g if $blog_config->{drop_html_indent};
		$result =~ s/(\r?\n)\s+/$1/g if $blog_config->{drop_html_indent};



		my $encode_to = $args->{charset} || $blog_config->{charset} || 'sjis';
		
		MT::App->instance->charset('Shift_JIS');
		

		my $hankaku = $args->{hankaku} || $blog_config->{hankaku} || 'all';
		

		my $opt = ($hankaku eq 'all' || ($carrier ne 'other' && $hankaku eq 'mobile'))? 'h': '';
		

		if($system_config->{smartphone_enabled}) {
			if(my $smartphone = $ctx->stash('mtkk_smartphone')) {

				$encode_to = encode_mapping($system_config->{smartphone_encoding}) || 'utf8';
    			if($ENV{MOD_PERL}) {
    				MT::App->instance->{apache}->subprocess_env('MTKK_OUTPUT_ENCODING', $encode_to);
    			} else {
    				$ENV{MTKK_OUTPUT_ENCODING} = $encode_to;
    			}
				

				$opt = '' if $system_config->{smartphone_convert_kana};
				

				my $remove_style = $args->{smartphone_remove_style} || $system_config->{smartphone_remove_style};
				if($remove_style eq 'all') {
					$result =~ s!\sstyle="[^"]+"!!ig; #"
				} elsif($remove_style eq 'properties') {
					my %properties = map { s/\s//g; $_ => 1; } split(/,/, lc($args->{smartphone_remove_style} || $system_config->{smartphone_remove_css_properties}));
					$result =~ s!\sstyle="([^"]+)"!&_remove_css_properties(\%properties, $1);!ieg; #"
				}
			}
		}
		

		if($IS_MT5) {

			$result = Lingua::JA::Regular::Unicode::katakana_z2h($result) if $opt eq 'h';
		
		} else {
			convert_encoding(\$result, $encode_to, 0, $opt);
		}


		$result =~ s/&([a-z0-9]+);/&emoji_entity_sys_tmpl($ctx, $1);/ieg;
		

		if($blog_config->{use_session} && !$args->{disable_session}) {

			my $external_urls = $blog_config->{session_external_urls};
			$external_urls = "$blog_url\n$external_urls";
			my $jsp_style_urls = '';
			$jsp_style_urls = $blog_config->{session_jsp_style_urls} if $OPTIONS{jsp_support};
			

			my $session_id = MT->instance->param($blog_config->{session_param});
			

			_replace_session_link(\$result, $session_id, $blog_config->{session_param}, $external_urls, $jsp_style_urls) if $session_id;
		}
		

		my @xhtml_headers = ();
		my $default_doctype = MT->instance->config('KeitaiDefaultDoctype') || '';
		

		my $xhtml_version = 0;
		if($carrier eq 'i' && $spec->{format2}) {
			$xhtml_version = $spec->{format2};
			$xhtml_version = 230 if $xhtml_version >= 230;
		} elsif($carrier eq 'ez' && $spec->{format1} >= 600) {
			$xhtml_version = $spec->{format1};
		} elsif($carrier eq 's' && $spec->{format1} >= 1100) {
			$xhtml_version = $spec->{format1};
		} elsif($carrier eq 'other' && $default_doctype) {
			$xhtml_version = 1;
		}

		if($xhtml_version) {

			if($args->{xml_declaration}) {
				push @xhtml_headers, sprintf($XML_DECLARATION, 'Shift_JIS');
			}
		

			if($args->{doctype}) {
				my $doctype = $DOCTYPE{$carrier} || $default_doctype || '';
				push @xhtml_headers, sprintf($doctype, $xhtml_version / 100);
			}
		

			$result = join("\n", (@xhtml_headers, $result))
		}
	} else {

		defined($result = $builder->build($ctx, $tokens, $cond)) ||
			return $ctx->error($ctx->errstr);
	}
	
	$result;
}


sub _hdr_SearchString {
	my ($ctx, $args, $cond) = @_;
	
	if($ctx->stash('mtkk_in_keitaikit_systmpl')) {
		$ctx->stash('mtkk_search_string') || '';
	} else {
		$ctx->stash('search_string') || '';
	}
}


sub _replace_session_link {
	my ($rresult, $session_id, $session_name, $external_urls, $jsp_style_urls) = @_;


	my $src = $$rresult;
	$$rresult = '';
	

	my $session = "$session_name=$session_id";
	my @external_urls = grep($_, split(/[\r\n]+/, $external_urls));
	my @jsp_style_urls = grep($_, split(/[\r\n]+/, $jsp_style_urls));


	//;
	while(1) {

		last unless $src =~ /<a(?=\s)/i;
		$$rresult .= $` . $&;
		$src = $'; #'


		last unless $src =~ />|\shref=(["'])/i; #"
		$$rresult .= $` . $&;
		$src = $'; #'
		

		next if $& eq '>';


		my $delim = $1;
		last unless $src =~ /$delim/;
		

		my ($link, $follow) = ($`, $'); #'
		if($link !~ /$session/) {
			my $protocol = index($link, ':') >= 0? 1: 0;
			if((!$protocol && $link !~ /^#/) || ($protocol && $link =~ /^https?:/i)) {
				my $external = ($link =~ /^https?:/i? 1: 0);
				if(!$external || ($external && 0 < scalar grep(index($link, $_) >= 0, @external_urls))) {
					if(0 < scalar grep(index($link, $_) >= 0, @jsp_style_urls) || $link =~ /(\.jsp)($|\?|#)/i) {

						$link =~ s/($|\?|#)/;$session$1/i;
					} elsif(index($link, '?') >= 0) {
						$link =~ s/\?/"?$session&"/e;
					} else {
						$link =~ s/($|#)/"?$session$&"/e;
					}
				}
			}
		}
		
		$$rresult .= $link . $delim;
		$src = $follow;
	}
	
	$$rresult .= $src;
	
	1;
}


sub _hdr_KeitaiErrStrSysTmpl {
	my $ctx = shift;
	$ctx->stash('mtkk_errstr');
}


sub _hdr_IfKeitaiSysTmpl {
	is_dynamic;
}


sub _hdr_IfKeitaiLoggedInSysTmpl {
	my $ctx = shift;
	my $app = MT->instance;
	return $app->user? 1: 0;
}


sub emoji_alt {
	my ($ctx, $emoji, $use_aa) = @_;
	

	my $emoji_alt = $ctx->stash('mtkk_emoji_alt');
	my $emoji_size = $ctx->stash('mtkk_emoji_size');
	my $emoji_subpath = $ctx->stash('mtkk_emoji_subpath') || '';
	my $symbol = $emoji->{symbol};
	
	if($emoji_aa->{$symbol} && $use_aa) {
		return $emoji_aa->{$symbol};
	} elsif($emoji_alt eq 'text') {

		return convert_from_utf8($emoji->{text}) if $emoji->{text};
	} else {

		my $script = $ctx->stash('mtkk_image_script');
		my $ua_spec = $ctx->stash('mtkk_spec');
		

		my $format;
		if($ua_spec->{'img'} & $FORMATS{MG_GIF}) {
			$format = 'gif';
		} elsif($ua_spec->{'img'} & $FORMATS{MG_PNG}) {
			$format = 'png';
		} else {

			return '';
		}
		

		my $file = "$symbol.$format";
		$file = "$emoji_subpath/$file" if $emoji_subpath;
		my $src = "$script?mtkk_emoji=$file";
		my $width = $emoji_size;
		my $height = $emoji_size;
		if($ctx->stash('mtkk_is_vga_screen')) {
		    $width *= 2;
		    $height *= 2;
		}
		return qq{<img src="$src" border="0" width="$width" height="$height" class="emoji emoji-$symbol" />};
	}	
}


sub emoji_entity_sys_tmpl {
	my ($ctx, $symbol) = @_;
	my $ua_carrier = $ctx->stash('mtkk_carrier');
	my $ua_spec = $ctx->stash('mtkk_spec');
	

	if($symbol =~ /^(i|ez|s|w)([0-9a-fA-F]+)$/) {
		my ($carrier, $sjis) = ($1, lc($2));


		if($carrier eq $ua_carrier) {

			return "&#x[$2];" if $IS_MT5;
			return pack('n', hex($2));
		} elsif($carrier eq 'w' && $ua_carrier eq 's') {

			return "&#x[1b24${2}1f];" if $IS_MT5;
			return pack('CCnC', 0x1b, 0x24, hex($2), 0x1f);
		} else {



			if($carrier eq 'w') {
				$sjis = sprintf('%x', KeitaiCode::s_webcode_to_sjis(hex($sjis)));
				$carrier = 's';
			}
			

			my $format;
			if($ua_spec->{'img'} & $FORMATS{MG_GIF}) {
				$format = 'gif';
			} elsif($ua_spec->{'img'} & $FORMATS{MG_PNG}) {
				$format = 'png';
			} else {

				return '';
			}
			

			my $script = $ctx->stash('mtkk_image_script');
			my $src = "$script?mtkk_emoji=$carrier/$format/$sjis.$format";
			my $width = $EMOJI_SIZES->{$carrier}{width};
			my $height = $EMOJI_SIZES->{$carrier}{height};
			if($ctx->stash('mtkk_is_vga_screen')) {
			    $width *= 2;
			    $height *= 2;
			}
			return qq{<img src="$src" border="0" width="$width" height="$height" />};
		}
	}
	

	my $emoji = $kdb->findEmoji($symbol);
	

	return "&$symbol;" if $emoji->{isjis} == 0;
	

	emoji_sys_tmpl($ctx, $emoji);
}


sub _hdr_KeitaiEmojiSysTmpl {
	my ($ctx, $args, $cond) = @_;


	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiEmojiSysTmpl', 'MTKeitaiSysTmpl')) unless $ctx->stash('mtkk_in_keitaikit_systmpl');


	my $symbol = $args->{symbol};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiEmojiSysTmpl', 'symbol')) if !$symbol && $symbol != 0;
	

	my $emoji = $kdb->findEmoji($symbol);
	

	emoji_sys_tmpl($ctx, $emoji);
}


sub emoji_sys_tmpl {
	my ($ctx, $emoji) = @_;
	

	my $carrier = $ctx->stash('mtkk_carrier') || 'other';
	my $spec = $ctx->stash('mtkk_spec');
	my $code;
	

	if($carrier eq 'i' && ($code = $emoji->{isjis})) {


		if($code >= 63921 || $spec->{format1} >= 400) {

			return emoji_alt($ctx, $emoji, 1) if($spec->{pict} == 1);
			return '&#x' . sprintf('%x', $emoji->{iuni}) . ';';
		} else {

			return "&#$code;";
		}
	} elsif($carrier eq 'ez' && ($code = $emoji->{ez})) {


		return emoji_alt($ctx, $emoji, 1) if($spec->{pict} == 1 && $code >= 335);

		return "<img localsrc=\"$code\" />";
	} elsif($carrier eq 's' && ($code = $emoji->{s})) {


		return emoji_alt($ctx, $emoji, 1) if($spec->{pict} == 1 && $code >= 58113);


		if(MT::App->instance->is_secure && $spec->{format1} >= 600) {

			return sprintf('&#x%x;', $code);
		} else {

			my ($c1, $c2);
			if($code >= 58625) {

				$c1 = 0x51;
				$c2 = 0x21 + $code - 58625;
			} elsif($code >= 58369) {

				$c1 = 0x50;
				$c2 = 0x21 + $code - 58369;
			} elsif($code >= 58113) {

				$c1 = 0x4f;
				$c2 = 0x21 + $code - 58113;
			} elsif($code >= 57857) {

				$c1 = 0x46;
				$c2 = 0x21 + $code - 57857;
			} elsif($code >= 57601) {

				$c1 = 0x45;
				$c2 = 0x21 + $code - 57601;
			} else {

				$c1 = 0x47;
				$c2 = 0x21 + $code - 57345;
			}
			return pack('C5', 0x1b, 0x24, $c1, $c2, 0x0f);
		}
	} else {
		return emoji_alt($ctx, $emoji, 0);
	}
}


sub _hdr_IfKeitaiCarrierSysTmpl {
	my ($ctx, $args, $cond) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTIfKeitaiCarrierSysTmpl', 'MTKeitaiKitSysTmpl')) unless $ctx->stash('mtkk_in_keitaikit_systmpl');


	my $in = $args->{in};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTIfKeitaiCarrierSysTmpl', 'in')) unless $in;
	
	my @carriers = split(/\s*,\s*/, $in);
	my $carrier = $ctx->stash('mtkk_carrier');
	
	foreach (@carriers) {
		return 1 if($_ eq $carrier);
	}
	
	0;
}


sub _hdr_IfKeitaiiXHTMLSysTmpl {
	my ($ctx, $args, $cond) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTIfKeitaiiXHTMLSysTmpl', 'MTKeitaiKitSysTmpl')) unless $ctx->stash('mtkk_in_keitaikit_systmpl');
	

	my $carrier = $ctx->stash('mtkk_carrier');
	my $spec = $ctx->stash('mtkk_spec');
	

	if($carrier eq 'i' && $spec && $spec->{format2} >= 100) {

	    $ctx->stash('mtkk_ixhtml', 1);


		if($ENV{MOD_PERL}) {
			MT::App->instance->{apache}->subprocess_env('MTKK_iXHTML', 1);
		} else {
			$ENV{MTKK_iXHTML} = 1;
		}
		return 1;
	}
	
	0;
}


sub _hdr_IfKeitaiGeneralCSSSysTmpl {
	my ($ctx, $args, $cond) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTIfKeitaiGeneralCSSSysTmpl', 'MTKeitaiKitSysTmpl')) unless $ctx->stash('mtkk_in_keitaikit_systmpl');
	

	my $carrier = $ctx->stash('mtkk_carrier');
	my $spec = $ctx->stash('mtkk_spec');
	

	return 1 if $spec && ($carrier eq 'other' || ($carrier eq 'ez' && $spec->{format1} >= 600) || ($carrier eq 's' && $spec->{format1} >= 1000));
	
	0;
}


sub _hdr_IfKeitaiKitVersionSysTmpl {
	my ($ctx, $args, $cond) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTIfKeitaiGeneralCSSSysTmpl', 'MTKeitaiKitSysTmpl')) unless $ctx->stash('mtkk_in_keitaikit_systmpl');
	

	my $over = $args->{over};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTIfKeitaiKitVersionSysTmpl', 'over')) unless $over;
	
	return 1 if $VERSION >= $over;
	
	0;
}


sub _hdr_KeitaiSearchScript {
	'plugins/KeitaiKit/search.cgi';
}


sub _hdr_KeitaiCommentScript {
	'plugins/KeitaiKit/comments.cgi';
}


sub _hdr_KeitaiCommentStaticSysTmpl {
	my ($ctx) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiCommentStaticSysTmpl', 'MTKeitaiKitSysTmpl')) unless $ctx->stash('mtkk_in_keitaikit_systmpl');


	my $app = MT::App->instance;
	$app->param('static');
}


sub _hdr_KeitaiImageSysTmpl {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	my $run_callbacks = $ctx->stash('mtkk_run_callbacks');
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiImageSysTmpl', 'MTKeitaiKitSysTmpl')) unless $ctx->stash('mtkk_in_keitaikit_systmpl');
	

	defined(my $src = $builder->build($ctx, $tokens, $cond)) ||
		return $ctx->error($ctx->errstr);
	

	if( $run_callbacks && MT->version_number >= 4.0 ) {
		$ctx->error('');
		my $html = MT->run_callbacks('keitaikit_replace_img', 0, $ctx, 'MTKeitaiImageSysTmpl', $src, $args);
		return if !defined($html) || $ctx->errstr;


		$html = undef if $html == 1;
		
		return $html if $html;
	}
	

	my $blog = $ctx->stash('blog');
	my $blog_url = $blog->site_url;
	$blog_url .= '/' if $blog_url !~ /\/$/;
	my $blog_id = $blog->id;
	my $blog_config = $ctx->stash('mtkk_blog_config') || $plugin->get_config_hash("blog:$blog_id");
	

	$src =~ s/^\s+//;
	$src =~ s/\s*$//;
	$src = MT::Util::encode_url($src);
	

	my $carrier = $ctx->stash('mtkk_carrier');
	

	my $spec = $ctx->stash('mtkk_spec');
	

	my $fit;
	my $copyright = $ctx->stash('mtkk_copyright');
	my $maximize = 'off';
	my $display = $ctx->stash('mtkk_default_display');
	my $cache_expires;
	my $magnify;
	my $style = $args->{style};
	if($style) {
		$style = $1 if $style =~ /^\s*(.+)\s*$/;
		foreach (split(/\s*;\s*/, $style)) {
			my @style = split(/\s*:\s*/, $_);
			if($style[0]) {
				$fit = $style[1] if ($style[0] eq 'keitai-crop' || $style[0] eq 'keitai-fit') && $style[1];
				$copyright = $style[1] if $style[0] eq 'keitai-copyright' && $style[1];
				$maximize = $style[1] if $style[0] eq 'keitai-maximize' && $style[1];
				$display = lc($style[1]) if $style[0] eq 'keitai-display' && $style[1];
				$cache_expires = $style[1] if $style[0] eq 'keitai-cache-expires' && $style[1] =~ /^-?[0-9]+$/;
				$magnify = $style[1] if $style[0] eq 'keitai-magnify' && $style[1];
			}
		}
	}
	

	$copyright = ($copyright eq '0' || $copyright eq 'no' || $copyright eq 'off')? 0: 1;
	

	$maximize = ($maximize eq '0' || $maximize eq 'no' || $maximize eq 'off')? 0: 1;
	

	my $image_script_url = $blog_config->{image_script_url} || ($blog_url . 'mtkkimage.php');
	$args->{src} = $image_script_url . '?mtkk_url=' . $src . '&mtkk_carrier=' . $carrier;
	if($spec) {
		my ($mtkk_sw, $mtkk_sh);
		$mtkk_sw = $spec->{bw} if $spec->{bw};
		$mtkk_sh = $spec->{bh} if $spec->{bh};
		if(defined($display) && $display eq 'screen') {
			$mtkk_sw = $spec->{sw} if $spec->{sw};
			

			if($mtkk_sw > $I_EZ_MAX_WIDTH && ($carrier eq 'i' || $carrier eq 'ez')) {
				$mtkk_sw = $I_EZ_MAX_WIDTH;
			}
		}
		
		$args->{src} .= '&mtkk_sw=' . $mtkk_sw if $mtkk_sw;
		$args->{src} .= '&mtkk_sh=' . $mtkk_sh if $mtkk_sh;
		$args->{src} .= '&mtkk_c=' . $spec->{colors} if $spec->{colors};
		$args->{src} .= '&mtkk_img=' . $spec->{img} if $spec->{img};
	}
	$args->{src} .= '&mtkk_fit=' . $fit if $fit;
	$args->{src} .= '&mtkk_copyright=' . $carrier if $copyright;
	$args->{src} .= '&mtkk_maximize=1' if $maximize;
	$args->{src} .= '&mtkk_cache_expires=' . $cache_expires if defined($cache_expires);
	$args->{src} .= '&mtkk_magnify=' . MT::Util::encode_url($magnify) if defined($magnify);
	$args->{src} .= '&mtkk_cache_size=' . ($spec->{cache} * 1024 - 1024) if $spec->{cache};
	$args->{src} .= '&mtkk_is_vga_screen=1' if $ctx->stash('mtkk_is_vga_screen');
	

	my %IMG_FORMAT = ( IMG_JPEG => 0x0001, IMG_GIF => 0x0002, IMG_PNG => 0x0008 );
	my ($ext, $img);
	$img = $spec->{img};
	if($src =~ /\.jpe?g$/i) {

		if(($img & $IMG_FORMAT{IMG_JPEG}) != 0) {
			$ext = 'jpg';
		} elsif(($img & $IMG_FORMAT{IMG_PNG}) != 0) {
			$ext = 'png';
		} else {
			$ext = 'gif';
		}
	} elsif($src =~ /\.gif$/i) {

		if(($img & $IMG_FORMAT{IMG_GIF}) != 0) {
			$ext = 'gif';
		} elsif(($img & $IMG_FORMAT{IMG_PNG}) != 0) {
			$ext = 'png';
		} else {
			$ext = 'jpg';
		}
	} elsif($src =~ /.png$/i) {

		if(($img & $IMG_FORMAT{IMG_PNG}) != 0) {
			$ext = 'png';
		} elsif(($img & $IMG_FORMAT{IMG_GIF}) != 0) {
			$ext = 'gif';
		} else {
			$ext = 'jpg';
		}
	}
	

	$args->{src} .= "&ext=dummy.$ext" if $ext;


	delete $args->{width} if substr($args->{width}, -1, 1) ne '%';
	delete $args->{height} if substr($args->{height}, -1, 1) ne '%';


	'<img ' . join(' ', map {qq($_="$args->{$_}")} grep {$_ ne '@'} keys %$args) . ' />';
}


sub _hdr_KeitaiInputStyleSysTmpl {
	my ($ctx, $args, $cond) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiInputStyleSysTmpl', 'MTKeitaiKitSysTmpl')) unless $ctx->stash('mtkk_in_keitaikit_systmpl');
	

	my $style = $args->{style};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiInputStyleSysTmpl', 'style')) unless $style;
	

	my $extra_style = $args->{extra_style} || '';
	

	my $carrier = $ctx->stash('mtkk_carrier') || 'other';
	my $model_id = $ctx->stash('mtkk_model_id') || '';
	

	my $ez_no_input_style = MT->instance->config('KeitaiEZNoInputStyle') || 'SH37,SH35';
	my %no_input_style;
	if($carrier eq 'ez') {
		%no_input_style = map { $_ => 1 } split /\s*,\s*/, $ez_no_input_style;
	}
	

	my $html = '';
	if($carrier eq 's') {
		my %modes = (1 => 'hiragana', 'katakana' => 'hankakukana', 2 => 'hankakukana', 3 => 'alphabet', 4 => 'numeric');
		my $value = exists $modes{$style}? $modes{$style}: $style;
		$html .= qq( mode="$value");
	} else {
		my %istyles = ('hiragana' => 1, 'katakana' => 2, 'hankakukana' => 2, 'alphabet' => 3, 'numeric' => 4);
		my $value = exists $istyles{$style}? $istyles{$style}: $style;
		$html .= qq( istyle="$value");
	}
	

	if(($carrier eq 'i' && $ctx->stash('mtkk_ixhtml')) || ($carrier eq 'ez' && !$no_input_style{$model_id})) {
		my %modes = (1 => 'hiragana', 'katakana' => 'hankakukana', 2 => 'hankakukana', 3 => 'alphabet', 4 => 'numeric');
		$style = exists $modes{$style}? $modes{$style}: $style;
	    my %styles = (
            'hiragana' =>    '-wap-input-format:&quot;*&lt;ja:h&gt;&quot;;-wap-input-format:*M;',
            'hankakukana' => '-wap-input-format:&quot;*&lt;ja:hk&gt;&quot;;-wap-input-format:*M;',
            'alphabet' =>    '-wap-input-format:&quot;*&lt;ja:en&gt;&quot;;-wap-input-format:*m;',
            'numeric' =>     '-wap-input-format:&quot;*&lt;ja:n&gt;&quot;;-wap-input-format:*N;',
	    );
	    my $value = exists $styles{$style}? $styles{$style}: $style;
	    $html .= qq( style="$value$extra_style");
	}
	
	$html;
}




sub _hdr_KeitaiLineGroup {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	$args->{branch} = $plugin->translate('LineBranch') unless $args->{branch};
	$args->{last} = $plugin->translate('LineLast') unless $args->{last};
	$args->{pipe} = $plugin->translate('LinePipe') unless $args->{pipe};
	$args->{blank} = $plugin->translate('LineBlank') unless $args->{blank};
	local $ctx->{__stash}->{mtkk_line_indents} = [];
	

	defined(my $result = $builder->build($ctx, $tokens, $cond)) ||
		return $ctx->error($ctx->errstr);
	

	my $indents = $ctx->stash('mtkk_line_indents');
	my @lines = ();
	my $last_indent = 0;
	my @last_line = ();
	my $i;
	while(defined(my $indent = pop @$indents)) {

		$indent++;


		my @line = ('blank') x $indent;

		if($indent == $last_indent) {

			for($i = 0; $i < $last_indent - 1; $i++) { $line[$i] = $last_line[$i]; }
			$line[$i] = $last_line[$i] eq 'blank'? 'blank': 'branch';
		} elsif($indent < $last_indent) {

			for($i = 0; $i < $indent - 1; $i++) { $line[$i] = $last_line[$i]; }
			$line[$i] = $last_line[$i] eq 'blank'? 'last': 'branch';
		} elsif($indent > $last_indent) {

			for($i = 0; $i < $last_indent; $i++) { $line[$i] = $last_line[$i] eq 'blank'? 'blank': 'pipe'; }
			$line[$indent - 1] = 'last';
		}
		

		unshift @lines, \@line;

		$last_indent = $indent;
		@last_line = @line;
	}
	

	my @blocks = split(/<!--mtkk_line-->/, $result);
	$result = shift @blocks;
	
	while(my $block = shift @blocks) {
		my $line = shift @lines;
		for (@$line) { $result .= $args->{$_}; }
		$result .= $block;
	}
	
	$result;
}


sub _hdr_KeitaiLineNode {
	my ($ctx) = @_;
	my $node = '';
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiLineNode', 'MTKeitaiLineGroup')) unless $ctx->stash('mtkk_line_indents');
	

	push @{$ctx->{__stash}->{mtkk_line_indents}}, $ctx->stash('subCatsDepth') || 0;
	
	return '<!--mtkk_line-->';
}


sub _hdr_KeitaiCycle {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	return $ctx->error($plugin->translate('Cannot use [_1] inside [_2]', 'MTKeitaiCycle', 'MTKeitaiCycle')) if $ctx->stash('mtkk_in_cycle');
	

	my $delimiter = $args->{delimiter} || '\\s*,\\s*';
	delete $args->{delimiter};


	my @keys = ();
	@keys = grep {$_ ne '@'} keys %$args if $args;
	

	return $ctx->error($plugin->translate('At least one attribute required in [_1]', 'MTKeitaiCycle')) if (scalar @keys) == 0;
	
	foreach (@keys) {
		my @values = ();
		@values = split(/$delimiter/, $args->{$_}) if defined($args->{$_});
		

		return $ctx->error($plugin->translate('No values for attribute [_2] in [_1]', 'MTKeitaiKit', $_)) if (scalar @values) == 0;

		$args->{$_} = \@values;
	}
	$ctx->stash('mtkk_cycles', $args);
	$ctx->stash('mtkk_in_cycle', 1);
	

	defined(my $result = $builder->build($ctx, $tokens, $cond)) ||
		return $ctx->error($ctx->errstr);

	$ctx->{__stash}->{mtkk_cycle_index}++;
	$ctx->stash('mtkk_in_cycle', 0);
	
	return $result;
}


sub _hdr_KeitaiCycleValue {
	my ($ctx, $args) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiCycleValue', 'MTKeitaiCycle')) unless $ctx->stash('mtkk_in_cycle');
	

	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiCycleValue', 'cycle')) unless my $cycle = $args->{cycle};
	

	my $cycles = $ctx->stash('mtkk_cycles') || {};
	my $values = $cycles->{$cycle} || [];
	

	return $ctx->error($plugin->translate('Cycle array [_1] is not defined', $cycle)) if @$values == 0;
	
	my $index = $ctx->stash('mtkk_cycle_index') || 0;
	$values->[$index % @$values];
}


sub _hdr_KeitaiInclude {
	my ($ctx, $args) = @_;
	$ctx->stash('mtkk_include_args', $args);


	if($IS_MT5) {
		MT::Template::Tags::System::_hdlr_include(@_);
	} else {
		MT::Template::Context::_hdlr_include(@_);
	}
}


sub _hdr_KeitaiIncludeArg {
	my ($ctx, $args) = @_;


	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiIncludeArg', 'arg')) unless my $cycle = $args->{arg};
	

	my $default = $args->{default} || '';
	

	my $include_args = $ctx->stash('mtkk_include_args');
	
	my $value = (!defined($include_args) || !defined($include_args->{$args->{arg}}))? $default : $include_args->{$args->{arg}};
	
	build_value($ctx, $value);
}


sub _hdr_KeitaiFunctionDef {
	my ($ctx, $args, $cond) = @_;
	

	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiFunctionDef', 'name')) unless my $name = $args->{name};
	

	my $key = 'mtkk_function_' . $name;
	$ctx->{__stash}{$key} = $ctx->stash('uncompiled');
	
	'';
}


sub _hdr_KeitaiFunction {
	my ($ctx, $args) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiFunction', 'name')) unless my $name = $args->{name};
	delete $args->{name};
	

	my $key = 'mtkk_function_' . $name;
	my $function = $ctx->{__stash}{$key} || return '';
	

	my @vars = keys %$args;
	my %saved_vars = map { $_ => $ctx->{__stash}{vars}{$_} } @vars;
	$ctx->{__stash}{vars}{$_} = $args->{$_} foreach @vars;
	

	my $tok = $builder->compile($ctx, $function);
	defined(my $result = $builder->build($ctx, $tok)) ||
		return $ctx->error($plugin->translate('An error occurred in function [_1]', $name) . ': ' . $ctx->errstr);
	

	$ctx->{__stash}{vars}{$_} = $saved_vars{$_} foreach @vars;
	
	$result;
}


sub _hdr_KeitaiBlockDef {
	my ($is_header, $ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	my $class = $args->{class} || $args->{name};
	return $ctx->error($plugin->translate('[_1] requires at least any attribute in [_2]', 'MTKeitaiBlock' . ($is_header? 'Header': 'Footer'), 'class, name')) unless $class;
	

	my $stash = 'mtkk_block_';
	$stash .= $is_header? 'headers': 'footers';
	$ctx->{__stash}{$stash}{$class} = $ctx->stash('uncompiled');
	
	'';
}


sub _hdr_KeitaiBlock {
	my ($ctx, $args, $cond) = @_;
	my $builder = $ctx->stash('builder');
	my $tokens = $ctx->stash('tokens');
	

	my $class = $args->{class} || $args->{name};
	my $cycle = $args->{cycle};
	return $ctx->error($plugin->translate('[_1] requires at least any attribute in [_2]', 'MTKeitaiBlock', 'class, cycle, name')) unless $class || $cycle;
	

	delete $args->{$_} foreach (qw/class cycle/);


	my $visualize = MT->instance->config('KeitaiVisualizeBlock') || 0;


	if($cycle) {

		return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'cycle', 'MTKeitaiCycle')) unless $ctx->stash('mtkk_in_cycle');
		
		my $cycles = $ctx->stash('mtkk_cycles') || {};
		my $values = $cycles->{$cycle} || [];


		return $ctx->error($plugin->translate('Cycle array [_1] is not defined', $cycle)) if @$values == 0;
		
		my $index = $ctx->stash('mtkk_cycle_index') || 0;
		$class = $values->[$index % @$values];
	}
	

	$ctx->{__stash}{mtkk_block_headers} ||= {};
	$ctx->{__stash}{mtkk_block_footers} ||= {};
	

	my @vars = keys %$args;
	my %saved_vars = map { $_ => $ctx->{__stash}{vars}{$_} } @vars;
	$ctx->{__stash}{vars}{$_} = $args->{$_} foreach @vars;
	

	my $header = $ctx->{__stash}{mtkk_block_headers}{$class} || '';
	my $footer = $ctx->{__stash}{mtkk_block_footers}{$class} || '';
	my $uncompiled = $ctx->stash('uncompiled') || '';
	
	my $template = $header . $uncompiled . $footer;
	my $tok = $builder->compile($ctx, $template);
	defined(my $result = $builder->build($ctx, $tok, $cond)) ||
		return $ctx->error($plugin->translate('An error occurred in block [_1]', $class) . ': ' . $ctx->errstr);
		

	if($visualize) {
		$result = sprintf('<div style="padding:0px;margin:4px;border:1px red solid;"><div style="margin:0px;padding:0px;"><span style="margin:0px;background-color:red;color:white;">%s</span></div>%s</div>', $class, $result);
	}


	$ctx->{__stash}{vars}{$_} = $saved_vars{$_} foreach @vars;

	$result;
}


sub _hdr_KeitaiInputStyle {

	return _hdr_KeitaiInputStyleSysTmpl(@_) if is_dynamic;

	my ($ctx, $args, $cond) = @_;
	

	my $style = $args->{style};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiInputStyle', 'style')) unless $style;
	

	my $extra_style = $args->{extra_style} || '';
	

	$style =~ s/'/\\'/g;
	$extra_style = s/'/\\'/g;
	
	"<?php mtkk_input_style('$style', '$extra_style'); ?>";
}




sub _hdr_KeitaiIfAddToFavoritesEnabled {
	my ($ctx, $args, $cond) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiIfAddToFavoritesEnabled', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');


	my $if = "\$mtkk_carrier == 'ez'";
	write_php_if('MTKeitaiIfAddToFavoritesEnabled', $if, $ctx, $args, $cond);
}


sub _hdr_KeitaiAddToFavoritesLink {
	my ($ctx, $args, $cond) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiAddToFavoritesLink', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');


	my $blog = $ctx->stash('blog');
	my $url = $args->{url};
	$url = '<?php echo(mtkk_current_url()); ?>' unless $url;
	my $title = build_value($ctx, $args->{title}) || $blog->name;
	
	"device:home/bookmark?url=$url&amp;title=$title";
}


sub _hdr_KeitaiIfSendToFriendEnabled {
	my ($ctx, $args, $cond) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiIfSendToFriendEnabled', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');


	my $if = "(\$mtkk_carrier == 'i' && (\$mtkk_spec['format1'] >= 300 || \$mtkk_spec['format2'] >= 100))" .
		"|| (\$mtkk_carrier == 'ez')  || (\$mtkk_carrier == 's' && \$mtkk_spec['format1'] > 2) || (\$mtkk_carrier == 'other')";
	write_php_if('MTKeitaiIfSendToFriendEnabled', $if, $ctx, $args, $cond);
}


sub convert_and_encode_url {
	my ($string, $charset) = @_;
	

	if($IS_MT5) {
		$charset = encode_reverse_mapping($charset);
		$string = MT::I18N::encode_text($string, 'UTF-8', $charset);
		$string =~ s/([^\w ])/'%' . unpack('H2', $1)/eg;
		$string =~ tr/ /+/;
		return $string;
	}
	
	my $internal = internal_charset;

	$string = Unicode::Japanese->new($string, $internal)->$charset;
	MT::Util::encode_url($string);
}


sub _hdr_KeitaiSendToFriendLink {
	my ($ctx, $args, $cond) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiSendToFriendLink', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');


	my $blog = $ctx->stash('blog');


	my ($subject, $subject_url);
	$subject = build_value($ctx, $args->{subject}) || $blog->name;
	my $subject_url_sjis = convert_and_encode_url($subject, 'sjis');
	my $subject_url_utf8 = convert_and_encode_url($subject, 'utf8');
	$subject_url = qq{<?php echo((\$mtkk_carrier == 's' && \$mtkk_spec['format1'] >= 1100)?'$subject_url_utf8': '$subject_url_sjis'); ?>};


	my ($body, $body_url);
	if($args->{body}) {

		$body = build_value($ctx, $args->{body});
		$body =~ s/<br\s*\/?>/\n/gi;
		$body =~ s/%n/\n/gi;
		$body =~ s/\\n/\n/gi;
		my $body_url_sjis = convert_and_encode_url($body, 'sjis');
		my $body_url_utf8 = convert_and_encode_url($body, 'utf8');
		$body_url = qq{<?php echo((\$mtkk_carrier == 's' && \$mtkk_spec['format1'] >= 1100)?'$body_url_utf8': '$body_url_sjis'); ?>};
	} else {

		$body = '<?php echo(htmlentities(mtkk_current_url(), ENT_QUOTES)); ?>';
		$body_url = '<?php echo(urlencode(mtkk_current_url())); ?>';
	}
	
	"mailto:?subject=$subject_url&body=$body_url\" mailbody=\"$subject: $body";
}


sub _search_supported {
	my ($ctx, $carrier) = @_;


	my $blog = $ctx->stash('blog');
	my $blog_id = $blog->id;
	my $blog_config = $ctx->stash('mtkk_blog_config') || $plugin->get_config_hash("blog:$blog_id");
	

	my $mt = MT->instance;
	my $mt_path = $mt->mt_dir;
	my $plugin_dir = File::Spec->catdir($mt_path, $plugin->envelope);
	my $db_path = File::Spec->catdir($plugin_dir, 'db');
	

	require KeitaiDB;
	my $kdb = KeitaiDB->new($db_path);
	

	my ($supported, $include, $exclude);


	$include = [split(/\s*,\s*/, $blog_config->{supported_include}{$carrier})];
	$exclude = [split(/\s*,\s*/, $blog_config->{supported_exclude}{$carrier})];

	if($carrier eq 'i') {

		$supported = $kdb->searchSpec($carrier, $blog_config->{supported_format}{i}, $blog_config->{supported_format}{ix}, $include, $exclude);
	} else {

		$supported = $kdb->searchSpec($carrier, $blog_config->{supported_format}{$carrier}, 0, $include, $exclude);
	}

	$supported;
}


sub _hdr_KeitaiSupportedModels {
	my ($ctx, $args) = @_;
	
	use MT::Util;
	

	my $carrier = $args->{carrier};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiSupportedModels', 'carrier')) unless $carrier;

	my $glue = MT::Util::decode_html($args->{glue}) || '/';
	

	my $supported = _search_supported($ctx, $carrier);


	my @models = map { $_->{model} } @$supported;
	my $models = convert_from_utf8(join($glue, @models));
	
	$models;
}


sub _hdr_KeitaiSessionID {
	my ($ctx, $args) = @_;
	
	if(is_dynamic()) {

		_hdr_KeitaiSessionIDSysTmpl(@_);
	} else {

		return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiSessionID', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');

		'<?php echo $mtkk_session_id; ?>';
	}
}


sub _hdr_KeitaiSessionIDSysTmpl {
	my ($ctx, $args) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiSessionIDSysTmpl', 'MTKeitaiKitSysTmpl')) unless $ctx->stash('mtkk_in_keitaikit_systmpl');
	

	my $blog = $ctx->stash('blog');
	my $blog_id = $blog->id;
	my $blog_config = $ctx->stash('mtkk_blog_config') || $plugin->get_config_hash("blog:$blog_id");
	
	my $app = MT->instance;
	$app->param($blog_config->{session_param}) || '';
}


sub _hdr_KeitaiSessionName {
	my ($ctx, $args) = @_;
	
	if(is_dynamic()) {

		_hdr_KeitaiSessionNameSysTmpl(@_);
	} else {

		return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiSessionName', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');

		'<?php echo $mtkk_session_param; ?>';
	}
}


sub _hdr_KeitaiSessionNameSysTmpl {
	my ($ctx, $args) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiSessionNameSysTmpl', 'MTKeitaiKitSysTmpl')) unless $ctx->stash('mtkk_in_keitaikit_systmpl');
	

	my $blog = $ctx->stash('blog');
	my $blog_id = $blog->id;
	my $blog_config = $ctx->stash('mtkk_blog_config') || $plugin->get_config_hash("blog:$blog_id");
	
	$blog_config->{session_param};
}


sub _hdr_KeitaiSessionInclude {
	my ($ctx, $args) = @_;
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTKeitaiSessionInclude', 'MTKeitaiKit')) unless $ctx->stash('mtkk_in_keitaikit');


	my $php = $args->{php};
	return $ctx->error($plugin->translate('[_1] requires [_2] attribute', 'MTKeitaiSessionInclude', 'php')) unless $php;
	
	"<?php mtkk_session_include('$php'); ?>";
}


sub _str_to_rgb {
	my ( $ctx, $color, $default ) = @_;
	

	return $default unless $color;
	

	if(defined($ctx->{__stash}{mtkk_rgb_map}{$color})) {
		return $ctx->{__stash}{mtkk_rgb_map}{$color};
	}
	

	if( $color =~ /^#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})$/i ) {
		my $rgb = { r => hex( $1 ), g => hex( $2 ), b => hex( $3 ) };
		$ctx->{__stash}{mtkk_rgb_map}{$color} = $rgb;
		return $rgb;
	}
	

	if( $color =~ /^#?([0-9a-f])([0-9a-f])([0-9a-f])$/i ) {
		my $rgb = { r => hex( $1.$1 ), g => hex( $2.$2 ), b => hex( $3.$3 ) };
		$ctx->{__stash}{mtkk_rgb_map}{$color} = $rgb;
		return $rgb;
	}
	
	$default || { r => 0x00, g => 0x00, b => 0x00 };
}


sub _tag_rate {
	my ($tag, $ctx, $args, $cond) = @_;
	

	my $min = $ctx->stash('tag_min_count');
	my $max = $ctx->stash('tag_max_count');
	my $count = $ctx->stash('tag_entry_count');
	unless (defined $min && defined $max && defined $count) {
		if($IS_MT5) {
			require MT::Template::Tags::Tag;
			MT::Template::Tags::Tag::_hdlr_tag_rank( @_ );
		} else {
			MT::Template::Context::_hdlr_tag_rank( @_ );
		}
		$min = $ctx->stash('tag_min_count');
		$max = $ctx->stash('tag_max_count');
		$count = $ctx->stash('tag_entry_count');
	}
	

	my $rate = ( $max == $min )? 1: ( $count - $min ) / ( $max - $min );
	$rate = 0.0 if $rate < 0.0;
	$rate = 1.0 if $rate > 1.0;

	$rate;
}


sub _hdr_KeitaiTagColor {
	my ($ctx, $args) = @_;
	
	my $tag = $ctx->stash('Tag');
	return '' unless $tag;
	

	my $min_color = _str_to_rgb( $ctx, $args->{min}, { r => 0x88, g => 0x88, b => 0xff } );
	my $max_color = _str_to_rgb( $ctx, $args->{max}, { r => 0x00, g => 0x00, b => 0xff } );
	

	my $rate = _tag_rate($tag, @_);
	

	return sprintf('#%02lX%02lX%02lX',
		int( $min_color->{r} + ( $max_color->{r} - $min_color->{r} ) * $rate ),
		int( $min_color->{g} + ( $max_color->{g} - $min_color->{g} ) * $rate ),
		int( $min_color->{b} + ( $max_color->{b} - $min_color->{b} ) * $rate ) );
}


sub _hdr_KeitaiTagFontSize {
	my ($ctx, $args) = @_;
	
	my $tag = $ctx->stash('Tag');
	return '' unless $tag;
	

	my $sizes = $args->{sizes} || '1,2,3,4,5,6';
	my @sizes = split(/\s*,\s*/, $sizes);
	

	my $rate = _tag_rate($tag, @_);
	

	my $index = int( (scalar @sizes - 1) * $rate );
	
	return $sizes[$index];
}


sub _hdr_KeitaiTagSearchLink {
	my ($ctx, $args) = @_;
	
	my $tag = $ctx->stash('Tag');
	
	my $search_script = _hdr_KeitaiSearchScript;
	

	my $default_search_script;
	if(MT->version_number >= 4) {
		$default_search_script = $ctx->{config}->SearchScript;
		$ctx->{config}->SearchScript( $search_script );
	} else {
		$default_search_script = MT::ConfigMgr->instance->SearchScript;
		MT::ConfigMgr->instance->SearchScript( $search_script );
	}
	
	my $result;


	if($IS_MT5) {

		my $default_charset = $ctx->{config}->PublishCharset;
		$ctx->{config}->PublishCharset('Shift_JIS');
		

		$result = MT::Template::Tags::Tag::_hdlr_tag_search_link( @_ );
		

		$ctx->{config}->PublishCharset($default_charset);
	} else {

		my $default_tag_name = $tag->name;
		my $tag_name = $default_tag_name;
		convert_encoding(\$tag_name, 'sjis');
		$tag->name( $tag_name );
		
		$result = MT::Template::Context::_hdlr_tag_search_link( @_ );
		

		$tag->name( $default_tag_name );
	}
	

	if(MT->version_number >= 4) {
		$ctx->{config}->SearchScript( $default_search_script );
	} else {
		MT::ConfigMgr->instance->SearchScript( $default_search_script );
	}

	$result;
}


sub _hdr_KeitaiIfSmartphone {
	my ($ctx, $args, $cond) = @_;
	my ($os, $version);
	$os = $args->{os};
	$version = $args->{version};
	

	return $ctx->error($plugin->translate('[_2] attribute requires [_3] attribute at [_1]', 'MTKeitaiIfSmartphone', 'version', 'os'))
	    if($version && !$os);
	

	my $if = q{(isset($mtkk_smartphone) && $mtkk_smartphone)};
	$if .= sprintf(q{ && (isset($mtkk_smartphone['os']) && strtolower($mtkk_smartphone['os']) == '%s')}, lc($os)) if $os;
	$if .= sprintf(q{ && (isset($mtkk_smartphone['os_version']) && $mtkk_smartphone['os_version'] >= %f)}, $version) if $version;
	
	write_php_if('MTKeitaiIfSmartphone', $if, @_);
}

sub _hdr_IfKeitaiSmartphone {
	my ($ctx, $args, $cond) = @_;
	my ($os, $version);
	$os = $args->{os};
	$version = $args->{version};
	

	return $ctx->error($plugin->translate('Use [_1] inside [_2]', 'MTIfKeitaiSmartphone', 'MTKeitaiSysTmpl')) unless $ctx->stash('mtkk_in_keitaikit_systmpl');


	return $ctx->error($plugin->translate('[_2] attribute requires [_3] attribute at [_1]', 'MTKeitaiIfSmartphone', 'version', 'os'))
		if($version && !$os);
	

	my $smartphone = $ctx->stash('mtkk_smartphone') || return 0;
	return 0 if $os && lc($smartphone->{'os'}) ne lc($os);
	return 0 if $version && $smartphone->{'os_version'} < $version;
	
	return 1;
}

sub _hdr_IfCommentEmojiAllowed {
	my ($ctx, $args, $cond) = @_;
	my $blog = $ctx->stash('blog') || return 0;
	my $blog_id = $blog->id;
	my $blog_config = $ctx->stash('mtkk_blog_config') || $plugin->get_config_hash("blog:$blog_id");
	
	return $blog_config->{accept_comment_emoji}? 1: 0;
}


sub build_value {
	my ($ctx, $value) = @_;

	$value = '' unless defined($value);
	$value =~ s/(?<!\\)\[/</g;
	$value =~ s/(?<!\\)\]/>/g;
	$value =~ s/(?<!\\)'/"/g;


	$value =~ s/\\([\[\]'])/$1/g; #'
	 

	if ($value =~ /<MT/) {
		my $builder = $ctx->stash('builder');
		my $tok = $builder->compile($ctx, $value);
		$value = $builder->build($ctx, $tok);
		return $ctx->error($builder->errstr) unless defined($value);
	}

	return $value;
}


1;