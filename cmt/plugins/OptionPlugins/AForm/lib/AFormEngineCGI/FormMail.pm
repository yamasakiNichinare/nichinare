# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package AFormEngineCGI::FormMail;

use strict;
use Time::Local;
use AFormEngineCGI::Common;
use MT::Mail;
use MT::I18N;

sub validate_param {
    my $app = shift;
    my $aform = shift;

    my $plugin = MT->component('AForm');
    my @error_msgs;

    my $fields = &_inject_param_value($app, &_get_fields($app, $aform), '');

    foreach my $field ( @$fields ){
        # Necessary
        if( $field->{'is_necessary'} ) {
            if( !&AFormEngineCGI::Common::must_check( $field->{'label_value'} ) ) {
              if( $field->{'type'} eq 'privacy' ){
                push(@error_msgs, $plugin->translate('Please agree to [_1]. Please check if you agree. (It is not possible to send if you do not agree.)', $field->{'label'}));
              }else{
                push(@error_msgs, $plugin->translate('[_1] is not input.', $field->{'label'}));
              }
            }
        }

        # If any value not received, Go next!
        next if( !&AFormEngineCGI::Common::must_check( $field->{'label_value'} ) );

        # E-Mail
        if ( $field->{'type'} eq 'email' ) {
            if( !&AFormEngineCGI::Common::mail_check( $field->{'label_value'} ) ) {
                push(@error_msgs, $plugin->translate('[_1] format is invalid. ex) foo@example.com (ascii character only)', $field->{'label'}));
            }
        }
        # Tel
        if ( $field->{'type'} eq 'tel' ) {
            if( !&AFormEngineCGI::Common::num_check( $field->{'label_value'} ) ) {
                push(@error_msgs, $plugin->translate('[_1] format is invalid. ex) 03-1234-5678 (numbers and "-" only)', $field->{'label'}));
            }
        }
        # URL
        if ( $field->{'type'} eq 'url' ) {
            if( !&AFormEngineCGI::Common::url_check( $field->{'label_value'} ) ) {
                push(@error_msgs, $plugin->translate('[_1] format is invalid. ex) http://www.example.com/ (ascii character only)', $field->{'label'}));
            }
        }
        # Zipcode
        if ( $field->{'type'} eq 'zipcode' ) {
            if( !&AFormEngineCGI::Common::zipcode_check( $field->{'label_value'} ) ) {
                push(@error_msgs, $plugin->translate('[_1] format is invalid. ex) 123-4567 (numbers and "-" only)', $field->{'label'}));
            }
        }

        # max length
        if ( $field->{'max_length'} > 0 ) {
            $field->{'label_value'} =~ s/\x0D\x0A|\x0D|\x0A//g;
            if( MT::I18N::length_text($field->{'label_value'}) > $field->{'max_length'} ){
                push(@error_msgs, $plugin->translate('Please enter [_1] of [_2] characters.', $field->{'label'}, $field->{'max_length'}) );
            }
        }
    }

    return @error_msgs;
}

sub generate_form_preview {
    my $app = shift;
    my $aform = shift;

    my %param = (
        id => $aform->id,
        title => $aform->title,
        fields => &_get_fields($app, $aform),
        action_url => &_get_action_url($app),
        logger_url => &_get_logger_url($app),
        charset => $app->charset,
        preview => 1,
        static_uri => $app->static_path,
    );

    my $html = $app->load_tmpl(&_get_tmpl_file_path($app, $aform->id, 'aform_form.tmpl'), \%param);
    return $app->build_page($html, \%param);
}

sub generate_form_view {
    my $app = shift;
    my $aform = shift;
    my $ctx = shift;

    my $plugin = MT->component('AForm');
    my $for_business = &is_business();
    my $checked_sn = int($plugin->get_config_value('checked_sn'));

    my %param = (
        blog_id => $ctx->stash('blog_id'),
        id => $aform->id,
        title => $aform->title,
        fields => &_get_fields($app, $aform),
        action_url => &_get_action_url($app),
        logger_url => &_get_logger_url($app),
        checker_url => &_get_checker_url($app),
        aform_url => $ctx->stash('entry')->permalink,
        charset => $app->charset,
        preview => 0,
        static_uri => &_get_static_uri($app, $ctx->stash('blog_id')),
        hide_demo_warning => (!$for_business || $checked_sn),
        hide_powered_by => ($for_business || $checked_sn),
        check_immediate => $aform->check_immediate,
    );

    my $html = $app->load_tmpl(&_get_tmpl_file_path($app, $aform->id, 'aform_form.tmpl'), \%param);
    return $app->build_page($html, \%param);
}

