# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package AForm::CMS;

use strict;

sub _list_aform {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_user_permission() );

    $app->{plugin_template_path} = 'plugins/AForm/tmpl';

    my $is_aform_superuser = aform_superuser_permission();
    my $html = $app->listing({
        Type => 'aform',
        Terms => {
        },
        Args => { sort => 'id' },
        Code => \&_form_item_for_display,
        Params => {
          saved_deleted => ( $app->param('saved_deleted') || '' ),
          form_copied => ( $app->param('form_copied') || '' ),
#          help_url => plugin()->doc_link,
          can_create_aform => $is_aform_superuser,
          can_delete_aform => $is_aform_superuser,
          can_copy_aform => $is_aform_superuser,
          can_publish_aform => $is_aform_superuser,
          aform_manual_url => plugin()->manual_link,
        },
    });
    return $app->build_page($html);
}

sub _form_item_for_display {
    my $app = shift;
    my $item_hash = shift;

    $item_hash->{'disp_id'} = sprintf("%03d", $item_hash->{'id'});

#    $item_hash->{'title'} = MT::I18N::encode_text($item_hash->{'title'}, 'utf8');

    $item_hash->{'publish_term'} = sprintf("%s - %s", $item_hash->{'start_at'}, $item_hash
->{'end_at'});

    my %status = (
        '0' => 'Unpublished',
        '1' => 'Waiting',
        '2' => 'Published',
        '3' => 'Closed' );

    $item_hash->{'status'} = $item_hash->{'status'} ? $item_hash->{'status'} : 0;
    $item_hash->{'status_label'} = plugin()->translate( $status{$item_hash->{'status'}} );

    # data count
    $item_hash->{'data_count'} = MT::App->model('aform_data')->count( { aform_id => $item_hash->{'id'} } );
    # session count
    my @aform_access = MT::App->model('aform_access')->load( { aform_id => $item_hash->{'id'} } );
    foreach my $access ( @aform_access ){
        $item_hash->{'session'} += $access->session;
        $item_hash->{'pv'} += $access->pv;
    }
    if( $item_hash->{'pv'} > 0 ){
        $item_hash->{'conversion_rate'} = sprintf("%0.2f", $item_hash->{'data_count'} / $item_hash->{'pv'} * 100) . '%';
    }else{
        $item_hash->{'conversion_rate'} = '-.--';
    }
}


sub _create_aform {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    my $q = $app->param;
    $app->{plugin_template_path} = 'plugins/AForm/tmpl';
    $q->param('_type', 'aform');

    my %param = (
      plugin_static_uri => _get_plugin_static_uri($app),
#      help_url => plugin()->doc_link,
    );
    my $html = $app->load_tmpl('create_aform.tmpl', \%param);
    return $app->build_page($html, \%param);
}


sub _edit_aform {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    my $q = $app->param;
    $app->{plugin_template_path} = 'plugins/AForm/tmpl';
    $q->param('_type', 'aform');

    # check params
    my $aform_id = $app->param('id') || 0;
    my $blog_id = $app->param('blog_id') || '';

    my $aform;
    if( $aform_id ){
       $aform = $app->model('aform')->load($aform_id);
    }else{
       $aform = $app->model('aform')->new;
    }

    # get webpage
    my %terms;
    $terms{class} = 'page';
    $terms{blog_id} = $blog_id if $blog_id;
    my @pages = $app->model('page')->load( \%terms );
    my $is_webpage = 0;
    my @webpages;
    for(my $i =0; $i < scalar @pages; $i++ ){
       $webpages[$i]{'title'} = $pages[$i]->title;
       $webpages[$i]{'link'} = $pages[$i]->permalink;
       if( $pages[$i]->permalink eq $aform->thanks_url ){
         $webpages[$i]{'selected'} = 1;
         $is_webpage = 1;
       }
    }

    my %param = (
      plugin_static_uri => _get_plugin_static_uri($app),
      exists_form_data => _exists_form_data($app, $aform_id),
      alert_save_msg => plugin()->translate('Your changes has not saved! Are you ok?'),
      alert_disable_tab_msg => plugin()->translate('alert disable tab'),
      webpages => \@webpages,
      display_title => $aform_id ? sprintf("%s(aform%03d)", plugin()->translate('Edit [_1]', $aform->title), $aform_id) : plugin()->translate('New A-Form'),
#      help_url => plugin()->doc_link,
      is_webpage => $is_webpage,
      data_id_offset => $aform->data_id_offset,
      check_immediate => $aform->check_immediate,
    );

    ## Load next and previous entries for next/previous links
    if( my $next = $aform->next ){
      $param{next_aform_id} = $next->id;
    }
    if( my $previous = $aform->previous ){
      $param{previous_aform_id} = $previous->id;
    }

    my $html = $app->edit_object(
      {
        output => 'edit_aform.tmpl',
        screen_class => 'edit-aform',
      }
    );
    return $app->build_page($html, \%param);
}


