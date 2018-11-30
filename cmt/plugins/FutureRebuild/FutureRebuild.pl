package MT::Plugin::SKR::FutureRebuild;
# FutureRebuild - Enable you the scheduled rebuilding of entries and webpages.
#       Copyright (c) 2008 SKYARC System Co.,Ltd.
#       @see http://www.skyarc.co.jp/engineerblog/entry/futurerebuild.html

use strict;
use MT 4;
use MT::Entry;
use MT::PluginData;
use MT::WeblogPublisher;
use MT::Template::Context;
use MT::Util qw( start_background_task );
#use Data::Dumper;#DEBUG

use vars qw( $MYNAME $VERSION );
$MYNAME = 'FutureRebuild';
$VERSION = '0.16';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
        name => $MYNAME,
        id => lc $MYNAME,
        key => lc $MYNAME,
        version => $VERSION,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp/',
        doc_link => 'http://www.skyarc.co.jp/engineerblog/entry/futurerebuild.html',
        description => <<HTMLHEREDOC,
<__trans phrase="Enable you the scheduled rebuilding of entries and webpages.">
HTMLHEREDOC
        l10n_class => $MYNAME. '::L10N',
});
MT->add_plugin( $plugin );

sub instance { $plugin; }

### Registry
sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        callbacks => {
            'MT::App::CMS::template_source.edit_entry' => sub {
                if (5.0 <= $MT::VERSION) {
                    _edit_entry_source_v5(@_);
                } elsif (4.0 <= $MT::VERSION) {
                    _edit_entry_source_v4(@_);
                }
            },
            'MT::App::CMS::template_param.edit_entry' => \&_edit_entry_param,
            'MT::App::CMS::template_param.list_entry' => \&_list_entry_param,
            'MT::Entry::post_save' => {
                priority => 5,
                code => \&_hdlr_post_save,
            },
            'MT::Page::post_save' => {
                priority => 5,
                code => \&_hdlr_post_save,
            },
            'MT::App::CMS::template_param.preview_strip' => \&_preview_strip_param,
        },
        tasks => {
            $MYNAME => {
                name        => $MYNAME,
                frequency   => 60,
                code        => \&_hdlr_future_unpublish,
            },
        },
        tags => {
            function => {
                UnpublishedDate => \&_tag_unpublished_date,
            },
            block => {
                'IfAfterUnpublishedDay?' => \&_tag_if_after_unpublished_day,
            },
        },
    });
}

### Modify callback - template_source.edit_entry (V5)
sub _edit_entry_source_v5 {
    my ($eh_ref, $app_ref, $tmpl_ref) = @_;

    my $old = trimmed_quotemeta( <<'HTMLHEREDOC' );
    <mtapp:setting
        id="basename"
HTMLHEREDOC
    my $new = &instance->translate_templatized (<<'HTMLHEREDOC');
        <mtapp:setting
            id="future_unpublish"
            label="<__trans phrase="Future Rebuild">"
            label_class="top-label"
            help_page="entries"
            help_section="date">
            <select name="future_unpublish_mode" id="future_unpublish_mode" class="full-width" onchange="OnChange_future_unpublish(this);">
                <option value="0"<TMPL_IF NAME=FUTURE_UNPUBLISH_MODE_0> selected="selected"</TMPL_IF>><__trans phrase="Not in use"></option>
                <option value="1"<TMPL_IF NAME=FUTURE_UNPUBLISH_MODE_1> selected="selected"</TMPL_IF>><__trans phrase="Scheduled unpublish"></option>
                <option value="2"<TMPL_IF NAME=FUTURE_UNPUBLISH_MODE_2> selected="selected"</TMPL_IF>><__trans phrase="Rebuild only"></option>
            </select>
        </mtapp:setting>

        <mtapp:setting
            id="unpublish_on"
            label="<__trans phrase="Rebuild on">"
            label_class="top-label"
            help_page="entries"
            help_section="date">
            <div class="date-time-fields<mt:if name="status_future"><mt:if name="can_publish_post"> highlight</mt:if></mt:if>">
                <input type="text" id="UnpublishOn" class="post-date text-date" name="unpublish_on_date" value="<$mt:var name="unpublish_on_date" escape="html"$>" />
                 @ <input type="text" class="post-time" name="unpublish_on_time" value="<$mt:var name="unpublish_on_time" escape="html"$>" />
            </div>
        </mtapp:setting>

        <script type="text/javascript">
        function OnChange_future_unpublish( obj ) {
            if (!obj)
                obj = DOM.getElement('future_unpublish_mode');
            var e = DOM.getElement('unpublish_on-field');
            var f = obj.options[obj.selectedIndex].value;
            e.style.display = ( f != '0' ? 'block' : 'none' );
         }
        OnChange_future_unpublish( null );
        </script>
HTMLHEREDOC
    $$tmpl_ref =~ s/($old)/$new$1/;
}

