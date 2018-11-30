/*
 * aform_jQuery Tooltip plugin 1.1
 *
 * http://bassistance.de/jquery-plugins/jquery-plugin-tooltip/
 *
 * Copyright (c) 2006 Jörn Zaefferer, Stefan Petre
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Revision: aform$Id: jquery.tooltip.js 2237 2007-07-04 19:11:15Z joern.zaefferer aform$
 *
 */

/**
 * Display a customized tooltip instead of the default one
 * for every selected element. The tooltip behaviour mimics
 * the default one, but lets you style the tooltip and
 * specify the delay before displaying it. In addition, it displays the
 * href value, if it is available.
 *
 * Requires dimensions plugin. 
 *
 * When used on a page with select elements, include the bgiframe plugin. It is used if present.
 *
 * To style the tooltip, use these selectors in your stylesheet:
 *
 * #tooltip - The tooltip container
 *
 * #tooltip h3 - The tooltip title
 *
 * #tooltip div.body - The tooltip body, shown when using showBody
 *
 * #tooltip div.url - The tooltip url, shown when using showURL
 *
 *
 * @example aform$('a, input, img').Tooltip();
 * @desc Shows tooltips for anchors, inputs and images, if they have a title
 *
 * @example aform$('label').Tooltip({
 *   delay: 0,
 *   track: true,
 *   event: "click"
 * });
 * @desc Shows tooltips for labels with no delay, tracking mousemovement, displaying the tooltip when the label is clicked.
 *
 * @example // modify global settings
 * aform$.extend(aform$.fn.Tooltip.defaults, {
 * 	track: true,
 * 	delay: 0,
 * 	showURL: false,
 * 	showBody: " - ",
 *  fixPNG: true
 * });
 * // setup fancy tooltips
 * aform$('a.pretty').Tooltip({
 * 	 extraClass: "fancy"
 * });
 aform$('img.pretty').Tooltip({
 * 	 extraClass: "fancy-img",
 * });
 * @desc This example starts with modifying the global settings, applying them to all following Tooltips; Afterwards, Tooltips for anchors with class pretty are created with an extra class for the Tooltip: "fancy" for anchors, "fancy-img" for images
 *
 * @param Object settings (optional) Customize your Tooltips
 * @option Number delay The number of milliseconds before a tooltip is display. Default: 250
 * @option Boolean track If true, let the tooltip track the mousemovement. Default: false
 * @option Boolean showURL If true, shows the href or src attribute within p.url. Defaul: true
 * @option String showBody If specified, uses the String to split the title, displaying the first part in the h3 tag, all following in the p.body tag, separated with <br/>s. Default: null
 * @option String extraClass If specified, adds the class to the tooltip helper. Default: null
 * @option Boolean fixPNG If true, fixes transparent PNGs in IE. Default: false
 * @option Function bodyHandler If specified its called to format the tooltip-body, hiding the title-part. Default: none
 * @option Number top The top-offset for the tooltip position. Default: 15
 * @option Number left The left-offset for the tooltip position. Default: 15
 *
 * @name Tooltip
 * @type aform_jQuery
 * @cat Plugins/Tooltip
 * @author Jörn Zaefferer (http://bassistance.de)
 */
 
/**
 * A global flag to disable all tooltips.
 *
 * @example aform$("button.openModal").click(function() {
 *   aform$.Tooltip.blocked = true;
 *   // do some other stuff, eg. showing a modal dialog
 *   aform$.Tooltip.blocked = false;
 * });
 * 
 * @property
 * @name aform$.Tooltip.blocked
 * @type Boolean
 * @cat Plugins/Tooltip
 */
 
/**
 * Global defaults for tooltips. Apply to all calls to the Tooltip plugin after modifying  the defaults.
 *
 * @example aform$.extend(aform$.Tooltip.defaults, {
 *   track: true,
 *   delay: 0
 * });
 * 
 * @property
 * @name aform$.Tooltip.defaults
 * @type Map
 * @cat Plugins/Tooltip
 */
/**
 * Modified by ARK-Web Co.,Ltd.
 * Base Version : 1.1
 * Copyright (c) ARK-Web Co.,Ltd.
 */
