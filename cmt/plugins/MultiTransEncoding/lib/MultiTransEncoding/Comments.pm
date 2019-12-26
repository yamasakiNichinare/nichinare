package MultiTransEncoding::Comments;

# 2008.08.23 version 1.00
#
# Convart comments-templates for charset of MultiTransEncoding.
#

use strict;

use MT;
use MT::App;
use MT::Entry;
use MT::I18N;
use MultiTransEncoding;
use base qw( MT::App::Comments );

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
}

sub init_request{
     my $app = shift;
     $app->SUPER::init_request(@_);

     my $q   = $app->param;
     my $entry_id = $q->param('entry_id') =~ /^(\d+)/ ? $1  : 0;
     my $entry    = MT::Entry->load( { id => $entry_id } );
     my $blog_id  = $entry->blog_id || 0;
     my $charset_id = MultiTransEncoding::load_blog_charset_id( $blog_id );
     my $code = MultiTransEncoding::get_code_by_id( $charset_id );

     my $query_author = $q->param('author') || '';
     my $query_text = $q->param('text') || '';

     if($charset_id ){
          $q->param('author' ,  MT::I18N::encode_text($query_author ,$code ,MT->instance->charset )) if $query_author;
          $q->param('text' ,  MT::I18N::encode_text($query_text ,$code ,MT->instance->charset )) if $query_text;
          $app->{MultiTransEncodingID}     = $charset_id;
          $app->{MultiTransEncodingCode}   = $code;
          $app->{MultiTransEncodingName}   = MultiTransEncoding::get_name_by_id( $charset_id );
          $app->{MultiTransEncodingMTCode} = MT->instance->charset;
      }
}

sub send_http_header{
   my $app = shift;
   if( exists $app->{MultiTransEncodingID} && $app->{MultiTransEncodingID} ){
       $app->charset( $app->{MultiTransEncodingName} );
       return $app->SUPER::send_http_header( @_ );
       
   }
   return $app->SUPER::send_http_header( @_ );
}

1;