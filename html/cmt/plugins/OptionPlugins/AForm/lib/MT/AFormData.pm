# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package MT::AFormData;

use strict;

use MT::Object;
@MT::AFormData::ISA = qw(MT::Object);
__PACKAGE__->install_properties({
	column_defs => {
		'id' => 'integer not null auto_increment',
                'aform_id' => 'integer not null',
                'values' => 'text',
                'aform_url' => 'string(255) not null',
	},
	indexes => {
		'id' => 1,
                'aform_id' => 1,
                'aform_url' => 1,
	},
        defaults => {
        },
	audit => 1,
	datasource => 'aform_data',
	primary_key => 'id'
});

1;

