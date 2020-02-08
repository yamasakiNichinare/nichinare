/**
 * Modified by ARK-Web Co.,Ltd.
 * Base Version : 
 * Copyright (c) ARK-Web Co.,Ltd.
 */
(function(aform$) {

	//Make nodes selectable by expression
	aform$.extend(aform$.expr[':'], { draggable: "(' '+a.className+' ').indexOf(' ui-draggable ')" });


	//Macros for external methods that support chaining
	var methods = "destroy,enable,disable".split(",");
	for(var i=0;i<methods.length;i++) {
		var cur = methods[i], f;
		eval('f = function() { var a = arguments; return this.each(function() { if(aform_jQuery(this).is(".ui-draggable")) aform_jQuery.data(this, "ui-draggable")["'+cur+'"](a); }); }');
		aform$.fn["draggable"+cur.substr(0,1).toUpperCase()+cur.substr(1)] = f;
	};
	
	//get instance method
	aform$.fn.draggableInstance = function() {
		if(aform$(this[0]).is(".ui-draggable")) return aform$.data(this[0], "ui-draggable");
		return false;
	};

	aform$.fn.draggable = function(o) {
		return this.each(function() {
			new aform$.ui.draggable(this, o);
		});
	}
	
	aform$.ui.ddmanager = {
		current: null,
		droppables: [],
		prepareOffsets: function(t, e) {
			var dropTop = aform$.ui.ddmanager.dropTop = [];
			var dropLeft = aform$.ui.ddmanager.dropLeft;
			var m = aform$.ui.ddmanager.droppables;
			for (var i = 0; i < m.length; i++) {
				if(m[i].item.disabled) continue;
				m[i].offset = aform$(m[i].item.element).offset();
				if (t && m[i].item.options.accept(t.element)) //Activate the droppable if used directly from draggables
					m[i].item.activate.call(m[i].item, e);
			}
		},
		fire: function(oDrag, e) {
			
			var oDrops = aform$.ui.ddmanager.droppables;
			var oOvers = aform$.grep(oDrops, function(oDrop) {
				
				if (!oDrop.item.disabled && aform$.ui.intersect(oDrag, oDrop, oDrop.item.options.tolerance))
					oDrop.item.drop.call(oDrop.item, e);
			});
			aform$.each(oDrops, function(i, oDrop) {
				if (!oDrop.item.disabled && oDrop.item.options.accept(oDrag.element)) {
					oDrop.out = 1; oDrop.over = 0;
					oDrop.item.deactivate.call(oDrop.item, e);
				}
			});
		},
		update: function(oDrag, e) {
			
			if(oDrag.options.refreshPositions) aform$.ui.ddmanager.prepareOffsets();
			
			var oDrops = aform$.ui.ddmanager.droppables;
			var oOvers = aform$.grep(oDrops, function(oDrop) {
				if(oDrop.item.disabled) return false; 
				var isOver = aform$.ui.intersect(oDrag, oDrop, oDrop.item.options.tolerance)
				if (!isOver && oDrop.over == 1) {
					oDrop.out = 1; oDrop.over = 0;
					oDrop.item.out.call(oDrop.item, e);
				}
				return isOver;
			});
			aform$.each(oOvers, function(i, oOver) {
				if (oOver.over == 0) {
					oOver.out = 0; oOver.over = 1;
					oOver.item.over.call(oOver.item, e);
				}
			});
		}
	};
	
	aform$.ui.draggable = function(el, o) {
		
		var options = {};
		aform$.extend(options, o);
		var self = this;
		aform$.extend(options, {
			_start: function(h, p, c, t, e) {
				self.start.apply(t, [self, e]); // Trigger the start callback				
			},
			_beforeStop: function(h, p, c, t, e) {
				self.stop.apply(t, [self, e]); // Trigger the start callback
			},
			_drag: function(h, p, c, t, e) {
				self.drag.apply(t, [self, e]); // Trigger the start callback
			},
			startCondition: function(e) {
				return !(e.target.className.indexOf("ui-resizable-handle") != -1 || self.disabled);	
			}			
		});
		
		aform$.data(el, "ui-draggable", this);
		
		if (options.ghosting == true) options.helper = 'clone'; //legacy option check
		aform$(el).addClass("ui-draggable");
		this.interaction = new aform$.ui.mouseInteraction(el, options);
		
	}
	
	aform$.extend(aform$.ui.draggable.prototype, {
		plugins: {},
		currentTarget: null,
		lastTarget: null,
		destroy: function() {
			aform$(this.interaction.element).removeClass("ui-draggable").removeClass("ui-draggable-disabled");
			this.interaction.destroy();
		},
		enable: function() {
			aform$(this.interaction.element).removeClass("ui-draggable-disabled");
			this.disabled = false;
		},
		disable: function() {
			aform$(this.interaction.element).addClass("ui-draggable-disabled");
			this.disabled = true;
		},
		prepareCallbackObj: function(self) {
			return {
				helper: self.helper,
				position: { left: self.pos[0], top: self.pos[1] },
				offset: self.options.cursorAt,
				draggable: self,
				options: self.options	
			}			
		},
		start: function(that, e) {
			
			var o = this.options;
			aform$.ui.ddmanager.current = this;
			
			aform$.ui.plugin.call(that, 'start', [e, that.prepareCallbackObj(this)]);
			aform$(this.element).triggerHandler("dragstart", [e, that.prepareCallbackObj(this)], o.start);
			
			if (this.slowMode && aform$.ui.droppable && !o.dropBehaviour)
				aform$.ui.ddmanager.prepareOffsets(this, e);
			
			return false;
						
		},
		stop: function(that, e) {			
			
			var o = this.options;
			
			aform$.ui.plugin.call(that, 'stop', [e, that.prepareCallbackObj(this)]);
			aform$(this.element).triggerHandler("dragstop", [e, that.prepareCallbackObj(this)], o.stop);

			if (this.slowMode && aform$.ui.droppable && !o.dropBehaviour) //If cursorAt is within the helper, we must use our drop manager
				aform$.ui.ddmanager.fire(this, e);

			aform$.ui.ddmanager.current = null;
			aform$.ui.ddmanager.last = this;

			return false;
			
		},
		drag: function(that, e) {

			var o = this.options;

			aform$.ui.ddmanager.update(this, e);

			this.pos = [this.pos[0]-o.cursorAt.left, this.pos[1]-o.cursorAt.top];

			aform$.ui.plugin.call(that, 'drag', [e, that.prepareCallbackObj(this)]);
			var nv = aform$(this.element).triggerHandler("drag", [e, that.prepareCallbackObj(this)], o.drag);

			var nl = (nv && nv.left) ? nv.left : this.pos[0];
			var nt = (nv && nv.top) ? nv.top : this.pos[1];
			
			aform$(this.helper).css('left', nl+'px').css('top', nt+'px'); // Stick the helper to the cursor
			return false;
			
		}
	});

})(aform$);
