package MT::Plugin::SKR::MultiFileUploader;

use strict;
use MT 4;
use MT::Author;
use MT::Session;

our $PLUGIN_NAME = 'MultiFileUploader';
our $VERSION = '0.39';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
    name     => $PLUGIN_NAME,
    version  => $VERSION,
    key      => lc $PLUGIN_NAME,
    id       => lc $PLUGIN_NAME,
    author_name => 'SKYARC System Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
    doc_link => 'http://www.skyarc.co.jp/engineerblog/entry/multifileuploader.html',
    description => q{<__trans phrase="Enable you to upload some files multiplly at once.">},
    l10n_class => $PLUGIN_NAME. '::L10N',
    init_request => \&_hdlr_init_request,
	settings => MT::PluginSettings->new(_default_settings()),
	config_template => \&_config_template,
});

MT->add_plugin( $plugin );

sub init_registry {
    my $plugin = shift;

    my $prefs = 5.0 <= MT->version_number
        ? 'asset:multifileuploader'
        : 'create:multifileuploader';
    my $label = 5.0 <= MT->version_number
        ? 'MultiFileUploader'
		: 'Upload File';

    $plugin->registry({
		callbacks => {
# #17771 reverted to show upload links.
#			'MT::App::CMS::template_source.asset_list' => \&template_source_asset_list,
		},
        applications => {
            cms => {
                methods => _register_methods(),
                menus => {
                    $prefs => {
                        label       => 'MultiFileUploader',
                        mode        => 'file_upload',
                        order       => '100100',
                        view        => view(),
                        condition => sub { !_replace_uploader_enabled() && _check_menu_permission() },
                    },
                    $prefs . "_alt" => {
                        label       => 'Upload File',
                        mode        => 'file_upload',
                        order       => '100100',
                        view        => view(),
                        condition => sub { !(5.0 <= MT->version_number) && _replace_uploader_enabled() && _check_menu_permission(); },
                    },

                    # MT4; Omit a menu
                    'create:file' => {
                        condition => sub { !_replace_uploader_enabled() },
                    },
                },
            },
        },
    });
}

# return whether replace uploader or not.
sub _replace_uploader_enabled {
    my $plugin = MT->component('MultiFileUploader');
	$plugin->get_config_value('mfu_replace_upload');
}

# determine whether or not show file uploader menu.
sub _check_menu_permission {
	my $app = MT->instance or return 0;
	my $author = $app->user;

	my $perm = $app->permissions or return 0;

    return 1 if $author->is_superuser;

	if(5.0 <= MT->version_number) {
		return $perm->can_do('upload');
	} else {
		return $perm->has('upload');
	}
}



# return CMS methods hash to register.
sub _register_methods {
	my $methods =  {
		file_upload => 'MultiFileUploader::CMS::file_upload',
		file_save   => 'MultiFileUploader::CMS::file_save',
	};

	if (5.0 <= MT->version_number) {
		# Override start_upload #15901
		$methods->{start_upload} = sub {
			my ($app) = @_;
			my %args;

			if(! _replace_uploader_enabled()) {
				return MT::CMS::Asset::start_upload(@_);
			}

			my $require_type = $app->param('require_type');
			if ($require_type && ($require_type eq 'archive')) {
				return MT::CMS::Asset::start_upload(@_);
			}

			map { $args{$_} = $app->param($_); } grep { !/__mode/; } $app->param;

			$app->redirect ($app->uri (
				mode => 'file_upload', args => \%args,
			));
		};
	}

	$methods;
}

# return default plugin settings.
sub _default_settings {
	my $settings = [
		['mfu_image_resize_mode', { Scope => 'system', Default => "1"} ],
		['mfu_image_resize_mode', { Scope => 'blog', Default => "0"} ],
		['mfu_limitation_size'],
		['mfu_replace_upload', { Scope => 'system', Default => "1"} ],
	];

	$settings;
}

