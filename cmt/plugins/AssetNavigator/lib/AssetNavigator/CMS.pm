package AssetNavigator::CMS;

use strict;
use MT;
use MT::Blog;
use MT::Folder;
use MT::Asset;
use MT::ObjectAsset;
use MT::Util;
use MT::FileMgr;
use Data::Dumper;#DEBUG

sub NAME { (split /::/, __PACKAGE__)[0]; }
sub instance { MT->component (&NAME); }



### Callbacks - template_*.edit_entry
sub _template_source_edit_entry {
    my ($cb, $app, $tmpl) = @_;

    ### Override related_content with Asset Navigator
    my $old = quotemeta (<<'HTMLHEREDOC');
<mt:setvarblock name="js_include" append="1">
HTMLHEREDOC
    my $new = &instance->translate_templatized (<<'HTMLHEREDOC');
<mt:ignore><!-- Asset Navigator --></mt:ignore>
<mt:setvarblock name="html_head" append="1">
  <style type="text/css">
    #main-content {
        margin-right: -300px !important;
    }
    .edit-entry #main-content-inner{
        margin-right: 315px !important;
    }
    #related-content {
        width: 300px !important;
        margin-top:-28px;
    }
    * html body #related-content{
    margin-top:-28px;
    }
    
    #asset_navi {
      width:100%; 
      height:430px; 
      border:none;
    }
    #asset-navi-widget{
    -moz-border-radius: 5px 5px 0px 0px !important;
    -webkit-border-radius: 5px 5px 0px 0px !important;
    -khtml-border-radius: 5px 5px 0px 0px !important;
    border-radius: 5px 5px 0px 0px !important;
    }
    #asset-navi-widget .widget-header {
        margin-bottom: 0px;
    }
    #asset-navi-widget .widget-content {
        margin: 0px;
        padding: 0px;
    }
    #editor-right .widget {
        margin-left:15px;
    }

    #asset-navi-header {
        color:#333;
        font-size: 12px;
        font-weight: bold;
        border-bottom: solid 1px #C8C2BE;
    }
    #asset-navi-header {
        font-size: 12px;
        text-shadow: 0 1px 0 #F8FBF8;
        font-weight: bold;
        border-bottom: solid 1px #C8C2BE;
    }
    #asset-navi-header a{
        color : #333;
        text-decoration:none;
        padding: 7px 10px 5px;
        display:block;
        background: url('<mt:var static_uri>plugins/AssetNavigator/images/asset-header-background.jpg') repeat-x left top;
    }
    #asset-navi-header a:hover{
        color:#777;
    }
    #asset-navi-selector {
        display: none;
        position: absolute;
        z-index: 100;
        width: 270px;
        top:  5px;
        left: 5px;
        background-color: #fff;
        border:1px solid #666;
        box-shadow:0px 0px 15px #888;
        -moz-box-shadow:0px 0px 15px #888;
        -webkit-box-shadow:0px 0px 15px #888;
        -moz-border-radius: 3px;
        -webkit-border-radius: 3px;
        -khtml-border-radius: 3px;
        border-radius: 3px;
        Filter: Alpha(Opacity=92);
        -moz-opacity:0.92;
        opacity:0.92;
    }
    
    #asset-navi-selector-inner {
        height:300px;
        overflow:auto;
        overflow-x:none;
    }
    #asset-navi-selector-inner a{
        text-decoration:none;
        color:#333;
    }
    #asset-navi-selector-inner a:hover{
        background:#f2f2f2;
        color:#666;
    }
    #asset-navi-selector-inner .parent{
        font-weight:bold;
        padding-left:3px;
        padding-bottom:2px;
    }
    
    #asset-navi-selector-inner{
        padding:5px 7px 5px 5px;
    }

    #asset-navi-selector-inner .border{
        border-top:1px solid #ccc;
        padding-top:7px;
    }

    #asset-navi-selector-inner ul li{
        margin-bottom:0px;
        line-height:1.2;
    }

    #asset-navi-selector-inner ul li a{
        display:block;
        padding:3px;
    }

    #asset-navi-selector-inner ul li.depth1{
        margin-left:15px;
    }
    #asset-navi-selector-inner ul li.depth2{
        margin-left:30px;
    }
    #asset-navi-loading {
        display: none;
        position: absolute;
        z-index: 100;
        width: 100%;
        height:430px;
        background-color: #fff;
        padding: 0px 0px;
        text-align: center;
        Filter: Alpha(Opacity=92);
        -moz-opacity:0.92;
        opacity:0.92;
    }
    #asset-navi-loading img{
        margin-top:150px;
    }
    .editor-header .tab a{
        color:#666;
        text-decoration:none;
        outline: 0 none;
    }
    div.tab-left{
        margin-left:15px !important;
    }
    * html body div.tab-left{
        margin-left:0px !impportant;
    }
    #editor-right .editor-header .selected-tab a{
        color:#333;
        text-decoration:none;
    }
    #editor-right .editor-header .selected-tab {
        background-color: #F3F3F3 !important;
        border-bottom: 1px solid #F3F3F3;
    }

    #editor-right .editor-header .tab {
        position: relative;
        width:60px;
        float:left;
        -moz-border-radius: 3px 3px 0 0;
        -webkit-border-radius: 3px 3px 0 0;
        -khtml-border-radius: 3px 3px 0 0;
        border-radius: 3px 3px 0 0;
        background-color: #FFFFFF;
        border: 1px solid #C8C2BE;
        display: block;
        font-size: 11px;
        font-weight: bold;
        margin: 4px 4px -1px 0;
        padding: 5px 10px 4px;
        text-align: center;
        text-transform: uppercase;
    }

    #editor-inner{
        clear:both;
        padding-top:15px;
        border-top:1px solid #ccc !important;
        border-left:1px solid #ccc;
        -moz-border-radius: 5px 0 0 0;
        -webkit-border-radius: 5px 0 0 0;
        -khtml-border-radius: 5px 0 0 0;
        border-radius: 5px 0 0 0;
    }

    * html #editor-inner{
        padding-top:0px !important;
        border:none !important;
    }

    div #main-content, div #editor-right {
        margin-top: 10px;
    }
  </style>
