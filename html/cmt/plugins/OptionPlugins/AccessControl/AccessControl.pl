package MT::Plugin::AccessControl;
use strict;
use warnings;
use MT 5;
use base qw( MT::Plugin );
use MT::Util qw( encode_url );
use vars qw( $PLUGIN_NAME $VERSION $SCHEMA_VERSION );
$PLUGIN_NAME = 'AccessControl';
$VERSION = '2.014';
$SCHEMA_VERSION = '2.001';

my $plugin = __PACKAGE__->new({
    name    => $PLUGIN_NAME,
    version => $VERSION,
    key     => lc $PLUGIN_NAME,
    id      => lc $PLUGIN_NAME,
    author_name => 'SKYARC System Co.,Ltd.',
    author_link => 'http://www.skyarc.co.jp/',
    l10n_class => $PLUGIN_NAME. '::L10N',
    system_config_template => $PLUGIN_NAME . '/system_config.tmpl',
    settings => new MT::PluginSettings([
        ## サイトへの参照権限がない場合は、参照権限のあるサイトへリダイレクトする。
        ['site_redirect' , { default => 1 , scope => 'system' }], 
    ]),
    schema_version => $SCHEMA_VERSION,
    description => <<HTMLHEREDOC,
<__trans phrase=".">
HTMLHEREDOC
});
MT->add_plugin( $plugin );

sub init_registry {
   my $plugin = shift;
   $plugin->registry({
       callbacks => {
           'accesscontrol_page_permission', \&page_permission,
           'accesscontrol_blog_permission', \&blog_permission,
           'accesscontrol_user_authentication' , \&user_authentication,
       },
       tags => {
            block => {

                ## login user infomation
                ##
                ## equal <mt:authors> one context (login user)
               'AccessControlAuthor' => 'AccessControl::Tags::author',

                ## permissions
                ##
                ##  <specify blog>
                ##
                ##  blog_id = "1"
                ##  global="1" or space="global" (default modifier) equal $app->blog->id or $app->param('blog_id')
                ##
                ##  Template_Context
                ##
                ##  blog="1" or space="blog" equal $ctx->stash('blog')->id
                ##  entry=1 or space="entry" equeal $ctx->stash('entry')->blog_id or $ctx->stash('page')->blog_id
                ##  category=1 or space="category" $ctx->stash('category')->blog_id or $ctx->stash('folder')->blog_id
                ##
               'AccessControlCanDo?'          => 'AccessControl::Tags::can_do',
               'AccessControlCanView?'        => 'AccessControl::Tags::can_view',
               'AccessControlCanComment?'     => 'AccessControl::Tags::can_comment',
               'AccessControlCanPost?'        => 'AccessControl::Tags::can_post',
               'AccessControlCanEdit?'        => 'AccessControl::Tags::can_edit',
               'AccessControlCanBlogAdmin?'   => 'AccessControl::Tags::can_blog_admin',
               'AccessControlCanWebsiteAdmin?'=> 'AccessControl::Tags::can_website_admin',
               'AccessControlCanAdminister?'  => 'AccessControl::Tags::can_administer',

               ## list context ( add permission filter )
               'AccessControlBlogs'     => 'AccessControl::Tags::accesscontrol_tags',
               'AccessControlWebsites'  => 'AccessControl::Tags::accesscontrol_tags',
               'AccessControlEntries'   => 'AccessControl::Tags::accesscontrol_tags',
               'AccessControlCategories'=> 'AccessControl::Tags::accesscontrol_tags',
               'AccessControlFolders'   => 'AccessControl::Tags::accesscontrol_tags',
               'AccessControlPages'     => 'AccessControl::Tags::accesscontrol_tags',
               'AccessControlComments'  => 'AccessControl::Tags::accesscontrol_tags',
               'AccessControlPings'     => 'AccessControl::Tags::accesscontrol_tags',
               'AccessControlAssets'    => 'AccessControl::Tags::accesscontrol_tags',

               ## Shortcut names
               'ACAuthor'          => 'AccessControl::Tags::author',
               'ACCanDo?'          => 'AccessControl::Tags::can_do',
               'ACCanView?'        => 'AccessControl::Tags::can_view',
               'ACCanComment?'     => 'AccessControl::Tags::can_comment',
               'ACCanPost?'        => 'AccessControl::Tags::can_post',
               'ACCanBlogAdmin?'   => 'AccessControl::Tags::can_blog_admin',
               'ACCanWebsiteAdmin?'=> 'AccessControl::Tags::can_website_admin',
               'ACCanAdminister?'  => 'AccessControl::Tags::can_administer',
               'ACBlogs'     => 'AccessControl::Tags::accesscontrol_tags',
               'ACWebsites'  => 'AccessControl::Tags::accesscontrol_tags',
               'ACEntries'   => 'AccessControl::Tags::accesscontrol_tags',
               'ACCategories'=> 'AccessControl::Tags::accesscontrol_tags',
               'ACFolders'   => 'AccessControl::Tags::accesscontrol_tags',
               'ACPages'     => 'AccessControl::Tags::accesscontrol_tags',
               'ACComments'  => 'AccessControl::Tags::accesscontrol_tags',
               'ACPings'     => 'AccessControl::Tags::accesscontrol_tags',
               'ACAssets'    => 'AccessControl::Tags::accesscontrol_tags',
            },
            function => {
               ## system pages
               ##
               ##  <specify blog>
               ##
               ##  blog_id="2" ( default 0: $app->blog > $app->param('blog_id') > $ctx->stash(blog) )
               ##
               'AccessControlSystemURL'          => 'AccessControl::Tags::system_pages',
               'AccessControlSystemSettings'     => 'AccessControl::Tags::system_pages',
               'AccessControlSystemBlogSettings' => 'AccessControl::Tags::system_pages',
               'AccessControlSystemEditEntry'    => 'AccessControl::Tags::system_pages',
               'AccessControlSystemEditPage'     => 'AccessControl::Tags::system_pages',
               'AccessControlSystemEditCategory' => 'AccessControl::Tags::system_pages',
               'AccessControlSystemEditFolder'   => 'AccessControl::Tags::system_pages',
               'AccessControlSystemUserDashboard'=> 'AccessControl::Tags::system_pages',
               'AccessControlSystemPostEntry'    => 'AccessControl::Tags::system_pages',
               'AccessControlSystemLoginURL'     => 'AccessControl::Tags::system_pages',
               'AccessControlSystemLogoutURL'    => 'AccessControl::Tags::system_pages',
               'AccessControlLoginURL'           => 'AccessControl::Tags::system_pages',
               'AccessControlLogoutURL'          => 'AccessControl::Tags::system_pages',
               'AccessControlErrorURL'           => 'AccessControl::Tags::system_pages',

               ## list counter
               'AccessControlBlogCategoryCount' => 'AccessControl::Tags::accesscontrol_tags',
               'AccessControlBlogEntryCount'    => 'AccessControl::Tags::accesscontrol_tags',
               'AccessControlBlogPageCount'    => 'AccessControl::Tags::accesscontrol_tags',
               'AccessControlBlogPingCount'     => 'AccessControl::Tags::accesscontrol_tags',

               ## Auto Commneter Sign in
               'AccessControlAutoCommenterSignIn' => 'AccessControl::Tags::auto_commenter_sign_in',

               ## Shortcut names
               'ACAutoCommenterSignIn' => 'AccessControl::Tags::auto_commenter_sign_in',
               
               'ACSystemURL'          => 'AccessControl::Tags::system_pages',
               'ACSystemSettings'     => 'AccessControl::Tags::system_pages',
               'ACSystemBlogSettings' => 'AccessControl::Tags::system_pages',
               'ACSystemEditEntry'    => 'AccessControl::Tags::system_pages',
               'ACSystemEditPage'     => 'AccessControl::Tags::system_pages',
               'ACSystemEditCategory' => 'AccessControl::Tags::system_pages',
               'ACSystemEditFolder'   => 'AccessControl::Tags::system_pages',
               'ACSystemUserDashboard'=> 'AccessControl::Tags::system_pages',
               'ACSystemPostEntry'    => 'AccessControl::Tags::system_pages',
               'ACSystemLoginURL'     => 'AccessControl::Tags::system_pages',
               'ACSystemLogoutURL'    => 'AccessControl::Tags::system_pages',
               'ACLoginURL'           => 'AccessControl::Tags::system_pages',
               'ACLogoutURL'          => 'AccessControl::Tags::system_pages',
               'ACErrorURL'           => 'AccessControl::Tags::system_pages',
               'ACBlogCategoryCount'  => 'AccessControl::Tags::accesscontrol_tags',
               'ACBlogEntryCount'     => 'AccessControl::Tags::accesscontrol_tags',
               'ACBlogPageCount'     => 'AccessControl::Tags::accesscontrol_tags',
               'ACBlogPingCount'      => 'AccessControl::Tags::accesscontrol_tags',
           },
       },
   });
}

