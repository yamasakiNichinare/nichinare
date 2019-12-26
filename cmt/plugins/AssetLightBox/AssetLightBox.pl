#
#  2011 SKYARC System Co.,Ltd. All Rights Reserved,
#

package MT::Plugin::SKR::AssetLightBox;

use strict;
use MT::Plugin;
use base qw( MT::Plugin );

use vars qw($PLUGIN_NAME $VERSION);
$PLUGIN_NAME = 'AssetLightBox';
$VERSION = '1.00';

use MT;
my $plugin = MT::Plugin::SKR::AssetLightBox->new({
    id => 'admanager',
    key => __PACKAGE__,
    name => $PLUGIN_NAME,
    version => $VERSION,
    description => "<MT_TRANS phrase='Embed Lightbox attribute to asset links when inserting images.'>",
    doc_link => 'http://www.skyarc.co.jp',
    author_name => 'SKYARC System Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
    l10n_class => 'AssetLightBox::L10N',
#     config_template => \&config_template,
     blog_config_template => \&blog_config_template,
#     system_config_template => \&system_config_template,
     settings => new MT::PluginSettings([
         ['asset_lightbox_enabled', { Default => 1, Scope => 'blog' }],
     ]),
    registry => {
		callbacks => {
			'MT::App::CMS::template_param.asset_insert' => \&_param_asset_insert,
            'MT::App::CMS::template_param.edit_entry'    => \&param_edit_entry,
		},
    },
});

MT->add_plugin($plugin);

sub instance { $plugin; }

# logging function.
sub doLog {
    my ($msg) = @_; 
    return unless defined($msg);

    use MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
}

# return config template for blog setting.
sub blog_config_template {
    my $tmpl = <<'EOT';
    <mtapp:setting
        id="asset_lightbox_enabled"
        label="<__trans phrase="Embedding of LightBox attribute for thumbnail">"
        show_hint="1"
        hint="<__trans phrase="Embed 'rel=lightbox' to thumbnail link when insert a image to entry.">">
        <input type="checkbox" name="asset_lightbox_enabled" id="asset_lightbox_enabled" value="1" <mt:if name="asset_lightbox_enabled">checked="checked"</mt:if> /> <__trans phrase="Enable">
    </mtapp:setting>
EOT

	$tmpl;
}

# check if plugin is enabled on this blog.
sub _is_lightbox_enabled {
	my ($blog_id) = @_;

	return unless $blog_id;

	my $plugin = __PACKAGE__->instance;

    my $status = $plugin->get_config_value('asset_lightbox_enabled', "blog:$blog_id");

#	MT->log("blog:$blog_id : " . $status);

	return $status;
}

# insert "rel=lightbox" to image link
sub _param_asset_insert {
    my ($eh, $app, $param) = @_;

	my $plugin = __PACKAGE__->instance;

	my $upload_html = $param->{upload_html};

#	MT->log('_param_asset_insert');

	unless ($upload_html) {
		return;
	}

	my $blog = $app->blog
		or return;

	# check if plugin is enabled on this blog.
	_is_lightbox_enabled($blog->id)
		or return;

#	MT->log('_param_asset_insert upload_html: ' . $upload_html );

	$upload_html =~ s/a\s+href/a rel="lightbox" href/g;

	$param->{upload_html} = $upload_html;
}

sub param_edit_entry {
    my ($eh, $app, $param) = @_;

	my $plugin = __PACKAGE__->instance;

# 	MT->log('param_edit_entry');

	my $blog = $app->blog
		or return;

# 	my %param_hash = $app->param_hash;
# 	my @keys = keys(%param_hash);
# 	use Data::Dumper;
# 	MT->log('param keys : ' . Dumper(\@keys));

	# check thumnail existence
	if ($app->param('id') or !$app->param('thumb')) {
		return;
	}

#	MT->log('param_edit_entry 2');

	my $upload_html = $app->param('text');

#	MT->log('_param_asset_insert');

	unless ($upload_html) {
		return;
	}

	# check if plugin is enabled on this blog.
	_is_lightbox_enabled($blog->id)
		or return;

#	MT->log('_param_asset_insert upload_html: ' . $upload_html );

	$upload_html =~ s/a\s+href/a rel="lightbox" href/g;

	$app->param('text', $upload_html);
    $param->{text} = $upload_html;

}

1;
