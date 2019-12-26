// A plugin for adding "A-Form" functionality.
// Copyright (c) 2008 ARK-Web Co.,Ltd.

function addAFormValidate() {
  Validation.addAllThese([
    ['hankaku', '', function(v,elm) {
      elm.value = elm.value.toHankaku();
      return true;
    }],

    ['required', 'This is a required field.', function(v,elm) {
      if( !Validation.get('IsEmpty').test(v) ){
        removeAFormInputErrorTitle(elm);
        return true;
      }else{
        addAFormInputErrorTitle(elm);
        postAFormErrorLog('empty', elm, v);
        return false;
      }
    }],

    ['validate-length', 'Length', function(v,elm) {
      var max_length = elm.readAttribute('validate_max_length');
      v = v.replace(/\r/g, "");
      v = v.replace(/\n/g, "");
      if( v.length <= max_length ){
        removeAFormInputErrorTitle(elm);
        return true;
      }else{
        addAFormInputErrorTitle(elm);
        postAFormErrorLog('max_length_error', elm, v);
        return false;
      }
    }],

    ['validate-email', 'Please enter a valid email address. For example fred@domain.com .', function (v,elm) {
      if( Validation.get('IsEmpty').test(v) || /^([*+!.&#$|\'\\%\/0-9a-z^_`{}=?~:-]+)@(([0-9a-z-]+\.)+[0-9a-z]{2,})$/i.test(v) ){
        removeAFormInputErrorTitle(elm);
        return true;
      }else{
        addAFormInputErrorTitle(elm);
        postAFormErrorLog('email_format_error', elm, v);
        return false;
      }
    }],

    ['validate-url', 'Please enter a valid URL.', function (v,elm) {
      if( Validation.get('IsEmpty').test(v) || /^(http|https|ftp):\/\/(([A-Z0-9][A-Z0-9_-]*)(\.[A-Z0-9][A-Z0-9_-]*)+)(:(\d+))?\/?/i.test(v) ){
        removeAFormInputErrorTitle(elm);
        return true;
      }else{
        addAFormInputErrorTitle(elm);
        postAFormErrorLog('url_format_error', elm, v);
        return false;
      }
    }],

    ['validate-tel', 'Please use only numbers (0-9) or '-' in this field.', function(v,elm) {
      if( Validation.get('IsEmpty').test(v) || /^[0-9\-]+$/.test(v) ){
        removeAFormInputErrorTitle(elm);
        return true;
      }else{
        addAFormInputErrorTitle(elm);
        postAFormErrorLog('tel_format_error', elm, v);
        return false;
      }
    }],

    ['validate-zipcode', 'Please enter a valid zipcode. For example 999-9999.', function(v,elm) {
      if( Validation.get('IsEmpty').test(v) || /^[0-9]{3}-[0-9]{4}$/.test(v) ){
        removeAFormInputErrorTitle(elm);
        return true;
      }else{
        addAFormInputErrorTitle(elm);
        postAFormErrorLog('zipcode_format_error', elm, v);
        return false;
      }
    }],

    ['validate-selection', 'Please make a selection', function(v,elm){
      if( !Validation.get('IsEmpty').test(v) ){
        removeAFormInputErrorTitle(elm);
        return true;
      }else{
        addAFormInputErrorTitle(elm);
        postAFormErrorLog('not_selected', elm, v);
        return false;
      }
    }],

    ['validate-one-required', 'Please select one of the above options.', function(v,elm) {
      var field_id = elm.name.match(/^aform-field-[0-9]+/);
      var reg = new RegExp( field_id );
      var options = elm.form.getElementsByTagName('INPUT');
      var check = $A(options).any(function(option) {
        if( option.name.search(reg) == -1 ){
          return '';
        }
        return $F(option);
      });
      if( check ){
        hideAFormAdvice(elm);
        removeAFormInputErrorTitle(elm);
        return true;
      }else{
        addAFormInputErrorTitle(elm);
        postAFormErrorLog('empty', elm, v);
        return false;
      }
    }],

    ['validate-privacy', 'Please check this privacy policy.', function(v,elm) {
      var field_id = elm.name.match(/^aform-field-[0-9]+/);
      var reg = new RegExp( field_id );
      var options = elm.form.getElementsByTagName('INPUT');
      var check = $A(options).any(function(option) {
        if( option.name.search(reg) == -1 ){
          return '';
        }
        return $F(option);
      });
      if( check ){
        removeAFormInputErrorTitle(elm);
        return true;
      }else{
        addAFormInputErrorTitle(elm);
        postAFormErrorLog('privacy_error', elm, v);
        return false;
      }
    }]
  ]);
}



function addAFormInputErrorTitle(elm)
{
  if( ! elm.title.match(eval("/^"+ aform.phrases['Input error:'] +"/")) ){
    elm.title = aform.phrases['Input error:'] + elm.title;
  }
}


function removeAFormInputErrorTitle(elm)
{
  elm.title = elm.title.replace(eval("/"+ aform.phrases['Input error:'] +"/"), "");
}


function hideAFormAdvice(elm)
{
  var field_id = elm.name.match(/^aform-field-[0-9]+/);
  $(field_id + '-error').innerHTML = '';
}

function postAFormAccessLog(aform_id)
{
  var params = {
    screen : 'form',
    run_mode : 'access',
    aform_id : aform_id,
    aform_url : document.location.href,
    first_access : Cookie.get(document.location.pathname) ? 0 : 1
  };
  var myAjax = new Ajax.Request(
        aform.logger_url,
        {
          method: 'post',
          parameters: $H(params).toQueryString()
        }); 
  Cookie.set(document.location.pathname, "1", 30*60);	// expires sec
}

function postAFormErrorLog(type, elm, value)
{
  var aform_id = elm.form.id.value;
  var field_id = elm.name.replace(/aform-field-(\d+).*/, "$1");
  var params = {
    run_mode : 'error',
    aform_id : aform_id,
    aform_url : document.location.href,
    type : type,
    error_field_id : field_id,
    error_value : value
  };
  var myAjax = new Ajax.Request (
        aform.logger_url,
        {
          method: 'post',
          parameters: $H(params).toQueryString()
        });
}

function postAFormChecker()
{
  var params = {
  };
  var myAjax = new Ajax.Request(
        aform.checker_url,
        {
          method: 'post',
          parameters: $H(params).toQueryString()
        }); 
}

