﻿(function(){function a(g){if(!g||g.type!=CKEDITOR.NODE_ELEMENT||g.getName()!='form')return[];var h=[],i=['style','className'];for(var j=0;j<i.length;j++){var k=i[j],l=g.$.elements.namedItem(k);if(l){var m=new CKEDITOR.dom.element(l);h.push([m,m.nextSibling]);m.remove();}}return h;};function b(g,h){if(!g||g.type!=CKEDITOR.NODE_ELEMENT||g.getName()!='form')return;if(h.length>0)for(var i=h.length-1;i>=0;i--){var j=h[i][0],k=h[i][1];if(k)j.insertBefore(k);else j.appendTo(g);}};function c(g,h){var i=a(g),j={},k=g.$;if(!h){j['class']=k.className||'';k.className='';}j.inline=k.style.cssText||'';if(!h)k.style.cssText='position: static; overflow: visible';b(i);return j;};function d(g,h){var i=a(g),j=g.$;if('class' in h)j.className=h['class'];if('inline' in h)j.style.cssText=h.inline;b(i);};function e(g){var h=CKEDITOR.instances;for(var i in h){var j=h[i];if(j.mode=='wysiwyg'){var k=j.document.getBody();k.setAttribute('contentEditable',false);k.setAttribute('contentEditable',true);}}if(g.focusManager.hasFocus){g.toolbox.focus();g.focus();}};function f(g){if(!CKEDITOR.env.ie||CKEDITOR.env.version>6)return null;var h=CKEDITOR.dom.element.createFromHtml('<iframe frameborder="0" tabindex="-1" src="javascript:void((function(){document.open();'+(CKEDITOR.env.isCustomDomain()?"document.domain='"+this.getDocument().$.domain+"';":'')+'document.close();'+'})())"'+' style="display:block;position:absolute;z-index:-1;'+'progid:DXImageTransform.Microsoft.Alpha(opacity=0);'+'"></iframe>');return g.append(h,true);};CKEDITOR.plugins.add('maximize',{init:function(g){var h=g.lang,i=CKEDITOR.document,j=i.getWindow(),k,l,m,n;function o(){var q=j.getViewPaneSize();n&&n.setStyles({width:q.width+'px',height:q.height+'px'});g.resize(q.width,q.height,null,true);};var p=CKEDITOR.TRISTATE_OFF;g.addCommand('maximize',{modes:{wysiwyg:1,source:1},editorFocus:false,exec:function(){var q=g.container.getChild(1),r=g.getThemeSpace('contents');if(g.mode=='wysiwyg'){var s=g.getSelection();k=s&&s.getRanges();l=j.getScrollPosition();}else{var t=g.textarea.$;k=!CKEDITOR.env.ie&&[t.selectionStart,t.selectionEnd];l=[t.scrollLeft,t.scrollTop];}if(this.state==CKEDITOR.TRISTATE_OFF){j.on('resize',o);m=j.getScrollPosition();var u=g.container;while(u=u.getParent()){u.setCustomData('maximize_saved_styles',c(u));u.setStyle('z-index',g.config.baseFloatZIndex-1);}r.setCustomData('maximize_saved_styles',c(r,true));q.setCustomData('maximize_saved_styles',c(q,true));if(CKEDITOR.env.ie)i.$.documentElement.style.overflow=i.getBody().$.style.overflow='hidden';
else i.getBody().setStyles({overflow:'hidden',width:'0px',height:'0px'});CKEDITOR.env.ie?setTimeout(function(){j.$.scrollTo(0,0);},0):j.$.scrollTo(0,0);var v=j.getViewPaneSize();q.setStyle('position','absolute');q.$.offsetLeft;q.setStyles({'z-index':g.config.baseFloatZIndex-1,left:'0px',top:'0px'});n=f(q);o();var w=q.getDocumentPosition();q.setStyles({left:-1*w.x+'px',top:-1*w.y+'px'});CKEDITOR.env.gecko&&e(g);q.addClass('cke_maximized');}else if(this.state==CKEDITOR.TRISTATE_ON){j.removeListener('resize',o);var x=[r,q];for(var y=0;y<x.length;y++){d(x[y],x[y].getCustomData('maximize_saved_styles'));x[y].removeCustomData('maximize_saved_styles');}u=g.container;while(u=u.getParent()){d(u,u.getCustomData('maximize_saved_styles'));u.removeCustomData('maximize_saved_styles');}CKEDITOR.env.ie?setTimeout(function(){j.$.scrollTo(m.x,m.y);},0):j.$.scrollTo(m.x,m.y);q.removeClass('cke_maximized');if(n){n.remove();n=null;}g.fire('resize');}this.toggleState();var z=this.uiItems[0],A=this.state==CKEDITOR.TRISTATE_OFF?h.maximize:h.minimize,B=g.element.getDocument().getById(z._.id);B.getChild(1).setHtml(A);B.setAttribute('title',A);B.setAttribute('href','javascript:void("'+A+'");');if(g.mode=='wysiwyg'){if(k){CKEDITOR.env.gecko&&e(g);g.getSelection().selectRanges(k);var C=g.getSelection().getStartElement();C&&C.scrollIntoView(true);}else j.$.scrollTo(l.x,l.y);}else{if(k){t.selectionStart=k[0];t.selectionEnd=k[1];}t.scrollLeft=l[0];t.scrollTop=l[1];}k=l=null;p=this.state;},canUndo:false});g.ui.addButton('Maximize',{label:h.maximize,command:'maximize'});g.on('mode',function(){g.getCommand('maximize').setState(p);},null,null,100);}});})();
