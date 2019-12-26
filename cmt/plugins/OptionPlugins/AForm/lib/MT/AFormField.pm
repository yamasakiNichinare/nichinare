# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package MT::AFormField;

use strict;

use MT::Object;
@MT::AFormField::ISA = qw(MT::Object);
__PACKAGE__->install_properties({
	column_defs => {
		'id' => 'integer not null auto_increment',
		'aform_id' => 'integer not null',
		'type' => 'string(10) not null',
		'label' => 'text',
		'is_necessary' => 'boolean',
		'sort_order' => 'integer',
		'property' => 'text',
	},
	indexes => {
		'id' => 1,
		'aform_id' => 1,
                'type' => 1,
                'sort_order' => 1,
	},
        defaults => {
        },
	audit => 1,
	datasource => 'aform_field',
	primary_key => 'id'
});

sub options {
    my $self = shift;

    my $property = $self->_get_property();
    my $options = $property->{options};
    if ( ref($options) eq 'ARRAY' ) {
        for ( my $i=0; $i<@$options; $i++ ) {
            $options->[$i]->{'index'} = $i+1; 
        }
    }
    return $options;
}

sub use_default {
    my $self = shift;

    my $property = $self->_get_property();
    return $property->{use_default};
}

sub default_label {
    my $self = shift;

    my $property = $self->_get_property();
    return $property->{default_label};
}

sub privacy_link {
    my $self = shift;

    my $property = $self->_get_property();
    return $property->{privacy_link};
}

sub is_replyed {
    my $self = shift;

    my $property = $self->_get_property();
    return $property->{is_replyed};
}

sub input_example {
    my $self = shift;

    my $property = $self->_get_property();
    return $property->{input_example};
}

sub max_length {
    my $self = shift;

    my $property = $self->_get_property();
    return $property->{max_length};
}

sub _get_property {
    my $self = shift;

    my $property = $self->property;
    require AFormEngineCGI::Common;
    return AFormEngineCGI::Common::json_to_obj($self->property);
}

1;
