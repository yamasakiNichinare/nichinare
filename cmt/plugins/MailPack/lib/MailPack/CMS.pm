package MailPack::CMS;

use strict;
use warnings;
use Exporter;

use MT::App;
use MT::Blog;
use MT::Author;
use MT::Category;
use MT::Mailpackaddress;
use MT::Log;
use MT::Util;
use MT::Plugin;
use Data::Dumper;

use base qw( MT::App );

sub plugin {
    return MT->component('MailPack');
}

sub _permission_check {
    my $app = MT->instance;
    return ($app->user && $app->user->is_superuser);
}

sub list {
    my $app = shift;
    my (%opt) = @_;

    my $plugin = MT::Plugin::MailPack->instance;

    return $app->return_to_dashboard(permission => 1)
        unless _permission_check();

    my $q = $app->{query};

    my @blogs = MT::Blog->load;
    my @categories = MT::Category->load;

    # 各パラメータ初期化
    my @blog_list;
    my @category_list;
    my @bc_list;
    my @setting;
    my @setting_list;
    my %param;

    # 設定元のブログ-カテゴリの全ハッシュ(新規入力箇所)
    foreach my $blog (@blogs) {
        my @c_list;

        my @category = MT::Category->load({blog_id => $blog->id});
        foreach my $cat (@category) {
            my $buf_hash = {
                C_ID => $cat->id,
                C_LABEL => $cat->label
            };
            push(@c_list,$buf_hash);
        }
        my $buf_hash1 = {
            B_ID => $blog->id,
            B_NAME => $blog->name,
            C_ARRAY => \@c_list
        };
        push(@bc_list,$buf_hash1);
    }

    # アドレス設定数を取得
    @setting = MT::Mailpackaddress->load({},{'sort' => 'email'});
    my %tmp;
    my @set_array = grep(!$tmp{$_->email}++,@setting);
    foreach my $set_address (@set_array) {
        my @buf_category;
#        my @cat1 = MT::Category->load({blog_id => $set_address->blog_id});
        my @cat1 = &_get_sub_category_list(0, $set_address->blog_id, 0);
        my @cat2 = MT::Mailpackaddress->load({email => $set_address->email})
            or next;# ロード失敗

        foreach my $cat1 (@cat1) {
            my $c_clug = 0;
            foreach my $cat2 (@cat2) { if ($cat1->{C_ID} == $cat2->category_id)  { $c_clug = 1; last; } }
            my $buf_hash2 = $cat1;
            $buf_hash2->{C_FLUG} = $c_clug;
            push(@buf_category,$buf_hash2);
        }
        my $buf_blog = MT::Blog->load({id => $set_address->blog_id})
            or next;# ブログが削除されていた場合

        my $author = MT::Author->load({id => $set_address->author_id})
            or next;# ユーザが削除されていた場合

        my $author_name;
        if ($author){
            if ($author->nickname){
                $author_name = $author->nickname;
            }else{
                $author_name = $author->name;
            }
        }

        my $created_on_relative;
        if ($set_address->created_on){
            my $ts = $set_address->created_on;
            $created_on_relative  = MT::Util::relative_date( $ts, time, $buf_blog);
        }

        my $buf_hash1 = {
            SETTING_ID => $set_address->setting_id,
            B_ID => $set_address->blog_id,
            B_NAME => $buf_blog->name,
            EMAIL => $set_address->email,
            POP3 => $set_address->pop3,
            USER => $set_address->user,
            PASS => $set_address->pass,
            PORT => $set_address->port,
            SSL_FLG => $set_address->ssl_flg,
            A_NAME => $author_name,
            created_on_relative  => $created_on_relative,
            C_ARRAY => \@buf_category,
        };
        push(@setting_list,$buf_hash1);
    }

    my $err_msg = $q->param('err_msg');
    if ($err_msg){
        if ($err_msg == 'data_err'){
            $err_msg = $plugin->translate('edit data not find');
        }
        $param{mpack_error} = $err_msg;
    }

    my $total = @setting_list;
    my $limit = 20;
    my $offset = $q->param('offset');
    if (! $offset =~ /[0-9]+/){
        $offset = 0;
    }

    my $have_next_entry = @setting_list > $limit;

    if ( $total && $offset > $total - 1 ) {
        $offset = $total - $limit;
    }
    elsif ( $offset < 0 ) {
        $offset = 0;
    }
    
    if ($offset > 1){
        for ( 1 .. $offset ) { shift @setting_list; }
    }
    pop @setting_list while @setting_list > $limit;

    if ($offset) {
        $param{prev_offset}     = 1;
        $param{prev_offset_val} = $offset - $limit;
        $param{prev_offset_val} = 0 if $param{prev_offset_val} < 0;
    }

    if ($have_next_entry) {
        $param{next_offset}     = 1;
        $param{next_offset_val} = $offset + $limit;
    }
    $param{limit}       = $limit;
    $param{offset}      = $offset;
    $param{list_start}  = $offset + 1;
    $param{list_end}    = $offset + scalar @setting_list;
    $param{list_total}  = $total;
    $param{next_max}    = $param{list_total} - $limit;
    $param{next_max}    = 0 if ( $param{next_max} || 0 ) < $offset + 1;

    $param{page_title}   = $plugin->translate('Entry Email Settings');
    $param{B_C_LIST}     = \@bc_list;
    $param{SETTING_LIST} = \@setting_list;
    $param{SETTING_NUM}  = \@setting;
    $param{APP_URL}      = $app->mt_uri;
    $param{OFFSET}       = $offset;

    $param{listing_screen}  = 1;
    $param{position_actions_top}  = 1;
    
    $param{content_header}  = '<p style="margin-top:20px;"><a href="?__mode=edit_mailpack&id=&offset=' . $offset . '" class="icon-left icon-create">' 
                            . $plugin->translate('Add Entry Email Setting')
                            . '</a><br />' . $plugin->translate('Please Select Blog and Set Entry Email') .'</p>';

    my $tmpl = $plugin->load_tmpl('mailpack_list.tmpl');
    return $app->build_page($tmpl, \%param);
}

