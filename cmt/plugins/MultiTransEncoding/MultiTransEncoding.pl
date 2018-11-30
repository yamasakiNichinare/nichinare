package MT::Plugin::MultiTransEncoding;

#==========================================================================================
# MultiTransEncoding ブログ単位でパブリッシュ用の文字コードを設定可能にする
#
#  Copyright (c) 2008 SKYARC System Co.,Ltd.
#==========================================================================================

use strict;

use MT;
use MT::Plugin;

use MT::App;
use MT::Template::Context;
use MT::I18N;
use MultiTransEncoding;

use vars qw( $PRODUCT_NAME $PRODUCT_VERSION $PRODUCT_DESC $VENDOR_NAME $VENDOR_SITE $KEYCODE );
$PRODUCT_NAME    = 'Multi Trans Encoding';
$PRODUCT_VERSION = '1.29';
$PRODUCT_DESC    = 'Blog publishing units can be set for the character code.';
$VENDOR_NAME     = 'Copyright (c) 2008 SKYARC System Co.,Ltd.';
$VENDOR_SITE     = 'http://www.skyarc.co.jp';
$KEYCODE         = $MultiTransEncoding::TRANSENCODE_KEYCODE;

#------------------------------------------------------------------------------------------
# Plugin Setting
#------------------------------------------------------------------------------------------
use base qw(MT::Plugin);
my $plugin = __PACKAGE__->new ({
    name           => $PRODUCT_NAME,
    version        => $PRODUCT_VERSION,
    key            => $KEYCODE,
    id             => $KEYCODE,
    author_name    => $VENDOR_NAME,
    author_link    => $VENDOR_SITE,
    description    => '<MT_TRANS phrase="'. $PRODUCT_DESC. '">',
    l10n_class     => 'MultiTransEncoding::L10N',
    settings       => new MT::PluginSettings([
        [ 'charcode', { Default => 0, Scope => 'blog' }],
    ]),
    blog_config_template    => 'blog_config.tmpl',
});
MT->add_plugin ($plugin);

sub init_registry {
  my $plugin = shift;
  $plugin->registry({
        tags => {
            function => {
                #override
                'PublishCharset'  => \&_hdlr_blog_charcter_set,
#                'SearchScript'    => \&_hdlr_search_script,   # mt5 simple supoort.
#                'CommentScript'   => \&_hdlr_comment_script,  # mt5 no support.
             },
        },
 });
}
MT->add_callback ('BuildPage', 8 , $plugin, \&_hdlr_multi_trans_encoding);

#------------------------------------------------------------------------------------------
# MTPublishCharaset tag override
#------------------------------------------------------------------------------------------
sub _hdlr_blog_charcter_set {
     my ($ctx, $args, $cond) = @_;

     my $blog_id = $ctx->stash('blog_id') || 0;
     my $app = MT->instance;
     my $id = 0;
     unless ( $app->isa('MT::App::CMS') 
         && $app->mode =~ m/preview_template|preview_entry|approval_preview/ ){
         $id = MultiTransEncoding::load_blog_charset_id ($blog_id);
     }
     return MultiTransEncoding::get_name_by_id ($id);
}
#------------------------------------------------------------------------------------------
# MTSearchScript tag override
#------------------------------------------------------------------------------------------
sub _hdlr_search_script {
     my ($ctx, $args, $cond) = @_;

     my $blog_id = $ctx->stash ('blog_id') || 0;
     my $id = MultiTransEncoding::load_blog_charset_id ($blog_id);
     return 'plugins/'. $1. '/mt-multi_trans_encoding_search.cgi'
        if $id && __FILE__ =~ /plugins[\/\\](.*?)[\/\\].*$/;

     return MT::Template::Tags::System::_hdlr_search_script ($ctx, $args, $cond)
        if MT->version_number =~ /^5/;
     return $ctx->_hdlr_search_script ($args ,$cond);
}

#------------------------------------------------------------------------------------------
# MTCommentScript tag override
#------------------------------------------------------------------------------------------
sub _hdlr_comment_script {
     my ($ctx, $args, $cond) = @_;

     my $blog_id = $ctx->stash('blog_id') || 0;
     my $id = MultiTransEncoding::load_blog_charset_id( $blog_id );
     return 'plugins/'. $1. '/mt-multi_trans_encoding_comments.cgi'
        if $id && __FILE__ =~ /plugins[\/\\](.*?)[\/\\].*$/;

     return MT::Template::Tags::System::_hdlr_comment_script ($ctx , $args , $cond)
        if MT->version_number =~ /^5/;
     return $ctx->_hdlr_comment_script ($args ,$cond);
}