sub generate_confirmation_view {
    my $app = shift;
    my $aform = shift;

    my $blog_id = int($app->param('blog_id'));

    my %param = (
        id => $aform->id,
        title => $app->blog->name,
        aform_title => $aform->title,
        fields => &_inject_param_value($app, &_get_fields($app, $aform), 'html'),
        blog_id => $blog_id,
        use_xhr => ($aform->thanks_url eq '') ? 1 : 0,
        blog_top => $app->blog->site_url,
        action_url => &_get_action_url($app),
        logger_url => &_get_logger_url($app),
        aform_url => $app->param('aform_url'),
        app_version_id => $app->version_id,
        template_set => $app->blog->template_set,
        use_mt_blog_template_set_ver42 => &_use_mt_blog_template_set_ver42($app, $blog_id),
        static_uri => &_get_static_uri($app, $blog_id),
    );

    my $tmpl = $app->load_tmpl(&_get_tmpl_file_path($app, $app->param('id'), 'aform_confirm.tmpl'), \%param);
    $tmpl->context->stash('blog_id', $blog_id);
    return $app->build_page($tmpl, \%param);
}

sub generate_finish_view {
    my $app = shift;
    my $aform = shift;

    my $blog_id = int($app->param('blog_id'));

    my %param = (
        title => $app->blog->name,
        aform_title => $aform->title,
        blog_id => $blog_id,
        blog_top => $app->blog->site_url,
        app_version_id => $app->version_id,
        template_set => $app->blog->template_set,
        use_mt_blog_template_set_ver42 => &_use_mt_blog_template_set_ver42($app, $blog_id),
        static_uri => &_get_static_uri($app, $blog_id),
    );

    my $tmpl = $app->load_tmpl(&_get_tmpl_file_path($app, $app->param('id'), 'aform_finish.tmpl'), \%param);
    $tmpl->context->stash('blog_id', $blog_id);
    return $app->build_page($tmpl, \%param);
}

sub generate_error_view {
    my $app = shift;
    my $error_msgs = shift;

    my $blog_id = int($app->param('blog_id'));

    my %param = (
        title => $app->blog->name,
        blog_id => $blog_id,
        error_msgs => $error_msgs,
        app_version_id => $app->version_id,
        template_set => $app->blog->template_set,
        use_mt_blog_template_set_ver42 => &_use_mt_blog_template_set_ver42($app, $blog_id),
        static_uri => &_get_static_uri($app, $blog_id),
    );

    my $tmpl = $app->load_tmpl(&_get_tmpl_file_path($app, $app->param('id'), 'aform_error.tmpl'), \%param);
    $tmpl->context->stash('blog_id', $blog_id);
    return $app->build_page($tmpl, \%param);
}

sub _get_fields {
    my $app = shift;
    my $aform = shift;

    my @aform_fields = MT::AFormField->load({ aform_id => $aform->id() }, { sort => 'sort_order' });

    my @fields;
    for my $aform_field (@aform_fields) {
        my $param = {
            id => $aform_field->id,
            type => $aform_field->type,
            label => $aform_field->label,
            is_necessary =>  $aform_field->is_necessary,
            options => $aform_field->options,
            use_default => $aform_field->use_default,
            default_label => $aform_field->default_label,
            privacy_link => $aform_field->privacy_link,
            is_replyed => $aform_field->is_replyed,
            input_example => $aform_field->input_example,
            max_length => $aform_field->max_length,
        };
        push(@fields, $param);
    }
    return \@fields;
}


sub _get_script_url_dir {
    my $app = shift;

    my $plugin = MT->component('AForm');
    my $script_url_dir = $plugin->get_config_value('script_url_dir');
    if( $script_url_dir !~ m#\/$# ){
        $script_url_dir .= '/';
    }
    if( ! &AFormEngineCGI::Common::url_check( $script_url_dir ) ){
        $script_url_dir = $app->mt_path . 'plugins/AForm/';
    }
    return $script_url_dir;
}


sub _get_action_url {
    my $app = shift;

    return &_get_script_url_dir($app) . 'aform_engine.cgi';
}

sub _get_logger_url {
    my $app = shift;

    return &_get_script_url_dir($app) . 'aform_logger.cgi';
}

sub _get_checker_url {
    my $app = shift;

    return &_get_script_url_dir($app) . 'aform_checker.cgi';
}

sub _get_static_uri {
    my $app = shift;
    my $blog_id = shift;

    my $static_uri = $app->static_path;
    my $blog = MT::Blog->load($blog_id);
    if( $blog && $blog->site_url =~ m#^https://# ){
      $static_uri =~ s#^http://#https://#;
    }
    return $static_uri;
}

