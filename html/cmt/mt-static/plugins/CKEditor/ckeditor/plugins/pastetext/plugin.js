﻿(function(){var a={exec:function(d){var e=CKEDITOR.tools.tryThese(function(){var f=window.clipboardData.getData('Text');if(!f)throw 0;return f;},function(){window.netscape.security.PrivilegeManager.enablePrivilege('UniversalXPConnect');var f=window.Components.classes['@mozilla.org/widget/clipboard;1'].getService(window.Components.interfaces.nsIClipboard),g=window.Components.classes['@mozilla.org/widget/transferable;1'].createInstance(window.Components.interfaces.nsITransferable);g.addDataFlavor('text/unicode');f.getData(g,f.kGlobalClipboard);var h={},i={},j;g.getTransferData('text/unicode',h,i);h=h.value.QueryInterface(window.Components.interfaces.nsISupportsString);j=h.data.substring(0,i.value/2);return j;});if(!e){d.openDialog('pastetext');return false;}else d.fire('paste',{text:e});return true;}};function b(d,e){if(CKEDITOR.env.ie){var f=d.selection;if(f.type=='Control')f.clear();f.createRange().pasteHTML(e);}else d.execCommand('inserthtml',false,e);};CKEDITOR.plugins.add('pastetext',{init:function(d){var e='pastetext',f=d.addCommand(e,a);d.ui.addButton('PasteText',{label:d.lang.pasteText.button,command:e});CKEDITOR.dialog.add(e,CKEDITOR.getUrl(this.path+'dialogs/pastetext.js'));if(d.config.forcePasteAsPlainText)d.on('beforeCommandExec',function(g){if(g.data.name=='paste'){d.execCommand('pastetext');g.cancel();}},null,null,0);},requires:['clipboard']});function c(d,e,f,g){while(f--)CKEDITOR.plugins.enterkey[e==CKEDITOR.ENTER_BR?'enterBr':'enterBlock'](d,e,null,g);};CKEDITOR.editor.prototype.insertText=function(d){this.focus();this.fire('saveSnapshot');var e=this.getSelection().getStartElement().hasAscendant('pre',true)?CKEDITOR.ENTER_BR:this.config.enterMode,f=e==CKEDITOR.ENTER_BR,g=this.document.$,h=this,i;d=CKEDITOR.tools.htmlEncode(d.replace(/\r\n|\r/g,'\n'));var j=0;d.replace(/\n+/g,function(k,l){i=d.substring(j,l);j=l+k.length;i.length&&b(g,i);var m=k.length,n=f?0:Math.floor(m/2),o=f?m:m%2;c(h,e,n);c(h,CKEDITOR.ENTER_BR,o,f?false:true);});i=d.substring(j,d.length);i.length&&b(g,i);this.fire('saveSnapshot');};})();
