package AuthorRegistration::CMS;
#           Copyright (c) 2008 SKYARC System Co.,Ltd.
#           @see http://www.skyarc.co.jp/

use strict;
use warnings;
use POSIX;
use Exporter;
use File::Basename;
use HTTP::Date;

# Use MT's objects
use MT::App;
use MT::Blog;
use MT::Author;
use MT::Role;
use MT::Association;
use MT::Log;
use MT::Plugin;
use Data::Dumper;
use MT::I18N qw( encode_text );
use Encode;

# *CAUTION*, not work on MTOS
use lib qw(addons/Commercial.pack/lib);
use CustomFields::Util qw( get_meta save_meta );
use CustomFields::Field;

# AuthorEffective plugin
use lib qw(plugins/AuthorEffective/lib);

use base qw( MT::App );
my $plugin = MT->component('AuthorRegistration');

sub _permission_check {
    my $app = MT->instance;
    return ($app->user && $app->user->is_superuser);
}

########################################################################
### menu form display
########################################################################
sub disp {
    my $app = shift;

    return $app->return_to_dashboard(permission => 1)
        unless _permission_check();

    return $app->error( $app->translate('Invalid request') )
        if $app->blog;

    my %param;

    my $tmpl = $plugin->load_tmpl('author_registration.tmpl');

    $param{page_title} = $plugin->translate('AuthorRegistration');

    return $app->build_page($tmpl, \%param);
}

sub encode_filter {
   my $text = shift;
   if( $MT::VERSION >= 5.0 )
   {
      Encode::_utf8_on( $text ) unless Encode::is_utf8( $text );
   }
   return $text;
}


