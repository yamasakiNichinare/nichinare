package MultiFileUploader::CMS;

use strict;
use warnings;
use MT 4;
use base qw( MT::App );

use MT::Blog;
use MT::Entry;
use MT::Asset;
use MT::Tag;
use MT::ObjectTag;
use MT::ObjectAsset;
use MT::Placement;
use MT::CMS::Asset;
use MT::I18N;
use Encode;
use File::Basename;

#use Data::Dumper;

###
sub file_upload {
    my $app = shift;
    
    return $app->error( $app->translate('Invalid request.') )
        unless $app && $app->isa('MT::App::CMS');
    my $author = $app->user
        or return $app->error( $app->translate('Permission denied.') );

    my $plugin  = MT->component('MultiFileUploader')
        or return $app->error( $app->translate('Failed to get component. MultiFileUploader-Plugin') );

    my $blog_id = $app->param('blog_id') || '';
    my $perms = '';

	# if there is no blog ID, return to dashboard.
    unless ( $blog_id )
    {
        my $user_dashboard = 1;
        $user_dashboard = 0 if $author->is_superuser;
        if ( $user_dashboard )
        {
            $perms = MT::Permission->load({author_id => $author->id , blog_id => 0 }) || '';
            $user_dashboard = 0 if $perms;
        }
        ## to user dashboard
        return $app->return_to_user_dashboard()
            if $user_dashboard;

        ## to sysntem dashboard
        return $app->return_to_dashboard();
    }

	# permission check.
    unless ( $author->is_superuser ) {
        unless ( $author->permissions($blog_id)->can_upload ) {
            return $app->error( $app->translate('Permission denied.') ); 
        } 
    }

	# set parameters for rendering template.
    my %up_params = map { $_ => $app->param($_); } $app->{query}->param;
    my $param = MT::CMS::Asset::_set_start_upload_params($app, \%up_params);
    $param->{blog_id} = $blog_id;
    $param->{dialog} = $app->param('dialog');
    $param->{saved} = $app->param('saved');
    $param->{entry_id} = $app->param('entry_id');

    # When any authentications enabled, SWF uploader doesn't appear #16537
    $param->{disable_swf} = defined $ENV{AUTH_TYPE} && $ENV{AUTH_TYPE} ne '';

	# set paramaters for limitation of image size
	my $settings = MT::Plugin::SKR::MultiFileUploader::_current_settings($plugin, "blog:$blog_id", $blog_id);

#	MT->log(' $settings : ' . Dumper($settings));
	# Merge image size limitation parameters.
	$param = {
		%$param,
		%$settings,
	};

	# dispatch limitation mode.
	my $limit_mode = MT::Plugin::SKR::MultiFileUploader::_limitation_mode($plugin, $blog_id);

	if ($limit_mode eq '1') {
		# setting is 'None', so we don't care.
	} elsif ($limit_mode eq '2') {
		# limit size is 'as init value'
		$param->{mfu_limit_as_init_value} = 1;
		$param->{mfu_use_limit_value} = 1;
	} elsif ($limit_mode eq '3') {
		# limit size is 'as fixed value'
		$param->{mfu_limit_as_fixed_value} = 1;
		$param->{mfu_use_limit_value} = 1;
	} else {
		# not expected mode.
        return $app->error( $app->translate('Not expected size limitation mode : [_1]', $limit_mode));
	}

#	MT->log(' param : '. Dumper($param));

    my $tmpl = $plugin->load_tmpl('file_upload.tmpl');
    return $app->build_page ($tmpl, $param);
}