</mt:setvarblock>

<mt:ignore><!-- Asset Navigator --></mt:ignore>
<mt:setvarblock name="assets_navi">
<mtapp:widget
    id="asset-navi-widget"
    label="<__trans phrase="Assets">">
<div id="asset-navi-header">
    <a href="#" onclick="return showNaviSelector();"><span id="asset-navi-label">
  <mt:if id>
    <__trans phrase="Entry assets of this entry">
  <mt:else>
    <__trans phrase="Recent uploaded assets">
  </mt:if>
    </span>&nbsp;<img src="<mt:var static_uri>/images/selector-nav-spinner.gif" /></a>
</div>
<div style="position:relative;">
<div id="asset-navi-selector">
<div id="asset-navi-selector-inner">
<ul>
  <mt:if id>
    <li><a href="<mt:var script_uri>?__mode=asset_navi&amp;blog_id=<mt:var blog_id>&amp;id=<mt:var id>&amp;_type=<mt:var object_type>" onclick="return clickNavi(this, '<__trans phrase="Entry assets of this entry">');"><__trans phrase="Entry assets of this entry"></a></li>
  <mt:else>
    <li><a href="<mt:var script_uri>?__mode=asset_navi&amp;blog_id=<mt:var blog_id>&amp;id=<mt:var id>&amp;_type=<mt:var object_type>" onclick="return clickNavi(this, '<__trans phrase="Recent uploaded assets">');"><__trans phrase="Recent uploaded assets"></a></li>
  </mt:if>
</ul>
<mt:loop blog_loop>

  <ul class="border"><!--
    --><li class="parent"><mt:var name="name" escape="javascript"></li><!--
    --><li class="all-asset"><a href="<mt:var script_uri>?__mode=asset_navi&amp;blog_id=<mt:var blog_id>&amp;id=<mt:var id>&amp;_type=<mt:var object_type>&amp;folder=" onclick="return clickNavi(this, '<__Trans phrase="All assets">');"> - <__Trans phrase="All assets"></a></li><!--
<mt:loop folder_loop>
    --><li class="depth<mt:var depth>"><a href="<mt:var script_uri>?__mode=asset_navi&amp;blog_id=<mt:var blog_id>&amp;id=<mt:var id>&amp;_type=<mt:var object_type>&amp;folder=<mt:var value escape="html">" onclick="return clickNavi(this, '<mt:var name="label" escape="javascript">');"> - <mt:var name="label" escape="html"></a></li><!--
</mt:loop> --></ul>
</mt:loop>
</div></div>
<div id="asset-navi-loading"><img src="<mt:var static_uri>images/indicator.gif" /></div>
<iframe id="asset_navi" src="<mt:var script_uri>?__mode=asset_navi&amp;blog_id=<mt:var blog_id>&amp;id=<mt:var id>&amp;_type=<mt:var object_type>" frameborder="0"></iframe>
</div>
</mtapp:widget>
</mt:setvarblock>