sub _save_aform {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    # check params
    if( $app->param('title') eq '' ){
      return $app->error( $app->translate( "Please enter Title." ) );
    }
    my $aform_id = $app->param('id');

    # save data
    my $check_immediate = $app->param('check_immediate') || 0;
    my $aform;
    if( $aform_id ){
       $aform = $app->model('aform')->load($aform_id);
    }else{
       $aform = $app->model('aform')->new;
       $check_immediate = $aform->check_immediate;
    }

    my $mail_to_changed = ( $aform->mail_to ne $app->param('mail_to') ) ? 1 : 0;

    my $thanks_url = '';
    if( $app->param('thanks_url_setting') eq 'url' ){
      $thanks_url = $app->param('thanks_url');
    }elsif( $app->param('thanks_url_setting') eq 'webpage' ){
      $thanks_url = $app->param('thanks_url_select');
    }

    $aform->set_values(
      {
        title => $app->param('title'),
        status =>  ( $app->param('status') || 0 ),
        mail_to => ( $app->param('mail_to') || '' ),
        mail_from => ( $app->param('mail_from') || '' ),
        mail_cc => ( $app->param('mail_cc') || '' ),
        mail_bcc => ( $app->param('mail_bcc') || '' ),
        mail_subject => ( $app->param('mail_subject') || $app->param('title') || '' ),
#        is_replyed_to_customer => ( $app->param('is_replyed_to_customer') || 0 ),
        is_replyed_to_customer => 1,
        thanks_url => ( $thanks_url || '' ),
        mail_header => ( $app->param('mail_header') || '' ),
        mail_footer => ( $app->param('mail_footer') || '' ),
        action_url => ( $app->param('action_url') || '' ),
        data_id_offset => ( $app->param('data_id_offset') || 0 ),
        check_immediate => $check_immediate,
      }
    );
    if( $app->param('reset_data_id') ){
      $aform->set_values({ 'data_id' => 0 });
    }
    $aform->save() 
      or return $app->error(
        $app->translate( "Saving aform object failed: [_1]", $aform->errstr ) );

    my $msg_key;
    if( $app->param('mail_to') eq '' ){
        $msg_key = 'saved_changes_mail_to_is_null';
    }elsif( $mail_to_changed ){
        $msg_key = 'saved_changes_mail_to_changed';
    }else{
        $msg_key = 'saved_changes';
    }

    if( $aform_id ){
      return &_rebuild_aform_entry( 
          $app, 
          [ $aform_id ], 
          'edit_aform', 
          (id => $aform->id, $msg_key => 1) 
      );
    }else{
      return 'success:' . $aform->id;
    }
}


sub _copy_aform {
    my $app = shift;

    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    for my $id ( $app->param('id') ) {
        # load orignal aform
        my $aform = MT::AForm->load($id);

        # copy aform
        my $new_aform = MT::AForm->new;
        $new_aform->set_values({
            title => $app->translate('Copied ') . $aform->title,
            status => 0,	# Unpulished
            mail_to => $aform->mail_to,
            mail_from => $aform->mail_from,
            mail_cc => $aform->mail_cc,
            mail_bcc => $aform->mail_bcc,
            mail_subject => $aform->mail_subject,
            is_replyed_to_customer => $aform->is_replyed_to_customer,
            thanks_url => $aform->thanks_url,
            mail_header => $aform->mail_header,
            mail_footer => $aform->mail_footer,
            action_url => $aform->action_url,
            check_immediate  => $aform->check_immediate,
        });
        $new_aform->save()
          or return $app->error(
            $app->translate( "Coping aform object failed: [_1]", $new_aform->errstr ) );

        # load original aform fields
        my @aform_fields = MT::AFormField->load( { aform_id => $aform->id }, { 'sort' => 'sort_order' } );

        # copy aform fields
        foreach my $aform_field ( @aform_fields ){
            my $new_aform_field = MT::AFormField->new;
            $new_aform_field->set_values({
                aform_id => int($new_aform->id),
                type => $aform_field->type,
                label => $aform_field->label,
                is_necessary => int($aform_field->is_necessary),
                sort_order => int($aform_field->sort_order),
                property => $aform_field->property,
            });
            $new_aform_field->save()
              or return $app->error(
                $app->translate( "Coping aform field object failed: [_1]", $new_aform_field->errstr ) );
        }
    }

    return $app->redirect( $app->uri( mode => 'list_aform', args => { blog_id => $app->param('blog_id') || '', form_copied => 1} ) );
}