###
sub file_save {
    my $app = shift;

    my $plugin  = MT->component('MultiFileUploader')
        or return $app->error( $app->translate('Failed to get component. MultiFileUploader-Plugin') );

	# input validation.
	# 'size' parameter must be numerical
	my $size = $app->param('size');
	if (defined($size) && ($size ne '')) {
		if ($size !~ m/^\d+$/o) {
			my $msg = $plugin->translate('Image size must be numerical.');
			return $app->param('__ajax')
				? qq{<script type="text/javascript">parent.startUploadJS("$msg");</script>}
				: $msg;
		}
	}

    # For SWFUploader
    $app->param ('file', $app->param ('Filedata')) if $app->param ('Filedata'); # Hack

    # Check filename
    my $filename = ''. scalar $app->param('file');
    $filename =~ s!.+[\\\/]+!! if $filename =~ m![\\\/]!;
    if ($filename =~ /[^A-Za-z0-9\-\_\(\)\[\]\.]/) {
        my $msg = $plugin->translate ('Invalid filename. please rename with alpha-numeric characters only.');
        return $app->param('__ajax')
            ? qq{<script type="text/javascript">parent.startUploadJS("$msg");</script>}
            : $msg;
    }

REDO:
    my ($asset, $bytes) = MT::CMS::Asset::_upload_file ($app);
    # some error
    if (!defined $asset) {
        my $msg = $plugin->translate ('Got an error: [_1]', $app->errstr);
        return $app->param('__ajax')
            ? qq{<script type="text/javascript">parent.startUploadJS("$msg");</script>}
            : $msg;
    }
    # Asking overwrite
    if ((ref $asset) !~ /^\QMT::Asset\E/) {
        my $out = $asset->output;
        while ($out =~ s/type="hidden" name="(.+?)" value="(.+?)"//) {
            $app->param ($1, $2) if $1 !~ /^overwrite_/;
        }
        if ($app->param ('overwrite')) {
            $app->param ('overwrite_yes', 1);
            goto REDO;
        }
        else {
            my $msg = $plugin->translate ('Skipped because already existing file of same filename');
            return $app->param('__ajax')
                ? qq{<script type="text/javascript">parent.startUploadJS("$msg");</script>}
                : $msg;
        }
    }

    # Resize
    if (((ref $asset) eq 'MT::Asset::Image') && (my $size = $app->param('size')) && !$app->param('overwrite_no') ) {

        require MT::Image;

        my $img = MT::Image->new (Filename => $asset->file_path)
            or MT::Image->errstr;

        my $resize = $app->param('resize');
        my %size;

        $size{Width} = $resize eq 'width' && $size || undef;
        $size{Height} = $resize eq 'height' && $size || undef;

        my ($img_data, $new_w, $new_h) = $img->scale (%size)
            or return MT->translate ("error scaling image: [_1]", $img->errstr);

        $asset->image_width ($new_w);
        $asset->image_height ($new_h);
        $asset->save;

        my $plugin = MT->component('MultiFileUploader');
        my $path = $asset->file_path;
        open FH, "> $path"
            or return $plugin->translate( "error while writing image file: [_1]" , $!);
        binmode FH;
        print FH $img_data;
        close FH;
    }

    # Add Tag
    my $file_tag = $app->param('file_tag') || '';
    if ( $file_tag && $asset && !$app->param('overwrite_no') ) 
    {
        my $blog = $app->blog && $app->blog->id == $asset->blog_id 
              ? $app->blog
              : MT::Blog->load( $asset->blog_id ) || '';

        if( $blog )
        {
             my $fields = $blog->smart_replace_fields;
             $file_tag = MT::App::CMS::_convert_word_chars( $app, $file_tag ) if $fields =~ m/tags/ig;

             require MT::Tag;
             my $tag_delim = chr( $app->user->entry_prefs->{tag_delim} );
             my @filter_tags = MT::Tag->split( $tag_delim, $file_tag );
             if (@filter_tags) 
             {
                 $asset->set_tags(@filter_tags);
                 $asset->save;
             }
             else {
                 $asset->remove_tags();
             }
        }
    }

    # ObjectAsset
    if ($app->param ('entry_id')) {
        my $oa = MT::ObjectAsset->get_by_key ({
            blog_id => $app->param ('blog_id'),
            asset_id => $asset->id,
            object_ds => 'entry',
            object_id => $app->param ('entry_id'),
        });
        $oa->save;
    }

    return $app->param('__ajax')
        ? q{<script type="text/javascript">parent.startUploadJS(1);</script>}
        : 1;
}

1;