<mt:ignore><!-- Override with Asset Navigator --></mt:ignore>
<mt:setvarblock name="related_content">
<div id="editor-right">
  <div id="editor-header" class="editor-header" mt:delegate="tab-container">
    <div class="tab selected-tab first-child tab-left" mt:command="select-tab" mt:tab="metadata">
      <label><a href="javascript:void(0);"><__trans phrase="Metadata"></a></label>
    </div>
    <div class="tab" mt:command="select-tab" mt:tab="assets_navi">
      <label><a href="javascript:void(0);"><__trans phrase="Assets"></a></label>
    </div>
<div id="editor-inner"><div class="editor-line">
    <div mt:tab-content="metadata"><mt:var related_content></div>
    <div mt:tab-content="assets_navi" class="hidden"><mt:var assets_navi></div>
	  <!-- .editor-header --></div>
    <!-- #editor-inner --></div></div>
  <!-- #editor --></div>
</mt:setvarblock>
HTMLHEREDOC
    $$tmpl =~ s/($old)/$new$1/;

    ###
    $old = quotemeta (<<'HTMLHEREDOC');
<mt:include name="include/header.tmpl" id="header_include">
HTMLHEREDOC
    $new = &instance->translate_templatized (<<'HTMLHEREDOC');
<!-- Drag and Drop helper by AssetNavigator for CKEditor -->
<script type="text/javascript">
/*** Navigator ***/
var selector_open = false;
function showNaviSelector (flag) {
    if (typeof flag == 'undefined')
        selector_open = !selector_open;
    else
        selector_open = flag;
    if (selector_open)
        jQuery('#asset-navi-selector').show();
    else
        jQuery('#asset-navi-selector').hide();
    return false;
}

/*** Update iframe ***/
function clickNavi (obj, label) {
    showNaviSelector (false);
    showNaviLoading (true);
    jQuery('#asset-navi-label').text (label);
    jQuery('#asset_navi').attr('src', obj.href);
    return false;
}

function showNaviLoading (flag) {
    if (flag)
        jQuery('#asset-navi-loading').show();
    else
        jQuery('#asset-navi-loading').hide();
    return false;
}

/*** Add the selected item to assets list ***/
function updateAssetList ($blog_id, $id, $url, $label, $class, $thumb_url) {
    // make sure the asset isn't there already and that we're in the edit entry page
    var Asset = jQuery('#list-asset-' + $id);
    if (Asset.length) return;

    // make sure asset list is present in an entry edit page
    var AssetList = jQuery('#asset-list');
    if (!AssetList.length) return;

    // Hide the message for empty
    var EmptyAssetList = jQuery('#empty-asset-list');
    if (EmptyAssetList.length)
        EmptyAssetList.hide();

    // add the assets id to the include_asset_ids hidden input
    var asset_ids = jQuery('#include_asset_ids').val();
    if (asset_ids.length)
        asset_ids += ',';
    jQuery('#include_asset_ids').val(asset_ids + $id);

    // Add item
    var html =
        '<li class="asset-type-' + $class + '" id="list-asset-' + $id + '">' +
            '<a class="asset-title" href="<mt:CGIPath><mt:AdminScript>?__mode=view&_type=asset&blog_id=' + $blog_id + '&id=' + $id + '">' + $label + '</a>' +
            '<a class="remove-asset" href="javascript:removeAssetFromList(' + $id + ')"></a>';
    if ($class == 'image')
        html += '<img id="list-image-' + $id + '" class="list-image hidden" src="' + $thumb_url + '" />';
    AssetList.append (html + '</li>');
}

/*** Check whether the contents changes in CKEditor ***/
function myCheckDirty () {
    if (CKEDITOR && CKEDITOR.instances) {
        var inst = CKEDITOR.instances['editor-content-textarea'];
        if (inst && inst.checkDirty()) {
            var data = inst.getData();
            var orig_data = data;
            if (data.match (/ mt:url=".+?" /)) {
                data = data.replace (/<img\s*[^>]*?\s*mt:url="img (\d+) (\d+) (\S+) (\S+)"\s*[^>]*?\/>/gi, function ($_, $blog_id, $id, $url, $label) {
                    updateAssetList ($blog_id, $id, $url, $label, 'image');
                    return '<img src="' + $url + '" alt="' + $label + '" />';
                });
                data = data.replace (/<img\s*[^>]*?\s*mt:url="obj (\d+) (\d+) (\S+) (\S+)"\s*[^>]*?\/>/gi, function ($_, $blog_id, $id, $url, $label) {
                    updateAssetList ($blog_id, $id, $url, $label, 'file');
                    return '<a href="' + $url + '">' + $label + '</a>';
                });
            }
            if (data != orig_data)
                inst.setData(data, function () { inst.resetDirty(); });
        }
    }
    setTimeout (myCheckDirty, 200);
}
myCheckDirty();

