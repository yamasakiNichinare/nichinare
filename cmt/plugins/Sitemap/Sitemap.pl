package MT::Plugin::SKR::Sitemap;
# Sitemap - Overviewing your websites, blogs and webpages.
#       Copyright (c) 2009 SKYARC System Co.,Ltd.
#       http://www.skyarc.co.jp/

use strict;
use MT 4;
use MT::Blog;
use MT::Entry;
use MT::Category;
use MT::Placement;
use MT::Permission;
use MT::Util;

use vars qw( $MYNAME $VERSION );
$MYNAME = 'Sitemap';
$VERSION = '0.53_02';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
        name => $MYNAME,
        id => lc $MYNAME,
        key => lc $MYNAME,
        version => $VERSION,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp/',
        doc_link => 'http://www.mtcms.jp/',
        description => <<HTMLHEREDOC,
<__trans phrase="Overviewing your websites, blogs and webpages.">
HTMLHEREDOC
        l10n_class => $MYNAME. '::L10N',
        system_config_template => 'tmpl/system_config.tmpl',
        settings => new MT::PluginSettings([
            [ 'debug', { Default => 0, Scope => 'system' }],
        ]),
});
MT->add_plugin( $plugin );

sub instance { $plugin; }

### Registry
sub init_registry {
    # MT4
    my $widgets_settings = {
        "$MYNAME-blog" => {
            label    => 'Blog Overviewing',
            template => 'widget_v4.tmpl',
            handler  => \&_hdlr_show_blog,
            singular => 1,
            set      => 'main',
            view     => 'blog',
        },
    };

    # MT5
    if (5.0 <= $MT::VERSION) {
        $widgets_settings = {
                "$MYNAME-website" => {
                    label    => 'Sitemap Overviewing',
                    template => 'widget_v5.tmpl',
                    handler  => \&_hdlr_show_website,
                    singular => 1,
                    set      => 'main',
                    view     => 'website',
                },
                "$MYNAME-blog" => {
                    label    => 'Blog Overviewing',
                    template => 'widget_v5.tmpl',
                    handler  => \&_hdlr_show_blog,
                    singular => 1,
                    set      => 'main',
                    view     => 'blog',
                },
                "$MYNAME-user" => {
                    label    => 'All Sitemap Overviewing',
                    template => 'widget_v5.tmpl',
                    handler  => \&_hdlr_show_sitemap,
                    singular => 1,
                    set      => 'main',
                    view     => 'user',
                },
        };
    }

    shift->registry({
        applications => {
            cms => {
                widgets => $widgets_settings,
                methods => {
                    sitemap_open => \&_hdlr_sitemap_open,
                    sitemap_add_category => '$Sitemap::Sitemap::CMS::add_category',
                    sitemap_del_category => '$Sitemap::Sitemap::CMS::del_category',
                },
            },
        },
        callbacks => {
            'MT::App::CMS::template_param.asset_upload' => sub {
                # Enable you to specify the extra_path to upload from URL query string.
                my ($cb, $app, $param) = @_; $param->{extra_path} = $app->param('extra_path');
            },
        },
    });
}

### SortCatFld Plugin exists
sub isSortCatFld { MT->component ('Sort Categories And Folders'); }

### Retrieve the script_uri
sub script_uri { (MT->config->AdminCGIPath || MT->config->CGIPath). MT->config->AdminScript; }

### Retrieve child class name of class
sub child_class {
    {
        website => 'page',
        blog => 'entry',
        category => 'entry',
        folder => 'page',
    }->{$_[0]};
}

###
sub entry_status_text {
    qw/ null hold release review future junk /[$_[0]->status];
}

###
sub isDebug {
    $plugin->get_config_value ('debug');
}

### Callbacks for widget - Website
sub _hdlr_show_website {
    my ($app, $tmpl, $param) = @_;

    $param->{location} = 'website';
    $param->{envelope} = &instance->{envelope};
    $param->{tree_html} = _traverse_blog ($app, $param->{blog_id}, 'website');
}

### Callbacks for widget - Blog
sub _hdlr_show_blog {
    my ($app, $tmpl, $param) = @_;

    $param->{location} = 'blog';
    $param->{envelope} = &instance->{envelope};
    $param->{tree_html} = _traverse_blog ($app, $param->{blog_id}, 'blog');
}

