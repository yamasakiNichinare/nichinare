package MailPackApp;
use strict;

use MT::App;
use MT::App::CMS;
use MT::Blog;
use MT::Author;
use MT::Category;
use MT::Mailpackaddress;
use MT::Log;
use MT::Util;
use MT::Plugin;
use Net::POP3;

use base qw( MT::App );

sub init {
	my $app = shift;
	$app->SUPER::init (@_) or return;
	$app->add_methods (
		default  => \&default,
		mpack_edit => \&mpack_edit,
		mpack_post => \&mpack_post,
		mpack_del => \&mpack_del,
	);
	$app->{default_mode} = 'default';
	$app->{template_dir} = 'cms';
	$app->{requires_login} = 1;
	$app;
}

sub pre_run {
	my $app = shift;
	$app->SUPER::pre_run();
}

# Window Load ------------------------------------
sub default {
	my $plugin = MT::Plugin::MailPack->instance;
	my ($app) = @_;

    # システム管理者チェック
    $app->user->is_superuser or return $app->error($app->translate("Permission denied."));

	my $q = $app->{query};

	my @blogs = MT::Blog->load;
	my @categories = MT::Category->load;

	# 各パラメータ初期化
	my @blog_list;
	my @category_list;
	my @bc_list;
	my @setting;
	my @setting_list;
	my @top_blog_loop;
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

		push @top_blog_loop,
			{
				top_blog_id   => $blog->id,
				top_blog_name => $blog->name
			};
	}

	# アドレス設定数を取得
	@setting = MT::Mailpackaddress->load({},{'sort' => 'email'});
	my %tmp;
	my @set_array = grep(!$tmp{$_->email}++,@setting);
	foreach my $set_address (@set_array) {
		my @buf_category;
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
		my $buf_blog = MT::Blog->load({id => $set_address->blog_id});

		my $author = MT::Author->load({id => $set_address->author_id}); 

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
			A_NAME => $author_name,
			created_on_relative  => $created_on_relative,
			C_ARRAY => \@buf_category,
		};
		push(@setting_list,$buf_hash1);
	}

    my $total = @setting_list;
    my $limit = 2;
    my $offset = $q->param('offset') || 0;
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


	# default.tmplに渡すパラメータ
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

    $param{page_title}    = $plugin->translate('Entry Email Settings');
    $param{B_C_LIST}      = \@bc_list;
    $param{SETTING_LIST}  = \@setting_list;
    $param{SETTING_NUM}   = \@setting;
    $param{APP_URL}       = $app->mt_uri;
    $param{top_blog_loop} = \@top_blog_loop;

    $param{system_overview_nav} = 1;
    $param{single_blog_mode}    = 1;
    $param{can_create_blog}     = 1;

    my $tmpl = $plugin->load_tmpl('mailpack_list.tmpl');

    return $app->build_page($tmpl, \%param);
}
#-------------------------------------------------


sub mpack_edit {
    my $plugin = MT::Plugin::MailPack->instance;
    my ($app) = @_;

    # システム管理者チェック
    $app->user->is_superuser or return $app->error($app->translate("Permission denied."));

    # 設定値取得
    my $q = $app->{query};
    # パラメータ名全取得
    my @p_name = $q->param();

    my @blogs = MT::Blog->load;
    my @categories = MT::Category->load;

    # 各パラメータ初期化
    my @bc_list;
    my @top_blog_loop;

    my $err_msg = $q->param('err_msg') || '';
    my $setting_id      = "";
    my $setting_blog_id = 0;
    my $setting_email = "";
    my $setting_pop3  = "";
    my $setting_user  = "";
    my $setting_pass  = "";
    my @setting_category_ids;
    my @buf_category;
    my %param;

    if ($err_msg ne ''){
        if ($err_msg eq 'email_err'){
            $err_msg = $plugin->translate('email address repetition');
        }elsif ($err_msg eq 'conect_err'){
            $err_msg = $plugin->translate('email server no attestation. please setting again');
        }
    }

    # 投稿先メールアドレス設定をロード
    if ($q->param('id') ne "") {
        my @settings = MT::Mailpackaddress->load({setting_id=>$q->param('id')});

        my $set_address = shift(@settings);

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
    }

    # 設定元のブログ-カテゴリの全ハッシュ(新規入力箇所)
    foreach my $blog (@blogs) {
        my $select_blog_flg = 0;
        my @c_list;
        my @category = MT::Category->load({blog_id => $blog->id});

        if ($setting_blog_id == $blog->id){
            $select_blog_flg = 1;
        }

        foreach my $cat (@category) {
            my $select_category_flg = 0;

            if ($select_blog_flg == 1){
                foreach my $select_category (@buf_category) {
                    if (($cat->id == $select_category->{C_ID}) && ($select_category->{C_FLUG} == 1)){
                        $select_category_flg = 1;
                        last;
                    }
                }
            }
            my $buf_hash = {
                C_ID => $cat->id,
                C_LABEL => $cat->label,
                C_SELECT => $select_category_flg
            };
            push(@c_list,$buf_hash);
        }
        my $buf_hash1 = {
            B_ID => $blog->id,
            B_NAME => $blog->name,
            B_SELECT => $select_blog_flg,
            C_ARRAY => \@c_list
        };
        push(@bc_list,$buf_hash1);
    }

    $param{page_title}    = $plugin->translate('Add Entry Email Setting');

    $param{B_C_LIST} = \@bc_list;
    $param{APP_URL}  = $app->mt_uri;

    $param{SETTING_ID}      = $setting_id;
    $param{SETTING_BLOG_ID} = $setting_blog_id;
    $param{SETTING_EMAIL}   = $setting_email;
    $param{SETTING_POP3}    = $setting_pop3;
    $param{SETTING_USER}    = $setting_user;
    $param{SETTING_PASS}    = $setting_pass;

    $param{mpack_error}     = $err_msg;
    $param{system_overview_nav} = 1;
    $param{single_blog_mode}    = 1;
    $param{can_create_blog}     = 1;

    my $tmpl = $plugin->load_tmpl('mailpack_edit.tmpl');

    return $app->build_page($tmpl, \%param);
}

