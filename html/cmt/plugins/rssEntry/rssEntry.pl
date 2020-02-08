package MT::Plugin::SKR::rssEntry;
# rssEntry - Retrieve the RSS and post them as entries
#       Copyright (c) 2008 SKYARC System Co.,Ltd.
#       http://www.skyarc.co.jp/

use strict;
use MT;
use MT::Blog;
use MT::Entry;
use MT::Author;
use MT::Permission;
use MT::I18N;
use MT::Log;
use MT::Util qw( decode_xml iso2ts epoch2ts perl_sha1_digest_hex );
use HTTP::Request;
use LWP::UserAgent;
use XML::Simple;
$XML::Simple::PREFERRED_PARSER = 'XML::Parser';
use Time::ParseDate;
use Data::Dumper;#DEBUG

use vars qw( $MYNAME $VERSION $DEBUG_MODE );
$MYNAME = 'rssEntry';
$VERSION = '0.080';
$DEBUG_MODE = 0; #DEBUG

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
        name => $MYNAME,
        id => lc $MYNAME,
        key => lc $MYNAME,
        version => $VERSION,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp/',
        doc_link => 'http://www.skyarc.co.jp/engineerblog/entry/rssentry.html',
        description => <<HTMLHEREDOC,
<__trans phrase="Retrieve the RSS and post them as entries">
HTMLHEREDOC
        l10n_class  => $MYNAME. '::L10N',
        blog_config_template => \&_blog_config_template,
        settings => new MT::PluginSettings([
            [ 'rss_urls',  { Default => undef, scope => 'blog' } ],
            [ 'post_user',  { Default => undef, scope => 'blog' } ],
        ]),
});
MT->add_plugin( $plugin );

sub instance { $plugin; }

### Registry
sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        tasks => {
            $MYNAME => {
                name        => $MYNAME,
                frequency   => 60 * 60,# seconds #DEBUG
                code        => \&_hdlr_rss_entry,
            },
        },
    });
}



#
sub _blog_config_template {
    my ($plugin, $param, $scope) = @_;
    my ($blog_id) = $scope =~ /blog:(\d+)/;

    # Check whether blog is
    my $blog = MT::Blog->load ({ id => $blog_id })
        or return undef;
    return undef if $blog->can('is_blog') && !$blog->is_blog;

    # List up the users can post the entry on this blog
    my @post_users = ();
    my $iter = MT::Author->load_iter ();
    while (my $author = $iter->()) {
        my $perms = MT::Permission->load({
            blog_id => $blog_id, author_id => $author->id,
        }) or next;
        $perms->can_post
            or next;
        push @post_users, {
            id => $author->id,
            name => $author->nickname || $author->name,
        };
    }
    $param->{post_users} = \@post_users;

    # return the configuration template
    return &instance->load_tmpl ('config.tmpl', $param);
}



use constant INNER_CHARSET => 'utf8';