sub _inject_param_value {
    my $app = shift;
    my $fields = shift;
    my $mode = shift;

    require 'convert_dependence_char.pl';

    for my $field (@$fields) {
        if (  $field->{'type'} eq 'checkbox' || $field->{'type'} eq 'privacy' ) {
            my $options = $field->{'options'};
            if ( ref($options) eq 'ARRAY' ) {
                my @values;
                my %hash_values;
                for ( my $i=0; $i<@$options; $i++ ) {
                    my $value = $app->param(&_get_field_key($field->{'id'}, $i+1));
                    $value = convert_dependence_char($value);
                    if( $value ne '' && $value =~ /\d+/ ){
                      push(@values, $value);
                      $hash_values{$i+1} = $value;
                   }
                }
                $field->{'values'} = \@values;
                $field->{'hash_values'} = \%hash_values;
                $field->{'label_value'} = join("\n", map { $field->{'options'}->[$_-1]->{'label'} } @values);
            } else {
                return $app->error(
                $app->translate( "Checkbox field always require array data structure. Illegal data structure is found." ) );
            }
        } else {
            my $value = $app->param(&_get_field_key($field->{'id'}));
            $value = convert_dependence_char($value);
            if ( $field->{'type'} eq 'radio' || $field->{'type'} eq 'select' || $field->{'type'} eq 'prefecture' ) {
                if( $value ne '' && $value =~ /\d+/ ){
                    $field->{'value'} = $value;
                    my $options = $field->{'options'};
                    if ( ref($options) eq 'ARRAY' ) {
                        foreach my $option (@$options) {
                            if( $option->{'value'} eq $value ){
                                $field->{'label_value'} = $option->{'label'};
                                last;
                            }
                        }
                    } else {
                        return $app->error(
                        $app->translate( "Radio or Select field always require array data structure. Illegal data structure is found." ) );
                    }
                }
            } else {
                $field->{'value'} = $value;
                $field->{'label_value'} = $value;
            }
        }
        if( $mode eq 'html' ){
            $field->{'value'} = MT::Util::encode_html($field->{'value'});
            $field->{'label_value'} = MT::Util::encode_html($field->{'label_value'});
            $field->{'label_value'} = &_crlf2br($field->{'label_value'});
        }
    }

    return $fields;
}

sub _get_field_key {
    my $id = shift;
    my $index = shift;
    return $index ne '' ? 'aform-field-' . $id . '-' . $index : 'aform-field-' . $id;
}

sub _crlf2br {
    my $str = shift;
    $str =~ s/\x0D\x0A/<br\/>/g;
    $str =~ s/\x0D/<br\/>/g;
    $str =~ s/\x0A/<br\/>/g;
    return $str;
}

sub _get_csv_record {
	my ($data_id, $fields) = @_;
        my $datetime = &AFormEngineCGI::Common::get_date(); 

	my $spliter = ",";
	my $data = qq("$data_id");
	$data .= qq($spliter"$datetime");
	foreach my $field ( @$fields ){
            if( $field->{'type'} ne 'label' && $field->{'type'} ne 'note' ){
		$field->{'label_value'} =~ s/"/""/g;
		$data .= qq($spliter"$field->{'label_value'}");
            }
	}

	return $data;
}

sub check_double_submit
{
	my $app = shift;
	my $aform = shift;

	my ($data, $cmp_date, $compare, $double_submit_flag);

	my $fields = &_inject_param_value($app, &_get_fields($app, $aform), '');
	$data = &_get_csv_record($aform->data_id_offset + $aform->data_id, $fields);
	$data =~ s/.*?\",(.*)/$1/; # remove first column
	$data =~ s/.*?\",(.*)/$1/; # remove 2nd column

	# get last post data
	my $last_data = MT::AFormData->load( 
		{ aform_id => $aform->id }, 
		{ sort_order => 'created_on', direction => 'descend', limit => 1 } );
	if( !$last_data ){
		return 0;
	}

	$compare = $last_data->values;
	$compare =~ s/.*?\",(.*)/$1/; # remove first column
	$compare =~ /\"(.*?)\",(.*)/; # divine datetime and datas
	$cmp_date = $1;
	$compare  = $2;

	my $DOUBLE_SUBMIT_TIME_RANGE = 30;	# sec
	if ($data eq $compare
	and _datetime2timelocal($cmp_date)+$DOUBLE_SUBMIT_TIME_RANGE - time() > 0) {
		return 1;
	}

	return 0;
}

