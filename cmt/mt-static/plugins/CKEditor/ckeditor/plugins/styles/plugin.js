﻿CKEDITOR.plugins.add('styles',{requires:['selection']});CKEDITOR.editor.prototype.attachStyleStateChange=function(a,b){var c=this._.styleStateChangeCallbacks;if(!c){c=this._.styleStateChangeCallbacks=[];this.on('selectionChange',function(d){for(var e=0;e<c.length;e++){var f=c[e],g=f.style.checkActive(d.data.path)?CKEDITOR.TRISTATE_ON:CKEDITOR.TRISTATE_OFF;if(f.state!==g){f.fn.call(this,g);f.state!==g;}}});}c.push({style:a,fn:b});};CKEDITOR.STYLE_BLOCK=1;CKEDITOR.STYLE_INLINE=2;CKEDITOR.STYLE_OBJECT=3;(function(){var a={address:1,div:1,h1:1,h2:1,h3:1,h4:1,h5:1,h6:1,p:1,pre:1},b={a:1,embed:1,hr:1,img:1,li:1,object:1,ol:1,table:1,td:1,tr:1,th:1,ul:1,dl:1,dt:1,dd:1,form:1},c=/\s*(?:;\s*|$)/;CKEDITOR.style=function(C,D){if(D){C=CKEDITOR.tools.clone(C);u(C.attributes,D);u(C.styles,D);}var E=this.element=(C.element||'*').toLowerCase();this.type=E=='#'||a[E]?CKEDITOR.STYLE_BLOCK:b[E]?CKEDITOR.STYLE_OBJECT:CKEDITOR.STYLE_INLINE;this._={definition:C};};CKEDITOR.style.prototype={apply:function(C){B.call(this,C,false);},remove:function(C){B.call(this,C,true);},applyToRange:function(C){var D=this;return(D.applyToRange=D.type==CKEDITOR.STYLE_INLINE?d:D.type==CKEDITOR.STYLE_BLOCK?g:D.type==CKEDITOR.STYLE_OBJECT?f:null).call(D,C);},removeFromRange:function(C){return(this.removeFromRange=this.type==CKEDITOR.STYLE_INLINE?e:null).call(this,C);},applyToObject:function(C){s(C,this);},checkActive:function(C){var G=this;switch(G.type){case CKEDITOR.STYLE_BLOCK:return G.checkElementRemovable(C.block||C.blockLimit,true);case CKEDITOR.STYLE_OBJECT:case CKEDITOR.STYLE_INLINE:var D=C.elements;for(var E=0,F;E<D.length;E++){F=D[E];if(G.type==CKEDITOR.STYLE_INLINE&&(F==C.block||F==C.blockLimit))continue;if(G.type==CKEDITOR.STYLE_OBJECT&&!(F.getName() in b))continue;if(G.checkElementRemovable(F,true))return true;}}return false;},checkApplicable:function(C){switch(this.type){case CKEDITOR.STYLE_INLINE:case CKEDITOR.STYLE_BLOCK:break;case CKEDITOR.STYLE_OBJECT:return C.lastElement.getAscendant(this.element,true);}return true;},checkElementRemovable:function(C,D){if(!C)return false;var E=this._.definition,F;if(C.getName()==this.element){if(!D&&!C.hasAttributes())return true;F=v(E);if(F._length){for(var G in F){if(G=='_length')continue;var H=C.getAttribute(G)||'';if(G=='style'?A(F[G],y(H,false)):F[G]==H){if(!D)return true;}else if(D)return false;}if(D)return true;}else return true;}var I=w(this)[C.getName()];if(I){if(!(F=I.attributes))return true;for(var J=0;J<F.length;J++){G=F[J][0];var K=C.getAttribute(G);
if(K){var L=F[J][1];if(L===null||typeof L=='string'&&K==L||L.test(K))return true;}}}return false;},buildPreview:function(){var C=this._.definition,D=[],E=C.element;if(E=='bdo')E='span';D=['<',E];var F=C.attributes;if(F)for(var G in F)D.push(' ',G,'="',F[G],'"');var H=CKEDITOR.style.getStyleText(C);if(H)D.push(' style="',H,'"');D.push('>',C.name,'</',E,'>');return D.join('');}};CKEDITOR.style.getStyleText=function(C){var D=C._ST;if(D)return D;D=C.styles;var E=C.attributes&&C.attributes.style||'',F='';if(E.length)E=E.replace(c,';');for(var G in D){var H=D[G],I=(G+':'+H).replace(c,';');if(H=='inherit')F+=I;else E+=I;}if(E.length)E=y(E);E+=F;return C._ST=E;};function d(C){var Z=this;var D=C.document;if(C.collapsed){var E=r(Z,D);C.insertNode(E);C.moveToPosition(E,CKEDITOR.POSITION_BEFORE_END);return;}var F=Z.element,G=Z._.definition,H,I=CKEDITOR.dtd[F]||(H=true,CKEDITOR.dtd.span),J=C.createBookmark();C.enlarge(CKEDITOR.ENLARGE_ELEMENT);C.trim();var K=C.createBookmark(),L=K.startNode,M=K.endNode,N=L,O;while(N){var P=false;if(N.equals(M)){N=null;P=true;}else{var Q=N.type,R=Q==CKEDITOR.NODE_ELEMENT?N.getName():null;if(R&&N.getAttribute('_fck_bookmark')){N=N.getNextSourceNode(true);continue;}if(!R||I[R]&&(N.getPosition(M)|CKEDITOR.POSITION_PRECEDING|CKEDITOR.POSITION_IDENTICAL|CKEDITOR.POSITION_IS_CONTAINED)==CKEDITOR.POSITION_PRECEDING+CKEDITOR.POSITION_IDENTICAL+CKEDITOR.POSITION_IS_CONTAINED&&(!G.childRule||G.childRule(N))){var S=N.getParent();if(S&&((S.getDtd()||CKEDITOR.dtd.span)[F]||H)&&(!G.parentRule||G.parentRule(S))){if(!O&&(!R||!CKEDITOR.dtd.$removeEmpty[R]||(N.getPosition(M)|CKEDITOR.POSITION_PRECEDING|CKEDITOR.POSITION_IDENTICAL|CKEDITOR.POSITION_IS_CONTAINED)==CKEDITOR.POSITION_PRECEDING+CKEDITOR.POSITION_IDENTICAL+CKEDITOR.POSITION_IS_CONTAINED)){O=new CKEDITOR.dom.range(D);O.setStartBefore(N);}if(Q==CKEDITOR.NODE_TEXT||Q==CKEDITOR.NODE_ELEMENT&&!N.getChildCount()){var T=N,U;while(!T.$.nextSibling&&(U=T.getParent(),I[U.getName()])&&(U.getPosition(L)|CKEDITOR.POSITION_FOLLOWING|CKEDITOR.POSITION_IDENTICAL|CKEDITOR.POSITION_IS_CONTAINED)==CKEDITOR.POSITION_FOLLOWING+CKEDITOR.POSITION_IDENTICAL+CKEDITOR.POSITION_IS_CONTAINED&&(!G.childRule||G.childRule(U)))T=U;O.setEndAfter(T);if(!T.$.nextSibling)P=true;}}else P=true;}else P=true;N=N.getNextSourceNode();}if(P&&O&&!O.collapsed){var V=r(Z,D),W=O.getCommonAncestor();while(V&&W){if(W.getName()==F){for(var X in G.attributes){if(V.getAttribute(X)==W.getAttribute(X))V.removeAttribute(X);}for(var Y in G.styles){if(V.getStyle(Y)==W.getStyle(Y))V.removeStyle(Y);
}if(!V.hasAttributes()){V=null;break;}}W=W.getParent();}if(V){O.extractContents().appendTo(V);o(Z,V);O.insertNode(V);V.mergeSiblings();if(!CKEDITOR.env.ie)V.$.normalize();}O=null;}}L.remove();M.remove();C.moveToBookmark(J);C.shrink(CKEDITOR.SHRINK_TEXT);};function e(C){C.enlarge(CKEDITOR.ENLARGE_ELEMENT);var D=C.createBookmark(),E=D.startNode;if(C.collapsed){var F=new CKEDITOR.dom.elementPath(E.getParent()),G;for(var H=0,I;H<F.elements.length&&(I=F.elements[H]);H++){if(I==F.block||I==F.blockLimit)break;if(this.checkElementRemovable(I)){var J=C.checkBoundaryOfElement(I,CKEDITOR.END),K=!J&&C.checkBoundaryOfElement(I,CKEDITOR.START);if(K||J){G=I;G.match=K?'start':'end';}else{I.mergeSiblings();n(this,I);}}}if(G){var L=E;for(H=0;true;H++){var M=F.elements[H];if(M.equals(G))break;else if(M.match)continue;else M=M.clone();M.append(L);L=M;}L[G.match=='start'?'insertBefore':'insertAfter'](G);}}else{var N=D.endNode,O=this;function P(){var S=new CKEDITOR.dom.elementPath(E.getParent()),T=new CKEDITOR.dom.elementPath(N.getParent()),U=null,V=null;for(var W=0;W<S.elements.length;W++){var X=S.elements[W];if(X==S.block||X==S.blockLimit)break;if(O.checkElementRemovable(X))U=X;}for(W=0;W<T.elements.length;W++){X=T.elements[W];if(X==T.block||X==T.blockLimit)break;if(O.checkElementRemovable(X))V=X;}if(V)N.breakParent(V);if(U)E.breakParent(U);};P();var Q=E.getNext();while(!Q.equals(N)){var R=Q.getNextSourceNode();if(Q.type==CKEDITOR.NODE_ELEMENT&&this.checkElementRemovable(Q)){if(Q.getName()==this.element)n(this,Q);else p(Q,w(this)[Q.getName()]);if(R.type==CKEDITOR.NODE_ELEMENT&&R.contains(E)){P();R=E.getNext();}}Q=R;}}C.moveToBookmark(D);};function f(C){var D=C.getCommonAncestor(true,true),E=D.getAscendant(this.element,true);E&&s(E,this);};function g(C){var D=C.createBookmark(true),E=C.createIterator();E.enforceRealBlocks=true;if(this._.enterMode)E.enlargeBr=this._.enterMode!=CKEDITOR.ENTER_BR;var F,G=C.document,H;while(F=E.getNextParagraph()){var I=r(this,G);h(F,I);}C.moveToBookmark(D);};function h(C,D){var E=D.is('pre'),F=C.is('pre'),G=E&&!F,H=!E&&F;if(G)D=m(C,D);else if(H)D=l(j(C),D);else C.moveChildren(D);D.replace(C);if(E)i(D);};function i(C){var D;if(!((D=C.getPreviousSourceNode(true,CKEDITOR.NODE_ELEMENT))&&D.is&&D.is('pre')))return;var E=k(D.getHtml(),/\n$/,'')+'\n\n'+k(C.getHtml(),/^\n/,'');if(CKEDITOR.env.ie)C.$.outerHTML='<pre>'+E+'</pre>';else C.setHtml(E);D.remove();};function j(C){var D=/(\S\s*)\n(?:\s|(<span[^>]+_fck_bookmark.*?\/span>))*\n(?!$)/gi,E=C.getName(),F=k(C.getOuterHtml(),D,function(H,I,J){return I+'</pre>'+J+'<pre>';
}),G=[];F.replace(/<pre\b.*?>([\s\S]*?)<\/pre>/gi,function(H,I){G.push(I);});return G;};function k(C,D,E){var F='',G='';C=C.replace(/(^<span[^>]+_fck_bookmark.*?\/span>)|(<span[^>]+_fck_bookmark.*?\/span>$)/gi,function(H,I,J){I&&(F=I);J&&(G=J);return '';});return F+C.replace(D,E)+G;};function l(C,D){var E=new CKEDITOR.dom.documentFragment(D.getDocument());for(var F=0;F<C.length;F++){var G=C[F];G=G.replace(/(\r\n|\r)/g,'\n');G=k(G,/^[ \t]*\n/,'');G=k(G,/\n$/,'');G=k(G,/^[ \t]+|[ \t]+$/g,function(I,J,K){if(I.length==1)return '&nbsp;';else if(!J)return CKEDITOR.tools.repeat('&nbsp;',I.length-1)+' ';else return ' '+CKEDITOR.tools.repeat('&nbsp;',I.length-1);});G=G.replace(/\n/g,'<br>');G=G.replace(/[ \t]{2,}/g,function(I){return CKEDITOR.tools.repeat('&nbsp;',I.length-1)+' ';});var H=D.clone();H.setHtml(G);E.append(H);}return E;};function m(C,D){var E=C.getHtml();E=k(E,/(?:^[ \t\n\r]+)|(?:[ \t\n\r]+$)/g,'');E=E.replace(/[ \t\r\n]*(<br[^>]*>)[ \t\r\n]*/gi,'$1');E=E.replace(/([ \t\n\r]+|&nbsp;)/g,' ');E=E.replace(/<br\b[^>]*>/gi,'\n');if(CKEDITOR.env.ie){var F=C.getDocument().createElement('div');F.append(D);D.$.outerHTML='<pre>'+E+'</pre>';D=F.getFirst().remove();}else D.setHtml(E);return D;};function n(C,D){var E=C._.definition,F=CKEDITOR.tools.extend({},E.attributes,w(C)[D.getName()]),G=E.styles,H=CKEDITOR.tools.isEmpty(F)&&CKEDITOR.tools.isEmpty(G);for(var I in F){if((I=='class'||C._.definition.fullMatch)&&D.getAttribute(I)!=x(I,F[I]))continue;H=D.hasAttribute(I);D.removeAttribute(I);}for(var J in G){if(C._.definition.fullMatch&&D.getStyle(J)!=x(J,G[J],true))continue;H=H||!!D.getStyle(J);D.removeStyle(J);}H&&q(D);};function o(C,D){var E=C._.definition,F=E.attributes,G=E.styles,H=w(C),I=D.getElementsByTag(C.element);for(var J=I.count();--J>=0;)n(C,I.getItem(J));for(var K in H){if(K!=C.element){I=D.getElementsByTag(K);for(J=I.count()-1;J>=0;J--){var L=I.getItem(J);p(L,H[K]);}}}};function p(C,D){var E=D&&D.attributes;if(E)for(var F=0;F<E.length;F++){var G=E[F][0],H;if(H=C.getAttribute(G)){var I=E[F][1];if(I===null||I.test&&I.test(H)||typeof I=='string'&&H==I)C.removeAttribute(G);}}q(C);};function q(C){if(!C.hasAttributes()){var D=C.getFirst(),E=C.getLast();C.remove(true);if(D){D.type==CKEDITOR.NODE_ELEMENT&&D.mergeSiblings();if(E&&!D.equals(E)&&E.type==CKEDITOR.NODE_ELEMENT)E.mergeSiblings();}}};function r(C,D){var E,F=C._.definition,G=C.element;if(G=='*')G='span';E=new CKEDITOR.dom.element(G,D);return s(E,C);};function s(C,D){var E=D._.definition,F=E.attributes,G=CKEDITOR.style.getStyleText(E);
if(F)for(var H in F)C.setAttribute(H,F[H]);if(G)C.setAttribute('style',G);return C;};var t=/#\((.+?)\)/g;function u(C,D){for(var E in C)C[E]=C[E].replace(t,function(F,G){return D[G];});};function v(C){var D=C._AC;if(D)return D;D={};var E=0,F=C.attributes;if(F)for(var G in F){E++;D[G]=F[G];}var H=CKEDITOR.style.getStyleText(C);if(H){if(!D.style)E++;D.style=H;}D._length=E;return C._AC=D;};function w(C){if(C._.overrides)return C._.overrides;var D=C._.overrides={},E=C._.definition.overrides;if(E){if(!CKEDITOR.tools.isArray(E))E=[E];for(var F=0;F<E.length;F++){var G=E[F],H,I,J;if(typeof G=='string')H=G.toLowerCase();else{H=G.element?G.element.toLowerCase():C.element;J=G.attributes;}I=D[H]||(D[H]={});if(J){var K=I.attributes=I.attributes||[];for(var L in J)K.push([L.toLowerCase(),J[L]]);}}}return D;};function x(C,D,E){var F=new CKEDITOR.dom.element('span');F[E?'setStyle':'setAttribute'](C,D);return F[E?'getStyle':'getAttribute'](C);};function y(C,D){var E;if(D!==false){var F=new CKEDITOR.dom.element('span');F.setAttribute('style',C);E=F.getAttribute('style')||'';}else E=C;return E.replace(/\s*([;:])\s*/,'$1').replace(/([^\s;])$/,'$1;').replace(/,\s+/g,',').toLowerCase();};function z(C){var D={};C.replace(/&quot;/g,'"').replace(/\s*([^ :;]+)\s*:\s*([^;]+)\s*(?=;|$)/g,function(E,F,G){D[F]=G;});return D;};function A(C,D){typeof C=='string'&&(C=z(C));typeof D=='string'&&(D=z(D));for(var E in C){if(!(E in D&&(D[E]==C[E]||C[E]=='inherit'||D[E]=='inherit')))return false;}return true;};function B(C,D){var E=C.getSelection(),F=E.getRanges(),G=D?this.removeFromRange:this.applyToRange;for(var H=0;H<F.length;H++)G.call(this,F[H]);E.selectRanges(F);};})();CKEDITOR.styleCommand=function(a){this.style=a;};CKEDITOR.styleCommand.prototype.exec=function(a){var c=this;a.focus();var b=a.document;if(b)if(c.state==CKEDITOR.TRISTATE_OFF)c.style.apply(b);else if(c.state==CKEDITOR.TRISTATE_ON)c.style.remove(b);return!!b;};CKEDITOR.stylesSet=new CKEDITOR.resourceManager('','stylesSet');CKEDITOR.addStylesSet=CKEDITOR.tools.bind(CKEDITOR.stylesSet.add,CKEDITOR.stylesSet);CKEDITOR.loadStylesSet=function(a,b,c){CKEDITOR.stylesSet.addExternal(a,b,'');CKEDITOR.stylesSet.load(a,c);};CKEDITOR.editor.prototype.getStylesSet=function(a){if(!this._.stylesDefinitions){var b=this,c=b.config.stylesCombo_stylesSet||b.config.stylesSet||'default';if(c instanceof Array){b._.stylesDefinitions=c;a(c);return;}var d=c.split(':'),e=d[0],f=d[1],g=CKEDITOR.plugins.registered.styles.path;CKEDITOR.stylesSet.addExternal(e,f?d.slice(1).join(':'):g+'styles/'+e+'.js','');
CKEDITOR.stylesSet.load(e,function(h){b._.stylesDefinitions=h[e];a(b._.stylesDefinitions);});}else a(this._.stylesDefinitions);};
