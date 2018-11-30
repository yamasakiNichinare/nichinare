/*
 * 'this' -> original element
 * 1. argument: browser event
 * 2.argument: ui object
 */
/**
 * Modified by ARK-Web Co.,Ltd.
 * Base Version : 
 * Copyright (c) ARK-Web Co.,Ltd.
 */

(function(aform$) {

	aform$.ui.plugin.add("draggable", "stop", "effect", function(e,ui) {
		var t = ui.helper;
		if(ui.options.effect[1]) {
			if(t != this) {
				ui.options.beQuietAtEnd = true;
				switch(ui.options.effect[1]) {
					case 'fade':
						aform$(t).fadeOut(300, function() { aform$(this).remove(); });
						break;
					default:
						aform$(t).remove();
						break;	
				}
			}
		}
	});
	
	aform$.ui.plugin.add("draggable", "start", "effect", function(e,ui) {
		if(ui.options.effect[0]) {
			switch(ui.options.effect[0]) {
				case 'fade':
					aform$(ui.helper).hide().fadeIn(300);
					break;
			}
		}
	});

//----------------------------------------------------------------

	aform$.ui.plugin.add("draggable", "start", "cursor", function(e,ui) {
		var t = aform$('body');
		if (t.css("cursor")) ui.options.ocursor = t.css("cursor");
		t.css("cursor", ui.options.cursor);
	});

	aform$.ui.plugin.add("draggable", "stop", "cursor", function(e,ui) {
		if (ui.options.ocursor) aform$('body').css("cursor", ui.options.ocursor);
	});

//----------------------------------------------------------------
	
	aform$.ui.plugin.add("draggable", "start", "zIndex", function(e,ui) {
		var t = aform$(ui.helper);
		if(t.css("zIndex")) ui.options.ozIndex = t.css("zIndex");
		t.css('zIndex', ui.options.zIndex);
	});
	
	aform$.ui.plugin.add("draggable", "stop", "zIndex", function(e,ui) {
		if(ui.options.ozIndex) aform$(ui.helper).css('zIndex', ui.options.ozIndex);
	});


//----------------------------------------------------------------

	aform$.ui.plugin.add("draggable", "start", "opacity", function(e,ui) {
		var t = aform$(ui.helper);
		if(t.css("opacity")) ui.options.oopacity = t.css("opacity");
		t.css('opacity', ui.options.opacity);
	});
	
	aform$.ui.plugin.add("draggable", "stop", "opacity", function(e,ui) {
		if(ui.options.oopacity) aform$(ui.helper).css('opacity', ui.options.oopacity);
	});

//----------------------------------------------------------------

	aform$.ui.plugin.add("draggable", "stop", "revert", function(e,ui) {
	
		var o = ui.options;
		var rpos = { left: 0, top: 0 };
		o.beQuietAtEnd = true;

		if(ui.helper != this) {

			rpos = aform$(ui.draggable.sorthelper || this).offset({ border: false });

			var nl = rpos.left-o.po.left-o.margins.left;
			var nt = rpos.top-o.po.top-o.margins.top;

		} else {
			var nl = o.co.left - (o.po ? o.po.left : 0);
			var nt = o.co.top - (o.po ? o.po.top : 0);
		}
		
		var self = ui.draggable;

		aform$(ui.helper).animate({
			left: nl,
			top: nt
		}, 500, function() {
			
			if(o.wasPositioned) aform$(self.element).css('position', o.wasPositioned);
			if(o.stop) o.stop.apply(self.element, [self.helper, self.pos, [o.co.left - o.po.left,o.co.top - o.po.top],self]);
			
			if(self.helper != self.element) window.setTimeout(function() { aform$(self.helper).remove(); }, 0); //Using setTimeout because of strange flickering in Firefox
			
		});
		
	});

//----------------------------------------------------------------

	aform$.ui.plugin.add("draggable", "start", "iframeFix", function(e,ui) {

		var o = ui.options;
		if(!ui.draggable.slowMode) { // Make clones on top of iframes (only if we are not in slowMode)
			if(o.iframeFix.constructor == Array) {
				for(var i=0;i<o.iframeFix.length;i++) {
					var co = aform$(o.iframeFix[i]).offset({ border: false });
					aform$("<div class='DragDropIframeFix' style='background: #fff;'></div>").css("width", aform$(o.iframeFix[i])[0].offsetWidth+"px").css("height", aform$(o.iframeFix[i])[0].offsetHeight+"px").css("position", "absolute").css("opacity", "0.001").css("z-index", "1000").css("top", co.top+"px").css("left", co.left+"px").appendTo("body");
				}		
			} else {
				aform$("iframe").each(function() {					
					var co = aform$(this).offset({ border: false });
					aform$("<div class='DragDropIframeFix' style='background: #fff;'></div>").css("width", this.offsetWidth+"px").css("height", this.offsetHeight+"px").css("position", "absolute").css("opacity", "0.001").css("z-index", "1000").css("top", co.top+"px").css("left", co.left+"px").appendTo("body");
				});							
			}		
		}

	});
	
	aform$.ui.plugin.add("draggable","stop", "iframeFix", function(e,ui) {
		if(ui.options.iframeFix) aform$("div.DragDropIframeFix").each(function() { this.parentNode.removeChild(this); }); //Remove frame helpers	
	});
		
//----------------------------------------------------------------

	aform$.ui.plugin.add("draggable", "start", "containment", function(e,ui) {

		var o = ui.options;

		if(!o.cursorAtIgnore || o.containment.left != undefined || o.containment.constructor == Array) return;
		if(o.containment == 'parent') o.containment = this.parentNode;


		if(o.containment == 'document') {
			o.containment = [
				0-o.margins.left,
				0-o.margins.top,
				aform$(document).width()-o.margins.right,
				(aform$(document).height() || document.body.parentNode.scrollHeight)-o.margins.bottom
			];
		} else { //I'm a node, so compute top/left/right/bottom
			var ce = aform$(o.containment)[0];
			var co = aform$(o.containment).offset({ border: false });

			o.containment = [
				co.left-o.margins.left,
				co.top-o.margins.top,
				co.left+(ce.offsetWidth || ce.scrollWidth)-o.margins.right,
				co.top+(ce.offsetHeight || ce.scrollHeight)-o.margins.bottom
			];
		}

	});
	
	aform$.ui.plugin.add("draggable", "drag", "containment", function(e,ui) {
		
		var o = ui.options;
		if(!o.cursorAtIgnore) return;
			
		var h = aform$(ui.helper);
		var c = o.containment;
		if(c.constructor == Array) {
			
			if((ui.draggable.pos[0] < c[0]-o.po.left)) ui.draggable.pos[0] = c[0]-o.po.left;
			if((ui.draggable.pos[1] < c[1]-o.po.top)) ui.draggable.pos[1] = c[1]-o.po.top;
			if(ui.draggable.pos[0]+h[0].offsetWidth > c[2]-o.po.left) ui.draggable.pos[0] = c[2]-o.po.left-h[0].offsetWidth;
			if(ui.draggable.pos[1]+h[0].offsetHeight > c[3]-o.po.top) ui.draggable.pos[1] = c[3]-o.po.top-h[0].offsetHeight;
			
		} else {

			if(c.left && (ui.draggable.pos[0] < c.left)) ui.draggable.pos[0] = c.left;
			if(c.top && (ui.draggable.pos[1] < c.top)) ui.draggable.pos[1] = c.top;

			var p = aform$(o.pp);
			if(c.right && ui.draggable.pos[0]+h[0].offsetWidth > p[0].offsetWidth-c.right) ui.draggable.pos[0] = (p[0].offsetWidth-c.right)-h[0].offsetWidth;
			if(c.bottom && ui.draggable.pos[1]+h[0].offsetHeight > p[0].offsetHeight-c.bottom) ui.draggable.pos[1] = (p[0].offsetHeight-c.bottom)-h[0].offsetHeight;
			
		}

		
	});

//----------------------------------------------------------------

	aform$.ui.plugin.add("draggable", "drag", "grid", function(e,ui) {
		var o = ui.options;
		if(!o.cursorAtIgnore) return;
		ui.draggable.pos[0] = o.co.left + o.margins.left - o.po.left + Math.round((ui.draggable.pos[0] - o.co.left - o.margins.left + o.po.left) / o.grid[0]) * o.grid[0];
		ui.draggable.pos[1] = o.co.top + o.margins.top - o.po.top + Math.round((ui.draggable.pos[1] - o.co.top - o.margins.top + o.po.top) / o.grid[1]) * o.grid[1];
	});

//----------------------------------------------------------------

	aform$.ui.plugin.add("draggable", "drag", "axis", function(e,ui) {
		var o = ui.options;
		if(!o.cursorAtIgnore) return;
		if(o.constraint) o.axis = o.constraint; //Legacy check
		o.axis ? ( o.axis == 'x' ? ui.draggable.pos[1] = o.co.top - o.margins.top - o.po.top : ui.draggable.pos[0] = o.co.left - o.margins.left - o.po.left ) : null;
	});

//----------------------------------------------------------------

	aform$.ui.plugin.add("draggable", "drag", "scroll", function(e,ui) {

		var o = ui.options;
		o.scrollSensitivity	= o.scrollSensitivity || 20;
		o.scrollSpeed		= o.scrollSpeed || 20;

		if(o.pp && o.ppOverflow) { // If we have a positioned parent, we only scroll in this one
			// TODO: Extremely strange issues are waiting here..handle with care
		} else {
			if((ui.draggable.rpos[1] - aform$(window).height()) - aform$(document).scrollTop() > -o.scrollSensitivity) window.scrollBy(0,o.scrollSpeed);
			if(ui.draggable.rpos[1] - aform$(document).scrollTop() < o.scrollSensitivity) window.scrollBy(0,-o.scrollSpeed);
			if((ui.draggable.rpos[0] - aform$(window).width()) - aform$(document).scrollLeft() > -o.scrollSensitivity) window.scrollBy(o.scrollSpeed,0);
			if(ui.draggable.rpos[0] - aform$(document).scrollLeft() < o.scrollSensitivity) window.scrollBy(-o.scrollSpeed,0);
		}

	});

//----------------------------------------------------------------

	aform$.ui.plugin.add("draggable", "drag", "wrapHelper", function(e,ui) {

		var o = ui.options;
		if(o.cursorAtIgnore) return;
		var t = ui.helper;

		if(!o.pp || !o.ppOverflow) {
			var wx = aform$(window).width() - (aform$.browser.mozilla ? 20 : 0);
			var sx = aform$(document).scrollLeft();
			
			var wy = aform$(window).height();
			var sy = aform$(document).scrollTop();	
		} else {
			var wx = o.pp.offsetWidth + o.po.left - 20;
			var sx = o.pp.scrollLeft;
			
			var wy = o.pp.offsetHeight + o.po.top - 20;
			var sy = o.pp.scrollTop;						
		}

		ui.draggable.pos[0] -= ((ui.draggable.rpos[0]-o.cursorAt.left - wx + t.offsetWidth+o.margins.right) - sx > 0 || (ui.draggable.rpos[0]-o.cursorAt.left+o.margins.left) - sx < 0) ? (t.offsetWidth+o.margins.left+o.margins.right - o.cursorAt.left * 2) : 0;
		
		ui.draggable.pos[1] -= ((ui.draggable.rpos[1]-o.cursorAt.top - wy + t.offsetHeight+o.margins.bottom) - sy > 0 || (ui.draggable.rpos[1]-o.cursorAt.top+o.margins.top) - sy < 0) ? (t.offsetHeight+o.margins.top+o.margins.bottom - o.cursorAt.top * 2) : 0;

	});

})(aform_jQuery);