### Modify callback - template_source.edit_entry (V4)
sub _edit_entry_source_v4 {
    my ($eh_ref, $app_ref, $tmpl_ref) = @_;

    my $old = trimmed_quotemeta( <<'HTMLHEREDOC' );
        <mt:if name="object_type" eq="page">
            <$mt:var name="category_setting"$>
        </mt:if>
HTMLHEREDOC
    my $new = &instance->translate_templatized (<<'HTMLHEREDOC');
        <mtapp:setting
            id="future_unpublish"
            label="<__trans phrase="Future Rebuild">"
            help_page="entries"
            help_section="date">
            <select name="future_unpublish_mode" id="future_unpublish_mode" class="full-width" onchange="OnChange_future_unpublish(this);">
                <option value="0"<TMPL_IF NAME=FUTURE_UNPUBLISH_MODE_0> selected="selected"</TMPL_IF>><__trans phrase="Not in use"></option>
                <option value="1"<TMPL_IF NAME=FUTURE_UNPUBLISH_MODE_1> selected="selected"</TMPL_IF>><__trans phrase="Scheduled unpublish"></option>
                <option value="2"<TMPL_IF NAME=FUTURE_UNPUBLISH_MODE_2> selected="selected"</TMPL_IF>><__trans phrase="Rebuild only"></option>
            </select>
        </mtapp:setting>

        <mtapp:setting
            id="unpublish_on"
            label="<__trans phrase="Rebuild on">"
            help_page="entries"
            help_section="date">
            <span class="date-time-fields">
                <input id="UnpublishOn" class="entry-date" name="unpublish_on_date" value="<$mt:var name="unpublish_on_date" escape="html"$>" />
                <a href="javascript:void(0);" mt:command="open-calendar-unpublish-on" class="date-picker" title="<__trans phrase="Select unpublishing date">"><span>Choose Date</span></a>
                <input class="entry-time" name="unpublish_on_time" value="<$mt:var name="unpublish_on_time"$>" <TMPL_IF NAME=UNPUBLISH_ON_TIME_READONLY>readonly="readonly" style="background-color: #ccc;"</TMPL_IF> />
            </span>
        </mtapp:setting>

        <script type="text/javascript">
        function OnChange_future_unpublish( obj ) {
            if (!obj)
                obj = DOM.getElement('future_unpublish_mode');
            var e = DOM.getElement('unpublish_on-field');
            var f = obj.options[obj.selectedIndex].value;
            e.style.display = ( f != '0' ? 'block' : 'none' );
        }
        OnChange_future_unpublish( null );
        </script>
HTMLHEREDOC
    $$tmpl_ref =~ s/($old)/$new$1/;
}

### Modify callback - template_param.edit_entry
sub _edit_entry_param {
    my ($cb, $app, $param, $tmpl) = @_;

    my ( $mode , $date , $time ) = ( 0 , '' , ''  );
    if (my $entry_id = $param->{id} ) {
        if (my $settings = load_plugindata( key_name( $entry_id ))) {
            $mode = $settings->{mode} =~ m/^([0-2])$/ ? $1 : 0;

            if( my ( $dy , $dm , $dd , $th , $tm , $ts ) = 
                   $settings->{time} =~ m/^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/ ){
                
                $date = sprintf '%04d-%02d-%02d', $dy , $dm , $dd;
                $time = sprintf '%02d:%02d:%02d', $th , $tm , $ts;
            }
        }
    }

    # Set default value
    $param->{future_unpublish_mode_change} = 0;
    $param->{future_unpublish_mode} = $mode;
    $param->{unpublish_on_date} = $date || $param->{authored_on_date};
    $param->{unpublish_on_time} = $time || $param->{authored_on_time};

    # Returning from the preview screen.
    $param->{future_unpublish_mode} = $app->param('future_unpublish_mode') if $app->param('_preview_file');

    $mode = $param->{future_unpublish_mode} =~ /(\d)/ ? $1 : 0;
    $param->{"future_unpublish_mode_$mode"} = 1;
    if
    ( $app->param('unpublish_on_date') ){
         $date = $app->param('unpublish_on_date') =~ m/^(\d{4}-\d{2}-\d{2})$/ ? $1 : '';
         $param->{unpublish_on_date} = $date;
    }
    if( $app->param('unpublish_on_time') ){
         $time = $app->param('unpublish_on_time') =~ m/^(\d{2}:\d{2}:\d{2})$/ ? $1 : '';
         $param->{unpublish_on_time} = $time; 
    }
    return 1;
}

