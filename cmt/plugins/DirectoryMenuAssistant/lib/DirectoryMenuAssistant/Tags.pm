package DirectoryMenuAssistant::Tags;

use strict;
use MT 4;
use MT::Blog;
use MT::Category;
use MT::Folder;
use MT::Util;
use Data::Dumper;

sub instance { MT->component('DirectoryMenuAssistant') }



### DirectoryMenu
sub _directory_menu {
    my ($ctx, $args) = @_;

    my @parent_categories = ( undef, undef );
    if (defined (my $current_category = _get_category ($ctx))) {
        push @parent_categories, reverse $current_category->parent_categories;
        push @parent_categories, $current_category;
    }

    my $start = $args->{start} ||= 1;
    local $ctx->{__stash}{category_depth} = $start;
        my ($html) = _get_category_tree ($ctx, $args, $parent_categories[$start]);
    $html;
}

sub _get_category_tree {
    my ($ctx, $args, $category) = @_;

    my $current_category = _get_category ($ctx);

    my $blog = $ctx->stash ('blog');
    my $class_type = $args->{class} || _get_class_type ($ctx);
    my @categories = $class_type eq 'category'
        ? $category
            ? MT::Category->load ({ parent => $category->id })
            : MT::Category->top_level_categories ($blog->id)
        : $category
            ? MT::Folder->load ({ parent => $category->id })
            : MT::Folder->top_level_categories ($blog->id);

    # Sort Categories And Folders
    @categories = MT->component('Sort Categories And Folders')
        ? sort { $a->order_number <=> $b->order_number } @categories
        : sort { $a->label        cmp $b->label        } @categories;

    my ($html, $current) = ('', 0);
    foreach (@categories) {
        my $current_found = $current_category && $current_category->id == $_->id;

        $ctx->{__stash}{category_depth}++;
            my ($sub_html, $sub_current) = _get_category_tree ($ctx, $args, $_);
        $ctx->{__stash}{category_depth}--;

        $current ||= $current_found || $sub_current;

        next if $_->hidden && !$args->{show_all};
        next if $args->{depth} && $args->{depth} < $ctx->{__stash}{category_depth};

        $html .= sprintf qq|%s<li%s><a href="%s"%s><span>%s</span></a>%s</li>\n|,
            '    ' x $ctx->{__stash}{category_depth}, # indent
            $current_found || $sub_current ? qq| class="current"| : '',
            $_->alt_link ? $_->alt_link : _get_category_path ($_),
            $_->target_blank
                ? sprintf qq| target="%s" class="%s"|,
                    defined $args->{target} ? $args->{target} : '_blank',
                    defined $args->{class} ? $args->{class} : 'extRef'
                : '',
            MT::Util::encode_html ($_->label),
            $current_found || $sub_current ? $sub_html : '';
    }
    $html = sprintf qq|\n<ul class="level%02d">\n%s</ul>|, $ctx->{__stash}{category_depth}, $html if $html;
    ($html, $current);
}

### IfDirectoryMenuHidden?
sub IfDirectoryMenuHidden {
    my ($ctx, $args, $cond) = @_;

    my $category = _get_category ($ctx)
        or return 0;
    $category->hidden || 0;
}

### IfDirectoryMenuShow
sub IfDirectoryMenuShow {
    !IfDirectoryMenuHidden (@_);
}

### IfDirectoryMenuOpenExternal?
sub IfDirectoryMenuOpenExternal {
    my ($ctx, $args, $cond) = @_;

    my $category = _get_category ($ctx)
        or return 0;
    $category->target_blank || 0;
}

### DirectoryMenuAltLink
sub DirectoryMenuAltLink {
    my ($ctx, $args) = @_;

    my $category = _get_category ($ctx)
        or return '';
    $category->alt_link || '';
}



sub _get_class_type {
    my ($ctx, $args) = @_;

    if (defined (my $category = $ctx->stash('category') || $ctx->stash('archive_category'))) {
        return $category->class_type;
    }
    elsif (defined (my $entry = $ctx->stash ('entry'))) {
        $category = $entry->category;
        return $category
            ? $category->class_type
            : $entry->container_type;
    }
    return 'category';
}

sub _get_category {
    my ($ctx, $args) = @_;

    my $category = $ctx->stash('category') || $ctx->stash('archive_category');
    unless ($category) {
        my $entry = $ctx->stash ('entry');
        if ($entry) {
            $category = $entry->category;
        }
    }
    $category;
}

sub _get_category_path {
    my ($category) = @_;

    my $blog = MT::Blog->load ({ id => $category->blog_id })
        or return '';
    my $site_url = $blog->site_url;
    $site_url =~ s!/+$!!;

    my @basename;
    do {
        unshift @basename, $category->basename;
        $category = $category->parent_category
    } while ($category);

    join '/', $site_url, @basename, '';
}

1;