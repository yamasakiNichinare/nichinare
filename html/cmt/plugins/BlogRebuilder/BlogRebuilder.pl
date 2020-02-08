package MT::Plugin::BlogRebuilder;

use strict;
use MT;

use vars qw( $PLUGIN_NAME $VERSION );
$PLUGIN_NAME = 'BlogRebuilder';
$VERSION = '2.42';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
    id => $PLUGIN_NAME,
    key => $PLUGIN_NAME,
    name => $PLUGIN_NAME,
    version => $VERSION,
    description => '<MT_TRANS phrase="Enable you to rebuild a number of blogs at once">',
    author_name => 'SKYARC System Co., Ltd.',
    author_link => 'http://www.skyarc.co.jp/engineerblog/entry/2730.html',
    l10n_class => $PLUGIN_NAME. '::L10N',
    registry => {
        applications => {
            cms => {
                menus => {
                    'tools:rebuild_blogs' => {

                        label => 'Rebuild blogs',
                        mode  => 'rebuild_blogs_setting',
                        order => 710,
                        view  => [ 'system' , 'blog' ],
                        condition => '$BlogRebuilder::BlogRebuilder::CMS::show_blog_menu',

                    },
                    'tools:rebuild_website' => {

                        label => 'Rebuild website',
                        mode  => 'rebuild_blogs_setting',
                        order => 711,
                        view  => 'website',
                        condition => '$BlogRebuilder::BlogRebuilder::CMS::show_website_menu',

                    },
                    'tools:rebuild_sites' => {

                        label => 'Rebuild sites',
                        mode  => 'rebuild_blogs_setting',
                        order => 712,
                        view  => 'system',
                        condition => '$BlogRebuilder::BlogRebuilder::CMS::show_system_menu',

                    },
                },
                methods => {
                    rebuild_blogs_setting => '$BlogRebuilder::BlogRebuilder::CMS::setting',
                    rebuild_blogs_execute => '$BlogRebuilder::BlogRebuilder::CMS::execute',
                    rebuild_blogs_done => '$BlogRebuilder::BlogRebuilder::CMS::done',
                },
            },
        },
    },
});
MT->add_plugin($plugin);

sub instance { $plugin; }

## Sitempap plugin.
MT->add_callback('sitemap_action_menu' , 1 , $plugin, sub {
  my ( $eh , $app , $class , $status , $root , $perms , $blog_id , $template ) = @_;

  my $blog = MT::Blog->load( $blog_id ) or return 1;
  $blog->is_dynamic and return 1;

  if( $class eq 'website' ){

      my $uri = $app->uri( mode => "rebuild_blogs_setting", args => { blog_id => $blog_id });
      my $menu_name = instance->translate('Rebuild');

      require BlogRebuilder::CMS;
      return 1 unless BlogRebuilder::CMS::_accept_permission( $app , $blog_id );
      my $script_uri = ( MT->config->AdminCGIPath || MT->config->CGIPath) . MT->config->AdminScript;
      my $old = <<"HTMLHEREDOC";
      <a class="rebuild" href="$script_uri?__mode=rebuild_confirm&amp;blog_id=${blog_id}" id="rebuild_${blog_id}" title="<__trans phrase="Rebuild">"><__trans phrase="Rebuild"></a>
HTMLHEREDOC

      my $new = <<"HTMLHEREDOC";
      <a class="rebuild" href="$uri" title="$menu_name">$menu_name</a>
HTMLHEREDOC
      $old = quotemeta( $old );
      $$template =~ s/$old/$new/g;
  }

});

## MT4 shortcuts menu.
MT->add_callback('MT::App::CMS::template_source.mt_shortcuts', 9, $plugin, sub {
	my ($eh, $app, $tmpl) = @_;
	my $old = quotemeta (<<'HTML');
        </mt:if>
    </ul>
HTML
        my $blog_id = $app && $app->can('blog') && $app->blog ? $app->blog->id : 0;
        my $uri = $app->uri( mode => "rebuild_blogs_setting", args => { blog_id => $blog_id });
	my $new = &instance->translate_templatized(<<HTML);
        </mt:if>
        <li><a href="./$uri"><img src="<mt:getvar name="static_uri">images/ani-rebuild.gif" align="top" />&nbsp;<MT_TRANS phrase="Rebuild blogs"></a></li>
    </ul>
HTML
	$$tmpl =~ s/$old/$new/;
}) unless $MT::VERSION =~ /^5/;

1;
