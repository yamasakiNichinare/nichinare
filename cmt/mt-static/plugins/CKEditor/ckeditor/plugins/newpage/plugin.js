﻿CKEDITOR.plugins.add('newpage',{init:function(a){a.addCommand('newpage',{modes:{wysiwyg:1,source:1},exec:function(b){var c=this;b.setData(b.config.newpage_html,function(){setTimeout(function(){b.fire('afterCommandExec',{name:c.name,command:c});},200);});b.focus();},async:true});a.ui.addButton('NewPage',{label:a.lang.newPage,command:'newpage'});}});CKEDITOR.config.newpage_html='';
