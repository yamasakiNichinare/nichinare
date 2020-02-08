package Picnik::CMS;

use strict;
use MT::Blog;
use MT::Asset;
use MT::I18N;
use Data::Dumper;#DEBUG

sub instance { MT->component('Picnik'); }

### Page action handler - picnik_edit_asset
sub edit_asset {
    my ($app) = @_;

    my $blog = $app->blog
        or return $app->error ($app->translate ('Invalid request'));
    my $id = $app->param('id')
        or return $app->error ($app->translate ('Invalid request'));
    my $return_args = $app->param('return_args')
        or return $app->error ($app->translate ('Invalid request'));

    # API key
    my $api_key = 0
        || &instance->get_config_value ('api_key', 'blog:'. $blog->id)
        || $blog->is_blog && &instance->get_config_value ('api_key', 'blog:'. $blog->parent_id)
        || &instance->get_config_value ('api_key')
        or return $app->error ($app->translate ('[_1] <em>[_2]</em> is currently disabled.', 'API Key', &instance->name));

    # Check magic token
    return $app->error ($app->translate ('Invalid request'))
        unless $app->validate_magic;
    # Check blog permissions
    my $perms = $app->permissions;
    if ($perms) {
        return $app->error ($app->translate ('Permission denied.'))
            unless $perms->can_edit_assets;
    }

    # Load asset
    my $asset = MT::Asset->load ($id)
        or return $app->error ($app->translate ('Invalid request'));
    return $app->error ($app->translate ('Invalid request'))
        unless $asset->blog_id == $blog->id;

    # Transfer the opperation to Picnik
    my $ua = $app->new_ua
        or return $app->error ($app->translate ('Internal Error in [_1]', __LINE__));
    my $res = $ua->post (
        'http://www.picnik.com/service/',
        Content_Type => 'form-data',
        Content => [
            _apikey => $api_key,
            _import => 'file',
            _returntype => 'text',
            file => [
                MT::I18N::utf8_off ($asset->file_path),
                MT::I18N::utf8_off ($asset->file_name),
            ],
            _export_method => 'POST',
            _export_agent => 'browser',
            _export_title => MT::I18N::utf8_off (&instance->translate ('Save')),
            _host_name => MT::I18N::utf8_off ($blog->name. ' - '. MT->product_name),
            _export => $app->base. $app->uri (
                mode => 'picnik_save_asset',
                args => {
                    blog_id => $asset->blog_id,
                    id => $asset->id,
                },
            ),
            _close_target => $app->base. $app->uri (
                mode => 'view',
                args => {
                    _type => 'asset',
                    blog_id => $asset->blog_id,
                    id => $asset->id,
                },
            ),
        ],
    );

    return $app->error (&instance->translate ('Error in proceeding of Picnik - [_1]', $res->status_line))
        unless $res->is_success;
    my $url = $res->content
        or return $app->error ($app->translate ('No content'));
    return $app->redirect ($url);
}

### Callback method - picnik_save_asset
sub save_asset {
    my ($app) = @_;

    my $blog = $app->blog
        or return $app->error ($app->translate ('Invalid request'));
    my $id = $app->param('id')
        or return $app->error ($app->translate ('Invalid request'));

    # Load asset
    my $asset = MT::Asset->load ($id)
        or return $app->error ($app->translate ('Invalid request'));
    return $app->error ($app->translate ('Invalid request'))
        unless $asset->blog_id == $blog->id;

    # Check blog permissions
    my $perms = $app->user->permissions ($asset->blog_id);
    return $app->error ($app->translate ('Permission denied.'))
        unless $perms && $perms->can_edit_assets;

    # Retrieving the edited image from Picnik
    my $ua = $app->new_ua
        or return $app->error ($app->translate ('Internal Error in [_1]', __LINE__));
    my $file = $app->param('file')
        or return $app->error ($app->translate ('Invalid request'));
    my $res = $ua->get ($file)
        or return $app->error ($app->translate ('Network Error'));
    return $app->error (&instance->translate ('Error in proceeding of Picnik - [_1]', $res->status_line))
        unless $res->is_success;

    # Store the image data into file
    my $fmgr;
    if ($asset->blog_id) {
        my $blog = MT::Blog->load ($asset->blog_id)
            or return $app->error ($app->translate ('Invalid request'));
        $fmgr = $blog->file_mgr;
    } else {
        $fmgr = MT::FileMgr->new('Local');
    }
    $fmgr->put_data ($res->content, $asset->file_path, 'upload');

    # Set some parameters
    my $label = $app->param('label') || '';
    $asset->label ($label) if $label ne '';
    $asset->image_height (undef);   # Clear the image size
    $asset->image_width (undef);    # Clear the image size
    $asset->modified_by ($app->user->id);
    $asset->save
        or return $app->error ($asset->errstr);

    # Go back to the individual asset screen
    return $app->redirect ($app->uri (
        mode => 'view',
        args => {
            _type => 'asset',
            blog_id => $asset->blog_id,
            id => $asset->id,
        },
    ));
}

1;