# hndler for config template
sub _config_template {
	my ($plugin, $param, $scope) = @_;

	my $app = MT->instance;
	my $blog = $app->blog();

	# load plugin setting.
	my $blog_id = $blog ? $blog->id : undef;
	my $settings = _current_settings($plugin, $scope, $blog_id);

	# Merge setting parameters.
	$param = {
		%$param,
		%$settings,
	};

	$param->{parent_limitation_mode}
		= _limitation_mode($plugin, $blog_id, 1);

	# set template parameters
	$param->{is_system} = !defined($blog);
	if (5.0 <= MT->version_number ) {
		$param->{is_website} = $blog && !$blog->is_blog();
		$param->{is_blog} = $blog && $blog->is_blog();
	} else {
		$param->{is_blog} = $blog && 1;
	}

	# determine parent object name
	if (5.0 <= MT->version_number ) {
		if ($param->{is_website}) {
			$param->{parent_object_name} = $plugin->translate('System');
		}
		if ($param->{is_blog}) {
			$param->{parent_object_name} = $plugin->translate('Web site');
		}
	} else {
		if ($param->{is_blog}) {
			$param->{parent_object_name} = $plugin->translate('System');
		}
	}

	# determine availavility of repalacing menu.
	if ($param->{is_system}) {
		$param->{available_mfu_replace_upload} = 1;
	}

	if (5.0 <= MT->version_number ) {
		$param->{mfu_menu_name} = $plugin->translate('Asset:New');
	} else {
		$param->{mfu_menu_name} = $plugin->translate('Upload File');
	}


#	MT->log("param : " . Dumper($param));

	$plugin->load_tmpl('multi_file_uploader_config.tmpl', $param);
}

# return inherited settings.
sub _current_settings {
	my ($plugin, $scope, $blog_id) = @_;

    my $system_config = $plugin->get_config_hash('system');

	if ($scope eq 'system') {
	    return $system_config;
	}

	# load Website setting.
	my $website_config = {};

	if (5.0 <= MT->version_number ) {
		my $blog = MT::Blog->load($blog_id);
		if ($blog->is_blog()) {
			my $website_id = $blog->parent_id;
			my $website_scope = "blog:$website_id";
			$website_config = $plugin->get_config_hash($website_scope);
		}
	}

	# merge blog setting and sysytem setting.
	my $settings = $plugin->get_config_hash($scope);
	my %new_config = (%$system_config, %$website_config, %$settings);
#	MT->log('scope : $scope new_config : ' . Dumper(\%new_config));

	\%new_config;

}

# overwrite save config.
sub save_config {
	my $plugin = shift;
    my ($param, $scope) = @_;
	
	my $key = 'mfu_limitation_size';
	my $size = $param->{$key};

	if (defined($size) && ($size ne '')) {
		if ($size !~ m/^\d+$/o) {
			return $plugin->error($plugin->translate('Image size must be numerical.'));
		}
	}

    return $plugin->SUPER::save_config(@_);
}

# return blog's limitation mode.
sub _limitation_mode {
	my ($plugin, $blog_id, $parent_only) = @_;

	my $scope = $blog_id ? "blog:$blog_id" : 'system';

	my $key = 'mfu_image_resize_mode';
	my $limit_mode;
	if(!$parent_only) {
		$limit_mode = $plugin->get_config_value($key, $scope);
;
	}

	# seeing parent settings.
	if (!$limit_mode && $blog_id) {
		my $blog = MT::Blog->load($blog_id);
		if ($blog) {
			# fallback into website setting.
			if (5.0 <= MT->version_number && $blog->is_blog) {
				my $website_id = $blog->parent_id;
				$limit_mode = $plugin->get_config_value($key, "blog:$website_id");
			}
			# fallback into system setting
			if(!$limit_mode) {
				$limit_mode = $plugin->get_config_value($key, "system");
			}
		}
	}

	$limit_mode;
}

sub view {
    return 5.0 <= MT->version_number
        ? [qw/ website blog /]
        : 'blog';
}

### init_request - Pass through login check and simulate it for SWF
sub _hdlr_init_request {
    my $app = shift;

    if (defined (my $mode = $app->param('__mode'))) {
        if ($mode eq 'file_save') {
            my ($uname, $sid, undef) = split /%3A%3A/, $app->param('mt_user');
            my $user = MT::Author->load ({ name => $uname });
            my $sess = MT::Session->load ({ id => $sid, kind => 'US' });
            if ($user && $sess) {
                $app->user ($user);
                $app->{session} = $sess;
                $app->{requires_login} = 0;
            }
        }
    }
}


### Callbacks - template_source.asset_list
sub template_source_asset_list {
    my ($cb, $app, $tmpl) = @_;

#	MT->log(__PACKAGE__ . ': trace ');
	return unless ((5.0 <= MT->version_number) && _replace_uploader_enabled());

    # Omit upload link
    my $old = quotemeta (<<'HTMLHEREDOC');
<mt:include name="dialog/header.tmpl">
HTMLHEREDOC
    my $new = <<'HTMLHEREDOC';
<mt:setvar name="upload_new_file_link" value="<!-- Omit a link by ReplaceAssetUpload -->">
HTMLHEREDOC
    $$tmpl =~ s/($old)/$new$1/;
}

1;
