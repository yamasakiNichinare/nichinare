/* Copyright (c) 2007 Paul Bakaus (paul.bakaus@googlemail.com) and Brandon Aaron (brandon.aaron@gmail.com || http://brandonaaron.net)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 * $LastChangedDate: 2007-09-11 02:38:31 +0000 (Tue, 11 Sep 2007) $
 * $Rev: 3238 $
 *
 * Version: @VERSION
 *
 * Requires: aform_jQuery 1.2+
 */
/**
 * Modified by ARK-Web Co.,Ltd.
 * Base Version : @VERSION
 * Copyright (c) ARK-Web Co.,Ltd.
 */

(function(aform$){
	
aform$.dimensions = {
	version: '@VERSION'
};

// Create innerHeight, innerWidth, outerHeight and outerWidth methods
aform$.each( [ 'Height', 'Width' ], function(i, name){
	
	// innerHeight and innerWidth
	aform$.fn[ 'inner' + name ] = function() {
		if (!this[0]) return;
		
		var torl = name == 'Height' ? 'Top'    : 'Left',  // top or left
		    borr = name == 'Height' ? 'Bottom' : 'Right'; // bottom or right
		
		return this[ name.toLowerCase() ]() + num(this, 'padding' + torl) + num(this, 'padding' + borr);
	};
	
	// outerHeight and outerWidth
	aform$.fn[ 'outer' + name ] = function(options) {
		if (!this[0]) return;
		
		var torl = name == 'Height' ? 'Top'    : 'Left',  // top or left
		    borr = name == 'Height' ? 'Bottom' : 'Right'; // bottom or right
		
		options = aform$.extend({ margin: false }, options || {});
		
		return this[ name.toLowerCase() ]()
				+ num(this, 'border' + torl + 'Width') + num(this, 'border' + borr + 'Width')
				+ num(this, 'padding' + torl) + num(this, 'padding' + borr)
				+ (options.margin ? (num(this, 'margin' + torl) + num(this, 'margin' + borr)) : 0);
	};
});

// Create scrollLeft and scrollTop methods
aform$.each( ['Left', 'Top'], function(i, name) {
	aform$.fn[ 'scroll' + name ] = function(val) {
		if (!this[0]) return;
		
		return val != undefined ?
		
			// Set the scroll offset
			this.each(function() {
				this == window || this == document ?
					window.scrollTo( 
						name == 'Left' ? val : aform$(window)[ 'scrollLeft' ](),
						name == 'Top'  ? val : aform$(window)[ 'scrollTop'  ]()
					) :
					this[ 'scroll' + name ] = val;
			}) :
			
			// Return the scroll offset
			this[0] == window || this[0] == document ?
				self[ (name == 'Left' ? 'pageXOffset' : 'pageYOffset') ] ||
					aform$.boxModel && document.documentElement[ 'scroll' + name ] ||
					document.body[ 'scroll' + name ] :
				this[0][ 'scroll' + name ];
	};
});

aform$.fn.extend({
	position: function() {
		var left = 0, top = 0, elem = this[0], offset, parentOffset, offsetParent, results;
		
		if (elem) {
			// Get *real* offsetParent
			offsetParent = this.offsetParent();
			
			// Get correct offsets
			offset       = this.offset();
			parentOffset = offsetParent.offset();
			
			// Subtract element margins
			offset.top  -= num(elem, 'marginTop');
			offset.left -= num(elem, 'marginLeft');
			
			// Add offsetParent borders
			parentOffset.top  += num(offsetParent, 'borderTopWidth');
			parentOffset.left += num(offsetParent, 'borderLeftWidth');
			
			// Subtract the two offsets
			results = {
				top:  offset.top  - parentOffset.top,
				left: offset.left - parentOffset.left
			};
		}
		
		return results;
	},
	
	offsetParent: function() {
		var offsetParent = this[0].offsetParent;
		while ( offsetParent && (!/^body|htmlaform$/i.test(offsetParent.tagName) && aform$.css(offsetParent, 'position') == 'static') )
			offsetParent = offsetParent.offsetParent;
		return aform$(offsetParent);
	}
});

var num = function(el, prop) {
	return parseInt(aform$.css(el.jquery?el[0]:el,prop))||0;
};

})(aform_jQuery);
