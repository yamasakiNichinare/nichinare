// A plugin for adding "A-Form" functionality.
// Copyright (c) 2008 ARK-Web Co.,Ltd.

var config_form = new Object();

// controller
config_form.ConfigFormController = function(){
  this.documentReady();
}

config_form.ConfigFormController.prototype = {

  documentReady: function(){
    aform$(document).ready(function(){
      window.onbeforeunload = function(){
        if( !config_form.controller.form_submitted && config_form.controller.configForm.isChanged() ){
            return config_form.alertSaveMsg;
        }
      }

      aform$('#aform-config-form').submit(function(){
        if( aform$('#title').val() == '' ){
          alert(config_form.alertFormTitle);
          return false;
        }
        config_form.controller.form_submitted = true;
      });

      config_form.controller.configForm = new config_form.ConfigForm();
    });
  }

}
config_form.controller = new config_form.ConfigFormController();


// model
config_form.ConfigForm = function(){
  this.title = aform$('#title').val();
  this.action_url = aform$('#action_url').val();
  this.thanks_url = aform$('#thanks_url').val();
  this.thanks_url_select = aform$('#thanks_url_select').val();
  this.status = aform$("input[name='status']:checked").val();
  this.mail_subject = aform$('#mail_subject').val();
  this.mail_to = aform$('#mail_to').val();
  this.mail_from = aform$('#mail_from').val();
  this.is_replyed_to_customer = aform$('#is_replyed_to_customer').val();
  this.mail_header = aform$('#mail_header').val();
  this.mail_footer = aform$('#mail_footer').val();
}

config_form.ConfigForm.prototype = {
  isChanged: function(){
    return( 
      this.title != aform$('#title').val() ||
      this.action_url != aform$('#action_url').val() ||
      this.thanks_url != aform$('#thanks_url').val() ||
      this.thanks_url_select != aform$('#thanks_url_select').val() ||
      this.status != aform$("input[name='status']:checked").val() ||
      this.mail_subject != aform$('#mail_subject').val() ||
      this.mail_to != aform$('#mail_to').val() ||
      this.mail_from != aform$('#mail_from').val() ||
      this.is_replyed_to_customer != aform$('#is_replyed_to_customer').val() ||
      this.mail_header != aform$('#mail_header').val() ||
      this.mail_footer != aform$('#mail_footer').val() 
    );
  }
}


// view
config_form.ConfigFormView = {
}