#------------------------------------------------------------------------------------------
# PublishCharaset id load
#------------------------------------------------------------------------------------------
sub load_config {
    my $plugin = shift;
    my ($args, $scope) = @_;

    $plugin->SUPER::load_config (@_);
    if ($scope =~ /blog:(\d+)/) {
        my $blog_id = $1;
        my $id = MultiTransEncoding::load_blog_charset_id ($blog_id);
        my $option_list = '';
        foreach my $set (@MultiTransEncoding::TRANSENCODE_CHARSET) {
           $option_list .= '<option value="'. $set->{id}. '"'. ($set->{id} == $id ? ' selected="selected" >' : '>').
                $plugin->translate_templatized ('<MT_TRANS phrase="'. $set->{name}. '">'). '</option>\n';
        }
        $args->{trans_encoding_charset_list} = $option_list;
    }
}

#------------------------------------------------------------------------------------------
# PublishCharset id save
#------------------------------------------------------------------------------------------
sub save_config {
    my $plugin = shift;
    my ($args, $scope) = @_;

    $plugin->SUPER::save_config (@_);
    if ($scope =~ /blog:\d+/) {
        my $code = $args->{trans_encoding_charset} =~ /(\d+)/ ? $1 : 0;
        $plugin->set_config_value ('charcode', $code, $scope);
    }
}

sub DoFile{
  my $b = shift;
  my $file = shift || 'debug.txt';
  open FH , '> /var/www/html/'. $file;
  print FH $b;
  close FH;
}

#------------------------------------------------------------------------------------------
# get charset data
#------------------------------------------------------------------------------------------
sub get_name {
    my ( $plugin , $blog_id ) = @_;
    my $id = MultiTransEncoding::load_blog_charset_id ( $blog_id ) || 0;
    return MultiTransEncoding::get_name_by_id($id);
}
sub get_code {
    my ( $plugin , $blog_id ) = @_;
    my $id = MultiTransEncoding::load_blog_charset_id ( $blog_id ) || 0;
    return MultiTransEncoding::get_code_by_id($id);
}
#-------------------------------------------------------------------------------------------
# tranc encoding
#-------------------------------------------------------------------------------------------
sub _hdlr_multi_trans_encoding {
    my $eh = shift;
    my %args = @_;
    my $content = $args{Content};
    my $ctx = $args{Context};
    my $text = $$content;

    return 1 if $ctx->stash( 'MultiTransEncodingLoaded' );

    # BlogID
    my $blog_id = $args{Blog}->id;

    # Blog Scope Charset
    my $id = MultiTransEncoding::load_blog_charset_id ($blog_id)
        or return 1;

    my $code = MultiTransEncoding::get_code_by_id ($id);
    return 1 if $code =~ /DEFAULT/i;


    ## PageBute Plugin Support.
    my $pb = $ctx->stash('PageBute') || 0;
    if( $pb ){
         $pb->{trans_encode} = 1;
         $pb->{trans_encode_system} = MultiTransEncoding::get_code_by_id(0);
         $pb->{trans_encode_output} = $code;
         $pb->{trans_encode_filter} = \&version_encode;
         return 1;

    }
    $$content = version_encode( $text , $code );
    $ctx->stash('MultiTransEncodingLoaded' , 1 );
    return 1;
}

sub change_entity {
    my $clsss = shift if ref $_[0] eq __PACKAGE__;      
    my ( $text , $system , $code ) = @_;

    ## UTF-8 >> EUC
    if ( $system eq 'UTF-8' && ( $code eq 'euc' || $code eq 'sjis' ) ) {
        $text =~ s/(〜|～)/&#12316;/g;
        $text =~ s/－/&#12540;/g;
    }
    return $text;
}

sub version_encode {
    my ( $text , $code ) = @_;
    my $system =  MultiTransEncoding::get_code_by_id(0);
    return MT::I18N::encode_text( 
          change_entity( 
             MT->version_number =~ /^5/ && MT::I18N::is_utf8( $text ) ? MT::I18N::utf8_off( $text ) : $text , 
             $system,
             $code ),
          $system , $code , );
}

=pod
### MT::Log
sub doLog {
    my ($message , $metadata ) = @_;

    $metadata ||= '';

    my $log = new MT::Log;
    $log->message ($message);
    $log->ip ($ENV{REMOTE_ADDR});
    $log->blog_id (0);
    $log->author_id (1);
    $log->level (MT::Log::INFO());
    $log->category ('MultiTransEncoding');
    $log->class ('system');
    my @t = gmtime;
    my $ts = sprintf '%04d%02d%02d%02d%02d%02d', $t[5]+1900,$t[4]+1,@t[3,2,1,0];
    $log->created_on ($ts);
    $log->created_by (1);
    $log->metadata( $metadata ) if $metadata;
    $log->save;
}
=cut

1;
