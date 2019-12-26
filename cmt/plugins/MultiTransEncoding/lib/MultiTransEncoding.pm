package MultiTransEncoding;

use MT;
use MT::Template::Context;

#------------------------------------------------------------------------------------------
# Setting Charset of MultiTransEncoding
#
# id  :Save the database
# name:MTPublishCharset-tag output
#     : equoal MT::I18N::ENCODING_NAMES hash {display_name}
# code: equoal MT::I18N::ENCODING_NAMES hash {name}
#------------------------------------------------------------------------------------------

our @TRANSENCODE_CHARSET = (
 { id => '0000' , name => 'MovableType Publish CharacterCode' , code => 'DEFAULT'  },
 { id => '0001' , name => 'utf-8'                             , code => 'utf8'     },
 { id => '0002' , name => 'Shift-JIS'                         , code => 'sjis'     },
 { id => '0003' , name => 'euc-jp'                            , code => 'euc'      },
 { id => '0004' , name => 'iso-8859-1'                        , code => 'ascii'    },
);
our $TRANSENCODE_KEYCODE = 'MultiTransEncoding';

#------------------------------------------------------------------------------------------
# Get PublishCharaset: MultiTransEncoding Charset Name
#------------------------------------------------------------------------------------------
sub get_name_by_id {
    my $id = shift;
    
    $id = $id =~ /(\d+)/ ? $1 : 0;
    my $ctx = MT::Template::Context->new;
    my $name = $ctx->{config}->PublishCharset || 'utf-8';
    return $name unless $id + 0;
    my %charset;
    map { $charset{$_->{id}} = $_->{name} } @TRANSENCODE_CHARSET;
    return $charset{$id};
}
#------------------------------------------------------------------------------------------
# Get PublishCharaset: MultiTransEncoding Charset Code
#------------------------------------------------------------------------------------------
sub get_code_by_id {
    my $id = shift;

    $id = $id =~ /(\d+)/ ? $1 : 0;
    my $code = MT->instance->config('PublishCharset') || 'utf-8';
    return $code unless $id + 0;
    map { $charset{$_->{id}} = $_->{code} } @TRANSENCODE_CHARSET;
    return $charset{$id};
}

#------------------------------------------------------------------------------------------
# Get PublishCharaset: MultiTransEncoding Charset ID at blog
#------------------------------------------------------------------------------------------
sub load_blog_charset_id {
   my $blog_id = shift;

   return 0 unless $blog_id;
   require MT::PluginData;
   my $data = MT::PluginData->load( {plugin => $TRANSENCODE_KEYCODE , key => 'configuration:blog:'.$blog_id} ) or return 0;
   my $chr = $data->data;
   return $chr->{charcode} =~/(\d+)/ ? $1 : 0;

}

1;