### Callbacks for widget - All Website
sub _hdlr_show_sitemap {
     my ($app, $tmpl, $param) = @_;

     $param->{location} = 'user';
     $param->{envelope} = &instance->{envelope};
     my $perms = MT::Permission->load({ author_id => $app->user->id });
     $param->{tree_html} = $perms || $app->user->is_superuser
         ? _traverse_blog ($app, 0, 'website' , 1 )
         : qq(<ul><MT_TRANS phrase="Blogs and websites that do not have permission."></ul>);
}

### Application methods
sub _hdlr_sitemap_open {
    my ($app) = @_;
    my $bid = $app->param('bid')
        or return 'Illegal param - bid';
    my $cid = $app->param('cid') || 0;

    $app->{no_print_body} = 1;
    $app->send_http_header ('text/html');
    $app->print_encode (&instance->translate_templatized (_traverse_tree ($app, $bid, $cid)));
}

### Traverse tree
sub _traverse_tree {
    my ($app, $bid, $cid, $recursive) = @_;

    my $html;
    if (_has_blog_perms ($app, $bid)) {
        $html .= _traverse_category ($app, $bid, $cid, 'folder', $recursive);
        $html .= _traverse_entry ($app, $bid, $cid, 'page', $recursive);
        $html .= _traverse_category ($app, $bid, $cid, 'category', $recursive);
        $html .= _traverse_entry ($app, $bid, $cid, 'entry', $recursive);
    }
    $app->run_callbacks( 'Sitemap::template_filter' , $app, $bid , $cid , \$html );
    $html ? $html : '<p class="empty"><__trans phrase="No objects could be found."></p>';
}