(function(aform$) {
	
	// the tooltip element
	var helper = {},
		// the current tooltipped element
		current,
		// the title of the current element, used for restoring
		title,
		// timeout id for delayed tooltips
		tID,
		// IE 5.5 or 6
		IE = aform$.browser.msie && /MSIE\s(5\.5|6\.)/.test(navigator.userAgent),
		// flag for mouse tracking
		track = false;
	
	aform$.Tooltip = {
		blocked: false,
		defaults: {
			delay: 200,
			showURL: true,
			extraClass: "",
			top: 15,
			left: 15
		},
		block: function() {
			aform$.Tooltip.blocked = !aform$.Tooltip.blocked;
		}
	};
	
	aform$.fn.extend({
		Tooltip: function(settings) {
			settings = aform$.extend({}, aform$.Tooltip.defaults, settings);
			createHelper();
			return this.each(function() {
					this.tSettings = settings;
					// copy tooltip into its own expando and remove the title
					this.tooltipText = this.title;
					aform$(this).removeAttr("title");
					// also remove alt attribute to prevent default tooltip in IE
					this.alt = "";
				})
				.hover(save, hide)
				.click(hide);
		},
		fixPNG: IE ? function() {
			return this.each(function () {
				var image = aform$(this).css('backgroundImage');
				if (image.match(/^url\(["']?(.*\.png)["']?\)aform$/i)) {
					image = RegExp.aform$1;
					aform$(this).css({
						'backgroundImage': 'none',
						'filter': "progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, sizingMethod=crop, src='" + image + "')"
					}).each(function () {
						var position = aform$(this).css('position');
						if (position != 'absolute' && position != 'relative')
							aform$(this).css('position', 'relative');
					});
				}
			});
		} : function() { return this; },
		unfixPNG: IE ? function() {
			return this.each(function () {
				aform$(this).css({'filter': '', backgroundImage: ''});
			});
		} : function() { return this; },
		hideWhenEmpty: function() {
			return this.each(function() {
				aform$(this)[ aform$(this).html() ? "show" : "hide" ]();
			});
		},
		url: function() {
			return this.attr('href') || this.attr('src');
		}
	});
	
	function createHelper() {
		// there can be only one tooltip helper
		if( helper.parent )
			return;
		// create the helper, h3 for title, div for url
		helper.parent = aform$('<div id="tooltip"><h3></h3><div class="body"></div><div class="url"></div></div>')
			// hide it at first
			.hide()
			// add to document
			.appendTo('body');
			
		// apply bgiframe if available
		if ( aform$.fn.bgiframe )
			helper.parent.bgiframe();
		
		// save references to title and url elements
		helper.title = aform$('h3', helper.parent);
		helper.body = aform$('div.body', helper.parent);
		helper.url = aform$('div.url', helper.parent);
	}
	
	// main event handler to start showing tooltips
	function handle(event) {
		// show helper, either with timeout or on instant
		if( this.tSettings.delay )
			tID = setTimeout(show, this.tSettings.delay);
		else
			show();
		
		// if selected, update the helper position when the mouse moves
		track = !!this.tSettings.track;
		aform$('body').bind('mousemove', update);
			
		// update at least once
		update(event);
	}
	
	// save elements title before the tooltip is displayed
	function save() {
		// if this is the current source, or it has no title (occurs with click event), stop
		if ( aform$.Tooltip.blocked || this == current || !this.tooltipText )
			return;

		// save current
		current = this;
		title = this.tooltipText;
		
		if ( this.tSettings.bodyHandler ) {
			helper.title.hide();
			helper.body.html( this.tSettings.bodyHandler.call(this) ).show();
		} else if ( this.tSettings.showBody ) {
			var parts = title.split(this.tSettings.showBody);
			helper.title.html(parts.shift()).show();
			helper.body.empty();
			for(var i = 0, part; part = parts[i]; i++) {
				if(i > 0)
					helper.body.append("<br/>");
				helper.body.append(part);
			}
			helper.body.hideWhenEmpty();
		} else {
			helper.title.html(title).show();
			helper.body.hide();
		}
		
		// if element has href or src, add and show it, otherwise hide it
		if( this.tSettings.showURL && aform$(this).url() )
			helper.url.html( aform$(this).url().replace('http://', '') ).show();
		else 
			helper.url.hide();
		
		// add an optional class for this tip
		helper.parent.addClass(this.tSettings.extraClass);

		// fix PNG background for IE
		if (this.tSettings.fixPNG )
			helper.parent.fixPNG();
			
		handle.apply(this, arguments);
	}
	
	// delete timeout and show helper
	function show() {
		tID = null;
		helper.parent.show();
		update();
	}
	
	/**
	 * callback for mousemove
	 * updates the helper position
	 * removes itself when no current element
	 */
	function update(event)	{
		if(aform$.Tooltip.blocked)
			return;
		
		// stop updating when tracking is disabled and the tooltip is visible
		if ( !track && helper.parent.is(":visible")) {
			aform$('body').unbind('mousemove', update)
		}
		
		// if no current element is available, remove this listener
		if( current == null ) {
			aform$('body').unbind('mousemove', update);
			return;	
		}
		var left = helper.parent[0].offsetLeft;
		var top = helper.parent[0].offsetTop;
		if(event) {
			// position the helper 15 pixel to bottom right, starting from mouse position
			left = event.pageX + current.tSettings.left;
			top = event.pageY + current.tSettings.top;
			helper.parent.css({
				left: left + 'px',
				top: top + 'px'
			});
		}
		var v = viewport(),
			h = helper.parent[0];
		// check horizontal position
		if(v.x + v.cx < h.offsetLeft + h.offsetWidth) {
			left -= h.offsetWidth + 20 + current.tSettings.left;
			helper.parent.css({left: left + 'px'});
		}
		// check vertical position
		if(v.y + v.cy < h.offsetTop + h.offsetHeight) {
			top -= h.offsetHeight + 20 + current.tSettings.top;
			helper.parent.css({top: top + 'px'});
		}
	}
	
	function viewport() {
		return {
			x: aform$(window).scrollLeft(),
			y: aform$(window).scrollTop(),
			cx: aform$(window).width(),
			cy: aform$(window).height()
		};
	}
	
	// hide helper and restore added classes and the title
	function hide(event) {
		if(aform$.Tooltip.blocked)
			return;
		// clear timeout if possible
		if(tID)
			clearTimeout(tID);
		// no more current element
		current = null;
		
		helper.parent.hide().removeClass( this.tSettings.extraClass );
		
		if( this.tSettings.fixPNG )
			helper.parent.unfixPNG();
	}
	
})(aform_jQuery);
