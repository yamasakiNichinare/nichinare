﻿CKEDITOR.plugins.add('contextmenu',{requires:['menu'],beforeInit:function(a){a.contextMenu=new CKEDITOR.plugins.contextMenu(a);a.addCommand('contextMenu',{exec:function(){a.contextMenu.show(a.document.getBody());}});}});CKEDITOR.plugins.contextMenu=CKEDITOR.tools.createClass({$:function(a){this.id='cke_'+CKEDITOR.tools.getNextNumber();this.editor=a;this._.listeners=[];this._.functionId=CKEDITOR.tools.addFunction(function(b){this._.panel.hide();a.focus();a.execCommand(b);},this);this.definition={panel:{className:a.skinClass+' cke_contextmenu',attributes:{'aria-label':a.lang.contextmenu.options}}};},_:{onMenu:function(a,b,c,d){var e=this._.menu,f=this.editor;if(e){e.hide();e.removeAll();}else{e=this._.menu=new CKEDITOR.menu(f,this.definition);e.onClick=CKEDITOR.tools.bind(function(o){e.hide();if(o.onClick)o.onClick();else if(o.command)f.execCommand(o.command);},this);e.onEscape=function(o){var p=this.parent;if(p){p._.panel.hideChild();var q=p._.panel._.panel._.currentBlock,r=q._.focusIndex;q._.markItem(r);}else if(o==27){this.hide();f.focus();}return false;};}var g=this._.listeners,h=[],i=this.editor.getSelection(),j=i&&i.getStartElement();e.onHide=CKEDITOR.tools.bind(function(){e.onHide=null;if(CKEDITOR.env.ie){var o=f.getSelection();o&&o.unlock();}this.onHide&&this.onHide();},this);for(var k=0;k<g.length;k++){var l=g[k](j,i);if(l)for(var m in l){var n=this.editor.getMenuItem(m);if(n){n.state=l[m];e.add(n);}}}e.items.length&&e.show(a,b||(f.lang.dir=='rtl'?2:1),c,d);}},proto:{addTarget:function(a,b){if(CKEDITOR.env.opera){var c;a.on('mousedown',function(g){g=g.data;if(g.$.button!=2){if(g.getKeystroke()==CKEDITOR.CTRL+1)a.fire('contextmenu',g);return;}if(b&&(CKEDITOR.env.mac?g.$.metaKey:g.$.ctrlKey))return;var h=g.getTarget();if(!c){var i=h.getDocument();c=i.createElement('input');c.$.type='button';i.getBody().append(c);}c.setAttribute('style','position:absolute;top:'+(g.$.clientY-2)+'px;left:'+(g.$.clientX-2)+'px;width:5px;height:5px;opacity:0.01');});a.on('mouseup',function(g){if(c){c.remove();c=undefined;a.fire('contextmenu',g.data);}});}a.on('contextmenu',function(g){var h=g.data;if(b&&(CKEDITOR.env.webkit?d:CKEDITOR.env.mac?h.$.metaKey:h.$.ctrlKey))return;h.preventDefault();var i=h.getTarget().getDocument().getDocumentElement(),j=h.$.clientX,k=h.$.clientY;CKEDITOR.tools.setTimeout(function(){this.show(i,null,j,k);},0,this);},this);if(CKEDITOR.env.webkit){var d,e=function(g){d=CKEDITOR.env.mac?g.data.$.metaKey:g.data.$.ctrlKey;},f=function(){d=0;};a.on('keydown',e);
a.on('keyup',f);a.on('contextmenu',f);}},addListener:function(a){this._.listeners.push(a);},show:function(a,b,c,d){this.editor.focus();if(CKEDITOR.env.ie){var e=this.editor.getSelection();e&&e.lock();}this._.onMenu(a||CKEDITOR.document.getDocumentElement(),b,c||0,d||0);}}});
