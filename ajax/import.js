require('../ajax/jquery/jquery-1.3.2.min.js');
require('../ajax/jquery/jquery-ui.min.js');
require_css('../ajax/jquery/jquery-ui.css');
require('../ajax/jquery/jquery.tablednd_0_5.js');

function require(uri) {
  document.write('<script type="text/javascript" src="'+uri+'" charset="utf-8"></script>');
}

function require_css(uri) {
  document.write('<link rel="stylesheet" href="'+uri+'" type="text/css" />');
}