### Task to rotate logs
sub _hdlr_rss_entry {
    ###
    my $ua = LWP::UserAgent->new
        or return;
    $ua->timeout (30);

    ### Loop for each blogs
    my $blog_iter = MT::Blog->load_iter();
    while (my $blog = $blog_iter->()) {
        my $scope = "blog:". $blog->id;
        my $rss_urls = &instance->get_config_value ('rss_urls', $scope)
            or next;# No settings or undef
        my @rss_urls = split /[\s]/, $rss_urls;
        my $total_saved = 0;
        foreach my $url (@rss_urls) {
            $url
                or next;# Skip in empty
            # Load PluginData with $url as key
            my $pdata = load_plugindata ($scope. ':'. $url) || {};
            # Generate a request
            my $req = HTTP::Request->new (GET => $url)
                or next;# Failed to initialize object
            $req->header ('User-Agent' => "$MYNAME/$VERSION; +http://www.skyarc.co.jp/engineerblog/entry/rssentry.html");
            if ($pdata->{last_modified}) {
                $req->header ('If-Modified-Since' => $pdata->{last_modified});
            }
            # Make a request
            my $res = $ua->request( $req )
                or next;# Failed to request
            if (!$res->is_success) {
                # not 200 (304 or 404)
                MT->log({
                    message => MT->translate( "[_1] died with: [_2]", $MYNAME, $res->status_line ),
                    class => 'system',
                    blog_id   => $blog->id,
                    author_id => 0,
                    category => 'callback',
                    level    => MT::Log::WARNING(),
                });
                next;
            }
            # Get Charset
            my $buf = $res->content
                or next;# No content
            # Prepared encoding a whole to UTF-8
            my ($charset) = $buf =~ m!<\?xml[\s\S]+?encoding\s*=\s*"([^"]+)"[\s\S]*?\?>!;#"
            $charset = {
                'shift_jis' => 'sjis',
                'iso-2022-jp' => 'jis',
                'euc-jp' => 'euc',
                'utf-8' => 'utf8',
            }->{lc $charset} || INNER_CHARSET;
            $buf = MT::I18N::encode_text ($buf, $charset, INNER_CHARSET) if $charset ne INNER_CHARSET;
            # Parse to XML
            my $ref = XMLin ($buf,
                NormaliseSpace => 2,
            ) or next;# Failed to parse XML
            # Any params
            $ref->{post_user} = &instance->get_config_value ('post_user', 'blog:'. $blog->id)
                or next;# Posting user is not specified.
            $ref->{charset} = $charset;
            my $ret = 0;
            # RSS 0.91 (RDF)
            if (defined $ref->{xmlns} && $ref->{xmlns} eq 'http://purl.org/rss/1.0/') {
                $ret = _make_entry_rss091 ($blog, $pdata, $ref)
                    or next;
                $total_saved += $ret;
            }
            # RSS 2.0 (XML)
            elsif (defined $ref->{version} && $ref->{version} eq '2.0') {
                $ret = _make_entry_rss20 ($blog, $pdata, $ref)
                    or next;
                $total_saved += $ret;
            }
            # Atom
            elsif (defined $ref->{xmlns} && $ref->{xmlns} eq 'http://www.w3.org/2005/Atom') {
                $ret = _make_entry_atom ($blog, $pdata, $ref)
                    or next;
                $total_saved += $ret;
            }

            # Logging
            my $msg = &instance->translate ('[_1]: [_2] entries was posted from [_3]', $MYNAME, $ret, $url);
            _create_log ($blog->id, $ref->{post_user}, $msg);

            # Update the PluginData
            $pdata->{last_modified} = $res->header ('Last-Modified');
            save_plugindata ($scope. ':'. $url, $pdata) unless $DEBUG_MODE;
        }

        # Rebuild this blog
        if ($total_saved) {
            MT->instance->rebuild_indexes( Blog => $blog );
            MT->instance->rebuild_archives( Blog => $blog );
        }
    }
}



### RSS 0.91 (RDF)
sub _make_entry_rss091 {
    my ($blog, $pdata, $ref) = @_;

    my @items = @{$ref->{item}}
        or return undef;
    {
        no warnings;
        if( 1 < scalar @items ){
           @items = sort { $a->{'dc:date'} cmp $b->{'dc:date'} } @items;
        }
    }

    my $saved = 0;
    foreach my $item (@items) {
        my $permalink = $item->{'rdf:about'} || $item->{link}
            or next;
        defined $pdata->{$permalink}
            and next;
        # Create an entry object
        my $entry = MT::Entry->new;
        $entry->author_id ($ref->{post_user});
        $entry->blog_id ($blog->id);
        $entry->status (MT::Entry::RELEASE());

        my $title = $item->{'title'} || '';
        $entry->title ($title);
        my $description = $item->{'description'} || '';
        $entry->text ($description);
        $entry->text_more ($permalink);

        if (defined( my $ts = $item->{'dc:date'})) {
            $entry->authored_on (iso2ts ($blog, $ts));
            $entry->basename (perl_sha1_digest_hex ($ts));
        }

        #17956 - give the user a chance to modify the generated entry
        MT->run_callbacks ($MYNAME. '_pre_save', $blog, $entry, $ref, $item);

        if ($DEBUG_MODE) {
            print STDERR Dumper ($entry);
        } else {
            $entry->save;
            # Rebuild an entry
            _build_an_entry ($blog, $entry);
        }

        #17956 - give the user a chance to modify the generated entry
        MT->run_callbacks ($MYNAME. '_post_save', $blog, $entry, $ref, $item);

        # Mark as published
        $pdata->{$permalink} = time;
        $saved++;
    }
    $saved;
}

