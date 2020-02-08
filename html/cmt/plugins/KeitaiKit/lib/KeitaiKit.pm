package KeitaiKit;

use strict;
use base 'MT::App';
use vars qw($VERSION $MT_VERSION);

$VERSION = '1.62';
$MT_VERSION = MT->version_number;

use File::Spec;
use LWP::UserAgent;
use MT;

sub init {
    my $app = shift;
    
    $app->SUPER::init(@_) or return;
    $app->add_methods(
            clear_cache => \&clear_cache,
            download => \&download,
            register => \&register,
            prolong_trial => \&prolong_trial,
    );
    $app->{default_mode} = 'clear_cache';
    $app->{requires_login} = 1;
    $app;
}

sub plugin {
    MT::Plugin::KeitaiKit->instance;
}

sub get_user {
    my $app = shift;
    my $user;
    
    $user = eval { $app->user };
    $user ||= $app->{author};
    
    $user;
}

sub is_superuser {
    my $app = shift;
    my $user = $app->get_user;
    

    my $can_manage_plugins = eval{ $user->can_manage_plugins };
    return 1 if $can_manage_plugins;
    

    $user? $user->is_superuser: 0;
}

sub build_authorization_error {
    my $app = shift;
    my $goback = @_;
    
    return $app->build_page('complete.tmpl', {
        lead => $app->plugin->translate('Autherization failured'),
        error => $app->plugin->translate('Do this operation as a system administrator.'),
        GOBACK => $goback}
    );
}

sub build_page {
    my $app = shift;
    my ($template, $param) = @_;
    
    if($MT_VERSION >= 4) {
        $param->{success} = $param->{complete};
    } else {
        $template = "mt3/$template" ;
    }


    my $plugin = $app->plugin;
    if ($plugin) {
        my $path = $app->static_path;
        $path .= '/' unless $path =~ m!/$!;
        $path .= $app->plugin->envelope . "/";
        $path = $app->base . $path if $path =~ m!^/!;
        $_[1]->{plugin_static_uri} = $path;
    }

    $app->SUPER::build_page($template, $param);
}


sub download {
    my $app = shift;
    

    return $app->build_authorization_error unless $app->is_superuser;
    

    my ($result, $message) = $app->plugin->download_spec_db;
    

    my $goback = "location.href='" . $app->mt_uri('mode' => $MT_VERSION < 4? 'list_plugins': 'cfg_plugins') . "';";
    

    return $app->build_page('complete.tmpl', {lead => $app->plugin->translate('Download completed'), complete => $message, GOBACK => $goback})
        if $result eq 'complete';
    
    return $app->build_page('complete.tmpl', {lead => $app->plugin->translate('Download completed'), complete => $message, GOBACK => $goback})
        if $result eq 'warning';
    
    return $app->build_page('complete.tmpl', {lead => $app->plugin->translate('Download failured'), error => $message, GOBACK => $goback});
}


sub clear_cache {
    my $app = shift;
    

    $app->plugin->clear_cache;
    

    return $app->build_page('complete.tmpl', {lead => $app->plugin->translate('Clear completed'), complete => $app->plugin->translate('Image cache has cleared.'), GOBACK => $app->{goback} || 'history.back()'});
}


sub register {
    my $app = shift;
    

    return $app->build_authorization_error unless $app->is_superuser;
    

    my $licensekey = $app->param('licensekey');
    my $mailaddress = $app->param('mailaddress');
    my ($result, $message) = $app->plugin->register_license($licensekey, $mailaddress);
    

    my $download = $app->plugin->translate('Download the newest database file.');
    

    my $goback = "location.href='" . $app->mt_uri('mode' => $MT_VERSION < 4? 'list_plugins': 'cfg_plugins') . "';";
    

    return $app->build_page('complete.tmpl', {lead => $app->plugin->translate('Registration completed'), complete => $app->plugin->translate('Thank you for your purchase. The license has registered.') . $download, GOBACK => $goback})
        if $result eq 'complete';
    
    return $app->build_page('complete.tmpl', {lead => $app->plugin->translate('Registration completed'), complete => $message . $download, GOBACK => $goback})
        if $result eq 'warning';
    
    return $app->build_page('complete.tmpl', {lead => $app->plugin->translate('Registration failured'), error => $message, GOBACK => $goback});
}


sub prolong_trial {
	my $app = shift;
	

    return $app->build_authorization_error unless $app->is_superuser;
    

	my ($result, $message) = $app->plugin->prolong_trial();
	

    my $goback = "location.href='" . $app->mt_uri('mode' => $MT_VERSION < 4? 'list_plugins': 'cfg_plugins') . "';";
    

	return $app->build_page('complete.tmpl', {lead => $app->plugin->translate('The trial prolonged'), complete => $app->plugin->translate('Try new features of KeitaiKit.'), GOBACK => $goback})
		if $result eq 'complete';
	
	return $app->build_page('complete.tmpl', {lead => $app->plugin->translate('The trial not prolonged'), error => $message, GOBACK => $goback});
}


sub translate_templatized {
    my $app = shift;
    $app->plugin->translate_templatized(@_);
}

1;