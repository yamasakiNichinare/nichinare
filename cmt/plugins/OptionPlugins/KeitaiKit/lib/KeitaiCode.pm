package KeitaiCode;
use strict;

sub s_webcode_to_sjis {
	my ($wc) = @_;
	my $sjis = 0;
	
	my ($c1, $c2) = (int($wc / 256), $wc % 256);
	

	$c2 -= 0x21;
	
	if($c1 == 0x47) {

		$sjis = 0xf941 + $c2;
		$sjis++ if $c2 > 0x3d;
	} elsif($c1 == 0x45) {

		$sjis = 0xf741 + $c2;
		$sjis++ if $c2 > 0x3d;
	} elsif($c1 == 0x46) {

		$sjis = 0xf7a1 + $c2;
	} elsif($c1 == 0x4f) {

		$sjis = 0xf9a1 + $c2;
	} elsif($c1 == 0x50) {

		$sjis = 0xfb41 + $c2;
		$sjis++ if $c2 > 0x3d;
	} elsif($c1 == 0x51) {

		$sjis = 0xfba1 + $c2;
	}
	
	$sjis;
}

sub s_webcode_to_unicode {
	my ($wc) = @_;
	my $unicode = 0;
	
	my ($c1, $c2) = (int($wc / 256), $wc % 256);
	

	$c2 -= 0x21;
	
	if($c1 == 0x47) {

		$unicode = 0xe001 + $c2;
	} elsif($c1 == 0x45) {

		$unicode = 0xe101 + $c2;
	} elsif($c1 == 0x46) {

		$unicode = 0xe201 + $c2;
	} elsif($c1 == 0x4f) {

		$unicode = 0xe301 + $c2;
	} elsif($c1 == 0x50) {

		$unicode = 0xe401 + $c2;
	} elsif($c1 == 0x51) {

		$unicode = 0xe501 + $c2;
	}
	
	$unicode;
}

sub s_sjis_to_webcode {
	my ($sjis) = @_;
	my $webcode = 0;
	
	my ($c1, $c2) = (int($sjis / 256), $sjis % 256);
	
	if($c1 == 0xf7) {
		if($c2 >= 0x41 && $c2 <=0x9b) {

			$webcode = 0x4521 + $c2 - 0x41;
			$webcode-- if $c2 >= 0x80;
		} elsif($c2 >= 0xa1 && $c2 <= 0xf3) {

			$webcode = 0x4621 + $c2 - 0xa1;
		}
	} elsif($c1 == 0xf9) {
		if($c2 >= 0x41 && $c2 <=0x9b) {

			$webcode = 0x4721 + $c2 - 0x41;
			$webcode-- if $c2 >= 0x80;
		} elsif($c2 >= 0xa1 && $c2 <= 0xf3) {

			$webcode = 0x4f21 + $c2 - 0xa1;
		}
	} elsif($c1 == 0xfb) {
		if($c2 >= 0x41 && $c2 <=0x9b) {

			$webcode = 0x5021 + $c2 - 0x41;
			$webcode-- if $c2 >= 0x80;
		} elsif($c2 >= 0xa1 && $c2 <= 0xf3) {

			$webcode = 0x5121 + $c2 - 0xa1;
		}
	}
	
	$webcode;
}

sub s_sjis_to_unicode {
	my ($sjis) = @_;
	my $unicode = 0;
	
	my ($c1, $c2) = (int($sjis / 256), $sjis % 256);
	
	if($c1 == 0xf7) {
		if($c2 >= 0x41 && $c2 <=0x9b) {

			$unicode = 0xe101 + $c2 - 0x41;
			$unicode-- if $c2 >= 0x80;
		} elsif($c2 >= 0xa1 && $c2 <= 0xf3) {

			$unicode = 0xe201 + $c2 - 0xa1;
		}
	} elsif($c1 == 0xf9) {
		if($c2 >= 0x41 && $c2 <=0x9b) {

			$unicode = 0xe001 + $c2 - 0x41;
			$unicode-- if $c2 >= 0x80;
		} elsif($c2 >= 0xa1 && $c2 <= 0xf3) {

			$unicode = 0xe301 + $c2 - 0xa1;
		}
	} elsif($c1 == 0xfb) {
		if($c2 >= 0x41 && $c2 <=0x9b) {

			$unicode = 0xe401 + $c2 - 0x41;
			$unicode-- if $c2 >= 0x80;
		} elsif($c2 >= 0xa1 && $c2 <= 0xf3) {

			$unicode = 0xe501 + $c2 - 0xa1;
		}
	}
	
	$unicode;
}