/*** Refresh asset navigation window ***/
function updateObjectAsset (asset_id) {
    window.parent.jQuery('#asset_navi').get(0).src = '<mt:var script_uri>?__mode=update_objectasset&amp;blog_id=<mt:var blog_id>&amp;id=<mt:var id>&amp;_type=<mt:var object_type>&amp;asset_id=' + asset_id;
}
</script>
HTMLHEREDOC
    $$tmpl =~ s/($old)/$1$new/;
}

sub _template_param_edit_entry {
    my ($cb, $app, $param) = @_;

    my $blog_id = $app->param('blog_id')
        or return;
    my $blog = MT::Blog->load ($blog_id)
        or return;

    my @folder_loop;
    foreach (_get_folders ($blog, 0)) {
        push @folder_loop, {
            depth => $_->{depth},
            label => $_->{obj}->label,
            value => $_->{obj}->publish_path,
            assets => $_->{assets},
        };
    }

    my @blog_loop;
    push @blog_loop, {
        name => $blog->name,
        folder_loop => \@folder_loop,
        assets => MT::Asset->count ({ class => '*', blog_id => $blog->id }),
    };
    $param->{blog_loop} = \@blog_loop;
}

my $depth = 0;
sub _get_folders {
    my ($blog, $pid) = @_;
    my @folders;
    for (MT::Folder->load ({ blog_id => $blog->id, parent => $pid })) {
        # #17891 below loop is very slow if lumgenumber of folders or asset.
        # However this result was not used, so it should be quite useless.
        push @folders, {
            obj => $_,
            depth => $depth,
        };
        $depth++; push @folders, _get_folders ($blog, $_->id); $depth--;
    }
    @folders;
}



