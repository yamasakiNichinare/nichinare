# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package MT::AForm;

use strict;

use MT::Object;
@MT::AForm::ISA = qw(MT::Object);
__PACKAGE__->install_properties({
	column_defs => {
		'id' => 'integer not null auto_increment',
		'title' => 'string(255) not null',
		'status' => 'string(20) not null',
		'thanks_url' => 'string(255)',
		'start_at' => 'datetime',
		'end_at' => 'datetime',
		'mail_to' => 'string(100)',
		'mail_from' => 'string(100)',
		'mail_cc' => 'string(100)',
		'mail_bcc' => 'string(100)',
		'mail_subject' => 'string(255)',
		'mail_header' => 'text',
		'mail_footer' => 'text',
		'is_replyed_to_customer' => 'boolean not null',
		'action_url' => 'string(255)',
		'data_id' => 'integer',
		'data_id_offset' => 'integer',
		'check_immediate' => 'integer',
	},
	indexes => {
		'id' => 1,
                'title' => 1,
                'status' => 1,
                'start_at' => 1,
                'end_at' => 1,
	},
        defaults => {
                'is_replyed_to_customer' => 0,
                'data_id' => 0,
                'data_id_offset' => 0,
		'check_immediate' => 1,
        },
	audit => 1,
	datasource => 'aform',
	primary_key => 'id'
});

sub next {
  my $aform = shift;
  my @next_aform = MT::App->model('aform')->load( 
                     { id => [ $aform->id, undef ] },
                     { 
                       sort => 'id',
                       direction => 'ascend',
                       range => { id => 1},
                       limit => 1,
                     }
                   );
  return @next_aform ? $next_aform[0] : "";
}

sub previous {
  my $aform = shift;
  my @prev_aform = MT::App->model('aform')->load( 
                     { id => [ undef, $aform->id ] },
                     { 
                       sort => 'id',
                       direction => 'descend',
                       range => { id => 1},
                       limit => 1,
                     }
                   );
  return @prev_aform ? $prev_aform[0] : "";
}
1;