sub _delete_aform {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    my $q   = $app->param;
    my $type = 'aform';
    my $class = $app->model($type);

    my @delete_ids;
    for my $id ( $q->param('id') ) {
        next unless $id;    # avoid 'empty' ids
        my $obj = $class->load($id);
        next unless $obj;
        $app->run_callbacks( 'cms_delete_permission_filter.' . $type,
            $app, $obj )
          || return $app->error(
            $app->translate( "Permission denied: [_1]", $app->errstr() ) );
        $obj->remove
          or return $app->errtrans(
            'Removing [_1] failed: [_2]',
            $app->translate($type),
            $obj->errstr
          );

        # delete fields & data
        MT::AFormField->remove({ aform_id => $id });
        MT::AFormData->remove({ aform_id => $id });

        push(@delete_ids, $id);
    }

    my $return = &_rebuild_aform_entry( 
        $app, 
        \@delete_ids, 
        'list_aform', 
        (saved_deleted => 1) 
    );
    # remove aform_entry
    for my $id ( $q->param('id') ) {
        next unless $id;    # avoid 'empty' ids
        MT::AFormEntry->remove({aform_id => $id});
    }
    return $return;
}


sub _edit_aform_field {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    my $q = $app->param;
    $app->{plugin_template_path} = 'plugins/AForm/tmpl';
    $q->param('_type', 'aform_field');

    # check params
    my $aform_id = $app->param('id');
    return $app->errtrans("Invalid request") unless $aform_id;

    # get AFormField data
    my @aform_fields = MT::AFormField->load(
      # where
      {
        aform_id => $aform_id,
      },
      # order by
      { 'sort' => 'sort_order' },
    );

    # make json data
    require AFormEngineCGI::Common;
    my @fields;
    foreach my $aform_field ( @aform_fields ){
      push(@fields, {
        id => int($aform_field->id),
        type => $aform_field->type,
        label => $aform_field->label,
        is_necessary => int($aform_field->is_necessary),
        sort_order => int($aform_field->sort_order),
        property => AFormEngineCGI::Common::json_to_obj($aform_field->property),  # property is saved json format
      });
    }
    my $json_data = { fields => \@fields };
    my $json_aform_fields = &AFormEngineCGI::Common::obj_to_json($json_data);


    # make json phrases for javascript
    my $prefecture_list = plugin()->translate('PrefectureList');
    $prefecture_list = '' if $prefecture_list eq 'PrefectureList';
    my %phrases = (
      'Undefined' => plugin()->translate('Undefined'),
      'type label' => plugin()->translate('AForm Field Type Label'),
      'type note' => plugin()->translate('AForm Field Type Note'),
      'type text' => plugin()->translate('AForm Field Type Text'),
      'type textarea' => plugin()->translate('AForm Field Type Textarea'),
      'type select' => plugin()->translate('AForm Field Type Select'),
      'type checkbox' => plugin()->translate('AForm Field Type Checkbox'),
      'type radio' => plugin()->translate('AForm Field Type Radio'),
      'necessary' => plugin()->translate('necessary'),
      'not necessary' => plugin()->translate('not necessary'),
      'necessary description' => plugin()->translate('necessary description'),
      'privacy policy warning' => plugin()->translate('privacy policy warning'),
      'edit label' => plugin()->translate('edit label'),
      'copy' => plugin()->translate('copy'),
      'delete' => plugin()->translate('delete'),
      'move-up' => plugin()->translate('up'),
      'move-down' => plugin()->translate('down'),
      'add value' => plugin()->translate('add value'),
      'edit' => plugin()->translate('edit'),
      'delete' => plugin()->translate('delete'),
      'Value' => plugin()->translate('Value'),
      'Email' => plugin()->translate('Email'),
      'Tel' => plugin()->translate('Tel'),
      'URL' => plugin()->translate('URL'),
      'ZipCode' => plugin()->translate('ZipCode'),
      'Prefecture' => plugin()->translate('Prefecture'),
      'PrefectureList' => eval('[' . $prefecture_list .']'),
      'please select' => plugin()->translate('please select'),
      'use default' => plugin()->translate('use default'),
      'Privacy' => plugin()->translate('Privacy'),
      'privacy_link' => plugin()->translate('privacy_link'),
      'Edit Privacy Link' => plugin()->translate('Edit Privacy Link'),
      'Agree' => plugin()->translate('Agree'),
      'delete default' => plugin()->translate('delete default'),
      'At least one option is required.' => plugin()->translate('At least one option is required.'),
      'description when there is no field' => plugin()->translate('description when there is no field'),
      'is replyed to customer' => plugin()->translate('is replyed to customer'),
      'check status is reflected in default check status of form.' => plugin()->translate('check status is reflected in default check status of form.'),
      'input example is not displayed' => plugin()->translate('input example is not displayed'),
      'edit input example' => plugin()->translate('edit input example'),
      'Example:' => plugin()->translate('Example:'),
      'edit max length' => plugin()->translate('edit max length'),
      'Max Length:' => plugin()->translate('Max Length:'),
      'undefined max length' => plugin()->translate('undefined max length'),
      'reset default checked' => plugin()->translate('reset default checked'),
      'Invalid max length.' => plugin()->translate('Invalid max length.'),
    );
    my $json_phrases = AFormEngineCGI::Common::obj_to_json(\%phrases);

    # get aform object
    my $aform = $app->model('aform')->load($aform_id);

    my %param = (
      aform_id => $aform_id,
      plugin_static_uri => _get_plugin_static_uri($app),
      json_aform_fields => $json_aform_fields,
      json_phrases => $json_phrases,
      object_label => plugin()->translate('aform_field'),
      saved_changes => ( $app->param('saved_changes') || '' ),
      status_changed => ( $app->param('status_changed') || '' ),
      exists_form_data => _exists_form_data($app,$aform_id) ? 1 : 0,
      display_title => sprintf("%s(aform%03d)", plugin()->translate('Edit [_1]', $aform->title), $aform_id),
      edit_field_help_url => plugin()->manual_link_edit_field,
      alert_save_msg => plugin()->translate('Your changes has not saved! Are you ok?'),
      aform_status => $aform->status,
    );

    ## Load next and previous entries for next/previous links
    if( my $next = $aform->next ){
      $param{next_aform_id} = $next->id;
    }
    if( my $previous = $aform->previous ){
      $param{previous_aform_id} = $previous->id;
    }

    my $html = $app->load_tmpl('edit_aform_field.tmpl', \%param);
    return $app->build_page($html, \%param);
}


