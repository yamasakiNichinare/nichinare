package quemgr;

use strict;
use warnings;
use Exporter;
@quemgr::ISA = qw( Exporter );
use vars qw( @EXPORT_OK );
@EXPORT_OK = qw( quemgr );
use listner qw( getmail );
use cleanup qw( analisismail );
use create qw( createblogque );
use post_entry qw( post_entry );
use notification qw( notification_mail );
use logmgr qw( logmgr add_logque );

sub quemgr {
    my $plugin = shift;
    my (@maildrop, @inbound, @outbound, @logque);
    my ($maildrop_ref, $inbound_ref, $outbound_ref, $logque_ref, $entry_ref);
    eval {
        ($maildrop_ref, $logque_ref) = getmail ($plugin);
        ($inbound_ref, $logque_ref) = analisismail ($plugin, $maildrop_ref, $logque_ref);
        ($outbound_ref, $logque_ref) = createblogque ($plugin, $inbound_ref, $logque_ref);
        ($entry_ref, $logque_ref) = post_entry ($plugin, $outbound_ref, $logque_ref);
        $logque_ref = notification_mail ($plugin, $entry_ref, $logque_ref);
        logmgr ($plugin, $logque_ref);

        # Temporaly directory
        my $tmpdir  = __FILE__;
        $tmpdir =~ s![\/\\]quemgr\.pm$!!;
        $tmpdir .= '/tmp/';
        # make sure to empty in directory
        if (opendir DIR, $tmpdir) {
            map { unlink $tmpdir.$_ if -f $tmpdir.$_; } readdir DIR;
            closedir DIR;
        }
        # remove directory
        rmdir $tmpdir if -d $tmpdir;
    };
    if ($@) {
        my $log = MT::Log->new;
        $log->message ('MailPack: ' . $@);
        $log->level (MT::Log->WARNING());
        MT->log ($log);
    }
}

1;
