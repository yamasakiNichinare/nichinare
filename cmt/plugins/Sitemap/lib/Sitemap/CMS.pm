package Sitemap::CMS;

use MT 4;
use strict;
use MT::Category;
use Data::Dumper;#DEBUG

sub instance { MT->component( 'Sitemap' ); }

### Method - sitemap_add_category
sub add_category {
    my ( $app ) = @_;

    my %param;
    $param{obj_type} = $app->param('_type') || 'category';
    $param{blog_id} = $app->param('blog_id');
    $param{parent_id} = $app->param('id') || 0;
    $param{return_args} = $app->uri (
        mode => 'dashboard',
        args => { $app->param('home_blog_id') ? (blog_id => $app->param('home_blog_id')) : () },
    );
    &instance->load_tmpl ('add_category.tmpl', \%param);
}

### Method - sitemap_del_category
sub del_category {
    my ( $app ) = @_;

    my $id = $app->param('id')
        or return $app->error ($app->translate ('Invalid request.'));
    my $category = MT::Category->load ($id)
        or return $app->error ($app->translate ('Invalid request.'));

    my %param;
    $param{obj_type} = $app->param('_type') || 'category';
    $param{blog_id} = $app->param('blog_id');
    map { $param{$_} = $category->$_; } qw( id label basename description );
    $param{return_args} = $app->uri (
        mode => 'dashboard',
        args => { $app->param('home_blog_id') ? (blog_id => $app->param('home_blog_id')) : () },
    );
    &instance->load_tmpl ('del_category.tmpl', \%param);
}

1;