// A plugin for adding "A-Form" functionality.
// Copyright (c) 2008 ARK-Web Co.,Ltd.

var edit_aform = new Object();


edit_aform.EditAformController = function()
{
  this.documentReady();
}


edit_aform.EditAformController.prototype = {

  documentReady: function(){
    aform$(document).ready(function(){
      window.onbeforeunload = function(e){
        if( !edit_aform.controller.form_submitted && edit_aform.controller.editAform.is_changed ){
          if( e != undefined ){
            return e.returnValue = edit_aform.alertSaveMsg;
          }
          return edit_aform.alertSaveMsg;
        }
      }

      aform$('#aform-field-form').submit(function(){
        edit_aform.controller.form_submitted = true;
      });

      edit_aform.controller.editAform = new edit_aform.EditAform();
      edit_aform.controller.refreshEditFieldsArea();

      edit_aform.controller.setPartsAddEvents('label');
      edit_aform.controller.setPartsAddEvents('note');
      edit_aform.controller.setPartsAddEvents('text');
      edit_aform.controller.setPartsAddEvents('textarea');
      edit_aform.controller.setPartsAddEvents('select');
      edit_aform.controller.setPartsAddEvents('checkbox');
      edit_aform.controller.setPartsAddEvents('radio');
      edit_aform.controller.setPartsAddEvents('email');
      edit_aform.controller.setPartsAddEvents('tel');
      edit_aform.controller.setPartsAddEvents('url');
      edit_aform.controller.setPartsAddEvents('zipcode');
      edit_aform.controller.setPartsAddEvents('prefecture');
      edit_aform.controller.setPartsAddEvents('privacy');
      edit_aform.controller.setBtnSaveEvent();
      aform$('#display-aform-field-extra-types a').Tooltip({
        delay: 0,
        showURL: false,
        opacity: 0.85
      });

      edit_aform.controller.setDragdrop();
    });
  },


  // redraw all & reset events
  refreshEditFieldsArea: function(){
    if( edit_aform.controller.editAform.fields.length == 0 ){
      edit_aform.EditAformView.drawDropFieldDescription();
    }else{
      edit_aform.EditAformView.redrawFields(
        edit_aform.controller.editAform.fields, 
        edit_aform.controller.editAform.active_field_idx
      );
    }
    this.setEditFieldEvents();
    this.setDragFields();
  },


  setPartsAddEvents: function( type ){
    aform$('#aformFieldType-' + type).click( function(event){
      Event.stop(event);
      edit_aform.controller.editAform.addField(type);
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setDragdrop: function(){
    aform$('.aform-field-type').draggable( {
      helper: 'clone'
    });

    aform$('.field-edit-field').droppable( {
      accept: function( obj ){
        return( obj.id.match(/aformField(Type|Label)/) );
      },
      drop: function(event, ui){
        if( ui.helper.id.match(/aformFieldLabel/) ){
          edit_aform.controller.editAform.dragdropField(event, ui);
        }else{
          edit_aform.controller.editAform.dragdropNewField(event, ui);
        }
        edit_aform.controller.refreshEditFieldsArea();
      }
    });
  },


  setDragFields: function(){
    aform$('.aform-field-label').draggable( {
      helper:'clone'
    } );
  },


  destroyDragFields: function(){
    aform$('.aform-field-label').draggableDestroy();
  },


  setEditFieldEvents: function(){
    this.setClickFieldBlockEvent();
    this.setDblclickLabelEvent();
    this.setClickEditLabelEvent();
    this.setClickNecessaryEvent();
    this.setClickCopyEvent();
    this.setClickDeleteEvent();
    this.setClickMoveUpEvent();
    this.setClickMoveDownEvent();
    this.setClickAddValueEvent();
    this.setClickDeleteValueEvent();
    this.setDblclickValueLabelEvent();
    this.setClickEditValueLabelEvent();
    this.setClickUseDefaultEvent();
    this.setChangeEditDropdownEvent();
    this.setClickEditPrivacyLinkEvent();
    this.setClickEmailIsReplyedEvent();
    this.setClickValueCheckboxEvent();
    this.setClickValueRadioEvent();
    this.setClickEditInputExampleEvent();
    this.setClickEditMaxLengthEvent();
    this.setClickResetDefaultCheckedEvent();
    aform$('.aform-field-necessary a').Tooltip({ delay: 0, showURL: false, opacity: 0.85 });
    aform$('.aform-field-not-necessary a').Tooltip({ delay: 0, showURL: false, opacity: 0.85 });
    aform$('.aform-field-value-checkbox').Tooltip({ delay: 0, showURL: false, opacity: 0.85 });
    aform$('.aform-field-value-radio').Tooltip({ delay: 0, showURL: false, opacity: 0.85 });
  },


  setClickFieldBlockEvent: function(){
    aform$('.aform-field-block').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.editAform.active_field_idx = field_idx;
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setDblclickLabelEvent: function(){
    aform$('.aform-field-label').dblclick( function(event){
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.openEditLabel(field_idx);
    });
  },


  setClickEditLabelEvent: function(){
    aform$('.aform-field-edit-label').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.openEditLabel(field_idx);
    });
  },


  openEditLabel: function( field_idx ){
    this.destroyDragFields();
    edit_aform.controller.editAform.active_field_idx = field_idx;
    var label = edit_aform.controller.editAform.getLabel(field_idx);
    edit_aform.EditAformView.openEditLabelTextbox(field_idx, label);
    edit_aform.controller.setClickEditLabelSubmitEvent();
    edit_aform.controller.setBlurEditLabelTextEvent();
  },


  setBlurEditLabelTextEvent: function(){
    aform$('.aform-field-edit-label-text').blur( function(){
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.submitEditLabel( field_idx );
    });
  },


  setClickEditLabelSubmitEvent: function(){
    aform$('.aform-field-edit-label-submit').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.submitEditLabel( field_idx );
    });
  },


  submitEditLabel: function( field_idx ){
    edit_aform.controller.editAform.active_field_idx = field_idx;
    var label = aform$('#aformFieldEditLabelText' + field_idx).val();
    edit_aform.controller.editAform.setLabel(field_idx, label);
    edit_aform.EditAformView.closeEditLabelTextbox(field_idx, label);
    this.setDragFields();
  },


  setClickNecessaryEvent: function(){
    aform$('.aform-field-necessary').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.editAform.active_field_idx = field_idx;
      edit_aform.controller.editAform.tolgNecessary(field_idx);
      edit_aform.controller.refreshEditFieldsArea();
    });
    aform$('.aform-field-not-necessary').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.editAform.active_field_idx = field_idx;
      edit_aform.controller.editAform.tolgNecessary(field_idx);
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setClickCopyEvent: function(){
    aform$('.aform-field-copy').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.editAform.copyField(field_idx);
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setClickDeleteEvent: function(){
    aform$('.aform-field-delete').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.editAform.deleteField(field_idx);
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setClickMoveUpEvent: function(){
    aform$('.aform-field-move-up').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.editAform.moveUpField(field_idx);
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setClickMoveDownEvent: function(){
    aform$('.aform-field-move-down').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.editAform.moveDownField(field_idx);
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setClickAddValueEvent: function(){
    aform$('.aform-field-add-value').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.editAform.addValue(field_idx);
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setClickDeleteValueEvent: function(){
    aform$('.aform-field-delete-value').click( function(event){
      Event.stop(event);
      var idxs = edit_aform.controller.editAform.getFieldIdxAndOptionIdx(this);
      edit_aform.controller.editAform.deleteValue( idxs.field_idx, idxs.option_idx );
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setDblclickValueLabelEvent: function(){
    aform$('.aform-field-value-label').dblclick( function(){
      var idxs = edit_aform.controller.editAform.getFieldIdxAndOptionIdx(this);

      edit_aform.controller.openEditValueLabel( idxs.field_idx, idxs.option_idx );
    });
  },


  setClickEditValueLabelEvent: function(){
    aform$('.aform-field-edit-value-label').click( function(event){
      Event.stop(event);
      var idxs = edit_aform.controller.editAform.getFieldIdxAndOptionIdx(this);

      edit_aform.controller.openEditValueLabel( idxs.field_idx, idxs.option_idx );
    });
  },


  openEditValueLabel: function( field_idx, option_idx ){
    this.destroyDragFields();
    edit_aform.controller.editAform.active_field_idx = field_idx;
    var label = edit_aform.controller.editAform.getValueLabel(field_idx, option_idx);
    edit_aform.EditAformView.openEditValueLabelTextbox(field_idx, option_idx, label);
    edit_aform.controller.setClickEditValueLabelSubmitEvent();
    edit_aform.controller.setBlurEditValueLabelTextEvent();
  },


  setClickEditValueLabelSubmitEvent: function(){
    aform$('.aform-field-edit-value-label-submit').click( function(){
      var idxs = edit_aform.controller.editAform.getFieldIdxAndOptionIdx(this);

      edit_aform.controller.submitEditValueLabel(idxs.field_idx, idxs.option_idx);
    });
  },


  setBlurEditValueLabelTextEvent: function(){
    aform$('.aform-field-edit-value-label-text').blur( function(){
      var idxs = edit_aform.controller.editAform.getFieldIdxAndOptionIdx(this);

      edit_aform.controller.submitEditValueLabel(idxs.field_idx, idxs.option_idx);
    });
  },


  submitEditValueLabel: function( field_idx, option_idx ){
    edit_aform.controller.editAform.active_field_idx = field_idx;
    var label = aform$('#aformFieldEditValueLabelText' + field_idx + '-' + option_idx).val();
    edit_aform.controller.editAform.setValueLabel(field_idx, option_idx, label);
    edit_aform.EditAformView.closeEditValueLabelTextbox(field_idx, option_idx, label);
    this.setDragFields();
  },


  setClickUseDefaultEvent: function(){
    aform$('.aform-field-use-default').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.editAform.active_field_idx = field_idx;
      edit_aform.controller.editAform.tolgUseDefault(field_idx);
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setChangeEditDropdownEvent: function(){
    aform$('.aform-field-edit-dropdown').change( function(){
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      var use_default = edit_aform.controller.editAform.fields[field_idx].property.use_default;

      // cant edit default option
      if( use_default && this.selectedIndex == 0 ){
        return;
      }

      edit_aform.controller.destroyDragFields();
      var label = this.options[this.selectedIndex].text;
      var option_idx = this.selectedIndex - (use_default ? 1 : 0);
      edit_aform.controller.editAform.active_field_idx = field_idx;
      edit_aform.EditAformView.openEditDropdownOptionLabelTextbox(field_idx, option_idx, label);
      edit_aform.controller.setClickEditDropdownOptionLabelSubmitEvent();
      edit_aform.controller.setBlurEditDropdownOptionLabelTextEvent();
      edit_aform.controller.setClickDeleteValueEvent();
    });
  },


  setClickEditDropdownOptionLabelSubmitEvent: function(){
    aform$('.aform-field-edit-dropdown-option-label-submit').click( function(){
      var idxs = edit_aform.controller.editAform.getFieldIdxAndOptionIdx(this);

      edit_aform.controller.submitEditDropdownOptionLabel(idxs.field_idx, idxs.option_idx);
    });
  },


  setBlurEditDropdownOptionLabelTextEvent: function(){
    aform$('.aform-field-edit-dropdown-option-label-text').blur( function(){
      var idxs = edit_aform.controller.editAform.getFieldIdxAndOptionIdx(this);

      edit_aform.controller.submitEditDropdownOptionLabel(idxs.field_idx, idxs.option_idx);
    });
  },


  submitEditDropdownOptionLabel: function( field_idx, option_idx ){
    edit_aform.controller.editAform.active_field_idx = field_idx;
    var label = aform$('#aformFieldEditDropdownOptionLabelText' + field_idx + '-' + option_idx).val();
    edit_aform.controller.editAform.setDropdownOptionLabel(field_idx, option_idx, label);
    edit_aform.EditAformView.closeEditDropdownOptionLabelTextbox(field_idx, option_idx, label);
    edit_aform.controller.refreshEditFieldsArea();
  },


  setClickEditPrivacyLinkEvent: function(){
    aform$('.aform-field-edit-privacy-link').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.openEditPrivacyLink(field_idx);
    });
  },


  openEditPrivacyLink: function( field_idx ){
    this.destroyDragFields();
    edit_aform.controller.editAform.active_field_idx = field_idx;
    var privacy_link = edit_aform.controller.editAform.getPrivacyLink(field_idx);
    edit_aform.EditAformView.openEditPrivacyLinkTextbox(field_idx, privacy_link);
    edit_aform.controller.setClickEditPrivacyLinkSubmitEvent();
  },


  setClickEditPrivacyLinkSubmitEvent: function(){
    aform$('.aform-field-edit-privacy-link-submit').click( function(){
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.submitEditPrivacyLink(field_idx);
    });
  },


  submitEditPrivacyLink: function( field_idx ){
    edit_aform.controller.editAform.active_field_idx = field_idx;
    var privacy_link = aform$('#aformFieldEditPrivacyLinkText' + field_idx).val();
    edit_aform.controller.editAform.setPrivacyLink(field_idx, privacy_link);
    edit_aform.EditAformView.closeEditPrivacyLinkTextbox(field_idx, privacy_link);
    edit_aform.controller.refreshEditFieldsArea();
  },


  setClickEmailIsReplyedEvent: function(){
    aform$('.aform-field-email-is-replyed').click( function(event){
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      var is_replyed = this.checked ? 1 : 0;
      edit_aform.controller.editAform.setEmailIsReplyed(field_idx, is_replyed);
    });
  },


  setClickValueCheckboxEvent: function(){
    aform$('.aform-field-value-checkbox').click( function(){
      var idxs = edit_aform.controller.editAform.getFieldIdxAndOptionIdx(this);
      edit_aform.controller.editAform.setValueChecked(idxs.field_idx, idxs.option_idx, this.checked ? 1 : 0);
    });
  },


  setClickValueRadioEvent: function(){
    aform$('.aform-field-value-radio').click( function(){
      var idxs = edit_aform.controller.editAform.getFieldIdxAndOptionIdx(this);
      edit_aform.controller.editAform.setValueChecked(idxs.field_idx, idxs.option_idx, 1, 'unique');
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setClickResetDefaultCheckedEvent: function(){
    aform$('.aform-field-reset-default-checked').click( function(){
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.editAform.resetDefaultChecked(field_idx);
      edit_aform.controller.refreshEditFieldsArea();
    });
  },


  setClickEditInputExampleEvent: function(){
    aform$('.aform-field-edit-input-example').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.openEditInputExample(field_idx);
    });
  },


  openEditInputExample: function( field_idx ){
    this.destroyDragFields();
    edit_aform.controller.editAform.active_field_idx = field_idx;
    var input_example = edit_aform.controller.editAform.getInputExample(field_idx);
    edit_aform.EditAformView.openEditInputExampleTextbox(field_idx, input_example);
    edit_aform.controller.setClickEditInputExampleSubmitEvent();
    edit_aform.controller.setBlurEditInputExampleTextEvent();
  },


  setBlurEditInputExampleTextEvent: function(){
    aform$('.aform-field-edit-input-example-text').blur( function(){
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.submitEditInputExample( field_idx );
    });
  },


  setClickEditInputExampleSubmitEvent: function(){
    aform$('.aform-field-edit-input-example-submit').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.submitEditInputExample( field_idx );
    });
  },


  submitEditInputExample: function( field_idx ){
    edit_aform.controller.editAform.active_field_idx = field_idx;
    var input_example = aform$('#aformFieldEditInputExampleText' + field_idx).val();
    edit_aform.controller.editAform.setInputExample(field_idx, input_example);
    edit_aform.controller.refreshEditFieldsArea();
  },


  setClickEditMaxLengthEvent: function(){
    aform$('.aform-field-edit-max-length').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.openEditMaxLength(field_idx);
    });
  },


  openEditMaxLength: function( field_idx ){
    this.destroyDragFields();
    edit_aform.controller.editAform.active_field_idx = field_idx;
    var max_length = edit_aform.controller.editAform.getMaxLength(field_idx);
    edit_aform.EditAformView.openEditMaxLengthTextbox(field_idx, max_length);
    edit_aform.controller.setClickEditMaxLengthSubmitEvent();
    edit_aform.controller.setBlurEditMaxLengthTextEvent();
  },


  setBlurEditMaxLengthTextEvent: function(){
    aform$('.aform-field-edit-max-length-text').blur( function(){
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.submitEditMaxLength( field_idx );
    });
  },


  setClickEditMaxLengthSubmitEvent: function(){
    aform$('.aform-field-edit-max-length-submit').click( function(event){
      Event.stop(event);
      var field_idx = edit_aform.controller.editAform.getFieldIdx(this);
      edit_aform.controller.submitEditMaxLength( field_idx );
    });
  },


  submitEditMaxLength: function( field_idx ){
    edit_aform.controller.editAform.active_field_idx = field_idx;
    var max_length = aform$('#aformFieldEditMaxLengthText' + field_idx).val();
    if( max_length.match(/\D/) ){
      alert(edit_aform.phrases['Invalid max length.']);
      return false;
    }
    edit_aform.controller.editAform.setMaxLength(field_idx, max_length);
    edit_aform.controller.refreshEditFieldsArea();
  },


  setBtnSaveEvent: function(){
    aform$('#aformBtnSave').click( function(){
      edit_aform.controller.editAform.submitForm();
    });
  }
}

edit_aform.controller = new edit_aform.EditAformController();


function htmlspecialchars( str ){
    str = "" + str;	// convert to string type
    if( !str ){ return str; }
    str = str.replace(/&/g, "&amp;");
    str = str.replace(/"/g, "&quot;");
    str = str.replace(/'/g, "&#039;");
    str = str.replace(/</g, "&lt;");
    str = str.replace(/>/g, "&gt;");
    return str;
}