### Traverse tree/blog
sub _traverse_blog {
    my ($app, $bid, $class, $recursive) = @_;
    my $hbid = $app->param('blog_id') || ''; # Home Blog ID
    $class ||= 'blog';

    my $html;
    my $iter = MT::Blog->load_iter ({
        5.0 <= $MT::VERSION
            ? (class => $class)
            : (),
        !$bid
            ? ()
            :
        $class eq 'website' || !$recursive
            ? (id => $bid)
            : (parent_id => $bid),
    }, {
        sort => 'name', direction => 'ascend',
    });
    while (my $blog = $iter->()) {
        my $blog_id = $blog->id;
        my $perms = MT::Permission->load({ blog_id => $blog_id, author_id => $app->user->id });

        my $child_perms = 0;
        if( $MT::VERSION >= 5.0 && !$blog->is_blog ){
                my $child_blogs = $blog->blogs;
                foreach my $child_blog ( @{$child_blogs} ){
                   my $child_perm = MT::Permission->load({ blog_id => $child_blog->id , author_id => $app->user->id }) || '';
                   $child_perms = 1 if $child_perm;
                }
        }
        next unless $child_perms || $perms || $app->user->is_superuser;

        my $blog_name = MT::Util::encode_html ($blog->name) || '...';
        my $blog_url = $blog->site_url || '...';
        my $description = MT::Util::first_n_words ($blog->description, 40). '...';
        my $script_uri = &script_uri;
        my $child_class = &child_class ($class);
        my $child_node = $class eq 'website' || !$recursive || $app->cookie_val ("sm_b${blog_id}_c0") || $app->param('all_open')
            ? _traverse_tree ($app, $blog_id, 0)
            : '';
        my $child_blog = $class eq 'website'
            ? _traverse_blog ($app, $blog_id, 'blog', 1)
            : '';
        my $status = $app->cookie_val ("sm_b${blog_id}_c0")
            ? 'open'
            : 'close';
        my $child_style = $app->cookie_val ("sm_b${blog_id}_c0")
            ? 'block'
            : 'none';
        my $root = $recursive
            ? 'child'
            : 'root';
        my $return_args = MT::Util::encode_url ("__mode=dashboard". ($hbid ? "&amp;blog_id=${hbid}" : ''));
        my $debug = isDebug() ? qq{ <span class="debug">($class $blog_id)</span>} : '';
        # HTMLs
        $html .= <<"HTMLHEREDOC";
<li class="${class} ${status} ${root}">
  <div class="item root">
    <span class="${class}-label"><a href="$blog_url" onclick="openCategory ($blog_id, 0);return false;" title="$description">${blog_name}</a>$debug</span>
    <span class="url"><a href="${blog_url}">${blog_url}</a></span>
HTMLHEREDOC
        if ($app->user->is_superuser || $perms) {
            my $menu;
            # Go to Dashboard
            $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $blog_id != $app->param('blog_id');
      <a class="move" href="$script_uri?__mode=dashboard&blog_id=${blog_id}" title="<__trans phrase="Dashboard">"><__trans phrase="Dashboard"></a>
HTMLHEREDOC
            # Assets List
            $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms->can_edit_assets;
      <a class="asset" href="$script_uri?__mode=list_asset&amp;blog_id=${blog_id}" title="<__trans phrase="Assets List">"><__trans phrase="Assets List"></a>
HTMLHEREDOC
            # Template
            $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms->can_edit_templates;
      <a class="template" href="$script_uri?__mode=list_template&amp;blog_id=${blog_id}" title="<__trans phrase="Templates">"><__trans phrase="Templates"></a>
HTMLHEREDOC
            # Rebuild
            $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms->can_rebuild;
      <a class="rebuild" href="$script_uri?__mode=rebuild_confirm&amp;blog_id=${blog_id}" id="rebuild_${blog_id}" title="<__trans phrase="Rebuild">"><__trans phrase="Rebuild"></a>
HTMLHEREDOC
            # Config
            $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms->can_set_publish_paths || $perms->can_edit_config;
      <a class="config" href="$script_uri?__mode=cfg_prefs&amp;blog_id=${blog_id}" title="<__trans phrase="Config">"><__trans phrase="Config"></a>
HTMLHEREDOC
            # Plugins
            $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms->can_manage_plugins;
      <a class="plugin" href="$script_uri?__mode=cfg_plugins&amp;blog_id=${blog_id}" title="<__trans phrase="Plugins">"><__trans phrase="Plugins"></a>
HTMLHEREDOC
            # Activity Log
            $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms->can_view_blog_log;
      <a class="log" href="$script_uri?__mode=view_log&amp;blog_id=${blog_id}" title="<__trans phrase="Activity Log">"><__trans phrase="Activity Log"></a>
HTMLHEREDOC
            $menu .= '<br />' if $menu && $menu !~ m!<br />$!;

            # Create Page
            $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms->can_manage_pages;
      <a class="post-page" href="$script_uri?__mode=view&amp;_type=page&amp;blog_id=${blog_id}" title="<__trans phrase="Create Page">"><__trans phrase="Create Page"></a>
HTMLHEREDOC
            # Folders List
            $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms->can_manage_pages;
      <a class="folder" href="$script_uri?__mode=list_folder&amp;blog_id=${blog_id}" title="<__trans phrase="Folders List">"><__trans phrase="Folders List"></a>
HTMLHEREDOC
            # Create Folder
            $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms->can_manage_pages;
      <a class="folder_add mt-open-dialog" href="$script_uri?__mode=view&amp;_type=folder&amp;blog_id=${blog_id}&amp;dialog=1&amp;return_args=${return_args}" title="<__trans phrase="Create Folder">" onclick="jQuery(function(\$){ \$('div.menu').hide()})"><__trans phrase="Create Folder"></a>
HTMLHEREDOC
            $menu .= '<br />' if $menu && $menu !~ m!<br />$!;

            # Create Entry
            $menu .= <<"HTMLHEREDOC" if ($app->user->is_superuser || $perms->can_create_post) && $blog->is_blog;
      <a class="post-entry" href="$script_uri?__mode=view&amp;_type=entry&amp;blog_id=${blog_id}" title="<__trans phrase="Create Entry">"><__trans phrase="Create Entry"></a>
HTMLHEREDOC
            # Categories List
            $menu .= <<"HTMLHEREDOC" if ($app->user->is_superuser || $perms->can_edit_categories) && $blog->is_blog;
      <a class="category" href="$script_uri?__mode=list_category&amp;blog_id=${blog_id}" title="<__trans phrase="Categories List">"><__trans phrase="Categories List"></a>
HTMLHEREDOC
            # Create Category
            $menu .= <<"HTMLHEREDOC" if ($app->user->is_superuser || $perms->can_edit_categories) && $blog->is_blog;
      <a class="category_add mt-open-dialog" href="$script_uri?__mode=view&amp;_type=category&amp;blog_id=${blog_id}&amp;dialog=1&amp;return_args=${return_args}" title="<__trans phrase="Create Category">"  onclick="jQuery(function(\$){ \$('div.menu').hide()})"><__trans phrase="Create Category"></a>
HTMLHEREDOC

            ##  Action menu extend.
            ActionMenuExtend ($app, $class, $status, $root, $perms, $blog_id, \$menu);

            $html .= "<div class=\"menu\">$menu<!--.menu--></div>" if $menu;
        }
        $html .= <<"HTMLHEREDOC";
  <!--.item--></div>
  <div id="sm_b${blog_id}_c0" style="display: $child_style">${child_node}${child_blog}</div>
</li>
HTMLHEREDOC
        ### Link to rebuild for MT5
        if (5.0 <= $MT::VERSION) {
            $html .= <<"HTMLHEREDOC";
<script type="text/javascript">jQuery('a#rebuild_${blog_id}').length && jQuery('a#rebuild_${blog_id}').mtRebuild({blog_id: $blog_id});</script>
HTMLHEREDOC
        } else { # Link to rebuild for MT4
            $html .= <<"HTMLHEREDOC";
<script type="text/javascript">jQuery('a#rebuild_${blog_id}').length && jQuery('a#rebuild_${blog_id}').click(function () { doRebuild('$blog_id'); return false; });</script>
HTMLHEREDOC
        }
        $app->run_callbacks( 'Sitemap::template_filter' , $app, $blog_id , $class , \$html );
    }
    $app->run_callbacks( 'Sitemap::template_filter' , $app, $bid , $class , \$html );
    $html ? qq(<ul>$html</ul>) : qq();
}

