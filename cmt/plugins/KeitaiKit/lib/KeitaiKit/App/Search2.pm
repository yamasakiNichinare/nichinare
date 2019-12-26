package KeitaiKit::App::Search2;
use strict;

use Unicode::Japanese qw(PurePerl);
use MT::I18N;
use KeitaiKit::SysTmpl;
use MT::App::Search;
@KeitaiKit::App::Search2::ISA = qw( MT::App::Search );


sub core_methods {
    my $app = shift;
    return {
        'default' => \&process,
        'tag'     => '$Core::MT::App::Search::TagSearch::process',
    };
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
    my $blog_id = $app->param('blog_id');
    

    my @params = $app->param->param();
    my $str = '';
    foreach my $param (@params) {
        $str .= $app->param($param);
    }
    $charset = MT::I18N::guess_encoding( $str );
    $charset = $mapping->{$charset} || 'sjis';
    $charset = 'sjis' if $charset eq 'euc';
    

    foreach my $param (@params) {
        my $value = $app->param($param);
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
    

    $app->SUPER::init_request(@_);
}


sub render_error {
    my $app = shift;
    

    my $title = $app->plugin->translate('KeitaiKit for Movable Type');
    my $lead = $app->plugin->translate('An error occurred');
    my $footer = $app->plugin->translate('Back to previous page');
    my $tmpl = <<"TMPL";
<MTKeitaiKitSysTmpl>
<html>
<head>
<title>$title</title>
</head>
<body>
<p>$lead:</p>
<p><\$MTKeitaiErrStrSysTmpl\$></p>
<p>$footer</p>
</body>
</html>
</MTKeitaiKitSysTmpl>
TMPL


    my $ctx = MT::Template::Context->new;
    $ctx->stash('blog', MT::Blog->load);
    $ctx->stash('mtkk_errstr', $app->errstr);

    require MT::Builder;
    my $build = MT::Builder->new;
    my $tokens = $build->compile($ctx, $tmpl)
        or return $app->error($app->translate(
            "Building results failed: [_1]", $build->errstr));
    defined(my $res = $build->build($ctx, $tokens, { }))
        or return $app->error($app->translate(
            "Building results failed: [_1]", $build->errstr));
            
    $res;
}

sub process {
    my $app = shift;
    

    my $limit = $app->param('limit') || MT->instance->config('KeitaiSearchMaxResults') || MT->instance->config('SearchMaxResults') || undef;
    $app->param('limit', $limit) if $limit;
    

    $app->config->set('SearchCacheTTL', -1);
    

    my $res = $app->SUPER::process(@_);

    return $res if $res;

    return $app->render_error;
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
    my $encoding;
    if($ENV{MOD_PERL}) {
        $cache_control = $app->{apache}->subprocess_env('MTKK_CACHE_CONTROL');
        $encoding = $app->{apache}->subprocess_env('MTKK_OUTPUT_ENCODING');
    } else {
        $cache_control = $ENV{MTKK_CACHE_CONTROL};
        $encoding = $ENV{MTKK_OUTPUT_ENCODING};
    }
    $app->set_header('Cache-Control', $cache_control) if $cache_control;
    

    $app->charset($encoding || 'Shift_JIS');
    
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