sub _save_aform_field {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    $app->{plugin_template_path} = 'plugins/AForm/tmpl';

    # check params
    my $aform_id = $app->param('id');
    return $app->errtrans("Invalid request") unless $aform_id;

    my $aform = $app->model('aform')->load($aform_id);
###    return $app->errtrans("Status is published. Cannot edit fields.") if( $aform->status == '2' );

    require Encode;
    require AFormEngineCGI::Common;
    my $json_data = AFormEngineCGI::Common::json_to_obj($app->param('json_aform_fields'));
    my @fields = @{$json_data->{fields}};

    # check field exists
    my @old_fields = MT::AFormField->load({ 'aform_id' => $aform_id });
    foreach my $old_field ( @old_fields ){
      my $exists_id = 0;
      foreach my $field ( @fields ){
        if( $field->{id} eq $old_field->id ){
          $exists_id = 1;
          last;
        }
      }
      # remove if not exists
      if( !$exists_id ){
        MT::AFormField->remove({'id' => $old_field->id});
      }
    }

    # save fields data
    foreach my $field ( @fields ){
        my $aformField = MT::AFormField->load($field->{id});
        if( !$aformField ){
          $aformField = new MT::AFormField;
        }

        my $label = $field->{label};
        my $property = AFormEngineCGI::Common::obj_to_json($field->{property});
        $aformField->set_values(
          {
            aform_id   => int($aform_id),
            type   => $field->{type},
            label => $label,
            is_necessary => int($field->{is_necessary}),
            sort_order => int($field->{sort_order}),
            property => $property,
          }
        );
        $aformField->save();
    }

    return &_rebuild_aform_entry( 
        $app, 
        [ $aform_id ], 
        'edit_aform_field', 
        (id => $aform->id, saved_changes => 1) 
    );
#    return $app->redirect( $app->uri( mode => 'edit_aform_field', args => { id => $aform_id, saved_changes => 1 } ) );
}