##
sub ActionMenuExtend {
     my ($app, $class, $status, $root, $perms, $blog_id, $template) = @_;
     MT->run_callbacks ('sitemap_action_menu', $app, $class, $status, $root, $perms, $blog_id, $template);
}

### Traverse tree/categories
sub _traverse_category {
    my ($app, $bid, $cid, $class, $recursive) = @_;
    my $hbid = $app->param('blog_id') || ''; # Home Blog ID
    $class ||= 'category';

    my $blog = MT::Blog->load ($bid)
        or return "<!-- Failed to load blog (id:$bid)-->";
    my $blog_url = $blog->site_url || '';

    my $html;
    my $perms = MT::Permission->load({ blog_id => $bid, author_id => $app->user->id });
    my $iter = MT::Category->load_iter ({
        blog_id => $bid, parent => $cid, class => $class,
    }, {
        &isSortCatFld
            ? (sort => 'order_number')
            : (sort => 'label'),
        direction => 'ascend',
    });
    while (my $category = $iter->()) {
        my $category_id = $category->id;
        my $category_label = MT::Util::encode_html ($category->label) || '...';
        my $category_basename = $category->basename || '...';
        my $publish_path = $category->publish_path;
        my $encoded_publish_path = MT::Util::encode_url ($publish_path);
        my $description = MT::Util::first_n_words ($category->description, 40). '...';
        my $script_uri = &script_uri;
        my $child_class = &child_class ($class);
        my $child_node = $app->cookie_val ("sm_b${bid}_c$category_id") || $app->param('all_open')
            ? _traverse_tree ($app, $bid, $category->id, $class)
            : '';
        my $status = $child_node
            ? 'open'
            : $category->can('alt_link') && $category->alt_link
                ? 'link' # DirectoryMenuAssistant plugins feature
                : 'close';
        my $child_style = $child_node
            ? 'block'
            : 'none';
        my $action_title = $class eq 'category'
            ? '<__trans phrase="Create Entry">'
            : '<__trans phrase="Create Page">';
        my $action_list = $class eq 'category'
            ? '<__trans phrase="Entry List">'
            : '<__trans phrase="Page List">';
        my $action_addition = $class eq 'category'
            ? '<__trans phrase="Create Sub Category">'
            : '<__trans phrase="Create Sub Folder">';
        my $action_delete = $class eq 'category'
            ? '<__trans phrase="Delete Category">'
            : '<__trans phrase="Delete Folder">';
        my $action_config = $class eq 'category'
            ? '<__trans phrase="Category Config">'
            : '<__trans phrase="Folder Config">';
        my $return_args = MT::Util::encode_url ("__mode=dashboard". ($hbid ? "&amp;blog_id=${hbid}" : ''));
        my $debug = isDebug() ? qq{ <span class="debug">($class $category_id)</span>} : '';
        # HTMLs
        $html .= <<"HTMLHEREDOC";
<li class="${class} ${status}">
  <div class="item">
    <span class="${class}-label"><a href="$blog_url$publish_path" onclick="openCategory ($bid, $category_id); return false;" title="$description">$category_label</a>$debug</span>
    <span class="path" title="<__trans phrase="Basename">">$category_basename</span>
HTMLHEREDOC

        my $menu;
        # New Page/Entry
        $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms && ({ category => $perms->can_create_post, folder => $perms->can_manage_pages }->{$class});
      <a class="post-${child_class}" href="$script_uri?__mode=view&amp;_type=${child_class}&amp;blog_id=${bid}&amp;category_id=${category_id}" title="$action_title">$action_title</a>
HTMLHEREDOC
        # Page/Entry List
        $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms && ({ category => $perms->can_edit_all_posts, folder => $perms->can_manage_pages }->{$class});
      <a class="list" href="$script_uri?__mode=list_${child_class}&amp;blog_id=${bid}&amp;filter=category_id&amp;filter_val=${category_id}" title="$action_list">$action_list</a>
HTMLHEREDOC
        # Create Sub Category/Folder
        $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms && ({ category => $perms->can_edit_categories, folder => $perms->can_manage_pages }->{$class});
      <a class="${class}_add mt-open-dialog" href="$script_uri?__mode=view&amp;_type=${class}&amp;blog_id=${bid}&amp;dialog=1&amp;parent=${category_id}&amp;return_args=${return_args}" title="$action_addition" onclick="jQuery(function(\$){ \$('div.menu').hide()})">$action_addition</a>
HTMLHEREDOC
        # Delete Category/Folder
        $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms && ({ category => $perms->can_edit_categories, folder => $perms->can_manage_pages }->{$class});
      <a class="${class}_del mt-open-dialog" href="$script_uri?__mode=sitemap_del_category&amp;_type=${class}&amp;blog_id=${bid}&amp;home_blog_id=${hbid}&amp;id=${category_id}" title="$action_delete" onclick="jQuery(function(\$){ \$('div.menu').hide()})" >$action_delete</a>
HTMLHEREDOC
        $menu .= '<br />' if $menu;

    if ($category->class eq 'folder') {
        # Assets List
        $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms && $perms->can_edit_assets;
      <a class="asset" href="$script_uri?__mode=list_asset&amp;blog_id=${bid}&amp;filter=folder&amp;filter_val=${encoded_publish_path}" title="<__trans phrase="Assets List">"><__trans phrase="Assets List"></a>
HTMLHEREDOC
        # Upload Asset
        $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms && $perms->can_upload;
      <a class="upload mt-open-dialog" href="$script_uri?__mode=start_upload&amp;blog_id=${bid}&amp;dialog=1&amp;extra_path=${encoded_publish_path}" title="<__trans phrase="Upload Asset" >" onclick="jQuery(function(\$){ \$('div.menu').hide()})"><__trans phrase="Upload Asset"></a>
HTMLHEREDOC
        $menu .= '<br />' if $menu && $menu !~ m!<br />$!;
    }

       # Config
       $menu .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms && ({ category => $perms->can_edit_categories, folder => $perms->can_manage_pages }->{$class});
      <a class="config" href="$script_uri?__mode=view&amp;_type=${class}&amp;blog_id=${bid}&amp;id=${category_id}" title="$action_config">$action_config</a>
HTMLHEREDOC

        ##  Action menu extend.
        ActionMenuExtend ($app, $class, $status, '', $perms, $bid, \$menu);

        $html .= "<div class=\"menu\">$menu<!--.menu--></div>" if $menu;

        $html .= <<"HTMLHEREDOC";
  <!--.item--></div>
  <div id="sm_b${bid}_c${category_id}" style="display: $child_style">$child_node</div>
</li>
HTMLHEREDOC
    }
    $html ? qq(<ul>$html</ul>) : qq();
}

