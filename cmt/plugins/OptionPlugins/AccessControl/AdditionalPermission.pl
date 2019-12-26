package MT::Plugin::AdditionalPermission;

use strict;
use MT 5;
use MT::Permission;
use MT::Util;

use vars qw( $NAME $VERSION );
$NAME = 'AdditionalPermission';
$VERSION = '0.01';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
    id => $NAME,
    key => $NAME,
    name => $NAME,
    version => $VERSION,
    author_name => 'SKYARC System Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
    description => <<'HTMLHEREDOC',
<__trans phrase="This plugin function is to add a new permission.">
HTMLHEREDOC
    l10n_class => $NAME. '::L10N',
    system_config_template => 'tmpl/AdditionalPermission.tmpl',
    settings => new MT::PluginSettings([
        ['perms', { Default => undef, Scope => 'system' }],
    ]),
    registry => {
        callbacks => {
            'init_app' => \&hdlr_init_app,
            'MT::App::CMS::template_source.edit_role' => 'AdditionalPermission::CMS::source_edit_role',
        },
    },
});
MT->add_plugin ($plugin);
###
sub hdlr_init_app {
    my $add_perms = $plugin->get_config_value ('perms', 'system')
        or return; # not yet configured, do nothing
    my $order = 100;
    my $key = '';
    my $label = '';
    foreach (split /[\r\n]+/, $add_perms) {
        if ( $_ =~ /^\S+:\S+$/ ){
            ( $key , $label ) = split /:/ ,  $_;
        }else{
           $key = $_;
           $label = $_;
        }
        $key =~ s/^\s+|\s+$//g;
        next if $key =~ /^$/ || $label =~ /^$/;
        my $id = MT::Util::perl_sha1_digest_hex ($key);
        my $hash = {
            set     => 'blog',
            key     => $id,
            group   => 'blog_additional',
            label   => $label,
            order   => $order++,
            permitted_action => {
                $id => 1,
            }
        };
        MT::Permission->add_permission ($hash);
        MT->registry ('permissions', "blog.$id", $hash);
    }
}

1;