sub _manage_aform_data {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    $app->{plugin_template_path} = 'plugins/AForm/tmpl';

    # check params
    my $aform_id = $app->param('id');
    return $app->errtrans("Invalid request") unless $aform_id;

    my $aform = $app->model('aform')->load($aform_id);

    my %param = (
      id => $aform_id,
      plugin_static_uri => _get_plugin_static_uri($app),
      saved_deleted => ( $app->param('saved_deleted') || '' ),
      display_title => sprintf("%s(aform%03d)", plugin()->translate('Manage [_1] Data', $aform->title), $aform_id),
#      help_url => plugin()->doc_link,
    );

    ## Load next and previous entries for next/previous links
    if( my $next = $aform->next ){
      $param{next_aform_id} = $next->id;
    }
    if( my $previous = $aform->previous ){
      $param{previous_aform_id} = $previous->id;
    }

    my $html = $app->load_tmpl('manage_aform_data.tmpl', \%param);
    return $app->build_page($html, \%param);
}


sub _export_aform_data {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    my $charset = 'shift_jis';
    my $aform_id = $app->param('id')
      or return $app->error( $app->translate("Invalid request") );
    my $aform = MT::AForm->load($aform_id)
      or return $app->error(
        $app->translate(
            "Load of aform '[_1]' failed: [_2]",
            $aform_id, MT::AForm->errstr
        )
      );

    my @aform_fields = MT::AFormField->load({ aform_id => $aform->id() }, { sort => 'sort_order' });

    my @aform_datas = MT::AFormData->load({ aform_id => $aform_id }, {sort => 'created_on'});
    $app->validate_magic() or return;

    my @ts = localtime(time);
    my $file = sprintf("export-%06d-%04d%02d%02d%02d%02d%02d.csv", $app->param('id'), $ts[5] + 1900, $ts[4] + 1, @ts[ 3, 2, 1, 0 ]);

    local $| = 1;
    $app->{no_print_body} = 1;
    $app->set_header( "Cache-Control" => "public" );
    $app->set_header( "Pragma" => "public" );
    $app->set_header( "Content-Disposition" => "attachment; filename=$file" );
    $app->send_http_header(
        $charset
        ? "application/excel; charset=$charset"
        : 'application/excel'
    );

    my @field_labels;
    push( @field_labels, $app->translate('Received Data ID'));
    push( @field_labels, $app->translate('Received Datetime'));
    foreach my $aform_field ( @aform_fields ){
      if( $aform_field->type ne 'label' && $aform_field->type ne 'note' ){
        push( @field_labels, $aform_field->label );
      }
    }
     
    my $buf = '';
    foreach my $field_label ( @field_labels ){
        $field_label =~ s/"/""/g;
        $buf .= qq("$field_label",);
    }
    $buf =~ s/,$//;
    $buf .= "\n";
    foreach my $aform_data ( @aform_datas ){
        $buf .= $aform_data->values . "\n";
    }
    print MT::I18N::encode_text($buf, 'utf-8', $charset);
    1;
}


sub _clear_aform_data {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    my $aform_id = $app->param('id')
      or return $app->error( $app->translate("Invalid request") );
    $app->validate_magic() or return;

    # delete data
    MT::AFormData->remove({ aform_id => $aform_id });

    return $app->redirect( $app->uri( mode => 'manage_aform_data', args => { id => $aform_id, saved_deleted => 1 } ) );
}


sub _exists_form_data {
    my $app = shift;
    my( $aform_id ) = @_;
    my $data_count = MT::AFormData->count( { aform_id => $aform_id });
    return( $data_count > 0 );
}


sub check_entry_has_aform {
    my( $eh, $app, $entry ) = @_;

    # remove first
    &_remove_aform_entry($app, $entry->id);

    &_relate_aform_entry($app, $entry, $entry->text, '<\!--', '-->');
    &_relate_aform_entry($app, $entry, $entry->text_more, '<\!--', '-->');
    &_relate_aform_entry($app, $entry, $entry->text, '\[\[', '\]\]');
    &_relate_aform_entry($app, $entry, $entry->text_more, '\[\[', '\]\]');
}

