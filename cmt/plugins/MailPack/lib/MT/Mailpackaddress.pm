package MT::Mailpackaddress;
use strict;
use warnings;

use MT::Object;
@MT::Mailpackaddress::ISA = qw(MT::Object);

__PACKAGE__->install_properties ({
    column_defs => {
        'id' => 'integer not null auto_increment',
        'setting_id' => 'integer not null',
        'pop3' => 'string(255) not null',
        'user' => 'string(255) not null',
        'pass' => 'string(255) not null',
        'email' => 'string(75) not null',
        'port' => 'string(8) not null',
        'ssl_flg' => 'integer not null',
        'blog_id' => 'integer not null',
        'category_id' => 'integer',
        'author_id' => 'integer not null',
        'filter_type' => 'integer',
        'assist_id' => 'integer',
        'created_on' => 'datetime',
        'modified_on' => 'datetime',
    },
    indexes => {
        setting_id => 1,
        pop3 => 1,
        user => 1,
        pass => 1,
        email => 1,
        port => 1,
        ssl_flg => 1,
        blog_id => 1,
        category_id => 1,
        author_id => 1,
        filter_type => 1,
        assist_id => 1,
        created_on => 1,
        modified_on => 1,
    },
    datasource => 'mailpackaddress',
    primary_key => 'id',
});

sub class_label {
    'Mailpack Address Book';
}

1;
__END__