sub _datetime2timelocal {
	my ($date) = @_;
	
	$date =~ /^(\d+)\/(\d+)\/(\d+) (\d+):(\d+):(\d+)$/;
	my ($year) = $1;
	my ($mon)  = $2;
	my ($day)  = $3;
	my ($hour) = $4;
	my ($min)  = $5;
	my ($sec)  = $6;
	
	return timelocal($sec, $min, $hour, $day, $mon-1, $year);
}

sub _get_customer_mail {
	my( $fields ) = @_;

        my @customer_mails;
	foreach my $field ( @$fields ){
		if( $field->{'type'} == 'email' && $field->{'is_replyed'} && &AFormEngineCGI::Common::mail_check($field->{'value'}) ){
			push( @customer_mails, $field->{'value'} );
		}
	}
	return( \@customer_mails );
}

sub send_mail {
	my $app = shift;
	my $aform = shift;

	require 'convert_dependence_char.pl';

	my $fields = &_inject_param_value($app, &_get_fields($app, $aform), '');
	my $customer_mails = &_get_customer_mail($fields);

	my %param = (
		datetime => &AFormEngineCGI::Common::get_date(),
		fields => $fields,
	);
	my $html = $app->load_tmpl(&_get_tmpl_file_path($app, $aform->id, 'mail_aform_admin.tmpl'), \%param);
	my $body = &_replace_aform_data_id($aform->mail_header, $aform);
        $body .= "\n" if ($aform->mail_header !~ m/\n$/);
	$body .= $app->build_page($html, \%param) . &_replace_aform_data_id($aform->mail_footer, $aform);
	$body = &convert_dependence_char($body);

        my $mail_from = $aform->mail_from;
	my %headers = ( 
		'From' => $mail_from,
		'To' => $aform->mail_to,
		'Subject' => &convert_dependence_char(&_replace_aform_data_id($aform->mail_subject, $aform)),
		'Cc' => $aform->mail_cc,
		'Bcc' => $aform->mail_bcc,
#		'Return-Path' => $mail_from,
		'Reply-To' => ( @$customer_mails ) ? join(',', @$customer_mails) : $mail_from,
	);
	MT::Mail->send(\%headers, $body);
}


sub reply_to_customer {
	my $app = shift;
	my $aform = shift;

	require 'convert_dependence_char.pl';

	my $fields = &_inject_param_value($app, &_get_fields($app, $aform), '');
	my $customer_mails = &_get_customer_mail($fields);

	if( @$customer_mails == 0 ) {
		return;
	}

	my %param = (
		datetime => &AFormEngineCGI::Common::get_date(),
		fields => $fields,
	);
	my $html = $app->load_tmpl(&_get_tmpl_file_path($app, $aform->id, 'mail_aform_customer.tmpl'), \%param);
	my $body = &_replace_aform_data_id($aform->mail_header, $aform);
        $body .= "\n" if ($aform->mail_header !~ m/\n$/);
        $body .= $app->build_page($html, \%param) . &_replace_aform_data_id($aform->mail_footer, $aform);
	$body = &convert_dependence_char($body);

        my $mail_from = $aform->mail_from;
        foreach my $customer_mail ( @$customer_mails ){
	  my %headers = ( 
		'From' => $mail_from,
		'To' => $customer_mail,
		'Subject' => &convert_dependence_char(&_replace_aform_data_id($aform->mail_subject, $aform)),
		'Bcc' => '',
#		'Return-Path' => $mail_from,
		'Reply-To' => $mail_from,
	  );
	  MT::Mail->send(\%headers, $body);
        }
}


sub _replace_aform_data_id {
    my $str = shift;
    my $aform = shift;

    my $data_id = sprintf("%0d", $aform->data_id_offset + $aform->data_id);
    $str =~ s/__%aform-data-id%__/$data_id/g;
    return $str;
}


sub store {
    my $app = shift;
    my $aform = shift;

    $aform->set_values({
      'data_id' => $aform->data_id + 1,
    });
    $aform->save();

    my $fields = &_inject_param_value($app, &_get_fields($app, $aform), '');
    my $csv_record = &_get_csv_record($aform->data_id_offset + $aform->data_id, $fields);

    my $aform_data = new MT::AFormData;
    $aform_data->set_values(
        {
            aform_id => int($app->param('id')),
            values => $csv_record,
            aform_url => $app->param('aform_url'),
        }
    );
    $aform_data->save();


    # get config values
    my $alert_mail = MT->component('AForm')->get_config_value('alert_mail');
    if( &AFormEngineCGI::Common::mail_check( $alert_mail ) ){
        # data was really saved ?
        if( ! $aform_data->count( { values => $csv_record } ) ){
            &_sendmail_save_data_failed($app, $aform, $fields, $alert_mail);
        }
    }
}