### Traverse tree/entries
sub _traverse_entry {
    my ($app, $bid, $cid, $class, $recursive) = @_;
    $class ||= 'entry';

    my $html;
    my @entries;
    if ($cid) {
        @entries = sort {
            $b->authored_on <=> $a->authored_on
        } map {
            MT::Entry->load ({ id => $_->entry_id, class => $class })
        } MT::Placement->load ({
            blog_id => $bid, category_id => $cid,
        });
    }
    else {
        @entries = grep {
            !defined MT::Placement->load ({ entry_id => $_->id })
        } MT::Entry->load ({
            blog_id => $bid, class => $class
        }, {
            sort => 'authored_on', direction => 'descend',
        });
    }
    my $perms = MT::Permission->load({ blog_id => $bid, author_id => $app->user->id });

    my $lastn = 3;
    my $total = scalar @entries;
    foreach my $entry (@entries) {
        my $entry_id = $entry->id;

		MT->run_callbacks('Sitemap::entry_filter', $app, $entry, $class)
			or next;

        my $entry_title = MT::Util::encode_html ($entry->title) || '...';
        my $excerpt = MT::Util::encode_html ($entry->get_excerpt) || '';
        my $entry_basename = $entry->basename || '...';
        my $entry_permalink = $entry->permalink;
        my $status = &entry_status_text ($entry);
        my $script_uri = &script_uri;
        my $debug = isDebug() ? qq{ <span class="debug">($class $entry_id)</span>} : '';
        $html .= <<"HTMLHEREDOC";
<li class="$class $status">
  <div class="item">
HTMLHEREDOC
        $html .= <<"HTMLHEREDOC";
    <a href="$entry_permalink" onclick="return false;" title="$excerpt">$entry_title</a>$debug
    <div class="menu">
HTMLHEREDOC

        # Edit
        $html .= <<"HTMLHEREDOC" if $app->user->is_superuser || $perms && ($perms->can_edit_all_posts || $perms->can_edit_entry ($entry, $app->user));
      <a class="edit" href="$script_uri?__mode=view&amp;_type=${class}&amp;id=${entry_id}&amp;blog_id=${bid}" title="<__trans phrase="Edit $class">"><__trans phrase="Edit $class"></a>
HTMLHEREDOC
        # View
        $html .= <<"HTMLHEREDOC" if $entry->status == MT::Entry::RELEASE();
      <a class="view" href="$entry_permalink" title="<__trans phrase="View">"><__trans phrase="View"></a>
HTMLHEREDOC

        ##  Action menu extend.
        ActionMenuExtend ($app, $class, $status, '', $perms, $bid, \$html);

        $html .= <<"HTMLHEREDOC";
      <span class="path" title="<__trans phrase="Basename">">$entry_basename</span>
HTMLHEREDOC

		# run callbacks for each entry.
		MT->run_callbacks('Sitemap::entry_html', $app, $entry, $class, \$html);

        $html .= <<"HTMLHEREDOC";
    <!--.menu--></div>
  <!--.item--></div>
</li>
HTMLHEREDOC
        if ($class eq 'entry' && --$lastn == 0) {
            if ($cid) {
                $html .= <<"HTMLHEREDOC";
<li class="more"><a href="$script_uri?__mode=list_${class}&amp;blog_id=${bid}&amp;filter=category_id&amp;filter_val=${cid}"><__trans phrase="More ([_1] entries) ..." params="$total"></a></li>
HTMLHEREDOC
            }
            else {
                $html .= <<"HTMLHEREDOC";
<li class="more"><a href="$script_uri?__mode=list_${class}&amp;blog_id=${bid}"><__trans phrase="All entries ..."></a></li>
HTMLHEREDOC
            }
            last;
        }
    }
    $html ? qq(<ul class="$class">$html</ul>) : qq();
}

### Check some permissions on blog
sub _has_blog_perms {
    my ($app, $bid) = @_;
    my $user = $app->user
        or return 0;
    $user->is_superuser || MT::Permission->load({ blog_id => $bid, author_id => $user->id });
}



### Override the default widget #15915
use MT::App;
{
    local $SIG{__WARN__} = sub { };
    my $original_load_widgets = \&MT::App::load_widgets;
    *MT::App::load_widgets = sub {
        my ($app, $page, $scope_type, $param, $default_widgets) = @_;
        my $my_widgets = {
            'user' => {
                'this_is_you-1'  => {
                    order => 1,
                    set => 'main'
                },
                'mt_news'        => {
                    order => 3,
                    set => 'sidebar'
                },
                "$MYNAME-user" => {
                    order => 2,
                    set => 'main',
                },
            },
            'website' => {
                "$MYNAME-website" => {
                    order => 1,
                    set => 'main',
                },
            },
            'blog' => {
                "$MYNAME-blog" => {
                    order => 1,
                    set => 'main',
                },
            },
        };
        $original_load_widgets->($app, $page, $scope_type, $param, $my_widgets->{$scope_type} || $default_widgets);
    };
}

1;
