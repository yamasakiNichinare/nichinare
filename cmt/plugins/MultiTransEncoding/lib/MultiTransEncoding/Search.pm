package MultiTransEncoding::Search;

# 2008.08.23 version 1.00
#
# Convart search-templates for charset of MultiTransEncoding.
#

use strict;

use MT;
use MT::App;
use MT::I18N;
use MultiTransEncoding;
use base qw( MT::App::Search );

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
}

sub init_request{
     my $app = shift;

     MT::App::init_request($app,@_);
     $app->{init_request} = 1;
         my $q = $app->param;
         my $search  = $q->param('search') || '';
         my $blog_id = $q->param('IncludeBlogs') =~ /^(\d+)/ ? $1  : 0;
         my $charset_id = MultiTransEncoding::load_blog_charset_id( $blog_id );
         my $code = MultiTransEncoding::get_code_by_id( $charset_id );
         if( $search && $charset_id ){
             if( $app->version_number =~ /^5/ ){
                require Encode;
                $search = MT::I18N::utf8_off( $search ) if Encode::is_utf8( $search );
             }
             $q->param('search' ,  MT::I18N::encode_text($search ,$code ,MT->instance->charset ));
             $app->{MultiTransEncodingID}     = $charset_id;
             $app->{MultiTransEncodingCode}   = $code;
             $app->{MultiTransEncodingName}   = MultiTransEncoding::get_name_by_id( $charset_id );
             $app->{MultiTransEncodingMTCode} = MT->instance->charset;
         }
    $app->SUPER::init_request(@_);
}

sub send_http_header{
   my $app = shift;
   if( exists $app->{MultiTransEncodingID} && $app->{MultiTransEncodingID} ){
       $app->charset( $app->{MultiTransEncodingName} );
       return $app->SUPER::send_http_header( @_ );
   }
   return $app->SUPER::send_http_header( @_ );
}

sub throttle_response {
  my $app = shift;
  my $errmsg = $app->SUPER::throttle_response( @_ );
  if( exists $app->{MultiTransEncodingID} && $app->{MultiTransEncodingID} ){
      if( $app->version_number =~ /^5/ ){
         require Encode;
         $errmsg = MT::I18N::utf8_off( $errmsg ) if Encode::is_utf8( $errmsg );
      }
      $errmsg = MT::I18N::encode_text( $errmsg  , $app->{MultiTransEncodingMTCode} , $app->{MultiTransEncodingCode} );
  }
  return $errmsg;
}

sub print {
  my $app = shift;
  return $app->print_mt5( @_ ) if $app->version_number =~ /^5/;
  return $app->print_mt4( @_ );
}

sub print_mt4 {
  my ( $app , $body ) = @_;
  if( exists $app->{MultiTransEncodingID} && $app->{MultiTransEncodingID} ){
      $body = MT::I18N::encode_text( $body  , $app->{MultiTransEncodingMTCode} , $app->{MultiTransEncodingCode} );
  }
  return $app->SUPPER::print( $body );
}
sub print_mt5 {
   my ( $app , $body ) = @_;
   if( exists $app->{MultiTransEncodingID} && $app->{MultiTransEncodingID} ){
      require Encode;
      $body = MT::I18N::utf8_off( $body ) if Encode::is_utf8( $body );
      $body = MT::I18N::encode_text( $body  , $app->{MultiTransEncodingMTCode} , $app->{MultiTransEncodingCode} );
   }
   $app->SUPER::print( $body );
}

## version 5 use
sub print_encode {
   my $app = shift;
   return $app->print( @_ );
}
1;