sub s_unicode_to_webcode {
	my ($unicode) = @_;
	my $webcode = 0;
	
	my ($c1, $c2) = (int($unicode / 256), $unicode % 256);
	$c2--;
	
	if($c1 == 0xe0) {

		$webcode = 0x4721 + $c2;
	} elsif($c1 == 0xe1) {

		$webcode = 0x4521 + $c2;
	} elsif($c1 == 0xe2) {

		$webcode = 0x4621 + $c2;
	} elsif($c1 == 0xe3) {

		$webcode = 0x4f21 + $c2;
	} elsif($c1 == 0xe4) {

		$webcode = 0x5021 + $c2;
	} elsif($c1 == 0xe5) {

		$webcode = 0x5121 + $c2;
	}
	
	$webcode;
}

sub s_unicode_to_sjis {
	my ($unicode) = @_;
	my $sjis = 0;
	
	my ($c1, $c2) = (int($unicode / 256), $unicode % 256);
	$c2--;
	
	if($c1 == 0xe0) {

		$sjis = 0xf941 + $c2;
		$sjis++ if $c2 >= 0x3e;
	} elsif($c1 == 0xe1) {

		$sjis = 0xf741 + $c2;
		$sjis++ if $c2 >= 0x3e;
	} elsif($c1 == 0xe2) {

		$sjis = 0xf7a1 + $c2;
	} elsif($c1 == 0xe3) {

		$sjis = 0xf9a1 + $c2;
	} elsif($c1 == 0xe4) {

		$sjis = 0xfb41 + $c2;
		$sjis++ if $c2 >= 0x3e;
	} elsif($c1 == 0xe5) {

		$sjis = 0xfba1 + $c2;
	}
	
	$sjis;
}

sub ez_number_to_sjis {
	my ($number) = @_;
	my $sjis = 0;
	
	my @n2s = (
		[1, 3, 0xf659], [4, 11, 0xf748], [12, 12, 0xf69a], [13, 13, 0xf6ea], [14, 14, 0xf796], [15, 16, 0xf65e], [17, 24, 0xf750], [25, 25, 0xf797], [26, 43, 0xf758], [44, 44, 0xf660], [45, 45, 0xf693], [46, 46, 0xf7b1], [47, 47, 0xf661], [48, 48, 0xf6eb], [49, 49, 0xf77c], [50, 50, 0xf6d3], [51, 51, 0xf7b2], [52, 52, 0xf69b], [53, 53, 0xf6ec], [54, 55, 0xf76a], [56, 56, 0xf77d], [57, 57, 0xf798], [58, 58, 0xf654], [59, 59, 0xf77e], [60, 60, 0xf662], [61, 64, 0xf76c], [65, 65, 0xf69c], [66, 66, 0xf770], [67, 67, 0xf780], [68, 68, 0xf6d4], [69, 69, 0xf663], [70, 71, 0xf771], [72, 72, 0xf6ed], [73, 73, 0xf773], [74, 74, 0xf6b8], [75, 75, 0xf640], [76, 76, 0xf644], [77, 77, 0xf64e], [78, 78, 0xf6b9], [79, 79, 0xf7ac], [80, 80, 0xf6d5], [81, 82, 0xf774], [83, 83, 0xf674], [84, 84, 0xf7ad], [85, 85, 0xf7b3], [86, 86, 0xf6d6], [87, 87, 0xf799], [88, 89, 0xf776], [90, 90, 0xf790], [91, 91, 0xf675], [92, 92, 0xf781], [93, 93, 0xf7b4], [94, 94, 0xf6ee], [95, 95, 0xf664], [96, 96, 0xf694], [97, 97, 0xf782], [98, 98, 0xf65c], [99, 99, 0xf642], [100, 103, 0xf783], [104, 104, 0xf6ef], [105, 105, 0xf787], [106, 106, 0xf676], [107, 107, 0xf665], [108, 108, 0xf6fa], [109, 109, 0xf79a], [110, 110, 0xf6f0], [111, 111, 0xf79b], [112, 112, 0xf684], [113, 113, 0xf6bd], [114, 115, 0xf79c], [116, 116, 0xf6d7], [117, 118, 0xf778], [119, 120, 0xf6f1], [121, 121, 0xf788], [122, 122, 0xf677], [123, 123, 0xf79e], [124, 124, 0xf6f3], [125, 125, 0xf68a], [126, 126, 0xf79f], [127, 128, 0xf791], [129, 129, 0xf6f4], [130, 130, 0xf7a0], [131, 131, 0xf789], [132, 132, 0xf77a], [133, 133, 0xf6a7], [134, 134, 0xf6ba], [135, 135, 0xf7a1], [136, 136, 0xf77b], [137, 137, 0xf78a], [138, 138, 0xf6f5], [139, 139, 0xf7a2], [140, 141, 0xf6d8], [142, 142, 0xf78b], [143, 143, 0xf678], [144, 144, 0xf6a8], [145, 145, 0xf6f6], [146, 146, 0xf685], [147, 147, 0xf78c], [148, 148, 0xf68b], [149, 149, 0xf679], [150, 150, 0xf7a3], [151, 151, 0xf7ae], [152, 152, 0xf7a4], [153, 154, 0xf7af], [155, 155, 0xf6f7], [156, 156, 0xf686], [157, 157, 0xf78d], [158, 158, 0xf67a], [159, 159, 0xf793], [160, 160, 0xf69d], [161, 162, 0xf7a5], [163, 163, 0xf6da], [164, 164, 0xf7a7], [165, 166, 0xf6f8], [167, 167, 0xf666], [168, 169, 0xf68c], [170, 170, 0xf6a1], [171, 171, 0xf7a8], [172, 172, 0xf68e], [173, 175, 0xf7a9], [176, 179, 0xf655], [180, 181, 0xf6fb], [182, 189, 0xf740], [190, 190, 0xf641], [191, 191, 0xf65d], [192, 204, 0xf667], [205, 208, 0xf67b], [209, 212, 0xf680], [213, 214, 0xf78e], [215, 217, 0xf687], [218, 218, 0xf643], [219, 222, 0xf68f], [223, 223, 0xf645], [224, 228, 0xf695], [229, 230, 0xf646], [231, 233, 0xf69e], [234, 238, 0xf6a2], [239, 245, 0xf6a9], [246, 246, 0xf648], [247, 254, 0xf6b0], [255, 256, 0xf6bb], [257, 261, 0xf649], [262, 264, 0xf6be], [265, 269, 0xf64f], [270, 287, 0xf6c1], [288, 297, 0xf6db], [298, 299, 0xf794], [300, 304, 0xf6e5], [305, 333, 0xf7b5], [334, 357, 0xf7e5], [358, 420, 0xf340], [421, 499, 0xf380], [500, 518, 0xf7d2], [700, 745, 0xf3cf], [746, 808, 0xf440], [809, 828, 0xf480], 
	);

	foreach (@n2s) {
		if($number >= $_->[0] && $number <= $_->[1]) {
			return $_->[2] + $number - $_->[0];
		}
	}

	0;
}