### Modify callback - template_param.list_entry
sub _list_entry_param {
    my ($cb, $app, $param, $tmpl) = @_;

    $param->{object_loop}
        or return;
    my @object_loop = @{$param->{object_loop}};
    foreach (@object_loop) {
        my $pd = load_plugindata (key_name ($_->{id}));
        if ($pd->{time} && $pd->{mode} == 1) {
            my ($ts_y, $ts_m, $ts_d) = $pd->{time} =~ m/^(\d{4})(\d{2})(\d{2})/;
            $_->{created_on_relative} .= &instance->translate( '<br />- [_1]/[_2]/[_3]', $ts_y, $ts_m, $ts_d );
            $_->{created_on_formatted} .= &instance->translate( '<br />- [_1]/[_2]/[_3]', $ts_y, $ts_m, $ts_d );
        } else {
            $_->{created_on_relative} .= &instance->translate( '<br />(Stay Published)' );
            $_->{created_on_formatted} .= &instance->translate( '<br />(Stay Published)' );
        }
    }
    $param->{object_loop} = \@object_loop;
}



### Modify callback - template_param.preview_strip
sub _preview_strip_param {
    my ($cb, $app, $param, $tmpl) = @_;
    foreach (qw( future_unpublish_mode unpublish_on_date unpublish_on_time )) {
        push @{$param->{entry_loop}}, { data_name => $_, data_value => $app->param($_) };
    }
}



### Update rebuild flag
sub _hdlr_post_save {
    my ($eh, $obj) = @_;
    $obj->isa('MT::Entry') || $obj->isa('MT::Page')
        or return;

    my $q = MT->instance->{query}
        or return;

    return unless exists $q->{param}->{future_unpublish_mode};

    $q->param( '__mode' ) eq 'view' 
       && ( $q->param( '_type' ) eq 'entry' || $q->param( '_type' ) eq 'page' )
       and return;

    my ($q_mode) = $q->param( 'future_unpublish_mode' ) =~ m/^([0-2])$/;

    my $settings = load_plugindata( key_name( $obj->id || 0 ) ); # entry_id
    $settings ||= {};

    if ($q_mode) {

        my ($q_time_y, $q_time_m, $q_time_d) = $q->param( 'unpublish_on_date' ) =~ m/^(\d+)-(\d+)-(\d+)$/
            or return;# not update the settings
        my ($q_date_h, $q_date_m, $q_date_s) = $q->param( 'unpublish_on_time' ) =~ m/^(\d+):(\d+):(\d+)$/
            or return;# not update the settings

        $settings->{'mode'} = $q_mode;
        $settings->{'time'} = sprintf '%04d%02d%02d%02d%02d%02d',
                $q_time_y, $q_time_m, $q_time_d, $q_date_h, $q_date_m, $q_date_s;
        $settings->{'rebuild'} = 1;# mark to rebuild
        save_plugindata( key_name( $obj->id ), $settings );

    }else{

        ### Reset.
        if ( $settings ){
           remove_plugindata( key_name( $obj->id )) if $settings->{'mode'};
        }

    }
    return 1;
}


