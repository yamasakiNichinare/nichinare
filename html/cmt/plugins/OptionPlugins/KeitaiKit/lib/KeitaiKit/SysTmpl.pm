package KeitaiKit::SysTmpl;
use strict;


sub has_emoji {
    my $self = shift;
    my $str = shift;
    
    my @str = unpack('C*', $str);
    my $len = length($str);
    my $i = 0;
    
    $_ = $ENV{HTTP_USER_AGENT};
    
    while($i < $len -1) {
        my $c1 = $str[$i];
        my $c2 = $str[$i + 1];
        
        if((0x81 <= $c1 && $c1 <= 0x9f) || (0xe0 <= $c1 && $c1 <= 0xef)) {

            $i++;
        } else {
            my $s = $c1 * 256 + $c2;
            if(0xf040 <= $s && $s <= 0xf9fc) {

                return 1;
            } elsif(/^Vodafone\//i || /^SoftBank\//i || /^J\-PHONE\//i || /^MOT\-/i) {

                if((0xfb41 <= $s && $s <= 0xfbde) || $s == 0x1b24) {
                    return 1;
                }
            }
        }
        $i++;
    }
    return 0;
}

1;