sub instance { $plugin; }
sub user_authentication {
    my ( $eh , $app , $blog_id , $ua_param ) = @_;
    my $author;
    ($author) = $app->login();
    if( $author && $app->is_authorized ){
         return 1 unless ref $author =~ m/MT::Author/; 
         $ua_param->{'flag'} = 1;
         $ua_param->{'author_id'} = $author->id;
    }
    return 1;
}
sub page_permission {
   my ( $eh , $app , $opt ) = @_;
   my $blog_id = 0;
   unless( $opt->{file_info} ){
      my $item = MT::Asset->load( { file_path => $opt->{request_page_path} } );
      if ( $item ){
         $blog_id = $item->blog_id;
      }
   }else{
      my $fi = $opt->{file_info};
      my $blgo_id = $fi->blog_id;
   }
   return 1 unless $blog_id;
   if( exists $app->{author} && $app->{author} )
   {
      return 1 if $app->{author} && $app->user->is_superuser;
      my $perms = MT::Permission->load({ author_id => $app->user->id , blog_id => $blog_id }) || '';
      return 1 if $perms && $perms->permissions;
   }
   $opt->{'status'} = 0;
   return 1;
}
sub blog_permission {
   my ( $eh , $app , $opt ) = @_;
   if( exists $app->{author} && $app->{author} )
   {
      return 1 if $app->user->is_superuser;
      my $perms = MT::Permission->load({ author_id => $app->user->id , blog_id => $opt->{blog_id} }) || '';
      return 1 if $perms && $perms->permissions;
      if( $plugin->get_config_value( 'site_redirect' , 'system' ) ){

          foreach my $id ( keys %{$app->{__proxy_group_blogs}} )
          {
              $perms = MT::Permission->load({ author_id => $app->user->id , blog_id => $id }) || '';
              if ( $perms && $perms->permissions ){
                  $opt->{redirect} = $app->{__proxy_group_blogs}->{$id}->{url};
                  last;
              }
          }
      }
   }
   $opt->{'status'} = 0;
   return 1;
}
1;
