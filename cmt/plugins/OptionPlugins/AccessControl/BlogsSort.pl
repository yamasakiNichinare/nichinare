package MT::Plugin::BlogsSort;

use strict;
use warnings;
use MT 5;
use MT::Blog;

use vars qw( $PLUGIN_NAME $VERSION $SCHEMA_VERSION );
$PLUGIN_NAME = 'BlogsSort';
$VERSION = '2.05';
$SCHEMA_VERSION = '2.04';
use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
    id => $PLUGIN_NAME,
    key => $PLUGIN_NAME,
    name => $PLUGIN_NAME,
    version => $VERSION,
    author_name => 'SKYARC System Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
    l10n_class => 'BlogsSort::L10N',
    schema_version => $SCHEMA_VERSION,
    description => <<HTMLHEREDOC,
<__trans phrase="Enable you to arrange the listing order of blogs.">
HTMLHEREDOC
});
MT->add_plugin( $plugin );

sub instance { $plugin; }

sub sort_key { 'sort_no' }

### Registry initialization
sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        applications => {
            cms => {
                methods => {
                    blogs_sort => '$BlogsSort::BlogsSort::CMS::blogs_sort',
                },
                menus => {
                    'blog:blogs_sort' => {
                        label => 'blog sort Management',
                        mode  => 'blogs_sort',
                        order => 905,
                        permission => 'administer',
                        system_permission => 'administer,administer_website',
                        view => 'website',
                    },
                },
            },
        },
        object_types => {
            'blog' => {
                'sort_no' => {
                    type => 'integer',
                    default => 0,
                },
            }
        },
        tags => {
            function => {
                'BlogSortNo' => \&_tag_function_blog_sort_no,
            },
            block => {
                'BlogsSort' => \&_tag_block_blogs_sort,
            }
        },
        callbacks => {
           # ブログの全般画面を置き換えています。
           'MT::App::CMS::template_param.cfg_prefs' => \&_callback_template_param_edit_blog,
        },
    });
}
###
sub _tag_function_blog_sort_no {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash ('blog')
        or return 0;
    $blog->is_blog ? $blog->sort_no : 0;
}
###
sub _tag_block_blogs_sort {
    my($ctx, $args, $cond) = @_;
    my (%terms, %args);

    if ($args->{'multiblog'}){
        my $multiblog = MT->instance->component('multiblog');
        if ($multiblog) {
            my $id = $ctx->stash('blog_id');
            my $is_include = $multiblog->get_config_value('default_mtmultiblog_action', "blog:$id" );
            my $blogs = $multiblog->get_config_value('default_mtmulitblog_blogs', "blog:$id" );
            if ($blogs && defined($is_include)) {
                $args->{'blog_ids'} = "";
                if ($is_include){
                    $args->{'include_blogs'} = $blogs;
                    $args->{'exclude_blogs'} = "";
                }
                else {
                    $args->{'include_blogs'} = "";
                    $args->{'exclude_blogs'} = $blogs;
                }
            }
        }
    }
    $ctx->set_blog_load_context($args, \%terms, \%args, 'id')
        or return $ctx->error($ctx->errstr);

    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');

    local $ctx->{__stash}{entries} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp} = undef
        if $args->{ignore_archive_context};
    local $ctx->{current_timestamp_end} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{category} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{archive_category} = undef
        if $args->{ignore_archive_context};
    local $ctx->{__stash}{inside_blogs} = 1;

    require MT::Blog;
    $args{'sort'}    = $plugin->sort_key;
    $args{direction} = 'ascend';
    my $iter = MT::Blog->load_iter(\%terms, \%args);
    my $res = '';
    my $count = 0;
    my $next = $iter->();
    my $vars = $ctx->{__stash}{vars} ||= {};
    while ($next) {
        my $blog = $next;
        $next = $iter->();
        $count++;
        local $ctx->{__stash}{blog} = $blog;
        local $ctx->{__stash}{blog_id} = $blog->id;
        local $vars->{__first__} = $count == 1;
        local $vars->{__last__} = !$next;
        local $vars->{__odd__} = ($count % 2) == 1;
        local $vars->{__even__} = ($count % 2) == 0;
        local $vars->{__counter__} = $count;
        defined(my $out = $builder->build($ctx, $tokens, $cond))
            or return $ctx->error($builder->errstr);
        $res .= $out;
    }
    $res;
}
###
sub _callback_template_param_edit_blog {
    my ($eh, $app, $param, $tmpl) = @_;
    return
        unless UNIVERSAL::isa ($tmpl, 'MT::Template');

    my $blog = $app->blog;
    return 1 unless $blog->is_blog; ## ウェブサイトは無視する。

    $param->{sort_no} ||= 0; # MSSQL

    ## ここで指定したIDのコントロールの後にＵＩが挿入されます。
    my $host_node = $tmpl->getElementById ('description');
    my $innerHTML = '<input style="width:5em" name="sort_no" id="sort_no" size="3" maxlength="3" value="<$mt:var name="sort_no" escape="html"$>" type="text" />';
    my $block_node = $tmpl->createElement(
       'app:setting',
       {
          id => $plugin->sort_key,
          label => $plugin->translate ( $plugin->sort_key ),
          label_class => 'left-label',
       },
    );
    $block_node->innerHTML ($innerHTML);
    $tmpl->insertAfter ($block_node, $host_node);
}

1;
