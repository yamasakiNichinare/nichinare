# Movable Type (r) (C) 2007-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: Field.pm 117483 2010-01-07 08:27:20Z ytakayama $

# Original Copyright (c) 2005-2007 Arvind Satyanarayan

package CustomFields::Field;

use strict;
use base qw( MT::Object );

use MT::Util qw( dirify );

__PACKAGE__->install_properties({
    column_defs => {
        'id'          => 'integer not null auto_increment',
        'blog_id'     => 'integer',
        'name'        => 'string(255) not null',
        'description' => 'text',
        'obj_type'    => 'string(50) not null',
        'type'        => 'string(50) not null',
        'tag'         => 'string(255) not null',
        'default'     => 'text',
        'options'     => 'text',
        'required'    => 'boolean',
        'basename'    => 'string(255)',
    },
    indexes => {
        blog_id  => 1,
        name     => 1,
        obj_type => 1,
        type     => 1,
        basename => 1,
        blog_tag => {
            columns => [ 'blog_id', 'tag' ],
        },
    },
    primary_key => 'id',
    datasource => 'field',
});

sub class_label {
    return MT->translate("Field");
}

sub class_label_plural {
    return MT->translate("Fields");
}

sub save {
    my $field = shift;

    ## If there's no basename specified, create a unique basename.
    if (!defined($field->basename) || ($field->basename eq '')) {
        my $name = $field->make_unique_field_basename();
        $field->basename($name);
    }

    my $id = $field->id;
    my $orig_basename;

    if ($id) {
        if ($field->{changed_cols}{basename}) {
            my $orig_obj = __PACKAGE__->load($id);
            $orig_basename = $orig_obj->basename;
        }
    }

    my $res = $field->SUPER::save(@_);
    if ($res) {
        if (! $id) { # new meta field
            # install it!
            $field->add_meta();
        }
        if ( defined $orig_basename ) {
            # update existing meta records to use new basename
            my $ppkg = MT->model($field->obj_type);
            if ($ppkg) {
                if (my $mpkg = $ppkg->meta_pkg) {
                    my $driver = $mpkg->driver;
                    my $type_col = $driver->dbd->db_column_name($mpkg->datasource, 'type');
                    my $dbh = $driver->r_handle;
                    if ( $field->basename ne $orig_basename ) {
                        my $basename = $field->basename;
                        $orig_basename = $orig_basename;

                        $driver->sql('update ' . $mpkg->table_name
                            . qq{ set $type_col='field.$basename'}
                            . qq{ where $type_col='field.$orig_basename'});

                        $driver->clear_cache if $driver->can('clear_cache');
                    }
                }
            }
        }
    }

    return $res;
}

sub make_unique_field_basename {
    my $field = shift;
    my %param = @_;
    my ($base_stem, $field_id, $blog_id, $type, $check_only)
        = @param{qw( stem field_id blog_id type check_only )};

    if (ref $field) {
        $base_stem ||= $field->name;
        $field_id  ||= $field->id;
        $blog_id   ||= $field->blog_id;
        $type      ||= $field->type;
    }

    # Normalize the suggested basename.
    $base_stem ||= q{};
    $base_stem =~ s{ \A \s+ | \s+ \z }{}xmgs;
    $base_stem = dirify($base_stem);
    my $limit = 30;
    if ($blog_id) {
        my $blog = MT->model('blog')->load($blog_id);
        if ($blog && $blog->basename_limit) {
            $limit = $blog->basename_limit;
            $limit = 15  if $limit < 15;
            $limit = 250 if $limit > 250;
        }
    }
    $base_stem = substr $base_stem, 0, $limit;
    $base_stem =~ s{ _+ \z }{}xms;
    $base_stem ||= 'cf';

    my $i = 1;
    my $base = $base_stem;
    my $class = MT->model('field');
    my %terms = $field_id ? ( id => { op => '!=', value => $field_id } )
        : ();

    # System level fields have to be totally unique.
    if (!$blog_id) {
        while ($class->count({ %terms, basename => $base })) {
            return if $check_only;
            $base = $base_stem . '_' . $i++;
        }
        return $base;
    }

    # Blog level fields have to not conflict with a system field or a field
    # from a different blog with a different data type.
    BASE: while (my @dupes = $class->load({ %terms, basename => $base })) {
        DUP_FIELD: for my $dup_field (@dupes) {
            my $conflict = !$dup_field->blog_id             ? 1
                         :  $dup_field->blog_id == $blog_id ? 1
                         :  $dup_field->type ne $type       ? 1
                         :                                    0
                         ;
            if ($conflict) {
                return if $check_only;
                $base = $base_stem . '_' . $i++;
                next BASE;
            }
        }
        # All the duplicate fields are fields of the same type in other
        # blogs. We can use that basename too.
        last BASE;
    }

    return $base;
}

sub parents {
    my $obj = shift;
    {
        blog_id => { class => [ MT->model('blog'), MT->model('website') ], optional => 1 },
    };
}

sub create_obj_to_backup {
    my $class = shift;
    my ($blog_ids, $obj_to_backup, $populated, $order) = @_;

    # system fields have to be backed up earlier
    push @$obj_to_backup, {
        $class => {
            terms => { 'blog_id' => '0' },
            args => undef
        },
        'order' => 300, # earlier than website
    };

    if (defined($blog_ids) && scalar(@$blog_ids)) {
        push @$obj_to_backup, {
            $class => {
                terms => { 'blog_id' => $blog_ids },
                args => undef
            },
            'order' => $order,
        };
    }
    else {
        push @$obj_to_backup, {
            $class  => { terms => { 'blog_id' => { 'not' => '0' } }, args => undef },
            'order' => $order,
        };
    }
}

sub add_meta {
    my $field = shift;

    my $ppkg = MT->model($field->obj_type);
    return 0 unless $ppkg;

    my $types = MT->registry("customfield_types");

    my $fields = {};
    my $cf_type = $types->{$field->type}
        or return 0;

    my $type = $cf_type->{column_def} || 'vblob';
    $ppkg->install_meta({ column_defs => {
        'field.' . $field->basename => $type
    }});
    return 1;
}

1;
