package KeitaiKit::J10N;
use strict;
use base 'MT::L10N';
use vars qw( %Lexicon );

sub maketext {
    my $lh = shift;
    my $str;
    eval { $str = $lh->SUPER::maketext(@_); };
    if ($@) {
        my $mt_lh = MT->language_handle;
        $str = $mt_lh->maketext(@_);
    }
    $str;
}

%Lexicon = ();

1;