sub _relate_aform_entry {
    my( $app, $entry, $text, $pattern_pre, $pattern_post ) = @_;

    while( $text =~ m/${pattern_pre}aform(\d+)${pattern_post}/gi ){
        my $match_no = $1;
        my $aform_id = int($match_no);
        if( $aform_id ){
            &_regist_aform_entry($app, $entry->blog_id, $entry->id, $aform_id);
        }
    }
}

sub remove_aform_entry {
    my( $eh, $app, $entry ) = @_;

    &_remove_aform_entry($app, $entry->id);
}

sub _build_form {
    my( $entry_text, $args, $ctx ) = @_;

    require AFormEngineCGI::FormMail;

    use MT::App;
    my $app = MT::App->new;
    $app->{plugin_template_path} = 'plugins/AForm/tmpl';

    $entry_text = _replace_form($app, $ctx, $entry_text, '<\!--', '-->');
    $entry_text = _replace_form($app, $ctx, $entry_text, '\[\[', '\]\]');

    return $entry_text;
}

sub _replace_form {
    my( $app, $ctx, $entry_text, $pattern_pre, $pattern_post ) = @_;

    while( $entry_text =~ m/${pattern_pre}aform(\d+)${pattern_post}/gi ){
        my $match_no = $1;
        my $aform_id = int($match_no);

        # get aform
        my $aform = MT::AForm->load( $aform_id );
        if( !$aform ){
          $entry_text =~ s/${pattern_pre}aform${match_no}${pattern_post}//gi;
          next;
        }

        my $buf = '';
        if( $aform->status == 2 ){    # published
            # generate form
            $buf = AFormEngineCGI::FormMail::generate_form_view($app, $aform, $ctx);
        }else{
#            $buf = plugin()->translate('### form closed ###');
        }

        # replace
        $entry_text =~ s/${pattern_pre}aform${match_no}${pattern_post}/$buf/gi;
    }
    return $entry_text;
}


sub _hide_aform {
    my( $entry_text, $args, $ctx ) = @_;

    $entry_text =~ s/<\!--aform(\d+)-->//gi;
    $entry_text =~ s/\[\[aform(\d+)\]\]//gi;

    return $entry_text;
}


sub _regist_aform_entry {
    my $app = shift;
    my $blog_id = shift;
    my $entry_id = shift;
    my $aform_id = shift;

    if( ! MT::AFormEntry->count( { blog_id => $blog_id, entry_id => $entry_id, aform_id => $aform_id } ) ) {
        my $aform_entry = MT::AFormEntry->new;
        $aform_entry->set_values( {
            blog_id => $blog_id,
            entry_id => $entry_id,
            aform_id => $aform_id,
        });
        $aform_entry->save;
    }
}


sub _remove_aform_entry {
    my $app = shift;
    my $entry_id = shift;

    MT::AFormEntry->remove({ entry_id => $entry_id });
}


sub _disp_aform {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_user_permission() );

    $app->{plugin_template_path} = 'plugins/AForm/tmpl';

    # check params
    my $aform_id = $app->param('id');
    return $app->errtrans("Invalid request") unless $aform_id;

    # get aform
    my $aform = MT::AForm->load( $aform_id );

    # generate form
    require AFormEngineCGI::FormMail;
    return AFormEngineCGI::FormMail::generate_form_preview($app, $aform);
}


sub _get_plugin_static_uri {
    my $app = shift;

    my $path = $app->static_path;
    $path .= '/' unless $path =~ m!/$!;
    $path .= plugin()->envelope . "/";
    $path = $app->base . $path if $path =~ m!^/!;

    return $path;
}

sub plugin {
  return MT->component('AForm');
}


