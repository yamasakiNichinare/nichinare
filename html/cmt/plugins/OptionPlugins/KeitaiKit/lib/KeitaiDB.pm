package KeitaiDB;
use strict;


my $symbols;



sub new {
    my $class = shift;
    my $self = bless {}, $class;


    $self->{path} = shift;
    
    $self->{spec} = {};
    $self->{emoji} = {};
    $self->{iemoji} = {};
    $self->{resolution} = 0;
    
    return $self;
}

sub refSpec {
    my %spec = (
            'code' => '',
            'model' => 'UNKNOWN',
            'sw' => 240,
            'sh' => 320,
            'bw' => 230,
            'bh' => 320,
            'colors' => 6,
            'flashv' => 110,
            'flashs' => 100,
            'cache' => 100,
            'format1' => 600,
            'format2' => 200,
            'img' => 3,
            'mov' => 1,
            'pict' => 2
               );

    return \%spec;
}

sub errorEmoji {
    my $err = shift;
    my %emoji = (
            'symbol' => '',
            'isjis' => 0,
            'iuni' => 0,
            'ez' => 0,
            's' => 0,
            'gaiji' => 0,
            'text' => "[Err:$err]"
                 );
    
    return \%emoji;
}

sub findSpec {
    my ($self, $code) = @_;
    

    if( exists($self->{spec}->{$code}) ) {
        return $self->{spec}->{$code};
    }
    
    my %record;
       

    open(FP, "<" . $self->{path} . "/spec.db")
        || return ($self->{spec}->{$code} = refSpec());
    

    my $buf;
    read(FP, $buf, 5);
    
    my ($size, $version) = unpack('NC', $buf);
    

    while(!eof(FP)) {

        read(FP, $buf, 2);
        last if(length($buf) < 2);
        my ($size) = unpack('n', $buf);
        read(FP, my $id, $size);
        

        read(FP, $buf, 2);
        ($size) = unpack('n', $buf);
        
        if($id eq $code) {

            read(FP, $buf, 2);
            my ($len) = unpack('n', $buf);
            read(FP, $record{model}, $len);
            

            $record{code} = $code;
            

            read(FP, $buf, $size - $len);
            ($record{sw}, $record{sh}, $record{bw}, $record{bh}, $record{colors},
                $record{flashv}, $record{flashs}, $record{cache},
                $record{format1}, $record{format2},
                $record{img}, $record{mov}, $record{pict}) = unpack('n4cn7c', $buf);
        } elsif($size) {

            seek(FP, $size, 1);
        }
    }
    

    close(FP);
    

    return ($self->{spec}->{$code} = refSpec()) if 0 == keys %record;
    

    $self->{spec}->{$code} = \%record;
    
    return \%record;
}

sub isEmoji {
    my ($symbol) = @_;


    if(!defined($symbols)) {

        my %symbols = map {$_ => 1} qw(sun cloud rain snow thunder typhoon mist drizzle aries taurus gemini cancer leo virgo libra scorpio sagittarius capricorn aquarius pisces marathon baseball golf tennis soccer ski basketball motor pager train metro superexpress sedan rvcar bus ship airplane house bullding postoffice hospital bank atm hotel cvs gs parking trafficlight toilet restaurant cafe bar beer fastfood boutique hairsalon karaoke movie rightup playland music art drama event ticket smoking nosmoking camera bag book ribbon present birthday telephone mobilephone memo tv game cd heart spade diamond club eye ear stone scissors paper rightdown leftup foot shoe glasses wheelchair newmoon crackmoon dichotomy crescent fullmoon dog cat boat xmas leftdown phoneto mailto faxto imode imode2 mail docomo1 docomo2 check free lockkey password return clear search new geoflag freedial poundnumber mobileq 1 2 3 4 5 6 7 8 9 0 ok normalheart lovelyheart breakheart hearts ureshii okotta rakutan kanashii furafura increase melody hotspring lovely kissmark sparkle hirameki angry punch bomb melodies reduce zzz exclamation exandques exclamation2 impact rush sudor dash wave ringwave clapper sack pen shadow chair night soonmark onmark endmark clock iappli iappli2 tshirts pouch makeup jeans snowboard chapel door dollerbag pc loveletter wrench pencil crown ring sandclock bicycle yunomi watch thinkingface confidentface coldsweat coldsweat2 pukkuri bokee hearteyes thumbsign akkanbee wink happyface patientface catface cringface droptear ngmark clip copyright trademark runner confidential recycle resistered danger keepout vacancy pass novacancy rightleft updown school seawave fuji clover cherry tulip banana apple germ autumn sakura riceball shortcake sake donburi bread snail chick penguin fish delicious usshisshi horse pig wine scream);
        $symbols = \%symbols;
    }


    return $symbols->{$symbol}? 1: 0;
}