### Unpublish/Rebuild
sub _hdlr_future_unpublish {

    my @t = localtime;
    my $ts = sprintf '%04d%02d%02d%02d%02d%02d', $t[5]+1900, $t[4]+1, @t[3,2,1,0];

    my %rebuild_blogs = ();

    my $iter = load_iter_plugindata();
    while (my $pd = $iter->() ){
        my $settings = $pd->data;
        my $id = $pd->key =~ /entry_id\:\:(\d*)/ ? $1 : 0; 
        next unless $id;

        my $entry = MT::Entry->load({ id => $id , status => MT::Entry::RELEASE() }) || '';
        next unless $entry;

        $settings->{'time'} < $ts or next;

        # Release -> Draft
        if ($settings->{'mode'} == 1) {
            $entry->status( MT::Entry::HOLD());
            $entry->modified_on( $ts );
            $entry->update;

            $rebuild_blogs{$entry->blog_id} = 1;# mark to rebuild this blog

            start_background_task(sub {
                MT->instance->publisher->remove_entry_archive_file(
                    Entry => $entry,
                    ArchiveType => $entry->class_type eq 'entry'
                        ? 'Individual'
                        : 'Page',
                );

                ## indexes
                MT->rebuild_indexes( BlogID => $entry->blog_id );

                ## MultiBlog Support
                if (defined (my $mb = MT->component('MultiBlog'))) {
                    $mb->runner ('post_entry_save', undef, MT->instance, $entry)
                }
            });
        }
        # Release -> Release and rebuild
        elsif ($settings->{'mode'} == 2 && $settings->{'rebuild'}) {
            $entry->status( MT::Entry::RELEASE());# keep released
            $entry->modified_on( $ts );
            $entry->update;

            $settings->{'rebuild'} = 0;
            save_plugindata( key_name( $entry->id ), $settings );

            # Rebuild
            start_background_task(sub {
                MT->rebuild_entry(
                    BlogID            => $entry->blog_id,
                    Entry             => $entry,
                    BuildDependencies => 0,
#                    BuildIndexes      => 1,
                    OldEntry          => undef,
                    OldPrevious       => undef,
                    OldNext           => undef,
                );
            });
        }
        # do nothing
        # remove needless data. &  End of the process needs no PluginData.
        remove_plugindata( key_name( $entry->id ));
    }

    ### Rebuild the all affected blogs.
    foreach my $blog_id (keys %rebuild_blogs) {
        my $blog = MT::Blog->load({ id => $blog_id })
            or next;
        start_background_task(sub {
            MT->instance->rebuild( Blog => $blog );
        });
    }
}

### Template Tag - UnpublishedDate
sub _tag_unpublished_date {
    my ($ctx, $args) = @_;
    my $entry = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $settings = load_plugindata( key_name( $entry->id ))# entry_id
        or return '';
    $settings->{'mode'}
        or return '';
    $args->{ts} = $settings->{'time'};
    return MT::Template::Context::_hdlr_date ($ctx, $args);
}

### Conditional Tag - IfAfterUnpublishedDay
sub _tag_if_after_unpublished_day {
    my ($ctx, $arg, $cond) = @_;
    my $entry = $ctx->stash('entry')
        or return $ctx->_no_entry_error();
    my $settings = load_plugindata( key_name( $entry->id ))# entry_id
        or return 0;
    $settings->{'mode'}
        or return 0;
    my @t = localtime;
    my $ts = sprintf '%04d%02d%02d%02d%02d%02d', $t[5]+1900, $t[4]+1, @t[3,2,1,0];
    $settings->{'time'} <= $ts;
}

########################################################################
sub key_name { 'entry_id::'. $_[0]; }

sub save_plugindata {
    my ($key, $data_ref) = @_;
    my $pd = MT::PluginData->load({ plugin => &instance->id, key=> $key });
    if (!$pd) {
        $pd = MT::PluginData->new;
        $pd->plugin( &instance->id );
        $pd->key( $key );
    }
    $pd->data( $data_ref );
    $pd->save;
}

sub load_iter_plugindata {
   return MT::PluginData->load_iter( { plugin => &instance->id } ) || undef;
}

sub load_plugindata {
    my ($key) = @_;
    my $pd = MT::PluginData->load({ plugin => &instance->id, key=> $key })
        or return undef;
    $pd->data;
}

sub remove_plugindata {
    my ($key) = @_;
    my $pd = MT::PluginData->load({ plugin => &instance->id, key=> $key })
        or return undef;# there is no entry all along
    $pd->remove;
}

### Space and CR,LF trimmed quotemeta
sub trimmed_quotemeta {
    my ($str) = @_;
    $str = quotemeta $str;
    $str =~ s/(\\\s)+/\\s+/g;
    $str;
}

1;
