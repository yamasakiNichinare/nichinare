package KeitaiKit::App::Search;
use strict;

use Unicode::Japanese qw(PurePerl);
use MT::I18N;
use KeitaiKit::SysTmpl;
use MT::App::Search;
@KeitaiKit::App::Search::ISA = qw( MT::App::Search );

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods( search => \&execute );
    $app->{default_mode} = 'search';
    $app;
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
    my %enabled = map { $_ => 1 } values %$mapping;
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
    


    $app->SUPER::init_request(@_) if MT->version_number !~ /^3\.2/;
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


    my $ctx = MT::App::Search::Context->new;
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

sub execute {
    my $app = shift;


    my $res = $app->SUPER::execute(@_);
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

1;