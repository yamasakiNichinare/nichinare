package MT::Plugin::SKR::AssetBatchEditor;

use strict;
use base qw( MT::Plugin );
use MT::Util;
our $PLUGIN_NAME = 'AssetBatchEditor';
our $VERSION = '0.3';

my $plugin = __PACKAGE__->new({
    name     => $PLUGIN_NAME,
    version  => $VERSION,
    key      => lc $PLUGIN_NAME,
    id       => lc $PLUGIN_NAME,
    author_name => 'SKYARC System Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
    description => q{<MT_TRANS phrase="AssetBatchEditor">},
    l10n_class  => $PLUGIN_NAME. '::L10N',

});

MT->add_plugin( $plugin );

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        applications => {
            cms => {
                methods => {
                    asset_batch_save   => \&hdlr_asset_batch_save,
                    asset_batch_editor => \&hdlr_asset_batch_editor,
                },
                list_actions => {
                    asset => {
                        asset_batch_editor => {
                            label => 'AssetBatchEditor',
                            order => 10100,
                            code  => \&hdlr_asset_batch_editor,
                        },
                    },
                },
            },
        },
    });
}

sub hdlr_asset_batch_save {
    my $app = shift;
    my $blog_id = $app->param('blog_id');

    my %ids;

    for my $param ($app->{query}->param()) {

        my ($name, $id) = $param =~ m/^(label|description|tag|created)_(\d{1,})$/;
        next unless $name or $id;

        if(my $asset = $app->model('asset')->load($id)){
            my $value = $app->{query}->param($param);

            # for description
            if($name eq 'description'){
                my $new_value;
                for(split"\r\n|\n", $value){
                    next unless $_;
                    $new_value .= $_ . "\n";
                }
                $value = $new_value;
            }

            # for tag
            if ($name eq 'tag'){
                my $tag_delim = chr $app->user->entry_prefs->{tag_delim};
                my @filter_tags = $app->model('tag')->split( $tag_delim, $value );
                $asset->set_tags(@filter_tags);

            } elsif ($name eq 'created') {
                
                return $app->error(
                    $app->translate(
                        "Invalid date '[_1]'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.", $value
                    ) ) unless _datetime_to_ts($value);

                $asset->created_on(_datetime_to_ts($value));

            } else {
                $asset->$name($value);
            }

            $asset->save or die $asset->errstr;
            $ids{$id} = 1;
        }
    }
    my @ids = keys %ids;

    $app->redirect(
        $app->uri(
            mode => 'asset_batch_editor',
            args => {
                blog_id => $blog_id,
                id      => \@ids,
                saved   => 1,
            },
        )
    );
}

sub hdlr_asset_batch_editor {
    my $app = shift;
    my @ids = $app->param('id');

    my @assets = $app->model('asset')->load({id => \@ids});

    my @new_assets;
    for (@assets){

        my @objecttag = $app->model('objecttag')->load({
            blog_id           => $app->param('blog_id'),
            object_datasource => 'asset',
            object_id         => $_->id,
        });
        my @tags = map { $app->model('tag')->load($_->tag_id)->name } @objecttag;
        my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
        my $tags = join $tag_delim, @tags; 

        my $created_on_date = _ts_to_datetime( $_->created_on ); 

        push @new_assets, {
            file_name     => $_->file_name || undef,
            label         => $_->label || undef,
            description   => $_->description || undef,
            id            => $_->id || undef,
            tag           => $tags || undef,
            created       => $created_on_date || undef,
            thumbnail_url => $_->thumbnail_url(Width=>56),
        };
    }
    my $param = {
        page_title => q{<MT_TRANS phrase="AssetBatchEditor">},
        assets => \@new_assets,
    };
    $param->{saved} = 1 if $app->param('saved');
    $param->{screen_group} = 'asset';

    my $tmpl = $plugin->load_tmpl('editor.tmpl');
    return $app->build_page($tmpl, $param);
}

# timestamp >> date time.
sub _ts_to_datetime {
     my ( $value ) = @_;
     my ( @date ) = $value =~ m!^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$!;
     return sprintf '%04d-%02d-%02d %02d:%02d:%02d' , @date;
}

# date time >> timestamp.
sub _datetime_to_ts {
     my ( $value ) = @_;
     return 0
         unless $value =~ m!(\d{4})-(\d{2})-(\d{2})\s+(\d{2}):(\d{2})(?::(\d{2}))?!;
     my $s = $6 || 0;
     return 0 if $s > 59 
              || $s < 0
              || $5 > 59 
              || $5 < 0
              || $4 > 23 
              || $4 < 0
              || $2 > 12 
              || $2 < 1
              || $3 < 1
              || ( MT::Util::days_in( $2, $1 ) < $3 
                && !MT::Util::leap_day( $0, $1, $2 ) ); 

     my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $1, $2, $3, $4, $5, $s;
     return $ts;
}
1;
__END__ 