### RSS 2.0 (XML)
sub _make_entry_rss20 {
    my ($blog, $pdata, $ref) = @_;

    my @items = @{$ref->{channel}->{item}}
        or return undef;

    {
       no warnings;
       if( 1 < scalar @items ){
           @items = sort { $a->{'pubDate'} cmp $b->{'pubDate'} } @items;
       }
    }

    my $saved = 0;
    foreach my $item (@items) {
        my $permalink = $item->{link}
            or next;
        defined $pdata->{$permalink}
            and next;

        # Create an entry object
        my $entry = MT::Entry->new;
        $entry->author_id ($ref->{post_user});
        $entry->blog_id ($blog->id);
        $entry->status (MT::Entry::RELEASE());

        my $title = $item->{'title'} || '';
        $entry->title ($title);
        my $description = $item->{'description'} || '';
        $entry->text ($description);
        $entry->text_more ($permalink);

        if (defined( my $ts = $item->{'pubDate'})) {
            $ts = parsedate ($ts);
            $entry->authored_on ( epoch2ts ($blog, $ts));
            $entry->basename (perl_sha1_digest_hex ($ts));
        }

        #17956 - give the user a chance to modify the generated entry
        MT->run_callbacks ($MYNAME. '_pre_save', $blog, $entry, $ref, $item);

        if ($DEBUG_MODE) {
            print STDERR Dumper ($entry);
        } else {
            $entry->save;
            # Rebuild an entry
            _build_an_entry ($blog, $entry);
        }

        #17956 - give the user a chance to modify the generated entry
        MT->run_callbacks ($MYNAME. '_post_save', $blog, $entry, $ref, $item);

        # Mark as published
        $pdata->{$permalink} = time;
        $saved++;
    }
    $saved;
}

### Atom
sub _make_entry_atom {
    my ($blog, $pdata, $ref) = @_;

    my %items = %{$ref->{entry}}
        or return undef;
    my $saved = 0;
    foreach my $key (keys %items) {
        my $permalink = undef;
        if (ref $items{$key}->{link} eq 'ARRAY') {
            foreach (@{$items{$key}->{link}}) {
                if ($_->{rel} eq 'alternate') {
                    $permalink = $_->{href};
                    last;
                }
            }
        }
        else {
            # not implemented
        }
        defined $pdata->{$permalink}
            and next;

        # Create an entry object
        my $entry = MT::Entry->new;
        $entry->author_id ($ref->{post_user});
        $entry->blog_id ($blog->id);
        $entry->status (MT::Entry::RELEASE());

        my $title = $items{$key}->{title} || '';
        $entry->title ($title);
        my $description = $items{$key}->{content}->{content} || '';
        $entry->text ($description);
        $entry->text_more ($permalink);

        if (defined( my $ts = $items{$key}->{published})) {
            $entry->authored_on ( epoch2ts ($blog, parsedate ($ts)));
            $entry->basename (perl_sha1_digest_hex ($ts));
        }

        #17956 - give the user a chance to modify the generated entry
        MT->run_callbacks ($MYNAME. '_pre_save', $blog, $entry, $ref, $key);

        if ($DEBUG_MODE) {
            print STDERR Dumper ($entry);
        } else {
            $entry->save;
            # Rebuild an entry
            _build_an_entry ($blog, $entry);
        }

        #17956 - give the user a chance to modify the generated entry
        MT->run_callbacks ($MYNAME. '_post_save', $blog, $entry, $ref, $key);

        # Mark as published
        $pdata->{$permalink} = time;
        $saved++;
    }
    $saved;
}



########################################################################

# Get blog publish charset
sub _get_publish_charset {
    my $cfg = MT::ConfigMgr->instance
        or return undef;
    return {
        'shift_jis' => 'sjis',
        'iso-2022-jp' => 'jis',
        'euc-jp' => 'euc',
        'utf-8' => 'utf8',
    }->{lc $cfg->PublishCharset} || INNER_CHARSET;
}

# Create a log
sub _create_log {
    my ($blog_id, $author_id, $msg) = @_;
    my $log = MT::Log->new
        or return;
    $log->blog_id ($blog_id);
    $log->author_id ($author_id);
    $log->message ($msg);
    $log->level (MT::Log::INFO());
    $log->category (&instance->id);
    $log->save;
}

# Build an entry
sub _build_an_entry {
    my ($blog, $entry) = @_;
    return MT->instance->rebuild_entry(
        Blog => $blog,
        Entry => $entry,
        BuildDependencies => 0,
    );
}

########################################################################
use MT::PluginData;

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

sub load_plugindata {
    my ($key) = @_;
    my $pd = MT::PluginData->load({ plugin => &instance->id, key=> $key })
        or return undef;
    $pd->data;
}

1;