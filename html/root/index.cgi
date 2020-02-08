#!/usr/bin/perl

require '../../sys-perl/require.pl';
use lib '../../sys-perl/lib';

our %http = (    # URL������
    'htdocs' => '..',
    'ajax'   => '../ajax',
    'css'    => '.',
);

#------------------
# ���̎ގَ������ɤ߹���
#------------------
require $_ for ( glob("$dir{'include'}/*.pl"));
require $_ for ( glob("$dir{'conf'}/*.pl"));

our $TIMEOUT;
$TIMEOUT = 60 * 60;

#------------------
# ư��ώݎĎ��ɤ߹���
#------------------
our %cmd;
hash_IO( \%cmd, "$dir{'script'}/root/cmd.ini", 'e' );
require "$dir{'script'}/root/lib.pl";

#---------------
# �Îގ����͎ގ�������³
#---------------
connectDB();

#------------------
# �̎����юÎގ����ɤ߹���
#------------------
our %in;
Parse();

our %login;
%login = Cookies('lo');

if ( $in{'c'} ne 'login-2' ) {
    if ( !$login{'pk'} ) {
        $in{'c'} = 'login-1';
    }
    elsif ( length $login{'sid'} != 30 ) {
        $in{'c'} = 'login-1';
    }
    elsif ( $login{'exp'} < time - $TIMEOUT ) {    # >
        our %admin_user;
        %admin_user = _HTML_escape( readData( $login{'pk'}, 'admin_user' ));
        $in{'c'} = 'login-5';
    }
    else {
        our %admin_user;
        %admin_user = _HTML_escape( readData( $login{'pk'}, 'admin_user' ));

        if ( $admin_user{'pk'} ) {
            if ( $admin_user{'SID'} eq $login{'sid'} ) {    # *
                $admin_user{'LOGIN_TIME'} = &DATETIME;
                replaceData( \%admin_user, 'admin_user' );

                $login{'exp'} = time;
                Write_Cookies(
                    -name  => 'lo',
                    -value => \%login,
                );
            }         # *
            else {    # *
                $in{'c'} = 'login-4';    # *
            }    # *
        }
        else {
            $in{'c'} = 'login-1';
        }
    }
}

#---------------
# ���ώݎĎ޼¹�
#---------------
our %replace;
our $HTML;

exe( $in{'c'} );

#------------------
# �Îގ����͎ގ�����������
#------------------
disconnectDB();

#------------------
# HTML�ν���
#------------------
$HTML              ||= '_.htm';
$replace{'title'}  ||= '';
$replace{'htdocs'} ||= $http{'htdocs'};
$replace{'ajax'}   ||= $http{'ajax'};
$replace{'css'}    ||= $http{'css'};

my $template = HTML::Template->new(
   loop_context_vars => 1,
   die_on_bad_params => 0,
    filename => $HTML,
);

for my $key ( keys %replace ) {
    $template->param( $key => $replace{$key} );
}

print "Content-Type: text/html\n\n";
print $template->output;
exit;

1;
