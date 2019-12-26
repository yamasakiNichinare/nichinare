/**
 * @author Ryan Johnson <ryan@livepipe.net>
 * @copyright 2007 LivePipe LLC
 * @package Prototype.Tidbits
 * @license MIT
 * @url http://livepipe.net/projects/prototype_tidbits/
 * @version 1.7.0
 * 
 * Note that each tidbit is independent, and is meant to be copied and pasted as you see fit into your application rather than used as a whole.
 */

/**
 * Tidbit : getElementsByAttribute
 */

document.getElementsByAttribute = function(attribute,parent) {
	return $A(($(parent) || document.body).getElementsByTagName('*')).inject([],function(elements,child){
		if(Element.readAttribute(child,attribute))
			elements.push(Element.extend(child));
		return elements;
	});
}



document.getElementsByAttributeValue = function(attribute,value,parent) {
	return $A(($(parent) || document.body).getElementsByTagName('*')).inject([],function(elements,child){
		if(Element.readAttribute(child,attribute) == value)
			elements.push(Element.extend(child));
		return elements;
	});
}

Element.addMethods({
	getElementsByAttribute: function(element,attribute){
		return document.getElementsByAttribute(attribute,element);
	},
	getElementsByAttributeValue: function(element,attribute,value){
		return document.getElementsByAttributeValue(attribute,value,element);
	}
});

/**
 * Tidbit : makeUnselectable
 */

Element.addMethods({
	makeUnselectable: function(element,cursor){
		cursor = cursor || 'default';
		element.onselectstart = function() {
	        return false;
	    };
	    element.unselectable = "on";
	    element.style.MozUserSelect = "none";
	    element.style.cursor = cursor;
		return element;
	},
	makeSelectable: function(element){
		element.onselectstart = function() {
	        return true;
	    };
	    element.unselectable = "off";
	    element.style.MozUserSelect = "";
	    element.style.cursor = "inherit";
		return element;
	}
});

/**
 * Tidbit : Cookie
 */

var Cookie = {
	set: function(name,value,seconds){
		if(seconds){
			d = new Date();
			d.setTime(d.getTime() + (seconds * 1000));
			expiry = '; expires=' + d.toGMTString();
		}else
			expiry = '';
		document.cookie = name + "=" + value + expiry + "; path=/";
	},
	get: function(name){
		nameEQ = name + "=";
		ca = document.cookie.split(';');
		for(i = 0; i < ca.length; i++){
			c = ca[i];
			while(c.charAt(0) == ' ')
				c = c.substring(1,c.length);
			if(c.indexOf(nameEQ) == 0)
				return c.substring(nameEQ.length,c.length);
		}
		return null
	},
	unset: function(name){
		Cookie.set(name,'',-1);
	}
}

/**
 * Tidbit : Client
 */

var Client = {
	browser: false,
	OS: false,
	version: false,
	current_place: 0,
	current_string: '',
	detect: navigator.userAgent.toLowerCase(),
	load: function(){
		if(Client.check("konqueror")){
			Client.browser = "Konqueror";
			Client.OS = "Linux";
		}else{
			$H({
				safari: "Safari",
				omniweb: "OmniWeb",
				opera: "Opera",
				webtv: "WebTV",
				icab: "iCab",
				msie: "Internet Explorer"
			}).each(function(browser){
				if(!Client.browser && Client.check(browser[0]))
					Client.browser = browser[1];
			});
		}
		if(!Client.browser && !Client.check('compatible')){
			Client.browser = "Netscape Navigator"
			Client.version = Client.detect.charAt(8);
		}
		if(!Client.version)
			Client.version = Client.detect.charAt(Client.current_place + Client.current_string.length);
		if(!Client.OS){
			$H({
				linux: "Linux",
				x11: "Unix",
				mac: "Mac",
				win: "Windows"
			}).each(function(OS){
				if(!Client.OS && Client.check(OS[0]))
					Client.OS = OS[1];
			});
			if(!Client.OS)
				Client.OS = "unknown";
		}
	},
	check: function(string){
		Client.current_string = string;
		Client.current_place = Client.detect.indexOf(string) + 1;
		return Client.current_place;
	}	
};
Client.load();

/**
 * Tidbit : window.openCentered
 */

Object.extend(window,{	
	openedWindows: {},
	openCentered: function(location,name,params){
		this.openedWindows[name] = window.open(location,name,$H({
			width: 800,
			height: 600,
			left: (screen.width ? (screen.width - (params && params.width ? params.width : 800)) / 2 : 0),
			top: (screen.height ? (screen.height - (params && params.height ? params.height : 600)) / 4 : 0),
			dependent: true,
			directories: true,
			fullscreen: false,
			location: true,
			menubar: true,
			resizable: true,
			scrollbars: true,
			status: true,
			toolbar: true
		}).merge(params || {}).inject('',function(str,item){
			if(item[1] == true)
				value = 'yes';
			else if(item[1] == false)
				value = 'no';
			else
				value = item[1];
			return str + item[0] + '=' + value + ',';
		}).replace(/\,$/,''));
		this.openedWindows[name].focus();
		return this.openedWindows[name];
	}
});

/**
 * Tidbit: Builder.Inline
 */
if(typeof(Builder) != 'undefined'){
	Builder.Inline = {};
	$A(['div','span','table','tr','td','a','b','i','p','ul','ol','li','h1','h2','h3','h4','h5','h6','blockquote','pre','img']).each(function(tag){
		Builder.Inline[tag] = function(a,b,c){
			return Builder.node(a,b,c);
		}.bind(this,tag);
	});
}