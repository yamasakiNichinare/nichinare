package MT::Plugin::MailPack;

use strict;
use warnings;
use MT 4;
use MT::Blog;
use MT::Author;
use MT::Plugin;
use MT::Template::Context;
use MT::Mailpackaddress;
use quemgr qw(quemgr);

use vars qw( $PLUGIN_NAME $VERSION $SCHEMA_VERSION );
$PLUGIN_NAME = 'MailPack';
$VERSION = '1.79';
$SCHEMA_VERSION = '1.056';

use base qw(MT::Plugin);
my $plugin = __PACKAGE__->new({
    id => $PLUGIN_NAME,
    key => $PLUGIN_NAME,
    name => $PLUGIN_NAME,
    version => $VERSION,
    doc_link => 'http://www.skyarc.co.jp/product/manual/mailpack/',
    author_name => 'SKYARC System Co., Ltd,',
    author_link => 'http://www.skyarc.co.jp/',
    5.0 <= $MT::VERSION
        ? ()
        : (config_link => 'mailpack.cgi'),
    l10n_class => 'MailPack::L10N',
    schema_version => $SCHEMA_VERSION,
    config_template => 'notification.tmpl',
    settings => new MT::PluginSettings([
        ['notification_flg', { Default => 1 }],
        ['notification_superuser', { Default => 0 }],
        ['notification_subject', { Default => 'MailPack:' }],
        ['thumbnail_width', { Default => 200 }],
        ['insert_point', { Default => 1 }],
        ['comment_thread', { Default => 0 }],
        ['post_status' , { Default => 1 }],
        ['assist_post_status' , { Default => 1 }],
    ]),
    description => "<__trans phrase='BlogEntries Posted From Intarnet Mail.'>",
});
MT->add_plugin($plugin);

#----- Task
sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        object_types => {
            'Mailpackaddress' =>  'MT::Mailpackaddress',
            'MailPack_MessageId' => 'MT::MailPack::MessageId',
        },
        tasks => {
            'MailPackTask' => {
                label       => 'MailPack Check to Posted Mails',
                frequency   => 10, # seconds
                code        => sub { check_mails( $plugin ); },
            },
        },
        applications => {
            cms => {
                methods => {
                    list_mailpack   => '$MailPack::MailPack::CMS::list',
                    edit_mailpack   => '$MailPack::MailPack::CMS::edit',
                    delete_mailpack => '$MailPack::MailPack::CMS::delete',
                    save_mailpack   => '$MailPack::MailPack::CMS::post',
                },
                menus => {
                    'entry:mailpack' => {
                        label => 'MailPack Configure',
                        mode => 'list_mailpack',
                        order => 99999,
                        permission => 'administer',
                    },
                },
            },
        },
    });
}

sub instance { $plugin }

sub check_mails {
    my $plugin = shift;
    quemgr($plugin);
    1;
}

# Remove mapped object in MT::Mailpackaddress
MT::Blog->add_callback ('pre_remove', 5, $plugin, \&_hdlr_pre_remove);
MT::Author->add_callback ('pre_remove', 5, $plugin, \&_hdlr_pre_remove);
sub _hdlr_pre_remove {
    my ($cb, $obj) = @_;
    my %term;
    if ($obj->isa('MT::Blog')) {
        $term{blog_id} = $obj->id;
    }
    elsif ($obj->isa('MT::Author')) {
        $term{author_id} = $obj->id;
    }
    else {
        return 1;
    }
    map { $_->remove } MT::Mailpackaddress->load (\%term);
}



1;
__END__