#-------------------------------------------------


sub edit {
    my $plugin = MT::Plugin::MailPack->instance;
    my ($app) = @_;

    # システム管理者チェック
    return $app->return_to_dashboard(permission => 1)
        unless _permission_check();

    # 設定値取得
    my $q = $app->{query};
    # パラメータ名全取得
    my @p_name = $q->param();

    my @blogs = MT::Blog->load;
    my @categories = MT::Category->load;

    # 各パラメータ初期化
    my @bc_list;

    my $err_msg = $q->param('err_msg') || '';
    my $setting_id      = "";
    my $setting_blog_id = 0;
    my $setting_email = "";
    my $setting_pop3  = "";
    my $setting_user  = "";
    my $setting_pass  = "";
    my $setting_port  = "";
    my $setting_ssl_flg = 0;
    my $setting_filter_type = 0;
    my $setting_assist_id = 0;
    my @setting_category_ids;
    my @buf_category;
    my %param;

    my $offset = $q->param('offset');
    if (! $offset =~ /[0-9]+/){
        $offset = ""
    }

    if ($err_msg ne ''){
        if ($err_msg eq 'email_err'){
            $err_msg = $plugin->translate('email address repetition');
        }elsif ($err_msg eq 'conect_err'){
            $err_msg = $plugin->translate('email server no attestation. please setting again');
        }elsif ($err_msg eq 'user_err'){
            $err_msg = $plugin->translate('email user repetition. please setting again');
        }else{
            $err_msg = $plugin->translate($err_msg);
        }
    }

    # 投稿先メールアドレス設定をロード
    if ($q->param('id') ne "") {
        my @settings = MT::Mailpackaddress->load({setting_id=>$q->param('id')});

        my $set_address = shift(@settings);
        unless ($set_address){
            return $app->redirect($app->uri(mode => 'list_mailpack', args => {'offset'=>$offset, 'err_msg' => 'data_err'}));
        }
        my @cat1 = MT::Category->load({blog_id => $set_address->blog_id});
        my @cat2 = MT::Mailpackaddress->load({email => $set_address->email});
        foreach my $cat1 (@cat1) {
            my $c_clug = 0;
            foreach my $cat2 (@cat2) { if ($cat1->id == $cat2->category_id)  { $c_clug = 1; last; } }
            my $buf_hash2 = {
                C_ID => $cat1->id,
                C_LABEL => $cat1->label,
                C_FLUG => $c_clug
            };
            push(@buf_category,$buf_hash2);
        }

        $setting_id       = $set_address->setting_id;
        $setting_blog_id  = $set_address->blog_id;
        $setting_email    = $set_address->email;
        $setting_pop3     = $set_address->pop3;
        $setting_user     = $set_address->user;
        $setting_pass     = $set_address->pass;
        $setting_port     = $set_address->port;
        $setting_ssl_flg  = $set_address->ssl_flg;
        $setting_filter_type = $set_address->filter_type || 0;
        $setting_assist_id   = $set_address->assist_id || 0;
    }

    # 設定元のブログ-カテゴリの全ハッシュ(新規入力箇所)
    my @authors = MT::Author->load;
    foreach my $blog (@blogs) {
        my $select_blog_flg = 0;
        my @c_list;
        my @u_list;
        if ($setting_blog_id == $blog->id){
            $select_blog_flg = 1;
        }
        @c_list = &_get_sub_category_list(0, $blog->id, 0);
        my @buf_list;
        if ($select_blog_flg == 1){
            foreach my $c_list (@c_list) {
                $c_list->{C_SELECT} = 0;
                foreach my $select_category (@buf_category) {
                    if (($c_list->{C_ID} == $select_category->{C_ID}) && ($select_category->{C_FLUG} == 1)){
                        $c_list->{C_SELECT} = 1;
                        last;
                    }
                }
                push(@buf_list, $c_list);
            }
            @c_list = @buf_list;
        }

        foreach my $author ( @authors ) 
        {
            next unless $author->is_superuser 
                 || $author->permissions($blog->id)->can_post;

            push @u_list , {
                A_ID => $author->id,
                A_NAME => $author->nickname,
                A_SELECTED => $author->id == $setting_assist_id ? 1 : 0,
            };
        }

        my $buf_hash1 = {
            B_ID => $blog->id,
            B_NAME => $blog->name,
            B_SELECT => $select_blog_flg,
            C_ARRAY => \@c_list,
            AUTHORS => scalar @u_list ? \@u_list : 0,
            ASSIST_ID => $setting_assist_id,
        };
        push(@bc_list,$buf_hash1);
    }

    $param{page_title}    = $plugin->translate('Add Entry Email Setting');
    $param{mpack_error}     = $err_msg;

    $param{B_C_LIST} = \@bc_list;
    $param{APP_URL}  = $app->mt_uri;

    $param{SETTING_FILTER_TYPE} = $setting_filter_type;
    $param{SETTING_FILTER_TYPE_0} = $setting_filter_type == 0;
    $param{SETTING_FILTER_TYPE_1} = $setting_filter_type == 1;
    $param{SETTING_FILTER_TYPE_2} = $setting_filter_type == 2;

    $param{SETTING_ID}      = $setting_id;
    $param{SETTING_BLOG_ID} = $setting_blog_id;
    $param{SETTING_EMAIL}   = $setting_email;
    $param{SETTING_POP3}    = $setting_pop3;
    $param{SETTING_USER}    = $setting_user;
    $param{SETTING_PASS}    = $setting_pass;
    $param{SETTING_PORT}    = $setting_port;
    $param{SETTING_SSL_FLG} = $setting_ssl_flg;
    $param{OFFSET}          = $offset;
    $param{screen_group} = 'tools';

    my $tmpl = $plugin->load_tmpl('mailpack_edit.tmpl');
    return $app->build_page($tmpl, \%param);
}

