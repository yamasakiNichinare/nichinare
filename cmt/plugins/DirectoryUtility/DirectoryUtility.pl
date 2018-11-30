package MT::Plugin::SKR::DirectoryUtility;

use strict;
use warnings;
use MT::Entry;
use MT::Category;

use vars qw( $NAME $VERSION );
$NAME = 'DirectoryUtility';
$VERSION = '1.12';

use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new({
        name => $NAME,
        version => $VERSION,
        author_name => 'SKYARC System Co.,Ltd.',
        author_link => 'http://www.skyarc.co.jp',
        doc_link=>'http://www.skyarc.co.jp/engineerblog/entry/directoryutility.html',
        l10n_class => $NAME. '::L10N',
        description => '<MT_TRANS phrase="MT Tag of the category and the folder is enhanced.">',
        registry => {
            tags => {
                 function => {
                  TopLevelDirectoryBasename => \&_hdlr_topLevel_directory_function,
                  TopLevelDirectoryName     => \&_hdlr_topLevel_directory_function,
                  TopLevelDirectoryId       => \&_hdlr_topLevel_directory_function,
                  DirectoryDepth            => \&_hdlr_topLevel_directory_function,
            },
         },
     },
});
MT->add_plugin ($plugin);

### To get the current category.
sub _getCurrentCategory {
   my ( $ctx , $args ) = @_;

   return $ctx->stash('category') if $ctx->stash('category');
   my $entry = $ctx->stash('entry');
   return $entry->category if $entry && $entry->category;
   return $ctx->stash('archive_category') if $ctx->stash('archive_category');
   return '';

}
### Tag:MTTopLevelDirectoryXXXX
sub _hdlr_topLevel_directory_function {
    my ($ctx, $args) = @_;

    my $tag = lc $ctx->stash('tag') 
           or return '';

    my $category = _getCurrentCategory( $ctx , $args ) 
           or return '';

    my @parent_categories = $category->parent_categories;
    foreach my $cate ( @parent_categories ) {
        $category = $cate unless $cate->parent_categories;
    }

    return $category->basename if $tag eq 'topleveldirectorybasename';
    return $category->label if $tag eq 'topleveldirectoryname';
    return $category->id if $tag eq 'topleveldirectoryid';

    return '' unless $tag eq 'directorydepth';
    return 1 + scalar  @parent_categories;
}
1;