sub _list_aform_input_error {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    my $q = $app->param;
    $app->{plugin_template_path} = 'plugins/AForm/tmpl';
    $q->param('_type', 'aform_input_error');

    # check params
    my $aform_id = $app->param('id');
    return $app->errtrans("Invalid request") unless $aform_id;

    my $html = $app->listing({
        Type => 'aform_input_error',
        Terms => {
          aform_id => $aform_id,
        },
        Args => { sort => 'created_on', direction => 'descend' },
        Code => \&_error_item_for_display,
        Params => {
        },
    });

    # access count
    my @aform_access = $app->model('aform_access')->load( { aform_id => $aform_id } );
    my( $session, $pv);
    foreach my $access ( @aform_access ){
        $session += $access->session;
        $pv += $access->pv;
    }

    # conversion count & rate
    my $conversion_count = $app->model('aform_data')->count( { aform_id => $aform_id } );
    my $conversion_rate;
    if( $pv > 0 ){
        $conversion_rate = sprintf("%0.2f", $conversion_count / $pv * 100) . '%';
    }

    my $aform = $app->model('aform')->load($aform_id);

    my %param = (
      id => $aform_id,
      plugin_static_uri => _get_plugin_static_uri($app),
      session => $session || 0,
      pv => $pv || 0,
      conversion_count => $conversion_count || 0,
      conversion_rate => $conversion_rate || '-.--',
      display_title => sprintf("%s(aform%03d)", MT::Util::encode_html($aform->title), $aform_id),
      display_title => sprintf("%s(aform%03d)", plugin()->translate('[_1] List Input Error', $aform->title), $aform_id),
#      help_url => plugin()->doc_link,
       listing_screen => 0,
    );

    ## Load next and previous entries for next/previous links
    if( my $next = $aform->next ){
      $param{next_aform_id} = $next->id;
    }
    if( my $previous = $aform->previous ){
      $param{previous_aform_id} = $previous->id;
    }

    return $app->build_page($html, \%param);
}

sub _error_item_for_display {
    my $app = shift;
    my $item_hash = shift;

    $item_hash->{'created_on'} =~ s/(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/$1-$2-$3 $4:$5:$6/;

    $item_hash->{'type'} = plugin()->translate( $item_hash->{'type'} );
}

sub _change_aform_status {
    my $app = shift;
    return $app->return_to_dashboard( permission => 1 )
      if ( !aform_superuser_permission() );

    # check params
    my $q = $app->param;
    my $aform_id = $app->param('id');
    return $app->errtrans("Invalid request") unless $aform_id;

    # change status
    my $aform = $app->model('aform')->load($aform_id);
    $aform->set_values( {
        status => ($aform->status == 2 ? 0 : 2),
    } );
    $aform->save();

    # redirect
    my $redirect_mode = $app->param('redirect_mode') || 'list_aform';

    return &_rebuild_aform_entry(
        $app,
        [ $aform_id ],
        $redirect_mode,
        ( id => $aform->id, blog_id => $app->param('blog_id'), status_changed => 1)
    );
#    return $app->redirect( $app->uri( mode => $redirect_mode, args => { id => $aform->id, blog_id => $app->param('blog_id'), status_changed => 1 } ) );
}


sub aform_superuser_permission {
    my $app = MT->app;
    my $perms = $app->user->permissions;
    return( $perms && $perms->can_create_blog );
}


sub aform_user_permission {
    my $app = MT->app;
    return 1 if $app->user->is_superuser;
    return 1 if $app->user->can_create_blog;
    if ( $app->param('blog_id') ) {
        my $perms = $app->user->permissions($app->param('blog_id'));
        return 1 if $perms->can_create_post || $perms->can_manage_pages;
    }
    else {
        require MT::Permission;
        my @blogs =
        map { $_->blog_id }
        grep { $_->can_create_post || $_->can_manage_pages }
        MT::Permission->load( { author_id => $app->user->id } );
        return 1 if @blogs;
    }
    return 0;
}


sub _rebuild_aform_entry {
    my $app = shift;
    my $aform_ids = shift;
    my $return_mode = shift;
    my (%return_args) = @_;

    # get entry_ids
    my %entry_ids;
    foreach my $aform_id ( @$aform_ids ){
        my @aform_entries = $app->model('aform_entry')->load({ aform_id => $aform_id });
        foreach my $aform_entry ( @aform_entries ){
            my $entry = MT::Entry->load({id => $aform_entry->entry_id, status => MT::Entry::RELEASE()});
            if( ! $entry ){
                next;
            }
            $entry_ids{$aform_entry->entry_id} = 1;
        }
    }
    my @ids =  keys %entry_ids;

    if( @ids ){
        my $return_arg = $app->uri_params('mode' => $return_mode, 'args' => \%return_args); 
        $return_arg =~ s/^\?//;
        return $app->redirect( 
            $app->uri( 
              mode => 'rebuild_new_phase', 
              args => { id => \@ids, return_args => $return_arg } 
            ) 
        );
    }else{
        return $app->redirect( $app->uri( 'mode' => $return_mode, 'args' => \%return_args ) );
    }
}


1;