sub post {
    my $plugin = MT::Plugin::MailPack->instance;
    my ($app) = @_;

    # システム管理者チェック
    return $app->return_to_dashboard(permission => 1)
        unless _permission_check();

    my $author_id = $app->user->id;

    # 設定値取得
    my $q = $app->{query};
    # パラメータ取得
    my $setting_id      = $q->param('setting_id');
    my $setting_blog_id = $q->param('blog_select');
    my $setting_email   = $q->param('u_d_address_text');
    my $setting_pop3    = $q->param('u_d_pop3_text');
    my $setting_user    = $q->param('u_d_user_text');
    my $setting_pass    = $q->param('u_d_pass_text');
    my $setting_port    = $q->param('u_d_port_text') || "110";
    my $setting_ssl_flg = $q->param('u_d_ssl_flg') || "0";
    my $setting_filter_type = $setting_blog_id
          ? $q->param('u_d_filter_type') || 0
          : 0;
    my $setting_assist_id  = $setting_blog_id && $setting_filter_type
          ? $q->param('u_d_assist_id_' . $setting_blog_id ) || 0
          : 0;

    # パラメータ名全取得
    my @p_name = $q->param();
    my @category_ids = ();
    foreach (@p_name) {
        if ($_ =~ m!(category_)!i) { 
            push(@category_ids, $q->param($_));
        }
    }
    my $offset = $q->param('offset');
    if (! $offset =~ /[0-9]+/){
        $offset = "";
    }

    # POP server connect check
    if ($setting_ssl_flg eq "1"){
        eval{require Mail::POP3Client;};
        if ($@) {
            return $app->redirect($app->uri(
                mode => 'edit_mailpack',
                args => {
                    'id' => $setting_id,
                    'offset' => $offset,
                    'err_msg' => 'POP over SSL need Mail::POP3Client',
                }));
        }
        eval{require IO::Socket::SSL;};
        if ($@) {
            return $app->redirect($app->uri(
                mode => 'edit_mailpack',
                args => {
                    'id' => $setting_id,
                    'offset' => $offset,
                    'err_msg' => 'POP over SSL need IO::Socket::SSL',
                }));
        }
        eval{require IO::Stringy;};
        if ($@) {
            return $app->redirect($app->uri(
                mode => 'edit_mailpack',
                args => {
                    'id' => $setting_id,
                    'offset' => $offset,
                    'err_msg' => 'POP over SSL need IO::Stringy',
                }));
        }
        eval{require Net::SSLeay;};
        if ($@) {
            return $app->redirect($app->uri(
                mode => 'edit_mailpack',
                args => {
                    'id' => $setting_id,
                    'offset' => $offset,
                    'err_msg' => 'POP over SSL need Net::SSLeay',
                }));
        }
        my $pop = Mail::POP3Client->new(
            HOST => $setting_pop3,
            USER => $setting_user,
            PASSWORD => $setting_pass,
            USESSL => 1,
            PORT => $setting_port,
            TIMEOUT => 20,
        );
        unless ($pop->Alive){
            return $app->redirect($app->uri(
                mode => 'edit_mailpack',
                args => {
                    'id' => $setting_id,
                    'offset' => $offset,
                    'err_msg' => 'conect_err',
                }));
        }
    }
    else {
        eval{ require Net::POP3; };
        if ($@){
            return $app->redirect($app->uri(
                mode => 'edit_mailpack',
                args => {
                    'id' => $setting_id,
                    'offset' => $offset,
                    'err_msg' => 'POP need Net::POP3',
                }));
        }
        # POP server connect check
        my $pop = Net::POP3->new($setting_pop3, Timeout=> 120);
        if (! $pop){
            return $app->redirect($app->uri(
                mode => 'edit_mailpack',
                args => {
                    'id' => $setting_id,
                    'offset' => $offset,
                    'err_msg' => 'conect_err',
                }));
        }
        my $checklogin = $pop->login($setting_user, $setting_pass);
        $pop->quit;
        if (! $checklogin){
            return $app->redirect($app->uri(
                mode => 'edit_mailpack',
                args => {
                    'id' => $setting_id,
                    'offset' => $offset,
                    'err_msg' => 'conect_err',
                }));
        }
    }

    my $created_on;
    my @settings = MT::Mailpackaddress->load();
    foreach my $setting (@settings) {
        if ($setting_id ne ""){
            if (($setting->setting_id != $setting_id) && ($setting->email eq $setting_email)){
                return $app->redirect($app->uri(
                    mode => 'edit_mailpack',
                    args => {
                        'id' => $setting_id,
                        'offset' => $offset,
                        'err_msg' => 'email_err',
                    }));
            }
            if (($setting->setting_id != $setting_id) && ($setting_pop3 eq $setting->pop3) && ($setting_user eq $setting->user)){
                return $app->redirect($app->uri(
                    mode => 'edit_mailpack',
                    args => {
                        'id' => $setting_id,
                        'offset' => $offset,
                        'err_msg' => 'user_err',
                    }));
            }
            $created_on = $setting->created_on;
        }else{
            if (($setting_email eq $setting->email)){
                return $app->redirect($app->uri(
                    mode => 'edit_mailpack',
                    args => {
                        'id' => $setting_id,
                        'offset' => $offset,
                        'err_msg' => 'email_err',
                    }));
            }
            if (($setting_pop3 eq $setting->pop3) && ($setting_user eq $setting->user)){
                return $app->redirect($app->uri(
                    mode => 'edit_mailpack',
                    args => {
                        'id' => $setting_id,
                        'offset' => $offset,
                        'err_msg' => 'user_err',
                    }));
            }
        }
    }
    if ($setting_id ne ""){
        # 一旦登録してある情報を削除する
        @settings = MT::Mailpackaddress->load({ setting_id => $setting_id });
        $_->remove for @settings;
    }
    else{
        my @buf_obj = MT::Mailpackaddress->load();
        $setting_id ||= 0;
        foreach (@buf_obj) {
            if ($setting_id <= $_->setting_id) { $setting_id = $_->setting_id; $setting_id++; }
        }
    }

    my @ts = MT::Util::offset_time_list(time, $setting_blog_id);
    my $modified_on = sprintf '%04d%02d%02d%02d%02d%02d', $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
    unless ($created_on){$created_on = $modified_on;}

    unless (@category_ids){
        my $set_mail = MT::Mailpackaddress->new;
        $set_mail->setting_id($setting_id);
        $set_mail->blog_id($setting_blog_id);
        $set_mail->email($setting_email);
        $set_mail->pop3($setting_pop3);
        $set_mail->user($setting_user);
        $set_mail->pass($setting_pass);
        $set_mail->port($setting_port);
        $set_mail->ssl_flg($setting_ssl_flg);
        $set_mail->category_id(undef);
        $set_mail->author_id($author_id);
        $set_mail->modified_on($modified_on);
        $set_mail->created_on($created_on);
        $set_mail->filter_type( $setting_filter_type );
        $set_mail->assist_id( $setting_assist_id );
        $set_mail->save;
    }
    else{
        foreach (@category_ids) {
            my $set_mail = MT::Mailpackaddress->new;
            $set_mail->setting_id($setting_id);
            $set_mail->blog_id($setting_blog_id);
            $set_mail->email($setting_email);
            $set_mail->pop3($setting_pop3);
            $set_mail->user($setting_user);
            $set_mail->pass($setting_pass);
            $set_mail->port($setting_port);
            $set_mail->ssl_flg($setting_ssl_flg);
            $set_mail->category_id($_);
            $set_mail->author_id($author_id);
            $set_mail->modified_on($modified_on);
            $set_mail->created_on($created_on);
            $set_mail->filter_type( $setting_filter_type );
            $set_mail->assist_id( $setting_assist_id );
            $set_mail->save;
       }
    }
    return $app->redirect($app->uri(
        mode => 'list_mailpack',
        args => {
            'offset' => $offset,
        }));
}

