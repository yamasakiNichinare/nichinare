j$(function(){
    // setViewport
    // setViewport
    spView = 'width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1';
    tbView = 'width=1000px,maximum-scale=2.0,user-scalable=1';
 
    if(navigator.userAgent.indexOf('iPhone') > 0 || navigator.userAgent.indexOf('iPod') > 0 || (navigator.userAgent.indexOf('Android') > 0 && navigator.userAgent.indexOf('Mobile') > 0)){

    		var metalist = document.getElementsByTagName('meta');

			for(var i = 0; i < metalist.length; i++) {
    		var name = metalist[i].getAttribute('name');

    		if(name && name.toLowerCase() === 'viewport') {
        	metalist[i].setAttribute('content', spView );
        	break;
    }
}

 
    } else if(navigator.userAgent.indexOf('iPad') > 0 || (navigator.userAgent.indexOf('Android') > 0 && navigator.userAgent.indexOf('Mobile') == -1) || navigator.userAgent.indexOf('A1_07') > 0 || navigator.userAgent.indexOf('SC-01C') > 0){
    		var metalist = document.getElementsByTagName('meta');

			for(var i = 0; i < metalist.length; i++) {
    		var name = metalist[i].getAttribute('name');

    		if(name && name.toLowerCase() === 'viewport') {
        	metalist[i].setAttribute('content', tbView );
        	break;
    }
}

    } 
 
});