sub findEmoji {
    my ($self, $symbol) = @_;
    

    $symbol = 'bullding' if $symbol eq 'building';


    if( exists($self->{emoji}->{$symbol}) ) {
        return $self->{emoji}->{$symbol};
    }
       

    open(FP, "<" . $self->{path} . "/emoji.db")
        || return ($self->{emoji}->{$symbol} = errorEmoji('emoji.db is not found'));
    

    my $buf;
    read(FP, $buf, 5);
    
    my ($size, $version) = unpack('NC', $buf);
    
    my %record;
    

    while(!eof(FP)) {

        read(FP, $buf, 2);
        last if(length($buf) < 2);
        my ($size) = unpack('n', $buf);
        read(FP, my $id, $size);
        

        read(FP, $buf, 2);
        ($size) = unpack('n', $buf);
        
        if($id eq $symbol) {

            $record{symbol} = $symbol;


            read(FP, $buf, 12);
            ($record{isjis}, $record{iuni}, $record{ez}, $record{s}, $record{gaiji}, $size) = unpack('n6', $buf);
            read(FP, $record{text}, $size);
        } else {

            seek(FP, $size, 1);
        }
    }
    

    close(FP);
    

    return ($self->{emoji}->{$symbol} = errorEmoji("$symbol is not found")) if 0 == keys %record;
    

    $self->{emoji}->{$symbol} = \%record;
    
    return \%record;
}

sub findIEmoji {
    my ($self, $icode) = @_;
    

    if( exists($self->{iemoji}->{$icode}) ) {
        return $self->{iemoji}->{$icode};
    }
       

    open(FP, "<" . $self->{path} . "/iemoji.db")
        || return ($self->{iemoji}->{$icode} = '');
    

    my $buf;
    read(FP, $buf, 5);
    
    my ($size, $version) = unpack('NC', $buf);
    
    my $symbol='';
    

    while(!eof(FP)) {

        read(FP, $buf, 2);
        last if(length($buf) < 2);
        my ($id) = unpack('n', $buf);
        

        read(FP, $buf, 2);
        ($size) = unpack('n', $buf);
        
        if($id eq $icode) {

            read(FP, $buf, 2);
            $size = unpack('n', $buf);
            read(FP, $symbol, $size);
        } else {

            seek(FP, $size, 1);
        }
    }
    

    close(FP);
    

    $self->{iemoji}->{$icode} = $symbol;
    
    return $symbol;
}

sub getResolution {
    my $self = shift;
    
    if( $self->{resolution} ) {
        return $self->{resolution};
    }
    
    my %resolution;


    open(FP, "<" . $self->{path} . "/resolution.db")
        || return \%resolution;
    

    my $buf;
    read(FP, $buf, 5);
    my ($size, $version) = unpack('NC', $buf);
    
    while(!eof(FP)) {

        read(FP, $buf, 6);
        my ($bw, $bh, $count) = unpack('nnn', $buf);
        $resolution{$bw . 'x' . $bh} = $count;
    }
    

    close(FP);
    

    $self->{resolution} = \%resolution;
    
    return \%resolution;
}

sub searchSpec {
    my ($self, $carrier, $format1, $format2, $include, $exclude) = @_;
    
    my @records = ();
    my %models = ();
    my %include = map { $_ => 1 } @$include;
    my %exclude = map { $_ => 1 } @$exclude;
       

    open(FP, "<" . $self->{path} . "/spec.db")
        || return [];
    

    my $buf;
    read(FP, $buf, 5);
    
    my ($size, $version) = unpack('NC', $buf);
    

    while(!eof(FP)) {
    

        read(FP, $buf, 2);
        last if(length($buf) < 2);
        my ($size) = unpack('n', $buf);
        read(FP, my $id, $size);
        

        read(FP, $buf, 2);
        ($size) = unpack('n', $buf);
        
        my ($c, $code) = split(//, $id, 2);
        if($c eq 'e') {
        	$c = 'ez';
        	(undef, $code) = split(//, $code, 2);
        }
        if($c eq $carrier && !$exclude{$code}) {
            my %record;
            

            read(FP, $buf, 2);
            my ($len) = unpack('n', $buf);
            read(FP, $record{model}, $len);
            

            $record{code} = $code;
            

            read(FP, $buf, $size - $len - 2);
            ($record{sw}, $record{sh}, $record{bw}, $record{bh}, $record{colors},
                $record{flashv}, $record{flashs}, $record{cache},
                $record{format1}, $record{format2},
                $record{img}, $record{mov}, $record{pict}) = unpack('n4cn7c', $buf);
            

            if(!$models{$record{model}} && ($include{$code} || ($record{format1} >= $format1 && $record{format2} >= $format2))) {
                push @records, \%record;
                

                $models{$record{model}} = 1;
            }
        } else {

            seek(FP, $size, 1);
        }
    }
    

    close(FP);
    
    return \@records;
}

1;
