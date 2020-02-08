// A plugin for adding "A-Form" functionality.
// Copyright (c) 2008 ARK-Web Co.,Ltd.

function submitAForm( event ) {
  $('aform_btn_submit').disabled = true;
  $('aform_btn_back').disabled = true;

  Event.stop(event);
  $('aform-confirm-form').use_js.value = 1;
  var myAjax = new Ajax.Request (
        $('aform-confirm-form').action,
        {
          method: 'post',
          parameters: $('aform-confirm-form').serialize(),
          onSuccess: callbackSubmitAForm,
          onFailuer: reportAFormError
        });
  return false;
}

function callbackSubmitAForm( result ) {
//  $('aform-content').hide();
  if( result.responseText == 'success' ){
    $('aform_result').innerHTML = aform_confirm.msg_success;
  }else{
    $('aform_result').innerHTML = result.responseText;
  }
  return false;
}

function reportAFormError() {
  alert('Ajax error');
}
