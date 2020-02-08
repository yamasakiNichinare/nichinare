package MT::Plugin::SKR::DirectoryMenuAssistant;

use strict;
use warnings;
#use Data::Dumper;# DEBUG

use vars qw( $NAME $VERSION $SCHEMA_VERSION );
$NAME = 'DirectoryMenuAssistant';
$VERSION = '2.03';
$SCHEMA_VERSION = '1.3002';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
        id => $NAME,
        key => $NAME,
        name => $NAME,
        version => $VERSION,
        schema_version => $SCHEMA_VERSION,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp',
        l10n_class => $NAME. '::L10N',
        description => <<HTMLHEREDOC,
<__trans phrase="Enable you to generate the navigation menu HTML easily">
HTMLHEREDOC
        registry => {
            object_types => {
                category => {
                    hidden => {
                        label => 'Hide in MTDirectoryMenu',
                        type => 'boolean',
                    },
                    target_blank => {
                        label => 'Open in new window',
                        type => 'boolean',
                    },
                    alt_link => {
                        label => 'Alternative Link',
                        type => 'string',
                        size => 255,
                    },
                },
            },

            tags => {
                function => {
                    DirectoryMenu => '$DirectoryMenuAssistant::DirectoryMenuAssistant::Tags::_directory_menu',
                    DirectoryMenuAltLink => '$DirectoryMenuAssistant::DirectoryMenuAssistant::Tags::DirectoryMenuAltLink',
                },
                block => {
                    'IfDirectoryMenuHidden?' => '$DirectoryMenuAssistant::DirectoryMenuAssistant::Tags::IfDirectoryMenuHidden',
                    'IfDirectoryMenuShow?' => '$DirectoryMenuAssistant::DirectoryMenuAssistant::Tags::IfDirectoryMenuShow',
                    'IfDirectoryMenuOpenExternal?' => '$DirectoryMenuAssistant::DirectoryMenuAssistant::Tags::IfDirectoryMenuOpenExternal',
                },
            },

            callbacks => {
                # Category
                'MT::App::CMS::template_source.edit_category' => 'DirectoryMenuAssistant::CMS::_hdlr_src_edit_category',
                'MT::App::CMS::template_param.edit_category' => 'DirectoryMenuAssistant::CMS::_hdlr_param_edit_category',
                'cms_post_save.category' => 'DirectoryMenuAssistant::CMS::_hdlr_post_save_category',
                # Folder
                'MT::App::CMS::template_source.edit_folder' => 'DirectoryMenuAssistant::CMS::_hdlr_src_edit_category',
                'MT::App::CMS::template_param.edit_folder' => 'DirectoryMenuAssistant::CMS::_hdlr_param_edit_category',
                'cms_post_save.folder' => 'DirectoryMenuAssistant::CMS::_hdlr_post_save_category',
            },
        },
});
MT->add_plugin ($plugin);

1;