# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package AFormEngineCGI;

use strict;
use MT;
use MT::App;
use MT::Blog;
use MT::Entry;
use MT::Builder;
use MT::Template;
use MT::TemplateMap;
use MT::Template::Context;
use MT::PluginData;
use MT::AForm;
use MT::AFormField;
use MT::Util;
use AFormEngineCGI::FormMail;
use HTTP::Date;

@AFormEngineCGI::ISA = qw(MT::App);

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_);
    $app->add_methods( AFormEngineCGI => \&_AFormEngineCGI );
    $app->{default_mode} = 'AFormEngineCGI';
    $app->{requires_login} = 0;
    $app;
}

sub _AFormEngineCGI {
    my $app = shift;
    my $q = $app->param;
    my $request = $ENV{"REDIRECT_URL"};

    $AFormEngineCGI::plugin = new MT::Plugin::AForm({ id => 'AForm', l10n_class => 'AForm::L10N' });

    my $plugin = MT->component('AForm');

    $app->{plugin_template_path} = 'plugins/AForm/tmpl';
    $q->param('_type', 'aform');

    # check params
    my $aform_id = int($app->param('id'));
    return AFormEngineError($app, $plugin->translate('Invalid request')) unless $aform_id;
    return AFormEngineError($app, $plugin->translate('Invalid request')) unless $app->param('blog_id');

    my $aform = $app->model('aform')->load($aform_id);
    if( !$aform || $aform->status ne '2' ){
###        &AFormEngineCGI::FormMail::sendmail_unpublished_form_access($app, $aform);
        return AFormEngineError($app, $plugin->translate('Acceptance end'));
    }

    # check mode
    my $mode = $q->param('run_mode');
    if ( ! ( $mode eq 'confirm' || $mode eq 'complete' ) ) {
      return AFormEngineError($app, $plugin->translate('Invalid request'));
    }

    # validation
    my @error_msgs = AFormEngineCGI::FormMail::validate_param($app, $aform);

    if ( @error_msgs > 0 ) {
        return AFormEngineError($app, \@error_msgs);
    }

    # counter
    &AFormCountUp($app);

    # if confirmation mode
    if ( $mode eq 'confirm' ) {
        return AFormEngineCGI::FormMail::generate_confirmation_view($app, $aform);
    } elsif ( $mode eq 'complete' ) {
        # check double registration
        if ( ! AFormEngineCGI::FormMail::check_double_submit($app, $aform) ) {
            # store inquiry data
            AFormEngineCGI::FormMail::store($app, $aform);
            # notify by email to admin
            if ( $aform->mail_to ne '' ) {
                AFormEngineCGI::FormMail::send_mail($app, $aform);
            }
            # notify by email to customer
            if ( $aform->is_replyed_to_customer ) {
                AFormEngineCGI::FormMail::reply_to_customer($app, $aform);
            }
        } else {
            return AFormEngineError($app, $plugin->translate('Double submit warning. Please try again for a while.'));
        }
        # redirect to thanks_url
        if( $aform->thanks_url ne '' ){
            print "Location: " . $aform->thanks_url . "\n\n";
        }else{
          if( $app->param('use_js') ){
            return $plugin->translate('The data was sent. <a href="[_1]">Back to top page</a>', $app->blog->site_url);
          }else{
            return AFormEngineCGI::FormMail::generate_finish_view($app, $aform);
          }
        }
    }
}

sub AFormEngineError {
  my $app = shift;
  my $msg = shift;

  if( $app->param('use_js') ){
    return $msg;
  }else{
    if( ref $msg eq 'ARRAY' ){
      return AFormEngineCGI::FormMail::generate_error_view($app, $msg);
    }else{
      my @msgs = ($msg);
      return AFormEngineCGI::FormMail::generate_error_view($app, \@msgs);
    }
  }
}


sub AFormCountUp {
  my $app = shift;

  my $aform_counter = $app->model('aform_counter')->load(
                       {
                         aform_id => int($app->param('id')),
                         aform_url => $app->param('aform_url'),
                       });
  if( ! $aform_counter ){
    $aform_counter = $app->model('aform_counter')->new;
    $aform_counter->set_values(
                       {
                          aform_id => int($app->param('id')),
                          aform_url => $app->param('aform_url'),
                       });
  }

  if( $app->param('run_mode') eq 'confirm'){
    $aform_counter->set_values(
       {
          confirm_pv => $aform_counter->confirm_pv + 1,
       });
  }elsif( $app->param('run_mode') eq 'complete'){
    $aform_counter->set_values(
      { 
          complete_pv => $aform_counter->complete_pv + 1,
      }
    );
  }
  $aform_counter->save();
}

1;


