package BlogsSort::CMS;
use strict;
use warnings;
use MT::Blog;
use Data::Dumper;#DEBUG
use base qw( MT::App );
sub plugin { return MT->instance->component( 'BlogsSort' ); }

sub OWNER_STEP { 5000 }

########################################################################
#   CMS application methods
########################################################################
sub blogs_sort {
    my $app = shift;
    my $q = $app->param;
    return $app->return_to_dashboard( permission => 1 )
        unless _permission_check( $app );

    my $plugin = MT::Plugin::BlogsSort->instance;
    my $tmpl = $plugin->load_tmpl('BlogsSort/blog_sort.tmpl');

    my %param;
    $param{page_title} = $plugin->translate('blog sort Management');

    my $website = $app->blog;
    unless( $website && !$website->is_blog ){
        return $app->error( $plugin->translate('Invalid request.') );
    }
    my @ids = $q->param('blog_ids');
    if ( @ids ){
        foreach my $id (@ids) {
            next unless $id;
            my $sort_no = $q->param('sort_no_' . $id);
            if($sort_no =~ /[\D]/){
                $param{error} .= $plugin->translate('Sort No Error. ID:[_1]', $id);
                next;
            }
            my $blog = MT::Blog->load($id);
            if ($blog){
                $blog->sort_no( $sort_no );
                unless ($blog->save()){
                    $param{error} .= $plugin->translate('Sort No Save Error. ID:[_1]', $id);
                }
            }
        }
        $website->sort_no( 0 );
        unless( $website->save() ){
            $param{error} .= $plugin->translate('Sort No Reset Error. (Website)ID:[_1]', $website->id );
        }
        $param{success} .= $plugin->translate('save blog sort_no.');
    }

    my @set_header_cols = ( 'id' , 'name' , 'sort_no' );
    my ( @query_params , @headers , @blogs );
    @query_params = ( 
       { name => '__mode' , value => 'blogs_sort' },
       { name => 'blog_id' , value => $website->id },
    );

    my %terms = ( 'parent_id' => $website->id );
    my %args  = ( 'sort' => 'sort_no' , 'direction' => 'ascend' );
    my @blog_lists = MT::Blog->load( \%terms , \%args );
    my $sort_no = 0;
    for my $blog ( @blog_lists )
    {
       my %list;
       for( @set_header_cols )
       {
          $list{$_} = $blog->$_ || 0;
       }
       push @blogs, \%list;
    }
    for( @set_header_cols ){
       push @headers , ({ 'col' => $_ , 'display_name' => $plugin->translate($_) });
    }
    $param{'query_params'} = \@query_params;
    $param{'no_blog'}      = scalar @blogs ? 0 : 1;
    $param{'blogs'}        = \@blogs;
    $param{'headers'}      = \@headers;
    return $app->build_page( $tmpl, \%param );

}
########################################################################
#   Common functions
########################################################################

### permission check
sub _permission_check {
    my $app = shift;
    return 1 if $app->user && $app->user->is_superuser;
    return 1 if $app->permissions->can_administer_website;
    return 0;
}

1;