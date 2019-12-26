package KeitaiKit::App::Comments;
use strict;

use Unicode::Japanese qw(PurePerl);
use MT::I18N;
use KeitaiKit::SysTmpl;
use MT::App::Comments;
@KeitaiKit::App::Comments::ISA = qw( MT::App::Comments );


sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        preview => \&preview,
        post => \&post,
    );
    $app;
}


sub convert_emoji_s_webcode {
    my @webcodes = unpack('n*', shift);
    my $result = '';
    
    foreach (@webcodes) {
        $result .= sprintf('&w%x;', $_);
    }
    
    $result;
}


sub convert_emoji {
	$_ = shift;
	my $carrier = shift;
	my ($i, $ez, $s) = ($carrier eq 'i'? 1: 0, $carrier eq 'ez'? 1: 0, $carrier eq 's'? 1: 0);
	

	if($s) {
    	s/\x1b\x24([^\x0f])+\x0f/&convert_emoji_s_webcode($1);/ge;
	}
	

	my @chars = split(//, $_);
	my $result = '';
	my $part = '';
	while(defined(my $c = shift @chars)) {

	    if($c =~ m/[\x81-\x9f\xe0-\xff]/) {
	        $part = $c . shift(@chars);
	        if($i && $part =~ /^\xf8[\x9f-\xfc]|\xf9[\x40-\xfc]$/) {

	            $result .= '&i'.uc(unpack('H4', $part)).';';
	        } elsif($ez && $part =~ /^[\xf3\xf6\xf7][\x40-\xfc]|\xf4[\x40-\x93]$/) {

	            $result .= '&ez'.uc(unpack('H4', $part)).';';
	        } elsif($s && $part =~ /^[\xf7\xf9\xfb][\x41-\xf3]$/) {

	            $result .= '&s'.uc(unpack('H4', $part)).';';
	        } else {
	            $result .= $part;
	        }
	    } else {

	        $result .= $c;
	    }
	}
    
    $result;
}


sub _url_encode_all {
    my $str = shift;
    
    $str =~ s/[\x00-\x1f\x21-\xff]/'%'.unpack('H2',$&)/eg;
    $str =~ tr/ /+/;
    $str;
}


sub _comment_detail_information {
    my $app = shift;
    my ($original_post) = @_;

    my $plugin = MT::Plugin::KeitaiKit->instance;
    
    my $user_ip = $app->remote_ip;
    my $user_agent = $ENV{MOD_PERL}? $app->{apache}->subprocess_env('HTTP_USER_AGENT', 1): $ENV{HTTP_USER_AGENT};
    
    $plugin->translate('IP address:"[_1]" User Agent:"[_2]" URL encoded author:"[_3]" URL encoded email:"[_4]" URL encoded text:"[_5]"',
        $user_ip,
        $user_agent,
        _url_encode_all($original_post->{author} || ''),
        _url_encode_all($original_post->{email} || ''),
        _url_encode_all($original_post->{text} || '')
    );
}


sub init_request {
    my $app = shift;
    

    if($ENV{MOD_PERL}) {
    	$app->{apache}->subprocess_env('MTKK_DYNAMIC', 1);
    } else {
	    $ENV{MTKK_DYNAMIC} = 1;
	}
    

    $app->MT::App::init_request(@_);
    

    my $internal_charset = MT->instance->config('PublishCharset');
    my $mapping = {'shift_jis' => 'sjis', 'shiftjis' => 'sjis', 'sjis' => 'sjis', 'euc-jp' => 'euc', 'euc' => 'euc', 'utf-8' => 'utf8', 'utf8' => 'utf8'};
    my $internal = $mapping->{lc($internal_charset)} || 'utf8';
    my $charset = 'sjis';
    my $accept_comment_emoji;
    my $blog_id = $app->param('blog_id');
    my $plugin = MT::Plugin::KeitaiKit->instance;
    my $system_config = $plugin->get_config_hash;
    

    unless($blog_id) {
        my $entry_id = $app->param('entry_id');
        if($entry_id) {
            my $e = MT::Entry->load($entry_id);
            $blog_id = $e->blog_id if $e;
        }
    }
    

    if($blog_id) {
        my $blog_config = $plugin->get_config_hash("blog:$blog_id");
        $accept_comment_emoji = defined($blog_config->{accept_comment_emoji})? $blog_config->{accept_comment_emoji}: 0;
    }
    

    if($ENV{MOD_PERL}) {
        $_ = MT::App->instance->{apache}->subprocess_env('HTTP_USER_AGENT');
    } else {
        $_ = $ENV{HTTP_USER_AGENT};
    }
    my $carrier;
    if(/^DoCoMo\/1\.0\/([^\/]+)/i || /^DoCoMo\/2\.0 ([^\(]+)/i) {
        $carrier = 'i';
    } elsif(/^KDDI\-([^ ]+)/i) {
        $carrier = 'ez';
    } elsif(/^SoftBank\/[^\/]+\/([^\/]+)/i || /^J\-PHONE\/[^\/]+\/([^\/]+)/i || /^Vodafone\/[^\/]+\/([^\/]+)/i || /^J\-EMULATOR\/[^\/]+\/([^\/]+)/i || /^MOT\-([^\/]+)\/80.2F.2E.MIB/i) {
        $carrier = 's';
    } else {
        $carrier = 'other';
    }
    

    my $is_emoji_denied = 0;
    foreach my $param (qw(author text)) {

        my $value = $app->param($param);
        my $converted = convert_emoji($value, $carrier);
        if($value ne $converted) {
            if($accept_comment_emoji) {

                $app->param($param, $converted);
            } else {

                $is_emoji_denied = 1;
                last;
            }
        }
    }
    

    if($ENV{MOD_PERL}) {
        $app->{apache}->subprocess_env('MTKK_EMOJI_DENIED', $is_emoji_denied);
    } else {
        $ENV{MTKK_EMOJI_DENIED} = $is_emoji_denied;
    }
    

    my @params = $app->param->param();
    my $str = '';
    foreach my $param (@params) {
        $str .= $app->param($param);
    }
    $charset = MT::I18N::guess_encoding( $str );
    $charset = $mapping->{$charset} || 'sjis';
    $charset = 'sjis' if $charset eq 'euc';
    

    my $original_post = {};
    foreach my $param (@params) {
        my $value = $app->param($param);
        

        $original_post->{$param} = $value;

        my $s = Unicode::Japanese->new($value, $charset);
        $s->h2zKana;
        $value = $s->$internal;
        $app->param($param, $value);
    }
    



    if($ENV{MOD_PERL}) {
        $_ = MT::App->instance->{apache}->subprocess_env('CONTENT_TYPE');
        s/;[ ]*charset=.+($|;)/; charset=$internal_charset$1/;
        MT::App->instance->{apache}->subprocess_env('CONTENT_TYPE', $_);
    } else {
        $ENV{'CONTENT_TYPE'} =~ s/;[ ]*charset=.+($|;)/; charset=$internal_charset$1/;
    }
    

    $app->{default_mode} = 'view';
    my $q = $app->param;

    if ($q->param('post') || $q->param('post_x') ||
        $q->param('post.x')) {
        $app->mode('post');
    } elsif ($q->param('preview') || $q->param('preview_x') ||
        $q->param('preview.x')) {
        $app->mode('preview');
    }


    if($system_config->{log_comment_detail}) {
        my $mode = $app->mode || '';
        if($is_emoji_denied) {
            $app->log({
                message => sprintf('%s(%s)',
                    $plugin->translate('Comment is denied because used emoji'), 
                    $app->_comment_detail_information($original_post)
                ),
                blog_id => $blog_id || 0,
                level   => MT::Log::ERROR(),
            });
        } elsif($mode eq 'post') {
            $app->log({
                message => sprintf('%s(%s)',
                    $plugin->translate('Posting comment from mobile device'), 
                    $app->_comment_detail_information($original_post)
                ),
                blog_id => $blog_id || 0,
                level   => MT::Log::INFO(),
            });
        }
    }
}

sub post {
    my $app = shift;


    my $is_emoji_denied = 1;
    if($ENV{MOD_PERL}) {
        $is_emoji_denied = MT::App->instance->{apache}->subprocess_env('MTKK_EMOJI_DENIED');
    } else {
        $is_emoji_denied = $ENV{MTKK_EMOJI_DENIED};
    }


    if($is_emoji_denied) {
        my $plugin = MT::Plugin::KeitaiKit->instance;
        return $app->handle_error($plugin->translate('Emoji is denied in comment.'));
    }
    
    return $app->SUPER::post(@_);
}

sub preview {
    my $app = shift;


    my $is_emoji_denied = 1;
    if($ENV{MOD_PERL}) {
        $is_emoji_denied = MT::App->instance->{apache}->subprocess_env('MTKK_EMOJI_DENIED');
    } else {
        $is_emoji_denied = $ENV{MTKK_EMOJI_DENIED};
    }


    if($is_emoji_denied) {
        my $plugin = MT::Plugin::KeitaiKit->instance;
        return $app->handle_error($plugin->translate('Emoji is denied in comment.'));
    }

    return $app->SUPER::preview(@_);
}

sub post_run {
	my $app = shift;


    my $iXHTML;
    if($ENV{MOD_PERL}) {
    	$iXHTML = $app->{apache}->subprocess_env('MTKK_iXHTML');
    } else {
    	$iXHTML = $ENV{MTKK_iXHTML};
    }
    
    $app->set_header('Content-Type', 'application/xhtml+xml') if $iXHTML;
    

    my $cache_control;
    if($ENV{MOD_PERL}) {
    	$cache_control = $app->{apache}->subprocess_env('MTKK_CACHE_CONTROL');
    } else {
    	$cache_control = $ENV{MTKK_CACHE_CONTROL};
    }
    $app->set_header('Cache-Control', $cache_control) if $cache_control;
    

    $app->charset('Shift_JIS');
    
    1;
}

sub plugin {
	MT::Plugin::KeitaiKit->instance;
}


sub translate_templatized {
    my $app = shift;
    $app->plugin->translate_templatized(@_);
}


sub print_encode {
    my $app = shift;
    my $enc = $app->charset || 'UTF-8';
    my $result = Encode::encode( $enc, $_[0] );


    $result =~ s/&#x\[([0-9a-f]+)\];/{pack('C*', map { hex($_) } ($1 =~ m!.{2}!g));}/ige;
    
    $app->print($result);
}

1;