sub _sendmail_save_data_failed {
    my $app = shift;
    my $aform = shift;
    my $fields = shift;
    my $alert_mail = shift;

    my $plugin = MT->component('AForm');
    my %param = (
        aform_id => sprintf("%03d", $aform->id),
        datetime => &AFormEngineCGI::Common::get_date(),
        fields => $fields,
        aform_url => $app->param('aform_url'),
    );
    my $tmpl = $app->load_tmpl(&_get_tmpl_file_path($app, $aform->id, 'mail_save_data_failed.tmpl'), \%param);
    my $mail_body = $app->build_page($tmpl, \%param);

    my %headers = (
        'From'    => $alert_mail,
        'To'      => $alert_mail,
        'Subject' => $plugin->translate('[Important] A-Form The save was failed.') . &AFormEngineCGI::Common::get_date(),
#        'Return-Path' => $alert_mail,
        'Reply-To' => $alert_mail,
    );
    MT::Mail->send(\%headers, $mail_body);
}


sub sendmail_unpublished_form_access {
    my $app = shift;
    my $aform = shift;

    # get config values
    my $alert_mail = MT->component('AForm')->get_config_value('alert_mail');
    if( ! &AFormEngineCGI::Common::mail_check( $alert_mail ) ){
        return;
    }

    my @fields;
    my %params = $app->param_hash;
    foreach my $param_key ( sort keys %params ){
        if( $param_key !~ m/^aform-field-(\d+)/ ){
            next;
        }
        my $aform_field = $app->model('aform_field')->load($1);
        my $field = {
            label => $aform_field ? $aform_field->label : $param_key,
            label_value => $app->param($param_key),
        };
        push(@fields, $field);
    }

    my %param = (
        aform_id => sprintf("%03d", int($app->param('id'))),
        datetime => &AFormEngineCGI::Common::get_date(),
        fields => \@fields,
    );
    my $tmpl = $app->load_tmpl(&_get_tmpl_file_path($app, $aform->id, 'mail_unpublished_form_access.tmpl'), \%param);
    my $mail_body = $app->build_page($tmpl, \%param);

    my %headers = (
        'From'    => $alert_mail,
        'To'      => $alert_mail,
        'Subject' => '[A-Form Warning] Unpublished form was accessed.',
#        'Return-Path' => $alert_mail,
        'Reply-To' => $alert_mail,
    );
    MT::Mail->send(\%headers, $mail_body);
}

sub _get_tmpl_file_path {
    my $app = shift;
    my $aform_id = shift;
    my $filename = shift;

    my $plugin_tmpl_dir = $app->mt_dir . '/plugins/AForm/tmpl/';
    my $tmpl = sprintf("%s%03d/%s", $plugin_tmpl_dir, $aform_id, $filename);
    if( ! -e $tmpl ){
      # use default template if custom template not exists
      $tmpl = $plugin_tmpl_dir . $filename;
    }
    return $tmpl;
}

sub _use_mt_blog_template_set_ver42 {
    my $app = shift;
    my $blog_id = shift;

    my $plugin = MT->component('AForm');
    return ( ($app->blog->theme_id eq 'classic_blog' || $app->blog->theme_id eq 'classic_website' || $app->blog->theme_id eq 'pico')
          && $app->model('template')->count({name => $plugin->translate('html_head'), blog_id => $blog_id}) > 0 
          && $app->model('template')->count({name => $plugin->translate('banner_header'), blog_id => $blog_id}) > 0 
          && $app->model('template')->count({name => $plugin->translate('banner_footer'), blog_id => $blog_id}) > 0 );
}

sub check_serialnumber {
  my $plugin = MT->component('AForm');
  my $serialnumber = $plugin->get_config_value('serialnumber');

  require 'crc.pl';
  my $s = substr($serialnumber, 0, 2);
  my $tvmx = substr($serialnumber, int($s), 10) . substr($serialnumber, 2, int($s)-2) . substr($serialnumber, int($s)+18);
  my $c = substr($serialnumber, int($s)+10, 8);
  if( length($serialnumber) == 33 && _crc32($tvmx) eq $c ){
    return 1;
  }else{
    return 0;
  }
}

sub is_business {
  my $app = MT->instance;

  my $file = $app->mt_dir . '/plugins/AForm/key/aform_nonprofitkey.txt';
  if( -e $file ){
    return 0;
  }else{
    return 1;
  }
}

1;
