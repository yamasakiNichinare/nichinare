﻿CKEDITOR.plugins.add('domiterator');(function(){function a(d){var e=this;if(arguments.length<1)return;e.range=d;e.forceBrBreak=false;e.enlargeBr=true;e.enforceRealBlocks=false;e._||(e._={});};var b=/^[\r\n\t ]+$/,c=CKEDITOR.dom.walker.bookmark();a.prototype={getNextParagraph:function(d){var D=this;var e,f,g,h,i;if(!D._.lastNode){f=D.range.clone();f.enlarge(D.forceBrBreak||!D.enlargeBr?CKEDITOR.ENLARGE_LIST_ITEM_CONTENTS:CKEDITOR.ENLARGE_BLOCK_CONTENTS);var j=new CKEDITOR.dom.walker(f),k=CKEDITOR.dom.walker.bookmark(true,true);j.evaluator=k;D._.nextNode=j.next();j=new CKEDITOR.dom.walker(f);j.evaluator=k;var l=j.previous();D._.lastNode=l.getNextSourceNode(true);if(D._.lastNode&&D._.lastNode.type==CKEDITOR.NODE_TEXT&&!CKEDITOR.tools.trim(D._.lastNode.getText())&&D._.lastNode.getParent().isBlockBoundary()){var m=new CKEDITOR.dom.range(f.document);m.moveToPosition(D._.lastNode,CKEDITOR.POSITION_AFTER_END);if(m.checkEndOfBlock()){var n=new CKEDITOR.dom.elementPath(m.endContainer),o=n.block||n.blockLimit;D._.lastNode=o.getNextSourceNode(true);}}if(!D._.lastNode){D._.lastNode=D._.docEndMarker=f.document.createText('');D._.lastNode.insertAfter(l);}f=null;}var p=D._.nextNode;l=D._.lastNode;D._.nextNode=null;while(p){var q=false,r=p.type!=CKEDITOR.NODE_ELEMENT,s=false;if(!r){var t=p.getName();if(p.isBlockBoundary(D.forceBrBreak&&{br:1})){if(t=='br')r=true;else if(!f&&!p.getChildCount()&&t!='hr'){e=p;g=p.equals(l);break;}if(f){f.setEndAt(p,CKEDITOR.POSITION_BEFORE_START);if(t!='br')D._.nextNode=p;}q=true;}else{if(p.getFirst()){if(!f){f=new CKEDITOR.dom.range(D.range.document);f.setStartAt(p,CKEDITOR.POSITION_BEFORE_START);}p=p.getFirst();continue;}r=true;}}else if(p.type==CKEDITOR.NODE_TEXT)if(b.test(p.getText()))r=false;if(r&&!f){f=new CKEDITOR.dom.range(D.range.document);f.setStartAt(p,CKEDITOR.POSITION_BEFORE_START);}g=(!q||r)&&p.equals(l);if(f&&!q)while(!p.getNext()&&!g){var u=p.getParent();if(u.isBlockBoundary(D.forceBrBreak&&{br:1})){q=true;g=g||u.equals(l);break;}p=u;r=true;g=p.equals(l);s=true;}if(r)f.setEndAt(p,CKEDITOR.POSITION_AFTER_END);p=p.getNextSourceNode(s,null,l);g=!p;if((q||g)&&f){var v=f.getBoundaryNodes(),w=new CKEDITOR.dom.elementPath(f.startContainer);if(v.startNode.getParent().equals(w.blockLimit)&&c(v.startNode)&&c(v.endNode)){f=null;D._.nextNode=null;}else break;}if(g)break;}if(!e){if(!f){D._.docEndMarker&&D._.docEndMarker.remove();D._.nextNode=null;return null;}w=new CKEDITOR.dom.elementPath(f.startContainer);var x=w.blockLimit,y={div:1,th:1,td:1};
e=w.block;if(!e&&!D.enforceRealBlocks&&y[x.getName()]&&f.checkStartOfBlock()&&f.checkEndOfBlock())e=x;else if(!e||D.enforceRealBlocks&&e.getName()=='li'){e=D.range.document.createElement(d||'p');f.extractContents().appendTo(e);e.trim();f.insertNode(e);h=i=true;}else if(e.getName()!='li'){if(!f.checkStartOfBlock()||!f.checkEndOfBlock()){e=e.clone(false);f.extractContents().appendTo(e);e.trim();var z=f.splitBlock();h=!z.wasStartOfBlock;i=!z.wasEndOfBlock;f.insertNode(e);}}else if(!g)D._.nextNode=e.equals(l)?null:f.getBoundaryNodes().endNode.getNextSourceNode(true,null,l);}if(h){var A=e.getPrevious();if(A&&A.type==CKEDITOR.NODE_ELEMENT)if(A.getName()=='br')A.remove();else if(A.getLast()&&A.getLast().$.nodeName.toLowerCase()=='br')A.getLast().remove();}if(i){var B=CKEDITOR.dom.walker.bookmark(false,true),C=e.getLast();if(C&&C.type==CKEDITOR.NODE_ELEMENT&&C.getName()=='br')if(CKEDITOR.env.ie||C.getPrevious(B)||C.getNext(B))C.remove();}if(!D._.nextNode)D._.nextNode=g||e.equals(l)?null:e.getNextSourceNode(true,null,l);return e;}};CKEDITOR.dom.range.prototype.createIterator=function(){return new a(this);};})();
