# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package MT::Plugin::AForm;

use strict;
use MT;
use MT::AForm;
use MT::AFormField;
use MT::AFormData;
use MT::AFormInputError;
use MT::AFormAccess;
use MT::AFormCounter;
use MT::AFormEntry;
use AForm::CMS;

use vars qw( $VERSION $SCHEMA_VERSION );
$VERSION = '2.0.2';
$SCHEMA_VERSION = '1.2002';

use base qw( MT::Plugin );

###################################### Init Plugin #####################################

my $plugin = new MT::Plugin::AForm({
    id => 'AForm',
    name => 'A-Form',
    author_name => '<MT_TRANS phrase=\'_PLUGIN_AUTHOR\'>',
    author_link => 'http://www.ark-web.jp/',
    version => $VERSION,
    schema_version => $SCHEMA_VERSION,
    description => '<MT_TRANS phrase=\'_PLUGIN_DESCRIPTION\'>',
    doc_link => 'http://www.ark-web.jp/movabletype/',
    object_classes => [
        'MT::AForm',
        'MT::AFormField',
        'MT::AFormData',
        'MT::AFormInputError',
        'MT::AFormAccess',
        'MT::AFormCounter',
        'MT::AFormEntry',
    ],
    l10n_class => 'AForm::L10N',
    system_config_template => 'system_config.tmpl',
    settings => new MT::PluginSettings([
      [ 'script_url_dir', { Default => '', Scope => 'system' }],
      [ 'alert_mail', { Default => '', Scope => 'system' }],
      [ 'check_when_first_access', { Default => '', Scope => 'system' }],
      [ 'check_interval', { Default => '24h', Scope => 'system' }],
      [ 'alert_min_confirm_pv', { Default => '1', Scope => 'system' }],
      [ 'alert_min_complete_pv', { Default => '1', Scope => 'system' }],
      [ 'last_count_check_date', { Default => '', Scope => 'system' }],
      [ 'serialnumber', { Default => '', Scope => 'system' }],
      [ 'checked_sn', { Default => '', Scope => 'system' }],
      [ 'for_business', { Default => '', Scope => 'system' }],
    ]),
});
MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        'object_types' => {
            'aform' => 'MT::AForm',
            'aform_field' => 'MT::AFormField',
            'aform_data' => 'MT::AFormData',
            'aform_input_error' => 'MT::AFormInputError',
            'aform_access' => 'MT::AFormAccess',
            'aform_counter' => 'MT::AFormCounter',
            'aform_entry' => 'MT::AFormEntry',
        },
        'applications' => {
            'cms' => {
                'methods' => {
                    'list_aform' => '$AForm::AForm::CMS::_list_aform',
                    'create_aform' => '$AForm::AForm::CMS::_create_aform',
                    'edit_aform' => '$AForm::AForm::CMS::_edit_aform',
                    'save_aform' => '$AForm::AForm::CMS::_save_aform',
                    'delete_aform' => '$AForm::AForm::CMS::_delete_aform',
                    'copy_aform' => '$AForm::AForm::CMS::_copy_aform',
                    'edit_aform_field' => '$AForm::AForm::CMS::_edit_aform_field',
                    'save_aform_field' => '$AForm::AForm::CMS::_save_aform_field',
                    'manage_aform_data' => '$AForm::AForm::CMS::_manage_aform_data',
                    'export_aform_data' => '$AForm::AForm::CMS::_export_aform_data',
                    'clear_aform_data' => '$AForm::AForm::CMS::_clear_aform_data',
                    'list_aform_input_error' => '$AForm::AForm::CMS::_list_aform_input_error',
                    'disp_aform' => '$AForm::AForm::CMS::_disp_aform',
                    'change_aform_status' => '$AForm::AForm::CMS::_change_aform_status',
                },
                menus => {
                    'system:aform' => {
                        label => 'AForm',
                        order => 10000,
                        mode => 'list_aform',
                        condition  => sub { AForm::CMS::aform_user_permission() },
                    },
                    'aform' => {
                        label => 'AForm',
                        order => 10000,
                        condition  => sub { AForm::CMS::aform_user_permission() },
                    },
                    'aform:list' => {
                        label => 'List',
                        mode => 'list_aform',
                        condition  => sub { AForm::CMS::aform_user_permission() },
                        view => [ "blog", 'website', 'system' ],
                    },
                },
            },
        },
        tags => {
            modifier => {
                'aform' => \&AForm::CMS::_build_form,
                'hide_aform' => \&AForm::CMS::_hide_aform,
            },
        },
        callbacks => {
            'aform_check_entry_has_aform' => {
                callback => 'MT::Entry::post_save',
                handler => '$AForm::AForm::CMS::check_entry_has_aform',
            },
            'aform_check_page_has_aform' => {
                callback => 'MT::Page::post_save',
                handler => '$AForm::AForm::CMS::check_entry_has_aform',
            },
            'aform_remove_aform_entry' => {
                callback => 'MT::Entry::post_remove',
                handler => '$AForm::AForm::CMS::remove_aform_entry',
            },
            'aform_remove_aform_page' => {
                callback => 'MT::Page::post_remove',
                handler => '$AForm::AForm::CMS::remove_aform_entry',
            },
        },
        upgrade_functions => {
            'aform_upgrade_fix_mail_from' => {
                version_limit => 1.2001,
                updater => {
                    type => 'aform',
                    label => 'setting aform mail from',
                    code => sub {
                        my $aform = shift;
                        if( $aform->mail_from eq '' ){
                            $aform->set_values({
                                 mail_from => $aform->mail_to,
                            });
                            $aform->save;
                        }
                    },
                },
            },
        },
    });
}

sub instance {$plugin}

sub manual_link {
    return 'http://groups.google.co.jp/group/mt-a-form/web/a-form-top';
}

sub manual_link_edit_field {
    return 'http://groups.google.co.jp/group/mt-a-form/web/%E3%83%81%E3%83%A5%E3%83%BC%E3%83%88%E3%83%AA%E3%82%A2%E3%83%AB';
}

sub config_template {
  my $plugin = shift;
  my ($param, $scope) = @_;

  require AFormEngineCGI::FormMail;

  my $for_business = AFormEngineCGI::FormMail::is_business();
  $plugin->set_config_value('for_business', $for_business, 'system');
  $$param{'for_business'} = $for_business;

  my $checked_sn = &AFormEngineCGI::FormMail::check_serialnumber();
  $plugin->set_config_value('checked_sn', $checked_sn, 'system');
  $$param{'checked_sn'} = $checked_sn;

  return $plugin->SUPER::config_template($param, $scope);
}

sub save_config {
  my $plugin = shift;
  my( $args, $scope ) = @_;

  $plugin->SUPER::save_config(@_);

  require AFormEngineCGI::FormMail;
  my $checked_sn = &AFormEngineCGI::FormMail::check_serialnumber();
  $plugin->set_config_value('checked_sn', $checked_sn, 'system');
}
1;
