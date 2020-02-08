// A plugin for adding "A-Form" functionality.
// Copyright (c) 2008 ARK-Web Co.,Ltd.

edit_aform.EditAform = function(){
  this.fields = edit_aform.json_fields_data.fields;
  this.newId = 0;
  this.active_field_idx = null;
  this.is_changed = false;
}


edit_aform.EditAform.prototype = {

  resetSortOrder: function(){
    var sort_order = 0;
    aform$.each(edit_aform.controller.editAform.fields, function(i) {
      edit_aform.controller.editAform.fields[i].sort_order = sort_order;
      sort_order++;
    });
  },


  addField: function( type ){
    var new_id = this.getNewFieldId();
    this.fields.push(
      {
        id: new_id,
        type: type,
        label: this.getDefaultLabel(type),
        is_necessary: this.getDefaultNecessary(type),
        property: this.getDefaultProperty(type)
      }
    );
    this.resetSortOrder();
    this.is_changed = true;
  },


  unshiftField: function( type ){
    var newField = {
        id: this.getNewFieldId(),
        type: type,
        label: this.getDefaultLabel(type),
        is_necessary: this.getDefaultNecessary(type),
        property: this.getDefaultProperty(type)
    };

    this.fields.unshift( newField );
    this.resetSortOrder();
    this.active_field_idx = 0;
    this.is_changed = true;
  },


  insertAfterField: function( idx, type ){
    var beforeField = this.fields[idx];
    var newField = {
        id: this.getNewFieldId(),
        type: type,
        label: this.getDefaultLabel(type),
        is_necessary: this.getDefaultNecessary(type),
        property: this.getDefaultProperty(type)
    };

    this.fields.splice( idx, 1, beforeField, newField );
    this.active_field_idx = parseInt(idx) + 1;
    this.resetSortOrder();
    this.is_changed = true;
  },


  copyObj: function( obj ){
    return aform$.extend(true,{},obj);
  },


  copyField: function( field_idx ){
    var copyField = this.fields[field_idx];

    var newField = this.copyObj(copyField);
    newField.id = this.getNewFieldId();

    this.fields.splice( field_idx, 1, copyField, newField );
    this.resetSortOrder();
    this.is_changed = true;
  },


  deleteField: function( field_idx ){
    // delete
    this.fields.splice(field_idx,1);
    // move active_field
    this.active_field_idx = field_idx;

    this.resetSortOrder();
    this.is_changed = true;
  },


  // get field_idx by obj.id and className
  getFieldIdx: function( obj ){
    var patterns = Array();
    patterns['aform-field-block'] = /aformFieldBlock(\w+)/;
    patterns['aform-field-block ui-draggable'] = /aformFieldBlock(\w+)/;
    patterns['aform-field-block-active'] = /aformFieldBlock(\w+)/;
    patterns['aform-field-block-active ui-draggable'] = /aformFieldBlock(\w+)/;
    patterns['aform-field-label'] = /aformFieldLabel(\w+)/;
    patterns['aform-field-label ui-draggable'] = /aformFieldLabel(\w+)/;
    patterns['aform-field-edit-label'] = /aformFieldEditLabel(\w+)/;
    patterns['aform-field-edit-label-text'] = /aformFieldEditLabelText(\w+)/;
    patterns['aform-field-edit-label-submit'] = /aformFieldEditLabelSubmit(\w+)/;
    patterns['aform-field-necessary'] = /aformFieldNecessary(\w+)/;
    patterns['aform-field-not-necessary'] = /aformFieldNecessary(\w+)/;
    patterns['aform-field-use-default'] = /aformFieldUseDefault(\w+)/;
    patterns['aform-field-edit-dropdown'] = /aformFieldEditDropdown(\w+)/;
    patterns['aform-field-copy'] = /aformFieldCopy(\w+)/;
    patterns['aform-field-delete'] = /aformFieldDelete(\w+)/;
    patterns['aform-field-move-up'] = /aformFieldMoveUp(\w+)/;
    patterns['aform-field-move-down'] = /aformFieldMoveDown(\w+)/;
    patterns['aform-field-add-value'] = /aformFieldAddValue(\w+)/;
    patterns['aform-field-edit-privacy-link'] = /aformFieldEditPrivacyLink(\w+)/;
    patterns['aform-field-email-is-replyed'] = /aformFieldEmailIsReplyed(\w+)/;
    patterns['aform-field-edit-privacy-link-submit'] = /aformFieldEditPrivacyLinkSubmit(\w+)/;
    patterns['aform-field-edit-input-example'] = /aformFieldEditInputExample(\w+)/;
    patterns['aform-field-edit-input-example-text'] = /aformFieldEditInputExampleText(\w+)/;
    patterns['aform-field-edit-input-example-submit'] = /aformFieldEditInputExampleSubmit(\w+)/;
    patterns['aform-field-edit-max-length'] = /aformFieldEditMaxLength(\w+)/;
    patterns['aform-field-edit-max-length-text'] = /aformFieldEditMaxLengthText(\w+)/;
    patterns['aform-field-edit-max-length-submit'] = /aformFieldEditMaxLengthSubmit(\w+)/;
    patterns['aform-field-reset-default-checked'] = /aformFieldResetDefaultChecked(\w+)/;

    var match = obj.id.match(patterns[obj.className]);
    if( match ){
      return parseInt(match[1]);
    }else{
      return null;
    }
  },


  // get field_idx and option_idx by obj.id and className
  getFieldIdxAndOptionIdx: function( obj ){
    var patterns = Array();
    patterns['aform-field-value-label'] = /aformFieldValueLabel(\w+)\-(\w+)/;
    patterns['aform-field-edit-value-label'] = /aformFieldEditValueLabel(\w+)\-(\w+)/;
    patterns['aform-field-edit-value-label-submit'] = /aformFieldEditValueLabelSubmit(\w+)\-(\w+)/;
    patterns['aform-field-edit-value-label-text'] = /aformFieldEditValueLabelText(\w+)\-(\w+)/;
    patterns['aform-field-edit-dropdown-option-label-submit'] = /aformFieldEditDropdownOptionLabelSubmit(\w+)\-(\w+)/;
    patterns['aform-field-edit-dropdown-option-label-text'] = /aformFieldEditDropdownOptionLabelText(\w+)\-(\w+)/;
    patterns['aform-field-delete-value'] = /aformFieldDeleteValue(\w+)\-(\w+)/;
    patterns['aform-field-value-checkbox'] = /aformField(\w+)\-(\w+)/;
    patterns['aform-field-value-radio'] = /aformField(\w+)\-(\w+)/;

    var match = obj.id.match(patterns[obj.className]);
    if( match ){
      return {field_idx: parseInt(match[1]), option_idx: parseInt(match[2])};
    }else{
      return null;
    }
  },


  getLabel: function( field_idx ){
    return this.fields[field_idx].label;
  },


  setLabel: function( field_idx, label ){
    this.fields[field_idx].label = label;
    this.is_changed = true;
  },


  getInputExample: function( field_idx ){
    return this.fields[field_idx].property.input_example;
  },


  setInputExample: function( field_idx, input_example ){
    this.fields[field_idx].property.input_example = input_example;
    this.is_changed = true;
  },


  getMaxLength: function( field_idx ){
    return this.fields[field_idx].property.max_length;
  },


  setMaxLength: function( field_idx, max_length ){
    this.fields[field_idx].property.max_length = max_length;
    this.is_changed = true;
  },


  getValueLabel: function( field_idx, option_idx ){
    return this.fields[field_idx].property.options[option_idx].label;
  },


  setValueLabel: function( field_idx, option_idx, label ){
    this.fields[field_idx].property.options[option_idx].label = label;
    this.is_changed = true;
  },


  getValueChecked: function( field_idx, option_idx ){
    return this.fields[field_idx].property.options[option_idx].checked;
  },


  setValueChecked: function( field_idx, option_idx, checked, unique ){
    if( unique ){
      aform$(this.fields[field_idx].property.options).each( function(){
        this.checked = 0;
      });
    }
    this.fields[field_idx].property.options[option_idx].checked = checked;
    this.is_changed = true;
  },


  resetDefaultChecked: function( field_idx ){
    aform$(this.fields[field_idx].property.options).each( function(){
      this.checked = 0;
    });
    this.is_changed = true;
  },


  tolgNecessary: function( field_idx ){
    this.fields[field_idx].is_necessary = this.fields[field_idx].is_necessary  ? 0 : 1;
    this.is_changed = true;
  },


  getNewFieldId: function(){
    this.newId++;
    return 'New' + this.newId;
  },


  getDefaultLabel: function( type ){
    var label;
    switch( type ){
      case 'email':
        label = edit_aform.phrases['Email'];
        break;
      case 'tel':
        label = edit_aform.phrases['Tel'];
        break;
      case 'url':
        label = edit_aform.phrases['URL'];
        break;
      case 'zipcode':
        label = edit_aform.phrases['ZipCode'];
        break;
      case 'prefecture':
        label = edit_aform.phrases['Prefecture'];
        break;
      case 'privacy':
        label = edit_aform.phrases['Privacy'];
        break;
      default:
        label = edit_aform.phrases['type ' + type] + '(' + edit_aform.phrases['Undefined'] + ')';
        break;
    }
    return label;
  },


  getDefaultProperty: function( type ){
    var property = new Object();

    switch( type ){
      case 'radio':
        property.options = new Array( 
                             { label : edit_aform.phrases['Value'] + "1", value : "1"},
                             { label : edit_aform.phrases['Value'] + "2", value : "2"}
                           );
        property.next_value = 3;
        break;
      case 'select':
        property.use_default = 1;
        property.default_label = edit_aform.phrases['please select'];
        property.options = new Array();
        property.next_value = 1;
        break;
      case 'checkbox':
        property.options = new Array( 
                             { label : edit_aform.phrases['Value'] + "1", value : "1"}
                           );
        property.next_value = 2;
        break;
      case 'prefecture':
        property.use_default = 1;
        property.default_label = edit_aform.phrases['please select'];
        property.options = new Array();
        for( var i = 0; i < edit_aform.phrases['PrefectureList'].length; i++ ){
          property.options.push( { label : edit_aform.phrases['PrefectureList'][i], value : i+1 } );
        }
        property.next_value = property.options.length + 1;
        break;
      case 'privacy':
        property.options = new Array(
                             { label : edit_aform.phrases['Agree'], value : "1"}
                           );
        property.privacy_link = '';
        break;
      case 'email':
        property.is_replyed = 1;
        property.input_example = edit_aform.phrases['Example:'] + 'foo@example.com';
        break;
      case 'zipcode':
        property.input_example = edit_aform.phrases['Example:'] + '123-4567';
        break;
      case 'tel':
        property.input_example = edit_aform.phrases['Example:'] + '03-1234-5678';
        break;
      case 'url':
        property.input_example = edit_aform.phrases['Example:'] + 'http://www.example.com/';
        break;
      default:
        break;
    }
    return property;
  },


  getDefaultNecessary: function( type ){
    var is_necessary = 0;
    switch( type ){
      case 'privacy':
        is_necessary = 1;
        break;
    }
    return is_necessary;
  },


  addValue: function( field_idx ){
    var next_value = this.fields[field_idx].property.next_value;
    this.fields[field_idx].property.options.push(
      { label : edit_aform.phrases['Value'] + next_value, 
        value : next_value } 
    );
    this.fields[field_idx].property.next_value++;
    this.is_changed = true;
  },


  deleteValue: function( field_idx, option_idx ){
    if( this.fields[field_idx].property.options.length == 1 ){
      alert(edit_aform.phrases['At least one option is required.']);
      return;
    }

    this.fields[field_idx].property.options.splice(option_idx, 1);
    this.is_changed = true;
  },


  tolgUseDefault: function( field_idx ){
    this.fields[field_idx].property.use_default = this.fields[field_idx].property.use_default ? 0 : 1;
    this.is_changed = true;
  },


  setDropdownOptionLabel: function( field_idx, option_idx, label ){
    if( label == '' ){
      // delete option if label is null
      this.fields[field_idx].property.options.splice(option_idx, 1);
    }else{
      this.fields[field_idx].property.options[option_idx].label = label;
    }
    this.is_changed = true;
  },


  getPrivacyLink: function( field_idx ){
    return this.fields[field_idx].property.privacy_link;
  },


  setPrivacyLink: function( field_idx, privacy_link ){
    this.fields[field_idx].property.privacy_link = privacy_link;
    this.is_changed = true;
  },


  setEmailIsReplyed: function( field_idx, is_replyed ){
    this.fields[field_idx].property.is_replyed = is_replyed;
    this.is_changed = true;
  },


  submitForm: function(){
    var json_fields = aform$.toJSON(this);
    aform$('#json_aform_fields').val( json_fields );
    aform$('#aform-field-form').submit();
  },


  dragdropNewField: function( event, ui ){
    var match = ui.helper.id.match(/aformFieldType-(\w+)/);
    var type = match[1];

    if( this.fields.length == 0 ){
      this.addField(type);
      return;
    }

    var idx = null;
    aform$('.field-edit-field').children().each(function(i){
      var pos = aform$(this).position();
      if( pos.top < ui.helper.offsetTop ){
        idx = edit_aform.controller.editAform.getFieldIdx(this);
      }
    });

    if( idx == null ){
      this.unshiftField(type);
    }else{
      this.insertAfterField(idx, type);
    }
  },


  dragdropField: function( event, ui ){
    if(ui.helper.offsetTop == 0){
      return;
    }
    var move_idx = this.getFieldIdx(ui.helper);

    var before_idx = null;
    aform$('.field-edit-field').children().each(function(i){
      if( ui.helper.id != this.id ){
        var pos = aform$(this).position();
        if( pos.top < ui.helper.offsetTop ){
          before_idx = edit_aform.controller.editAform.getFieldIdx(this);
        }
      }
    });

    if( before_idx == null ){
      if( move_idx == 0 ){
        return;
      }
      // move field to top
      this.moveField( move_idx, 0, 'before' );
      this.active_field_idx = 0;
    }else{
      if( move_idx == before_idx || move_idx == before_idx + 1){
        return;
      }
      // move field after before_idx
      this.moveField( move_idx, before_idx, 'after' );
      if( move_idx > before_idx ){
        this.active_field_idx = before_idx + 1;
      }else{
        this.active_field_idx = before_idx;
      }
    }
  },


  moveField: function( move_idx, to_idx, position ){
    var moveField = this.copyObj(this.fields[move_idx]);
    var toField = this.copyObj(this.fields[to_idx]);

    // delete move field
    this.fields.splice(move_idx, 1);
    if( move_idx < to_idx ){
      to_idx--;
    }
    if( position == 'before' ){
      // insert before to_field
      this.fields.splice(to_idx, 1, moveField, toField);
    }else{
      // insert after to_field
      this.fields.splice(to_idx, 1, toField, moveField);
    }

    this.resetSortOrder();
    this.is_changed = true;
  },


  moveUpField: function( move_idx ){
    if( move_idx > 0 ){
      this.moveField( move_idx, move_idx - 1, 'before' );
      this.active_field_idx = move_idx - 1;
    }
  },


  moveDownField: function( move_idx ){
    if( move_idx < this.fields.length - 1 ){
      this.moveField( move_idx, move_idx + 1, 'after' );
      this.active_field_idx = move_idx + 1;
    }
  }
}