### Method - asset_navi
my $items_per_page = 30;
sub _hdlr_asset_navi {
    my ($app) = @_;
    my $user = $app->user;
    my $blog_id = $app->param('blog_id');
    my $blog = MT::Blog->load ($blog_id);
    my $id = $app->param('id');
    my $_type = $app->param('_type');
    my $folder = $app->param('folder');
    my $page = $app->param('page') || 1;
    my %param;
    $param{blog_id} = $blog_id;
    $param{id} = $id;
    $param{_type} = $_type;
    $param{folder} = $folder;
    $param{is_folder} = defined $folder;

    my $perms = $user->permissions ($blog_id);
    $param{can_upload} = $perms->can_upload;

    ### Assets List
    my $assets_iter;
    if (defined $folder) {
        # Filter by folder
		my $conditions = {
			class => '*',
			blog_id => $blog_id,
			$folder ne ''
				? (file_path_path => $folder)
                : (),
         };
        $assets_iter = MT::Asset->load_iter (
			    $conditions, {
                sort => 'modified_on', direction => 'descend',
                offset => ($page - 1) * $items_per_page, limit => $items_per_page + 1,
            });
    }
    elsif ($id) {
        # Entry assets
        $assets_iter = MT::Asset->load_iter ({
                class => '*',
            }, {
                sort => 'modified_on', direction => 'descend',
                offset => ($page - 1) * $items_per_page, limit => $items_per_page + 1,
                join => [
                    'MT::ObjectAsset',
                    'asset_id',
                    { blog_id => $blog_id, object_ds => 'entry', object_id => $id }]
            });
    }
    else {
        # Recent uploaded assets
        $assets_iter = MT::Asset->load_iter ({
                class => '*',
                blog_id => $blog_id,
            }, {
                sort => 'modified_on', direction => 'descend',
                offset => ($page - 1) * $items_per_page, limit => $items_per_page + 1,
            });
    }

    my $thumbnail_size = int (&instance->get_config_value ('thumbnail_size'))
        || &instance->{DEFAULT_THUMBNAIL_SIZE};
    $thumbnail_size = &instance->{DEFAULT_THUMBNAIL_SIZE}
        if $thumbnail_size <= 0;

    my @object_loop;
    while (my $obj = $assets_iter->()) {
        my $row = {
            label => $obj->label || '',
            description => $obj->description || '',
            class => $obj->class,
            created_on => MT::Util::format_ts (undef, $obj->created_on, $app->blog, $user->preferred_language),
            thumbnail_size => $thumbnail_size,
        };
        map { $row->{$_} = $obj->$_; } qw( id url class_type class_label );

        my $file_path = $obj->file_path;
        my $fmgr = MT::FileMgr->new ('Local');
        if ( $file_path && $fmgr->exists( $file_path ) ) {
            $row->{file_path} = $file_path;
            $row->{file_name} = File::Basename::basename( $file_path );
            my $size = $fmgr->file_size( $file_path );
            $row->{file_size} = $size;
            $row->{file_size_formatted} = sprintf '%.1f MB', $size / 1024000;
            $row->{file_size_formatted} = sprintf '%.1f KB', $size / 1024 if $size < 1024000;
            $row->{file_size_formatted} = sprintf '%d Bytes', $size if $size < 1024;
        }
        else {
            $row->{file_is_missing} = 1 if $file_path;
        }

        # Filetype icon
        $row->{filetype} = {
            'doc' => 'doc', 'docx' => 'doc',
            'eps' => 'eps',
            'fla' => 'fla', 'swf' => 'fla',
            'gif' => 'gif',
            'jpg' => 'jpg', 'jpeg' => 'jpg',
            'mp3' => 'mp3',
            'mpeg' => 'mpeg', 'mpg' => 'mpeg',
            'pdf' => 'pdf',
            'png' => 'png',
            'ppt' => 'ppt', 'pptx' => 'ppt',
            'psd' => 'psd',
            'txt' => 'txt',
            'xls' => 'xls', 'xlsx' => 'xls',
            'zip' => 'zip', 'rar' => 'zip', 'lzh' => 'zip',
        }->{lc $obj->file_ext} || 'default';

        # Thumbnail image
        my $meta = $obj->metadata;
        if ($obj->has_thumbnail) {
            $row->{has_thumbnail} = 1;
            my $height = $thumbnail_size;
            my $width  = $thumbnail_size;
            my $square = $height == $thumbnail_size && $width == $thumbnail_size;
            @$meta{qw( thumbnail_url thumbnail_width thumbnail_height )}
              = $obj->thumbnail_url( Height => $height, Width => $width , Square => $square );
            $meta->{thumbnail_width_offset}  = int(($width  - $meta->{thumbnail_width})  / 2);
            $meta->{thumbnail_height_offset} = int(($height - $meta->{thumbnail_height}) / 2);
        }
        @$row{keys %$meta} = values %$meta;
        push @object_loop, $row;
    }

    # paging
    $param{page_current} = $page;
    $param{page_prev_link} = $page - 1 if 1 < $page;
    if (defined $object_loop[$items_per_page]) {
        $param{page_next_link} = $page + 1;
        pop @object_loop;
    }
    $param{object_loop} = \@object_loop if @object_loop;
    &instance->load_tmpl ('asset_navi.tmpl', \%param);
}




### Callback - template_source.asset_insert
sub _template_source_asset_insert {
    my ($cb, $app, $tmpl) = @_;

    my $old = quotemeta (<<'HTMLHEREDOC');
<script type="text/javascript">
/* <![CDATA[ */
HTMLHEREDOC
    my $new = <<'HTMLHEREDOC';
if (window && window.parent && window.parent.updateObjectAsset)
    window.parent.updateObjectAsset (<mt:assetid>);
HTMLHEREDOC
    $$tmpl =~ s/($old)/$1$new/;
}

### Method - update_objectasset
sub _hdlr_update_objectasset {
    my ($app) = @_;

    my $blog_id = $app->param ('blog_id');
    my $asset_id = $app->param ('asset_id');
    my $object_id = $app->param ('id');
    my $object_ds = $app->param ('_type');

    my $oa = MT::ObjectAsset->new;
    $oa->blog_id ($blog_id);
    $oa->asset_id ($asset_id);
    $oa->object_ds ('entry');
    $oa->object_id ($object_id);
    $oa->save;

    $app->redirect ($app->uri (
        mode => 'asset_navi',
        args => {
            blog_id => $blog_id,
            id => $object_id,
            _type => $object_ds,
        },
    ));
}

1;