sub mpack_post {
    my $plugin = MT::Plugin::MailPack->instance;
    my ($app) = @_;

    # システム管理者チェック
    $app->user->is_superuser or return $app->error($app->translate("Permission denied."));
    my $author_id = $app->user->id;

    # 設定値取得
    my $q = $app->{query};
    # パラメータ名全取得
    my @p_name = $q->param();

    my $setting_id      = $q->param('setting_id');
    my $setting_blog_id = $q->param('blog_select');
    my $setting_email   = $q->param('u_d_address_text');
    my $setting_pop3    = $q->param('u_d_pop3_text');
    my $setting_user    = $q->param('u_d_user_text');
    my $setting_pass    = $q->param('u_d_pass_text');
    my @category_ids;
    foreach (@p_name) {
        if ($_ =~ m!(category_)!i) { 
            push(@category_ids, $q->param($_));
        }
    }

    # POPサーバ接続テスト
    my $pop = Net::POP3->new($setting_pop3, Timeout=> 120);
    if (! $pop){
        return $app->redirect($app->path."plugins/MailPack/mailpack.cgi?__mode=mpack_edit&id=$setting_id&err_msg=conect_err");
    }
    my $checklogin = $pop->login($setting_user, $setting_pass);
    $pop->quit;
    if (! $checklogin){
        return $app->redirect($app->path."plugins/MailPack/mailpack.cgi?__mode=mpack_edit&id=$setting_id&err_msg=conect_err");
    }

    my $new_flg = 0;
    my $created_on;
    my @settings = MT::Mailpackaddress->load({email => $setting_email});
    if ($setting_id ne ""){
        foreach my $setting (@settings) {
            unless ($setting->setting_id == $setting_id){
                return $app->redirect($app->path."plugins/MailPack/mailpack.cgi?__mode=mpack_edit&id=$setting_id&err_msg=email_err");
            }else{
                $created_on = $setting->created_on;
            }
        }

        # 一旦登録してある情報を削除する
        @settings = MT::Mailpackaddress->load({setting_id=>$setting_id});
        $_->remove for @settings;
    }else{
        my $new_flg = 1;
        if (@settings) {
            return $app->redirect($app->path."plugins/MailPack/mailpack.cgi?__mode=mpack_edit&id=$setting_id&err_msg=email_err");
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
        $set_mail->category_id('');
        $set_mail->author_id($author_id);
        $set_mail->modified_on($modified_on);
        $set_mail->created_on($created_on);
        $set_mail->save;
    }else{
        my @buf_obj = MT::Mailpackaddress->load;
        foreach (@buf_obj) {
            if ($setting_id <= $_->setting_id) { $setting_id = $_->setting_id; $setting_id++; }
        }
        foreach (@category_ids) {
            my $set_mail = MT::Mailpackaddress->new;
            $set_mail->setting_id($setting_id);
            $set_mail->blog_id($setting_blog_id);
            $set_mail->email($setting_email);
            $set_mail->pop3($setting_pop3);
            $set_mail->user($setting_user);
            $set_mail->pass($setting_pass);
            $set_mail->category_id($_);
            $set_mail->author_id($author_id);
            $set_mail->modified_on($modified_on);
            $set_mail->created_on($created_on);
            $set_mail->save;
       }
    }
    return $app->redirect($app->path."plugins/MailPack/mailpack.cgi");
}

sub mpack_del {
    my $plugin = MT::Plugin::MailPack->instance;
    my ($app) = @_;

    # システム管理者チェック
    $app->user->is_superuser or return $app->error($app->translate("Permission denied."));

    # 設定値取得
    my $q = $app->{query};
    # パラメータ名全取得
    my @p_name = $q->param();
    my @id = $q->param('id');
    foreach my $setting_id (@id) {
        my @settings = MT::Mailpackaddress->load({setting_id=>$setting_id});
        $_->remove for @settings;
    }
    return $app->redirect($app->path."plugins/MailPack/mailpack.cgi");
}

# Write Log --------------------------------------
sub writelog {
	my ($log_level,$log_time,$log_msg) = @_;

	my $log = MT::Log->new();
	$log->level($log_level);
	if ($log_time == 0){
		$log_time = time();
	}
	my @ts = gmtime($log_time);
	my $ts = sprintf '%04d%02d%02d%02d%02d%02d', $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];

	$log->modified_on($ts);
	$log->message($log_msg);
	$log->save or die $log->errstr;
}
#-------------------------------------------------

1;