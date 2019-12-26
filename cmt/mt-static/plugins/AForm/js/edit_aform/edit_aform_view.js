// A plugin for adding "A-Form" functionality.
// Copyright (c) 2008 ARK-Web Co.,Ltd.

edit_aform.EditAformView = {

  drawDropFieldDescription: function(){
    aform$('.field-edit-field').empty();
    aform$('.field-edit-field').append(
      '<div class="aform-drop-field-description">' + edit_aform.phrases['description when there is no field'] + '</div>'
    );
  },

  redrawFields: function( fields, active_field_idx ){
    aform$('.field-edit-field').empty();
    aform$.each(fields, function(field_idx){
      var active = (field_idx == active_field_idx);
      switch( this.type ){
        case 'label':
          edit_aform.EditAformView.drawLabelField(field_idx, this, active);
          break;
        case 'note':
          edit_aform.EditAformView.drawNoteField(field_idx, this, active);
          break;
        case 'text':
        case 'tel':
        case 'url':
        case 'zipcode':
          edit_aform.EditAformView.drawTextField(field_idx, this, active);
          break;
        case 'email':
          edit_aform.EditAformView.drawEmailField(field_idx, this, active);
          break;
        case 'textarea':
          edit_aform.EditAformView.drawTextareaField(field_idx, this, active);
          break;
        case 'select':
        case 'prefecture':
          edit_aform.EditAformView.drawSelectField(field_idx, this, active);
          break;
        case 'checkbox':
          edit_aform.EditAformView.drawCheckboxField(field_idx, this, active);
          break;
        case 'radio':
          edit_aform.EditAformView.drawRadioField(field_idx, this, active);
          break;
        case 'privacy':
          edit_aform.EditAformView.drawPrivacyField(field_idx, this, active);
          break;
      }
    });
  },


  drawLabelField: function( field_idx, field, active ){
    var tag = '';

    aform$('.field-edit-field').append(
      edit_aform.EditAformView.makeFieldEditTags(field_idx, field, active, tag)
    );
  },

  drawNoteField: function( field_idx, field, active ){
    var tag = '';

    aform$('.field-edit-field').append(
      edit_aform.EditAformView.makeFieldEditTags(field_idx, field, active, tag)
    );
  },

  drawTextField: function( field_idx, field, active ){
    var tag = '<input type="text" id="aformField'+ field_idx +'">';

    aform$('.field-edit-field').append(
      edit_aform.EditAformView.makeFieldEditTags(field_idx, field, active, tag)
    );
  },


  drawEmailField: function( field_idx, field, active ){
    var tag = '<input type="text" id="aformField'+ field_idx +'">&nbsp;' +
              '<label class="aform-field-email-is-replyed">' +
              '<input type="checkbox" class="aform-field-email-is-replyed" id="aformFieldEmailIsReplyed' + field_idx + '" value="1"' + (field.property.is_replyed ? ' checked="checked"' : '') + '>' +
              edit_aform.phrases['is replyed to customer'] +
              '</label>'; 

    aform$('.field-edit-field').append(
      edit_aform.EditAformView.makeFieldEditTags(field_idx, field, active, tag)
    );
  },

  drawTextareaField: function( field_idx, field, active ){
    var tag = '<textarea id="aformField'+ field_idx +'"></textarea>';

    aform$('.field-edit-field').append(
      edit_aform.EditAformView.makeFieldEditTags(field_idx, field, active, tag)
    );
  },


  drawSelectField: function( field_idx, field, active ){
    var size = field.property.options.length + (field.property.use_default ? 1 : 0);
    var tag = '<span><select id="aformFieldEditDropdown'+ field_idx +'"'+ (active ? ' size="5"' : '') +' class="aform-field-edit-dropdown">';
    if( field.property.use_default ){
      tag += '<option value="">'+ htmlspecialchars(field.property.default_label) +'</option>';
    }
    aform$.each( field.property.options, function(i){
      tag += '<option value="'+ this.value +'">'+ htmlspecialchars(this.label) +'</option>';
    });
    tag += '</select></span>';
    if( active ){
      tag += '<span id="aformFieldEditDropdownOptionLabel'+ field_idx +'"></span><br>';
      tag += edit_aform.EditAformView.makeAddValueBtn( field_idx, field ) + '<br />';
      tag += edit_aform.EditAformView.makeUseDefaultBtn( field_idx, field.property.use_default ) + '<br />';
    }

    aform$('.field-edit-field').append(
      edit_aform.EditAformView.makeFieldEditTags(field_idx, field, active, tag)
    );
  },


  drawCheckboxField: function( field_idx, field, active ){
    var tag = '';
    if( active ){
      aform$.each( field.property.options, function(i){
        tag += '<input class="aform-field-value-checkbox" type="checkbox" id="aformField'+ field_idx +'-'+ i +'" value="'+ this.value +'"'+ (this.checked ? ' checked="checked"' : '') +' title="'+ edit_aform.phrases['check status is reflected in default check status of form.'] +'">';
        tag += edit_aform.EditAformView.makeValueLabelTag( field_idx, i, this.label );
        tag += edit_aform.EditAformView.makeEditValueLabelBtn( field_idx, i, field, this.value );
        tag += edit_aform.EditAformView.makeDeleteValueBtn( field_idx, i, field, this.value );
      });
      tag += '<br />' + edit_aform.EditAformView.makeAddValueBtn( field_idx, field );
    }else{
      aform$.each( field.property.options, function(i){
        tag += '<input class="aform-field-value-checkbox" type="checkbox" id="aformField'+ field_idx +'-'+ i +'" value="'+ this.value +'"'+ (this.checked ? ' checked="checked"' : '') +' title="'+ edit_aform.phrases['check status is reflected in default check status of form.'] +'">';
        tag += edit_aform.EditAformView.makeValueLabelTag( field_idx, i, this.label );
      });
    }

    aform$('.field-edit-field').append(
      edit_aform.EditAformView.makeFieldEditTags(field_idx, field, active, tag)
    );
  },


  drawRadioField: function( field_idx, field, active ){
    var tag = '';
    if( active ){
      aform$.each( field.property.options, function(i){
        tag += '<input class="aform-field-value-radio" type="radio" id="aformField'+ field_idx +'-'+ i +'" value="'+ this.value +'"'+ (this.checked ? ' checked="checked"' : '') +' title="'+ edit_aform.phrases['check status is reflected in default check status of form.'] +'">';
        tag += edit_aform.EditAformView.makeValueLabelTag( field_idx, i, this.label );
        tag += edit_aform.EditAformView.makeEditValueLabelBtn( field_idx, i, field, this.value );
        tag += edit_aform.EditAformView.makeDeleteValueBtn( field_idx, i, field, this.value );
      });
      tag += edit_aform.EditAformView.makeResetDefaultCheckedBtn( field_idx );
      tag += '<br />' + edit_aform.EditAformView.makeAddValueBtn( field_idx, field );
    }else{
      aform$.each( field.property.options, function(i){
        tag += '<input class="aform-field-value-radio" type="radio" id="aformField'+ field_idx +'-'+ i +'" value="'+ this.value +'"'+ (this.checked ? ' checked="checked"' : '') +' title="'+ edit_aform.phrases['check status is reflected in default check status of form.'] +'">';
        tag += edit_aform.EditAformView.makeValueLabelTag( field_idx, i, this.label );
      });
    }

    aform$('.field-edit-field').append(
      edit_aform.EditAformView.makeFieldEditTags(field_idx, field, active, tag)
    );
  },


  drawPrivacyField: function( field_idx, field, active ){
    var tag = '';
    if( active ){
      tag += edit_aform.EditAformView.makeEditPrivacyLink( field_idx, field.property.privacy_link, active );
      tag += '<div>';
      aform$.each( field.property.options, function(i){
        tag += '<input class="aform-field-value-checkbox" type="checkbox" id="aformField'+ field_idx +'-'+ i +'" value="'+ this.value +'"' + (this.checked ? ' checked="checked"' : '') + ' title="'+ edit_aform.phrases['privacy policy warning'] +'">';
        tag += edit_aform.EditAformView.makeValueLabelTag( field_idx, i, this.label );
        tag += edit_aform.EditAformView.makeEditValueLabelBtn( field_idx, i, field, this.value );
      });
      tag += '</div>';
    }else{
      tag += edit_aform.EditAformView.makeEditPrivacyLink( field_idx, field.property.privacy_link, active );
      tag += '<div>';
      aform$.each( field.property.options, function(i){
        tag += '<input class="aform-field-value-checkbox" type="checkbox" id="aformField'+ field_idx +'-'+ i +'" value="'+ this.value +'"' + (this.checked ? ' checked="checked"' : '') + ' title="'+ edit_aform.phrases['privacy policy warning'] +'">';
        tag += edit_aform.EditAformView.makeValueLabelTag( field_idx, i, this.label );
      });
      tag += '</div>';
    }

    aform$('.field-edit-field').append(
      edit_aform.EditAformView.makeFieldEditTags(field_idx, field, active, tag)
    );
  },


  makeEditPrivacyLink: function( field_idx, privacy_link, active ){
    if( privacy_link == undefined ){
      privacy_link = '';
    }
    var tag = '<p class="aform-field-privacy-link">';
    tag += '<span id="aformFieldEditPrivacyLink'+ field_idx +'" class="aform-field-edit-privacy-link"><a href="javascript:void(0)" title="'+ edit_aform.phrases['privacy_link'] +'"><img src="'+ edit_aform.plugin_static_uri +'images/icons/chain.gif">'+ (privacy_link ? '' : edit_aform.phrases['Edit Privacy Link']) +'</a></span>' + '<span id="aformFieldPrivacyLink'+ field_idx +'" class="aform-field-privacy-link"><a target="_blank" href="'+ htmlspecialchars(privacy_link) +'">' + htmlspecialchars(privacy_link) + '</a></span>'
    tag += '</p>';
    return tag;
  },


  makeFieldEditTags: function( field_idx, field, active, tag ){
    var tags = '';
    if( active ){
      tags = 
       '<div id="aformFieldBlock'+ field_idx +'" class="aform-field-block-active">' +
        '<ul class="labelEdit">' +
        edit_aform.EditAformView.makeLabelTag(field_idx, field) +
        edit_aform.EditAformView.makeEditLabelBtn(field_idx, field) +
        edit_aform.EditAformView.makeNecessaryTag(field_idx, field) +
        '</ul>' +
        '<ul class="blockEdit">' +
        edit_aform.EditAformView.makeCopyBtn(field_idx, field) +
        edit_aform.EditAformView.makeDeleteBtn(field_idx, field) +
        edit_aform.EditAformView.makeMoveUpBtn(field_idx, field) +
        edit_aform.EditAformView.makeMoveDownBtn(field_idx, field) +
        '</ul>' +
        '<ul class="blockInputExample">' +
        edit_aform.EditAformView.makeInputExampleTag(field_idx, field) +
        edit_aform.EditAformView.makeEditInputExampleBtn(field_idx, field) +
        '</ul>' +
        '<ul class="blockMaxLength">' +
        edit_aform.EditAformView.makeMaxLengthTag(field_idx, field) +
        edit_aform.EditAformView.makeEditMaxLengthBtn(field_idx, field) +
        '</ul>' +
        '<p>' +
        tag +
        '</p>' +
       '</div>';
    }else{
      tags = 
       '<div id="aformFieldBlock'+ field_idx +'" class="aform-field-block">' +
        '<ul class="labelEdit">' +
        edit_aform.EditAformView.makeLabelTag(field_idx, field) +
        edit_aform.EditAformView.makeNecessaryTag(field_idx, field) +
        '</ul>' +
        '<ul class="blockInputExample">' +
        edit_aform.EditAformView.makeInputExampleTag(field_idx, field) +
        '</ul>' +
        '</ul>' +
        '<ul class="blockMaxLength">' +
        edit_aform.EditAformView.makeMaxLengthTag(field_idx, field) +
        '</ul>' +
        '<p>' +
        tag +
        '</p>' +
       '</div>';
    }
    return tags;
  },


  makeLabelTag: function( field_idx, field ){
    return '<li id="aformFieldLabel' + field_idx + '" class="aform-field-label">' + htmlspecialchars(field.label) + '</li>';
  },


  makeEditLabelBtn: function( field_idx ){
    return '<li id="aformFieldEditLabel' + field_idx + '" class="aform-field-edit-label"><a href="javascript:void(0)">['+ edit_aform.phrases['edit label'] +']</a></li>'; 
  },


  makeNecessaryTag: function( field_idx, field ){
    if( field.type == 'label' || field.type == 'note' ){
      return '';
    }
    if( field.type == 'privacy' ){
      return '<li id="aformFieldNecessary'+ field_idx +'" class="aform-field-necessary-fix"><a href="javascript:void(0)">[' + (field.is_necessary ? edit_aform.phrases['necessary'] : edit_aform.phrases['not necessary']) + ']</a></li>'; 
    }

    if( field.is_necessary ){
      return '<li id="aformFieldNecessary'+ field_idx +'" class="aform-field-necessary"><a href="javascript:void(0)" title="'+ edit_aform.phrases['necessary description'] +'">[' + edit_aform.phrases['necessary'] + ']</a></li>'; 
    }else{
      return '<li id="aformFieldNecessary'+ field_idx +'" class="aform-field-not-necessary"><a href="javascript:void(0)" title="'+ edit_aform.phrases['necessary description'] +'">[' + edit_aform.phrases['not necessary'] + ']</a></li>'; 
    }
  },


  makeInputExampleTag: function( field_idx, field ){
    if( field.property.input_example == '' || field.property.input_example == undefined ){
      label = '<span class="aform-field-input-example-not-display">' + edit_aform.phrases['input example is not displayed'] + '</span>';
    }else{
      label = htmlspecialchars(field.property.input_example);
    }
    return '<li id="aformFieldInputExample'+ field_idx +'" class="aform-field-input-example">' + label + '</li>'; 
  },


  makeEditInputExampleBtn: function( field_idx ){
    return '<li id="aformFieldEditInputExample' + field_idx + '" class="aform-field-edit-input-example"><a href="javascript:void(0)">['+ edit_aform.phrases['edit input example'] +']</a></li>'; 
  },


  isMaxLengthField: function( type ){
    switch( type ){
    case 'email':
    case 'tel':
    case 'url':
    case 'text':
    case 'textarea':
      return true;
      break;
    default:
      return false;
      break;
    }
  },


  makeMaxLengthTag: function( field_idx, field ){
    if( ! edit_aform.EditAformView.isMaxLengthField(field.type) ){
      return '';
    }
    if( field.property.max_length == '' || field.property.max_length == undefined ){
      label = '<span class="aform-field-max-length-not-display">' + edit_aform.phrases['undefined max length'] + '</span>';
    }else{
      label = htmlspecialchars(field.property.max_length);
    }
    return '<li id="aformFieldMaxLength'+ field_idx +'" class="aform-field-max-length">' + edit_aform.phrases['Max Length:'] + label + '</li>';
  },


  makeEditMaxLengthBtn: function( field_idx, field ){
    if( ! edit_aform.EditAformView.isMaxLengthField(field.type) ){
      return '';
    }
    return '<li id="aformFieldEditMaxLength' + field_idx + '" class="aform-field-edit-max-length"><a href="javascript:void(0)">['+ edit_aform.phrases['edit max length'] +']</a></li>';
  },


  makeCopyBtn: function( field_idx ){
    return '<li id="aformFieldCopy'+ field_idx +'" class="aform-field-copy"><a href="javascript:void(0)">['+ edit_aform.phrases['copy'] +']</a></li>'; 
  },


  makeDeleteBtn: function( field_idx ){
    return '<li id="aformFieldDelete'+ field_idx +'" class="aform-field-delete"><a href="javascript:void(0)">['+ edit_aform.phrases['delete'] +']</a></li>';
  },


  makeMoveUpBtn: function( field_idx ){
    return '<li id="aformFieldMoveUp'+ field_idx +'" class="aform-field-move-up"><a href="javascript:void(0)">['+ edit_aform.phrases['move-up'] +']</a></li>';
  },


  makeMoveDownBtn: function( field_idx ){
    return '<li id="aformFieldMoveDown'+ field_idx +'" class="aform-field-move-down"><a href="javascript:void(0)">['+ edit_aform.phrases['move-down'] +']</a></li>';
  },


  makeResetDefaultCheckedBtn: function( field_idx ){
    return '<span id="aformFieldResetDefaultChecked'+ field_idx +'" class="aform-field-reset-default-checked"><a href="javascript:void(0)">['+ edit_aform.phrases['reset default checked'] +']</a></span>'; 
  },

  makeAddValueBtn: function( field_idx ){
    return '<span id="aformFieldAddValue'+ field_idx +'" class="aform-field-add-value"><a href="javascript:void(0)">['+ edit_aform.phrases['add value'] +']</a></span>'; 
  },


  makeValueLabelTag: function( field_idx, option_idx, label ){
    return '<span id="aformFieldValueLabel' + field_idx + '-' + option_idx + '" class="aform-field-value-label">' + htmlspecialchars(label) + '</span>';
  },

  makeEditValueLabelBtn: function( field_idx, option_idx ){
    return '<span id="aformFieldEditValueLabel'+ field_idx +'-'+ option_idx +'" class="aform-field-edit-value-label"><a href="javascript:void(0)">['+ edit_aform.phrases['edit'] +']</a></span>';
  },


  makeDeleteValueBtn: function( field_idx, option_idx ){
    return '<span id="aformFieldDeleteValue'+ field_idx +'-'+ option_idx +'" class="aform-field-delete-value"><a href="javascript:void(0)">['+ edit_aform.phrases['delete'] +']</a></span>';
  },


  makeUseDefaultBtn: function( field_idx, use_default ){
    return '<span id="aformFieldUseDefault'+ field_idx +'" class="aform-field-use-default"><a href="javascript:void(0)">['+ (use_default ? edit_aform.phrases['delete default'] : edit_aform.phrases['use default']) +']</a></span>'; 
  },


  openEditLabelTextbox: function( field_idx, label ){
    aform$('#aformFieldEditLabel' + field_idx).hide();
    aform$('#aformFieldLabel' + field_idx).html(
      '<input type="text" id="aformFieldEditLabelText'+ field_idx +'" value="'+ htmlspecialchars(label) +'" class="aform-field-edit-label-text">' +
      '<input type="button" id="aformFieldEditLabelSubmit'+ field_idx +'" class="aform-field-edit-label-submit" value="OK">'
    );
  },


  closeEditLabelTextbox: function( field_idx, label ){
    aform$('#aformFieldLabel' + field_idx).html( htmlspecialchars(label) );
    aform$('#aformFieldEditLabel' + field_idx).show();
  },


  openEditInputExampleTextbox: function( field_idx, input_example ){
    aform$('#aformFieldEditInputExample' + field_idx).hide();
    if( input_example == undefined ){
      input_example = '';
    }
    aform$('#aformFieldInputExample' + field_idx).html(
      '<input type="text" id="aformFieldEditInputExampleText'+ field_idx +'" value="'+ htmlspecialchars(input_example) +'" class="aform-field-edit-input-example-text">' +
      '<input type="button" id="aformFieldEditInputExampleSubmit'+ field_idx +'" class="aform-field-edit-input-example-submit" value="OK">'
    );
  },


  openEditMaxLengthTextbox: function( field_idx, max_length ){
    aform$('#aformFieldEditMaxLength' + field_idx).hide();
    if( max_length == undefined ){
      max_length = '';
    }
    aform$('#aformFieldMaxLength' + field_idx).html(
      edit_aform.phrases['Max Length:'] + 
      '<input type="text" id="aformFieldEditMaxLengthText'+ field_idx +'" value="'+ htmlspecialchars(max_length) +'" class="aform-field-edit-max-length-text">' +
      '<input type="button" id="aformFieldEditMaxLengthSubmit'+ field_idx +'" class="aform-field-edit-max-length-submit" value="OK">'
    );
  },


  openEditValueLabelTextbox: function( field_idx, option_idx, label ){
    aform$('#aformFieldEditValueLabel' + field_idx +'-'+ option_idx).hide();
    aform$('#aformFieldDeleteValue' + field_idx +'-'+ option_idx).hide();
    aform$('#aformFieldValueLabel'+ field_idx +'-'+ option_idx).html(
      '<input type="text" id="aformFieldEditValueLabelText'+ field_idx +'-'+ option_idx +'" value="'+ htmlspecialchars(label) +'" class="aform-field-edit-value-label-text">' +
      '<input type="button" id="aformFieldEditValueLabelSubmit'+ field_idx +'-'+ option_idx +'" class="aform-field-edit-value-label-submit" value="OK">'
    );
  },


  closeEditValueLabelTextbox: function( field_idx, option_idx, label ){
    aform$('#aformFieldValueLabel'+ field_idx +'-'+ option_idx).html( htmlspecialchars(label) );
    aform$('#aformFieldEditValueLabel' + field_idx +'-'+ option_idx).show();
    aform$('#aformFieldDeleteValue' + field_idx +'-'+ option_idx).show();
  },


  openEditDropdownOptionLabelTextbox: function( field_idx, option_idx, label ){
    aform$('#aformFieldEditDropdownOptionLabel'+ field_idx).html(
      '<input type="text" id="aformFieldEditDropdownOptionLabelText'+ field_idx +'-'+ option_idx +'" value="'+ htmlspecialchars(label) +'" class="aform-field-edit-dropdown-option-label-text">' +
      '<input type="button" id="aformFieldEditDropdownOptionLabelSubmit'+ field_idx +'-'+ option_idx +'" class="aform-field-edit-dropdown-option-label-submit" value="OK">' +
      '<input type="button" id="aformFieldDeleteValue'+ field_idx +'-'+ option_idx +'" class="aform-field-delete-value" value="'+ edit_aform.phrases['delete'] + '">'
    );
  },


  closeEditDropdownOptionLabelTextbox: function( field_idx, option_idx, label ){
    aform$('#aformFieldEditDropdownOptionLabel'+ field_idx +'-'+ option_idx).html( htmlspecialchars(label) );
  },


  openEditPrivacyLinkTextbox: function( field_idx, link ){
    aform$('#aformFieldPrivacyLink' + field_idx).html(
      '<input type="text" id="aformFieldEditPrivacyLinkText'+ field_idx +'" value="'+ htmlspecialchars(link) +'" class="aform-field-edit-privacy-link-text">' +
      '<input type="button" id="aformFieldEditPrivacyLinkSubmit'+ field_idx +'" class="aform-field-edit-privacy-link-submit" value="OK">'
    );
  },


  closeEditPrivacyLinkTextbox: function( field_idx, link ){
    aform$('#aformFieldPrivacyLink' + field_idx).html( htmlspecialchars(link) );
  }
}