sub ez_sjis_to_number {
	my ($sjis) = @_;
	my $number = 0;
	
	my @s2n = (
		[0xf340, 0xf37e, 358], [0xf380, 0xf3ce, 421], [0xf3cf, 0xf3fc, 700], [0xf440, 0xf47e, 746], [0xf480, 0xf493, 809], [0xf640, 0xf640, 75], [0xf641, 0xf641, 190], [0xf642, 0xf642, 99], [0xf643, 0xf643, 218], [0xf644, 0xf644, 76], [0xf645, 0xf645, 223], [0xf646, 0xf647, 229], [0xf648, 0xf648, 246], [0xf649, 0xf64d, 257], [0xf64e, 0xf64e, 77], [0xf64f, 0xf653, 265], [0xf654, 0xf654, 58], [0xf655, 0xf658, 176], [0xf659, 0xf65b, 1], [0xf65c, 0xf65c, 98], [0xf65d, 0xf65d, 191], [0xf65e, 0xf65f, 15], [0xf660, 0xf660, 44], [0xf661, 0xf661, 47], [0xf662, 0xf662, 60], [0xf663, 0xf663, 69], [0xf664, 0xf664, 95], [0xf665, 0xf665, 107], [0xf666, 0xf666, 167], [0xf667, 0xf673, 192], [0xf674, 0xf674, 83], [0xf675, 0xf675, 91], [0xf676, 0xf676, 106], [0xf677, 0xf677, 122], [0xf678, 0xf678, 143], [0xf679, 0xf679, 149], [0xf67a, 0xf67a, 158], [0xf67b, 0xf67e, 205], [0xf680, 0xf683, 209], [0xf684, 0xf684, 112], [0xf685, 0xf685, 146], [0xf686, 0xf686, 156], [0xf687, 0xf689, 215], [0xf68a, 0xf68a, 125], [0xf68b, 0xf68b, 148], [0xf68c, 0xf68d, 168], [0xf68e, 0xf68e, 172], [0xf68f, 0xf692, 219], [0xf693, 0xf693, 45], [0xf694, 0xf694, 96], [0xf695, 0xf699, 224], [0xf69a, 0xf69a, 12], [0xf69b, 0xf69b, 52], [0xf69c, 0xf69c, 65], [0xf69d, 0xf69d, 160], [0xf69e, 0xf6a0, 231], [0xf6a1, 0xf6a1, 170], [0xf6a2, 0xf6a6, 234], [0xf6a7, 0xf6a7, 133], [0xf6a8, 0xf6a8, 144], [0xf6a9, 0xf6af, 239], [0xf6b0, 0xf6b7, 247], [0xf6b8, 0xf6b8, 74], [0xf6b9, 0xf6b9, 78], [0xf6ba, 0xf6ba, 134], [0xf6bb, 0xf6bc, 255], [0xf6bd, 0xf6bd, 113], [0xf6be, 0xf6c0, 262], [0xf6c1, 0xf6d2, 270], [0xf6d3, 0xf6d3, 50], [0xf6d4, 0xf6d4, 68], [0xf6d5, 0xf6d5, 80], [0xf6d6, 0xf6d6, 86], [0xf6d7, 0xf6d7, 116], [0xf6d8, 0xf6d9, 140], [0xf6da, 0xf6da, 163], [0xf6db, 0xf6e4, 288], [0xf6e5, 0xf6e9, 300], [0xf6ea, 0xf6ea, 13], [0xf6eb, 0xf6eb, 48], [0xf6ec, 0xf6ec, 53], [0xf6ed, 0xf6ed, 72], [0xf6ee, 0xf6ee, 94], [0xf6ef, 0xf6ef, 104], [0xf6f0, 0xf6f0, 110], [0xf6f1, 0xf6f2, 119], [0xf6f3, 0xf6f3, 124], [0xf6f4, 0xf6f4, 129], [0xf6f5, 0xf6f5, 138], [0xf6f6, 0xf6f6, 145], [0xf6f7, 0xf6f7, 155], [0xf6f8, 0xf6f9, 165], [0xf6fa, 0xf6fa, 108], [0xf6fb, 0xf6fc, 180], [0xf740, 0xf747, 182], [0xf748, 0xf74f, 4], [0xf750, 0xf757, 17], [0xf758, 0xf769, 26], [0xf76a, 0xf76b, 54], [0xf76c, 0xf76f, 61], [0xf770, 0xf770, 66], [0xf771, 0xf772, 70], [0xf773, 0xf773, 73], [0xf774, 0xf775, 81], [0xf776, 0xf777, 88], [0xf778, 0xf779, 117], [0xf77a, 0xf77a, 132], [0xf77b, 0xf77b, 136], [0xf77c, 0xf77c, 49], [0xf77d, 0xf77d, 56], [0xf77e, 0xf77e, 59], [0xf780, 0xf780, 67], [0xf781, 0xf781, 92], [0xf782, 0xf782, 97], [0xf783, 0xf786, 100], [0xf787, 0xf787, 105], [0xf788, 0xf788, 121], [0xf789, 0xf789, 131], [0xf78a, 0xf78a, 137], [0xf78b, 0xf78b, 142], [0xf78c, 0xf78c, 147], [0xf78d, 0xf78d, 157], [0xf78e, 0xf78f, 213], [0xf790, 0xf790, 90], [0xf791, 0xf792, 127], [0xf793, 0xf793, 159], [0xf794, 0xf795, 298], [0xf796, 0xf796, 14], [0xf797, 0xf797, 25], [0xf798, 0xf798, 57], [0xf799, 0xf799, 87], [0xf79a, 0xf79a, 109], [0xf79b, 0xf79b, 111], [0xf79c, 0xf79d, 114], [0xf79e, 0xf79e, 123], [0xf79f, 0xf79f, 126], [0xf7a0, 0xf7a0, 130], [0xf7a1, 0xf7a1, 135], [0xf7a2, 0xf7a2, 139], [0xf7a3, 0xf7a3, 150], [0xf7a4, 0xf7a4, 152], [0xf7a5, 0xf7a6, 161], [0xf7a7, 0xf7a7, 164], [0xf7a8, 0xf7a8, 171], [0xf7a9, 0xf7ab, 173], [0xf7ac, 0xf7ac, 79], [0xf7ad, 0xf7ad, 84], [0xf7ae, 0xf7ae, 151], [0xf7af, 0xf7b0, 153], [0xf7b1, 0xf7b1, 46], [0xf7b2, 0xf7b2, 51], [0xf7b3, 0xf7b3, 85], [0xf7b4, 0xf7b4, 93], [0xf7b5, 0xf7d1, 305], [0xf7d2, 0xf7e4, 500], [63461, 63484, 0x14e], 
	);
	
	foreach (@s2n) {
		if($sjis >= $_->[0] && $sjis <= $_->[1]) {
			return $_->[2] + $sjis - $_->[0];
		}
	}

	0;
}

1;