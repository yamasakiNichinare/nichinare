﻿(function(){CKEDITOR.plugins.add('enterkey',{requires:['keystrokes','indent'],init:function(h){var i=h.specialKeys;i[13]=f;i[CKEDITOR.SHIFT+13]=e;}});CKEDITOR.plugins.enterkey={enterBlock:function(h,i,j,k){j=j||g(h);var l=j.document;if(j.checkStartOfBlock()&&j.checkEndOfBlock()){var m=new CKEDITOR.dom.elementPath(j.startContainer),n=m.block;if(n&&(n.is('li')||n.getParent().is('li'))){h.execCommand('outdent');return;}}var o=i==CKEDITOR.ENTER_DIV?'div':'p',p=j.splitBlock(o);if(!p)return;var q=p.previousBlock,r=p.nextBlock,s=p.wasStartOfBlock,t=p.wasEndOfBlock,u;if(r){u=r.getParent();if(u.is('li')){r.breakParent(u);r.move(r.getNext(),true);}}else if(q&&(u=q.getParent())&&u.is('li')){q.breakParent(u);j.moveToElementEditStart(q.getNext());q.move(q.getPrevious());}if(!s&&!t){if(r.is('li')&&(u=r.getFirst(CKEDITOR.dom.walker.invisible(true)))&&u.is&&u.is('ul','ol'))(CKEDITOR.env.ie?l.createText('\xa0'):l.createElement('br')).insertBefore(u);if(r)j.moveToElementEditStart(r);}else{var v;if(q){if(q.is('li')||!d.test(q.getName()))v=q.clone();}else if(r)v=r.clone();if(!v)v=l.createElement(o);else if(k&&!v.is('li'))v.renameNode(o);var w=p.elementPath;if(w)for(var x=0,y=w.elements.length;x<y;x++){var z=w.elements[x];if(z.equals(w.block)||z.equals(w.blockLimit))break;if(CKEDITOR.dtd.$removeEmpty[z.getName()]){z=z.clone();v.moveChildren(z);v.append(z);}}if(!CKEDITOR.env.ie)v.appendBogus();j.insertNode(v);if(CKEDITOR.env.ie&&s&&(!t||!q.getChildCount())){j.moveToElementEditStart(t?q:v);j.select();}j.moveToElementEditStart(s&&!t?r:v);}if(!CKEDITOR.env.ie)if(r){var A=l.createElement('span');A.setHtml('&nbsp;');j.insertNode(A);A.scrollIntoView();j.deleteContents();}else v.scrollIntoView();j.select();},enterBr:function(h,i,j,k){j=j||g(h);var l=j.document,m=i==CKEDITOR.ENTER_DIV?'div':'p',n=j.checkEndOfBlock(),o=new CKEDITOR.dom.elementPath(h.getSelection().getStartElement()),p=o.block,q=p&&o.block.getName(),r=false;if(!k&&q=='li'){c(h,i,j,k);return;}if(!k&&n&&d.test(q)){l.createElement('br').insertAfter(p);if(CKEDITOR.env.gecko)l.createText('').insertAfter(p);j.setStartAt(p.getNext(),CKEDITOR.env.ie?CKEDITOR.POSITION_BEFORE_START:CKEDITOR.POSITION_AFTER_START);}else{var s;r=q=='pre';if(r&&!CKEDITOR.env.gecko)s=l.createText(CKEDITOR.env.ie?'\r':'\n');else s=l.createElement('br');j.deleteContents();j.insertNode(s);if(!CKEDITOR.env.ie)l.createText('\ufeff').insertAfter(s);if(n&&!CKEDITOR.env.ie)s.getParent().appendBogus();if(!CKEDITOR.env.ie)s.getNext().$.nodeValue='';if(CKEDITOR.env.ie)j.setStartAt(s,CKEDITOR.POSITION_AFTER_END);
else j.setStartAt(s.getNext(),CKEDITOR.POSITION_AFTER_START);if(!CKEDITOR.env.ie){var t=null;if(!CKEDITOR.env.gecko){t=l.createElement('span');t.setHtml('&nbsp;');}else t=l.createElement('br');t.insertBefore(s.getNext());t.scrollIntoView();t.remove();}}j.collapse(true);j.select(r);}};var a=CKEDITOR.plugins.enterkey,b=a.enterBr,c=a.enterBlock,d=/^h[1-6]$/;function e(h){if(h.mode!='wysiwyg')return false;if(h.getSelection().getStartElement().hasAscendant('pre',true)){setTimeout(function(){c(h,h.config.enterMode,null,true);},0);return true;}else return f(h,h.config.shiftEnterMode,true);};function f(h,i,j){j=h.config.forceEnterMode||j;if(h.mode!='wysiwyg')return false;if(!i)i=h.config.enterMode;setTimeout(function(){h.fire('saveSnapshot');if(i==CKEDITOR.ENTER_BR||h.getSelection().getStartElement().hasAscendant('pre',true))b(h,i,null,j);else c(h,i,null,j);},0);return true;};function g(h){var i=h.getSelection().getRanges();for(var j=i.length-1;j>0;j--)i[j].deleteContents();return i[0];};})();
