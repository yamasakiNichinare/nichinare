package MT::Plugin::SKR::AssetNavigator;

use strict;
use MT 5;
use MT::Asset;

use vars qw( $MYNAME $VERSION );
$MYNAME = (split /::/, __PACKAGE__)[-1];
$VERSION = '0.00_12';

my %params = (
    DEFAULT_THUMBNAIL_SIZE => 50,   #12599
);

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
        id => $MYNAME,
        key => $MYNAME,
        name => $MYNAME,
        version => $VERSION,
        schema_version => 0.0016,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp/',
        doc_link => 'http://www.mtcms.jp/',
        description => <<HTMLHEREDOC,
<__trans phrase="Enable you to drag and drop the assets into WYSIWYG editor from assets navigator.">
HTMLHEREDOC
        system_config_template => 'tmpl/config.tmpl',
        settings => new MT::PluginSettings([
            [ 'thumbnail_size', { Default => $params{DEFAULT_THUMBNAIL_SIZE} }],
        ]),
        registry => {
            object_types => {
                'asset.file' => {
                    file_path_path => {
                        type => 'string',
                        size => 255,
                    }
                },
                'asset.image' => {
                    file_path_path => {
                        type => 'string',
                        size => 255,
                    }
                },
                'asset.audio' => {
                    file_path_path => {
                        type => 'string',
                        size => 255,
                    }
                },
                'asset.video' => {
                    file_path_path => {
                        type => 'string',
                        size => 255,
                    }
                },
            },
            callbacks => {
                'MT::App::CMS::template_source.edit_entry' => '$AssetNavigator::AssetNavigator::CMS::_template_source_edit_entry',
                'MT::App::CMS::template_param.edit_entry' => '$AssetNavigator::AssetNavigator::CMS::_template_param_edit_entry',
                'MT::App::CMS::template_source.asset_insert' => '$AssetNavigator::AssetNavigator::CMS::_template_source_asset_insert',
                'cms_post_save.asset' => \&_cb_asset_pre_save,
            },
            upgrade_functions => {
                file_path_path => {
                    version_limit => 0.0015,
                    priority      => 3.1,
                    code => sub {
                        map {
                            _cb_asset_pre_save (undef, undef, $_);
                        } grep {
                            !defined $_->file_path_path;
                        } MT::Asset->load ({ class => '*' });
                    },
                },
            },
            applications => {
                cms => {
                    methods => {
                        asset_navi => '$AssetNavigator::AssetNavigator::CMS::_hdlr_asset_navi',
                        update_objectasset => '$AssetNavigator::AssetNavigator::CMS::_hdlr_update_objectasset',
                    },
                },
            },
        },
        %params
});
MT->add_plugin ($plugin);

sub instance { $plugin; }

### Override - save_config #12599
sub save_config {
    my ($self, $param, $scope) = @_;

    my $thumbnail_size = int ($param->{'thumbnail_size'})
        || &instance->{DEFAULT_THUMBNAIL_SIZE};
    $thumbnail_size = &instance->{DEFAULT_THUMBNAIL_SIZE}
        if $thumbnail_size <= 0;
    $param->{'thumbnail_size'} = $thumbnail_size;

    return $self->SUPER::save_config ($param, $scope);
}



### Callback - cms_post_save.asset
sub _cb_asset_pre_save {
    my ($cb, $app, $obj) = @_;

    my $filepath = $obj->column ('file_path') || '';
    $filepath =~ s!^[^/]*/|[^/]*$!!g;
    $filepath =~ s!/$!!;
    $obj->file_path_path ($filepath);
    $obj->update;
}

1;