sub delete {
    my $plugin = MT::Plugin::MailPack->instance;
    my ($app) = @_;

    # システム管理者チェック
    return $app->return_to_dashboard(permission => 1)
        unless _permission_check();

    # 設定値取得
    my $q = $app->{query};
    # パラメータ名全取得
    my @p_name = $q->param();
    my @id = $q->param('id');
    my $offset = $q->param('offset');
    if (! $offset =~ /[0-9]+/){
        $offset = ""
    }
    foreach my $setting_id (@id) {
        my @settings = MT::Mailpackaddress->load({setting_id=>$setting_id});
        $_->remove for @settings;
    }
    return $app->redirect($app->uri(mode => 'list_mailpack', args => {'offset'=>$offset}));
}

# Write Log --------------------------------------
sub writelog {
    my ($log_msg, $log_level, $log_time) = @_;

    my $log = MT::Log->new();
    $log->message ($log_msg || '');
    $log->level ($log_level || MT::Log::DEBUG());
    $log_time = time if !defined $log_time;
    my @ts = gmtime $log_time;
    my $ts = sprintf '%04d%02d%02d%02d%02d%02d', $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
    $log->modified_on ($ts);
    $log->save
        or die $log->errstr;
}

#-------------------------------------------------

sub _get_sub_category_list {
    my ($cats, $blog_id, $level) = @_;
    my @categorys;
    my @category_list;
    my $space;
    if ($level == 0){
        @categorys = MT::Category->top_level_categories($blog_id);
    }else{
        @categorys = @$cats;
    }    
    for ( 1 .. $level ) { $space = $space . "&nbsp;"; }
    foreach my $category (@categorys) {
        my $main_hash = {
            C_ID    => $category->id,
            C_LABEL => $category->label,
            C_SPACE => $space,
            C_LEVEL => $level,
        };
        push @category_list, $main_hash;
        my @sub_cate = $category->children_categories;
        my $sub_level = $level + 1;
        if (@sub_cate){
            my @sub_category_list = &_get_sub_category_list(\@sub_cate, $blog_id, $sub_level);
            foreach my $sub_category_list (@sub_category_list) {
                push @category_list, $sub_category_list;
            }
        }
    }
    return @category_list;
}

1;