########################################################################
### import csv data
########################################################################
sub run {
    my $app = shift;

    # user check 
    return $app->return_to_dashboard(permission => 1)
        unless _permission_check();

    my $q = $app->{query};
    my %param;

    my $cfg = MT::ConfigMgr->instance;

    my $update_flg = $q->param('update_flg') || 0;

    my $fh = $q->upload('upload_file');
    if (! $fh){
        $param{SKR_ERROR_MSG} = $plugin->translate('file upload error') . '&nbsp;';
        my $tmpl = $plugin->load_tmpl('author_registration.tmpl');
        return $app->build_page($tmpl, \%param);
    }

    my $suffix = _get_suffix($fh);
    unless (scalar $suffix =~ m/(csv)$/i){
        $param{SKR_ERROR_MSG} = $plugin->translate('file suffix error') .  " [$suffix]";
        my $tmpl = $plugin->load_tmpl('author_registration.tmpl');
        return $app->build_page($tmpl, \%param);
    }

    my @title_fields;
    my $line_count  = 1;
    my $title_count = 0;
    my $data_count  = 0;
    my $error_count = 0;

    my $system_encode = get_system_charset($app);
    my $encode_switch = '';
    my $decode_switch = '';
    if( $MT::VERSION >= 5.0 ){
        $encode_switch = sub { return encode_text( MT::I18N::utf8_off($_[0]), 'sjis' , $_[1] ); };
        $decode_switch = sub { return Encode::decode_utf8($_[0]); };
    }else{    
        $encode_switch = sub { return encode_text( $_[0], 'sjis', $_[1] ); };
        $decode_switch = sub { return $_[0]; };
    }
    my @data_buf;
    while (my $line_rec = <$fh>) {
        $line_rec .= <$fh> while ($line_rec =~ tr/"// % 2 and !eof($fh));#"

#        $line_rec = encode_text($line_rec, 'sjis', $app->config->PublishCharset);
         $line_rec = &$encode_switch( $line_rec , $system_encode );

        $line_rec =~ s/(?:\x0D\x0A|[\x0D\x0A])?$/,/;
        my @values = map {/^"(.*)"$/s ? scalar($_ = $1, s/""/"/g, $_) : $_}
                ($line_rec =~ /("[^"]*(?:""[^"]*)*"|[^,]*),/g);#"

        if ($line_count == 1){
            @title_fields = @values;
            $title_count = @title_fields;

            unless (& _check_field(\@title_fields , 'author_id')){
                $param{SKR_ERROR_MSG} = $plugin->translate('title field error. [_1] field not found.', 'author_id');
                my $tmpl = $plugin->load_tmpl('author_registration.tmpl');
                return $app->build_page($tmpl, \%param);
            }
            unless (& _check_field(\@title_fields , 'author_name')){
                $param{SKR_ERROR_MSG} = $plugin->translate('title field error. [_1] field not found.', 'author_name');
                my $tmpl = $plugin->load_tmpl('author_registration.tmpl');
                return $app->build_page($tmpl, \%param);
            }
            unless (& _check_field(\@title_fields , 'author_nickname')){
                $param{SKR_ERROR_MSG} = $plugin->translate('title field error. [_1] field not found.', 'author_nickname');
                my $tmpl = $plugin->load_tmpl('author_registration.tmpl');
                return $app->build_page($tmpl, \%param);
            }
            unless (& _check_field(\@title_fields , 'author_email')){
                $param{SKR_ERROR_MSG} = $plugin->translate('title field error. [_1] field not found.', 'author_email');
                my $tmpl = $plugin->load_tmpl('author_registration.tmpl');
                return $app->build_page($tmpl, \%param);
            }
            unless (& _check_field(\@title_fields , 'author_password')){
                $param{SKR_ERROR_MSG} = $plugin->translate('title field error. [_1] field not found.', 'author_password');
                my $tmpl = $plugin->load_tmpl('author_registration.tmpl');
                return $app->build_page($tmpl, \%param);
            }
            unless (& _check_field(\@title_fields , 'author_hint')){
                $param{SKR_ERROR_MSG} = $plugin->translate('title field error. [_1] field not found.', 'author_hint');
                my $tmpl = $plugin->load_tmpl('author_registration.tmpl');
                return $app->build_page($tmpl, \%param);
            }

            foreach my $title (@title_fields) {
                if ($title =~ m/^\[(\d{1,})\]/){
                    my $blog_id = $1;
                    ### blog_id
                    my $blog = MT::Blog->load($blog_id);
                    unless ($blog){
                        $param{SKR_ERROR_MSG} = $plugin->translate('title field error. field:[_1] not find ', 'role blog_id') . '&nbsp;  value= ' . &$decode_switch($title);
                        my $tmpl = $plugin->load_tmpl('author_registration.tmpl');
                        return $app->build_page($tmpl, \%param);
                    }
                }
            }

            if ($title_count < 5){
                $param{SKR_ERROR_MSG} = $plugin->translate('csv data field count error');
                my $tmpl = $plugin->load_tmpl('author_registration.tmpl');
                return $app->build_page($tmpl, \%param);
            }
        }else{
            $data_count = @values;
            if ($title_count ne $data_count){
                & _print_mt_log($plugin->translate('[_1] line:',  $line_count) . $plugin->translate('csv data field count error'));
                $error_count++;
            }else{
                my %data_rec;
                for (my $i=0; $i<$title_count; $i++) {
                    my $data_title = @title_fields[$i];
                    my $data_value = @values[$i];
                    $data_rec{$data_title} = $data_value;
                }
                push(@data_buf, \%data_rec);
            }
        }
        $line_count++;
    }
    
    my $update_count= 0;
    my $add_count   = 0;
    my $skip_count  = 0;
    my $total_count = 0;
    my $line_count  = 1;
    my $ret;

    foreach my $data (@data_buf) {
        my $author_id = $data->{author_id};

        eval{
            $line_count++;
            # data check
            my $err_msg = &_data_check($plugin, $data, $author_id);
            if ($err_msg){
                & _print_mt_log($plugin->translate('[_1] line:',  $line_count) . encode_filter( $err_msg ), 0, 0);
                $ret = 0;
            }else{
                $ret = & _save_author($plugin, $data, $update_flg, $line_count);
            }
        };
        if ($@)
        {
            & _print_mt_log($plugin->translate('[_1] line: csv import error.<[_2]>', $line_count,  encode_filter( $@ ) ), 0, 0);
            $ret = 0;
        }
        if ($ret == 1){
            $add_count++;
        }elsif ($ret == 2){
            $update_count++;
        }elsif ($ret == 3){
            $skip_count++;
        }else{
            $error_count++;
        }
        $total_count++;
    }
    my $msg = $plugin->translate('user data import save') . "&nbsp;" . $plugin->translate('all count : [_1]', $total_count);
    if ($add_count > 0){
        $msg .= "&nbsp;" . $plugin->translate('add count : [_1]', $add_count);
    }
    if ($update_count > 0){
        $msg .= "&nbsp;" . $plugin->translate('update count : [_1]', $update_count);
    }
    if ($skip_count > 0){
        $msg .= "&nbsp;" . $plugin->translate('skip count : [_1]', $skip_count);
    }
    if ($error_count > 0 || $skip_count > 0 ){
        $msg .= "&nbsp;" . $plugin->translate('error count : [_1]', $error_count);
        $msg .=  $plugin->translate('<a href="[_1]">show log<a>', 'mt.cgi?__mode=view_log');
    }
    & _print_mt_log($plugin->translate('user data import save') . " " . 
                    $plugin->translate('all count : [_1]', $total_count) ." " .
                    $plugin->translate('add count : [_1]', $add_count) ." " .
                    $plugin->translate('update count : [_1]', $update_count) ." " .
                    $plugin->translate('error count : [_1]', $error_count), 
                    MT::Log->INFO);

    $param{page_title} = $plugin->translate('AuthorRegistration');
    $param{SKR_MSG} = $msg;

    my $tmpl = $plugin->load_tmpl('author_registration.tmpl');
    return $app->build_page($tmpl, \%param);
}

### save author data
sub _save_author {
    my ($plugin, $data, $update_flg, $line_count) = @_;
    my $app = MT->instance;

    my $author;
    my $author_id = $data->{author_id} || 0;
    my $author_name = $data->{'author_name'};

    my @ts = gmtime(time());
    my $ts = sprintf '%04d%02d%02d%02d%02d%02d', $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];

    my $save_mode = 1;
    $author = $author_id ? MT::Author->load( $author_id ) : '';
    unless ($author) {
        $author = MT::Author->load({ 'name' => $author_name });
        if ( $author && !$update_flg )
        {
            & _print_mt_log($plugin->translate('[_1] line: same name user error. author_name:[_2]', $line_count,  encode_filter( $author_name) ), 0, 0);
            return 0;
        }
        unless ( $author )
        {
            $author = MT::Author->new;
            $author->id( $author_id ) if $author_id;
        }
        else
        {
            $save_mode = 2;
        }
    }
    else
    {
        unless ( $update_flg )
        {
             & _print_mt_log($plugin->translate('[_1] line: same id user error. author_id:[_2] author_name:[_3]', $line_count,  $author_id , encode_filter( $author_name )), 0, 0);
             return 3;
        }

        $save_mode = 2;
        my $authors = MT::Author->load_iter({'name' => $author_name });
        while (my $auth = $authors->()) 
        {
            unless ($auth->id == $author_id)
            {
                & _print_mt_log($plugin->translate('[_1] line: same name user error. author_name:[_2]', $line_count,  encode_filter( $author_name ) ), 0, 0);
                return 0;
            }
        }
    }
    my $author_columns = $author->column_names;
    my @author_columns = @$author_columns;

    while (my ($key, $value) = each(%$data) ) 
    {
        $value = encode_filter( $value );
        foreach my $column (@author_columns) 
        {
             if ($key eq "author_" . $column)
             {
                 if($column eq "status"){
                     unless ($value){
                         $value = MT::Author::ACTIVE if ($save_mode == 1);
                     }
                 }elsif($column eq "password"){
                     if ($author->password ne $value){
                         $author->set_password($value);
                     }
                     last;
                 }elsif($column eq "created_by"){
                     unless ($value){
                         $value = $app->user->id if ($save_mode == 1);
                     }
                 }elsif($column eq "created_on"){
                     if ($value){
                         my $created_on_time = HTTP::Date::str2time($value);
                         if ($created_on_time){
                             #my @created_on_ts   = MT::Util::offset_time_list($created_on_time, $blog);
                             my @created_on_ts = gmtime(time());
                             my $created_on_ts   = sprintf '%04d%02d%02d%02d%02d%02d', $created_on_ts[5]+1900, $created_on_ts[4]+1, @created_on_ts[3,2,1,0];
                             $value = $created_on_ts;
                         }else{
                             $value = $ts;
                         }
                     }else{
                         $value = $ts if ($save_mode == 1);
                     }
                 }elsif($column eq "modified_by"){
                     unless ($value){
                         $value = $app->user->id if ($save_mode == 2); 
                     }
                 }elsif($column eq "modified_on"){
                     if ($value){
                         my $modified_time = HTTP::Date::str2time($value);
                         if ($modified_time){
                             #my @modified_ts   = MT::Util::offset_time_list($modified_time, $blog);
                             my @modified_ts = gmtime(time());
                             my $modified_ts   = sprintf '%04d%02d%02d%02d%02d%02d', $modified_ts[5]+1900, $modified_ts[4]+1, @modified_ts[3,2,1,0];
                             $value = $modified_ts;
                         }else{
                             $value = $ts;
                         }
                     }else{
                         $value = $ts if ($save_mode == 2); 
                     }
                 }elsif(($column eq "meta") || 
                        ($column eq "id")){
                     last;
                 }
                 $author->$column($value);
                 last;
             }
        }
    }

    # auth_type 
    unless ($author->auth_type){
        $author->auth_type('MT');
    }
    unless ($author->save){
        & _print_mt_log($plugin->translate('[_1] line: user save error.', $line_count), 0, 0);
        return 0;
    }

    # save role data
    while (my ($key, $value) = each(%$data) ) {
        if ($key =~ m/^\[(\d{1,})\]/){
            my $blog_id = $1;
            my $blog = MT::Blog->load($blog_id);
            unless ($blog){
                & _print_mt_log( $plugin->translate('[_1] line:', $line_count) . $plugin->translate('csv data error: [_1] value: [_2]', 'role blog_id', $blog_id) , 0,0);
                $save_mode = 0;
                next;
            }
            my @role_ids = split(',', $value);
            foreach my $role_id (@role_ids) {
                my $role = MT::Role->load($role_id);
                unless ($role){
                    & _print_mt_log( $plugin->translate('[_1] line:', $line_count) . $plugin->translate('csv data error: [_1] value: [_2]', 'role_id', $role_id ), 0,0);
                    $save_mode = 0;
                    next;
                }
                my $asso_data = MT::Association->load({'author_id' => $author->id , 'blog_id' => $blog_id, 'role_id' => $role_id});
                unless ($asso_data){
                    $asso_data = MT::Association->new;
                }
                $asso_data->author_id($author->id);
                $asso_data->blog_id($blog_id);
                $asso_data->role_id($role_id);
                $asso_data->type(MT::Association::USER_BLOG_ROLE);
                unless ($asso_data->save()){
                    & _print_mt_log($plugin->translate('[_1] line: role save error. role_id:[_2]', $line_count, $role_id), 0, 0);
                    $save_mode = 0;
                }
            }
            my @assos = MT::Association->load({'author_id' => $author->id , 'blog_id' => $blog_id});
            foreach my $asso (@assos) {
                my $data_flg = 0;
                foreach my $role_id (@role_ids) {
                    if ($asso->role_id == $role_id){
                        $data_flg = 1;
                    }
                }
                unless ($data_flg){
                    $asso->remove;
                }
            }
        }
    }
    while (my ($key, $value) = each(%$data) ) {
        # author permissions
        if ($key eq 'permissions'){
            my $permission = MT::Permission->load({'author_id' => $author->id, 'blog_id' => 0});
            if ($value){
                unless ($permission){
                    $permission = MT::Permission->new;
                }
                unless (substr($value, 0, 1) eq "'"){
                    $value = "'" . $value;
                }
                $permission->author_id($author->id);
                $permission->blog_id(0);
                $permission->permissions($value);
                $permission->save;
            }else{
                if ($permission){
                    $permission->remove;
                }
            }

        # author_effective plugin data
        }elsif ($key eq 'effective_day'){
            eval {
                require MT::AuthorEffective;
                my $effective = MT::AuthorEffective->load({'author_id' => $author->id});

                my $effective_day = $data->{'effective_day'};
                if ($effective_day){
                    my $effective_time = HTTP::Date::str2time($effective_day);
                    if ($effective_time){
                        unless ($effective){
                            $effective = MT::AuthorEffective->new;
                        }
                        $effective->author_id($author->id);
                        $effective->effective_day(HTTP::Date::time2iso($effective_time));
                        $effective->save;
                        #有効期限切れはステイタスを無効化する
                        my $now_date = strftime('%Y%m%d%H%M%S',localtime);
                        my $check_time = HTTP::Date::str2time($effective_day);
                        my $chack_date = strftime('%Y%m%d%H%M%S',localtime($check_time));
                        if ($now_date ge $chack_date){
                            $author->status(MT::Author::INACTIVE);
                            $author->save;
                        }
                    }else{
                        if ($effective){
                            $effective->remove;
                        }
                    }
                }else{
                    if ($effective){
                        $effective->remove;
                    }
                }
            };
        }
    }

    # save customfields data
    my $meta = get_meta($author);
    my @CustomFields = CustomFields::Field->load({ obj_type => 'author'} );
    foreach my $CustomField (@CustomFields) {
        my $basename = $CustomField->basename;
        if (defined $data->{$basename}){
            $meta->{$basename} = $data->{$basename};
        }
    }
    if ($meta){
        &save_meta($author, $meta);
    }

    return $save_mode;
}

### import data check
sub _data_check{
    my ($plugin, $data, $author_id) = @_;

    ### author_id
    if( $data->{author_id} ){
       unless (_check_field_value( $data->{author_id} || '' , 0, 1)){
            return $plugin->translate('csv data error: [_1] value: [_2]', 'author_id', $data->{author_id} );
       }
    }
    ### author_hint mt5 no support
    
    ### author_name
    unless ($data->{author_name}){
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_name', $data->{author_name});
    }
    unless (_check_field_value($data->{author_name}, 1, 0)){
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_name', $data->{author_name});
    }
    ### author_nickname
    unless ($data->{author_nickname}){
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_nickname', $data->{author_nickname});
    }
    unless (_check_field_value($data->{author_nickname}, 1, 0)){
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_nickname', $data->{author_nickname});
    }
    ### author_email
    unless ($data->{author_email}){
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_email', $data->{author_email});
    }
    unless (_check_field_value($data->{author_email}, 1, 0)){
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_email', $data->{author_email});
    }
    unless (_check_email($data->{author_email})){
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_email', $data->{author_email});
    }
    ### author_password
    unless ($data->{author_password}){
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_password', $data->{author_password});
    }
    unless (_check_field_value($data->{author_password}, 1, 0)){
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_password', $data->{author_password});
    }
    ### author_status
    unless ($data->{author_status}){
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_status', $data->{author_status});
    }
    unless (_check_field_value($data->{author_status}, 1, 0)){
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_status', $data->{author_status});
    }
    unless ( $data->{author_status} > 0  && $data->{author_status} < 4  ) {
        return $plugin->translate('csv data error: [_1] value: [_2]', 'author_status', $data->{author_status});
    }
    ### permissions
    if ($data->{permissions} ne ""){
        my $value = $data->{permissions};
        unless (substr($value, 0, 1) eq "'"){
            $value = "'" . $value;
        }
        my @permissions = split(',', $value);
        foreach my $permission (@permissions) {
            unless (
                ($permission eq "'administer'") ||
                ($permission eq "'create_website'") ||
                ($permission eq "'create_blog'") ||
                ($permission eq "'view_log'") ||
                ($permission eq "'edit_templates'") ||
                ($permission eq "'manage_plugins'")
               ){
                return $plugin->translate('csv data error: [_1] value: [_2]', 'permissions', $value);
            }
        }
    }

    ### role
    while (my ($key, $value) = each(%$data) ) {
        if ($key =~ m/^\[(\d{1,})\]/){
            my $blog_id = $1;

            ### blog_id
            my $blog = MT::Blog->load($blog_id);
            unless ($blog){
                return $plugin->translate('csv data error: [_1] value: [_2]', 'blog_id', $blog_id);
            }

            ### role_id
            my @role_ids = split(',', $value);
            foreach my $role_id (@role_ids) {
                my $role = MT::Role->load($role_id);
                unless ($role){
                    return $plugin->translate('csv data error: [_1] value: [_2]', 'role_id', $role_id);
                }
            }
        # author_effective plugin data
        }elsif ($key eq 'effective_day'){
            if ($value){
                my $effective_time = HTTP::Date::str2time($value);
                unless ($effective_time){
                    return $plugin->translate('csv data error: [_1] value: [_2]', 'effective_day', $value);
                }
            }
        }
    }
    return "";
}


########################################################################
### export csv data
########################################################################
sub export {
    my $app = shift;

    # user check 
    return $app->return_to_dashboard(permission => 1)
        unless _permission_check();

    my $q = $app->{query};

    #-- export file name --#
    my $file = 'author_data.csv';

    #-- export header --#
    print "Content-Type: application/octet-stream\n";
    print "Content-Disposition: attachment; filename=$file\n";
    print "\n";

    my $author_effective_flg = 1;
    eval {require MT::AuthorEffective;};
    if ($@){
        $author_effective_flg = 0;
    }

    my $author = MT::Author->new;
    my $author_columns = $author->column_names;
    my @author_columns = @$author_columns;
    my @title_columns;

    my @buf_columns;
    my @CustomFields = CustomFields::Field->load( { blog_id => 0, obj_type => 'author'} );
    foreach my $CustomField (@CustomFields) {
        my $basename = $CustomField->basename;
        push(@buf_columns, $basename);
    }
    my %tmp;
    my @custom_columns = grep(!$tmp{$_}++, @buf_columns);

    my @blogs = MT::Blog->load({ class => '*' }, { sort => 'id' }); #17992
    my @blogs_columns;
    my @blog_ids;
    my $blog_name = sub { return $_[0]->name; };
    if( $app->version_number =~ /^5/ ){
        $blog_name = sub { return MT::I18N::utf8_off( $_[0]->name ) };
    }
    foreach my $blog (@blogs) {
        push(@blog_ids, $blog->id);
        push(@blogs_columns, '[' . $blog->id . ']_' . $blog_name->($blog));
    }

    # Select export fields
    foreach my $column (@author_columns) {
        unless
           (($column eq 'meta') 
         || ($column eq 'api_password')
         || ($column eq 'basename')
         || ($column eq 'entry_prefs')
         || ($column eq 'external_id')
         || ($column eq 'modified_by')
         || ($column eq 'modified_on')
         || ($column eq 'created_by')
         || ($column eq 'created_on')
         || ($column eq 'public_key')
         || ($column eq 'remote_auth_token')
         || ($column eq 'remote_auth_username')
         || ($column eq 'text_format')
         || ($column eq 'userpic_asset_id')
         || ($column eq 'type')
         || ($column eq 'auth_type')
         || ($column eq 'can_create_blog')
         || ($column eq 'can_view_log')
         || ($column eq 'is_superuser')
        ){
            push(@title_columns, 'author_' . $column);
        }
    }
    # author permissions title
    push(@title_columns, 'permissions');

    # author_effective plugin data
    if ($author_effective_flg == 1){
        push(@title_columns, 'effective_day');
    }

    foreach my $column (@custom_columns) {
        push(@title_columns, $column );
    }
    foreach my $column (@blogs_columns) {
        push(@title_columns, $column );
    }

    my $title_line = join ',', map {(s/"/""/g or /[\r\n,]/) ? qq("$_") : $_} @title_columns;

      my $system_encode = get_system_charset($app);
      my $encode_switch = $app->version_number =~ /^5/
         ? sub { return encode_text( MT::I18N::utf8_off($_[0]), $_[1] , 'sjis' ); }
         : sub { return encode_text( $_[0], $_[1] , 'sjis' ); };

    $title_line = encode_text ($title_line, $system_encode , 'sjis');

    print $title_line . "\n";

    my @authors = MT::Author->load({},{sort => 'id'});
    foreach my $author (@authors) {
        my @line_val;
        my $author_column_val = $author->column_values();
        foreach my $column (@title_columns) {
            foreach my $author_column (@author_columns) {
                if ($column eq ('author_' . $author_column)){
                    my $val = $author_column_val->{$author_column};
                    if (($author_column eq 'authored_on') or 
                        ($author_column eq 'created_on' ) or 
                        ($author_column eq 'modified_on')){
                        if ($val){
                            $val = MT::Util::format_ts( "%Y-%m-%d %H:%M:%S", $val, undef, undef );
                        }
                    }elsif( ($author_column eq 'meta') ){
                        next;
                    }elsif($author_column eq 'password'){
                        #$val = '';
                    }
                    push(@line_val, $val);
                }
            }
        }
        my $meta = get_meta($author);

        # author permissions data
        my $permissions = "";
        my $permission =  MT::Permission->load({'author_id' => $author->id, 'blog_id' => 0});
        if ($permission){
            $permissions = $permission->permissions;
        }
        push(@line_val, $permissions);

        # author_effective plugin data
        if ($author_effective_flg == 1){
            my $effective_day = "";
            my $effective =  MT::AuthorEffective->load({'author_id' => $author->id});
            if ($effective){
                $effective_day = MT::Util::format_ts( "%Y-%m-%d %H:%M:%S", $effective->effective_day, undef, undef );
            }
            push(@line_val, $effective_day);
        }

        foreach my $custom (@custom_columns) {
            my $val = "";
            foreach my $field (keys %$meta) {
                if ($field eq $custom){
                    $val = $meta->{$field};
                    if ($val){
                        my $customfield = CustomFields::Field->load( { basename => $field} );
                        if ($customfield->type eq 'datetime'){
                            $val = MT::Util::format_ts( "%Y-%m-%d %H:%M:%S", $val, undef, undef );
                            my $date_time = HTTP::Date::str2time($val);
                            unless ($date_time){
                                $val = ""
                            }
                        }elsif (($customfield->type eq 'asset') || 
                                ($customfield->type eq 'asset.image') ||
                                ($customfield->type eq 'asset.audio') ||
                                ($customfield->type eq 'asset.video')) {
                            $val = ""
                        }
                    }
                }
            }
            push(@line_val, $val);
        }
        foreach my $blog_id (@blog_ids) {
            my $val = "";
            my @assos = MT::Association->load({'author_id' => $author->id, 'blog_id' => $blog_id});
            foreach my $asso (@assos) {
                if ($val) {
                    $val .= ",";
                }
                $val .= $asso->role_id;
            }
            push(@line_val, $val);
        }
        my $author_line = join ',', map {(s/"/""/g or /[\r\n,]/) ? qq("$_") : $_} @line_val; 
        $author_line = &$encode_switch( $author_line , $system_encode );

        print $author_line . "\n";
    }
    exit;
}


########################################################################
### Common Used Functions
########################################################################

### field check
sub _check_field {
    my ($fields, $check_field) = @_;
    my @fields = @$fields;
    foreach my $field_name ( @fields ) {
        if ($field_name eq $check_field){
            return 1;
        }
    }
    return 0;
}

### field value check
sub _check_field_value {
    my ($value, $null_check, $num_check, $value_arr) = @_;

    if ( $null_check )
    {
        return 0 unless $value;
        return 1;
    }
    if ( $num_check )
    {
        return 1 if $value =~ /^\d+$/;
        return 0;
    }
    if ($value_arr){
        foreach my $val ( @$value_arr ) {
            return 1 if $value eq $val;
        }
    }
    return 0;
}

### get suffix
sub _get_suffix{
    my $path       = shift;
    my @suffixlist = @_;
    my ($name, $path, $suffix) = fileparse($path, @suffixlist);

    if( scalar(@suffixlist) ){
        return($suffix);
    }else{
        my $suffix = '';

       if( index($name, '.',  0) != -1){
            $suffix = (split(/\./, $name))[-1]; 
        }
        return($suffix);
    }
}

### mail address check
sub _check_email{
  my $email = shift;

  if( $email =~ /^([a-zA-Z0-9\.\-\/_\+]{1,})@([a-zA-Z0-9\.\-\/_]{1,})\.([a-zA-Z0-9\.\-\/_]{1,})$/ ){
    return 1;
  }else{
    return 0;
  }
}

### Logging
sub _print_mt_log{
    my ($msg, $level, $blog_id) = @_;
    $level = $level || MT::Log->ERROR;
    my $app = MT->instance;

    my $log = MT::Log->new;
    $log->message($msg);
    $log->level( $level );
    $log->blog_id( $blog_id );
    $log->author_id($app->user->id);
    MT->log( $log );
}

sub get_system_charset {
    my $app = shift;
    {   'shift_jis' => 'sjis',
        'iso-2022-jp' => 'jis',
        'euc-jp' => 'euc',
        'utf-8' => 'utf8'
    }->{lc $app->config->PublishCharset} || 'utf8';
}


1;
