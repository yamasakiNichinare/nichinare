<?php

class KeitaiCode {
    static function s_webcode_to_sjis($wc) {
        $c1 = (int)($wc / 256);
        $c2 = (int)($wc % 256);
        

        $c2 -= 0x21;
        
        $sjis = 0;
        if($c1 == 0x47) {

            $sjis = 0xf941 + $c2;
            if($c2 > 0x3d) $sjis++;
        } else if($c1 == 0x45) {

            $sjis = 0xf741 + $c2;
            if($c2 > 0x3d) $sjis++;
        } else if($c1 == 0x46) {

            $sjis = 0xf7a1 + $c2;
        } else if($c1 == 0x4f) {

            $sjis = 0xf9a1 + $c2;
        } else if($c1 == 0x50) {

            $sjis = 0xfb41 + $c2;
            if($c2 > 0x3d) $sjis++;
        } else if($c1 == 0x51) {

            $sjis = 0xfba1 + $c2;
        }
        
        return $sjis;
    }
    
    static function s_webcode_to_unicode($wc) {
        $c1 = (int)($wc / 256);
        $c2 = (int)($wc % 256);
        

        $c2 -= 0x21;
        
        $unicode = 0;

        if($c1 == 0x47) {

            $unicode = 0xe001 + $c2;
        } else if($c1 == 0x45) {

            $unicode = 0xe101 + $c2;
        } else if($c1 == 0x46) {

            $unicode = 0xe201 + $c2;
        } else if($c1 == 0x4f) {

            $unicode = 0xe301 + $c2;
        } else if($c1 == 0x50) {

            $unicode = 0xe401 + $c2;
        } else if($c1 == 0x51) {

            $unicode = 0xe501 + $c2;
        }

        return $unicode;
    }
    
    static function s_sjis_to_webcode($sjis) {
        $webcode = 0;
        
        $c1 = (int)($sjis / 256);
        $c2 = (int)($sjis % 256);
        
        if($c1 == 0xf7) {
            if($c2 >= 0x41 && $c2 <=0x9b) {

                $webcode = 0x4521 + $c2 - 0x41;
                if($c2 >= 0x80) $webcode--;
            } else if($c2 >= 0xa1 && $c2 <= 0xf3) {

                $webcode = 0x4621 + $c2 - 0xa1;
            }
        } else if($c1 == 0xf9) {
            if($c2 >= 0x41 && $c2 <=0x9b) {

                $webcode = 0x4721 + $c2 - 0x41;
                if($c2 >= 0x80) $webcode--;
            } else if($c2 >= 0xa1 && $c2 <= 0xf3) {

                $webcode = 0x4f21 + $c2 - 0xa1;
            }
        } else if($c1 == 0xfb) {
            if($c2 >= 0x41 && $c2 <=0x9b) {

                $webcode = 0x5021 + $c2 - 0x41;
                if($c2 >= 0x80) $webcode--;
            } else if($c2 >= 0xa1 && $c2 <= 0xf3) {

                $webcode = 0x5121 + $c2 - 0xa1;
            }
        }
        
        return $webcode;
    }
    
    static function s_sjis_to_unicode($sjis) {
        $unicode = 0;
        
        $c1 = (int)($sjis / 256);
        $c2 = (int)($sjis % 256);
        
        if($c1 == 0xf7) {
            if($c2 >= 0x41 && $c2 <=0x9b) {

                $unicode = 0xe101 + $c2 - 0x41;
                if($c2 >= 0x80) $unicode--;
            } else if($c2 >= 0xa1 && $c2 <= 0xf3) {

                $unicode = 0xe201 + $c2 - 0xa1;
            }
        } else if($c1 == 0xf9) {
            if($c2 >= 0x41 && $c2 <=0x9b) {

                $unicode = 0xe001 + $c2 - 0x41;
                if($c2 >= 0x80) $unicode--;
            } else if($c2 >= 0xa1 && $c2 <= 0xf3) {

                $unicode = 0xe301 + $c2 - 0xa1;
            }
        } else if($c1 == 0xfb) {
            if($c2 >= 0x41 && $c2 <=0x9b) {

                $unicode = 0xe401 + $c2 - 0x41;
                if($c2 >= 0x80) $unicode--;
            } else if($c2 >= 0xa1 && $c2 <= 0xf3) {

                $unicode = 0xe501 + $c2 - 0xa1;
            }
        }
        
        return $unicode;
    }
    
    static function s_unicode_to_webcode($unicode) {
        $webcode = 0;
        
        $c1 = (int)($unicode / 256);
        $c2 = (int)($unicode % 256);

        $c2--;
        
        if($c1 == 0xe0) {

            $webcode = 0x4721 + $c2;
        } else if($c1 == 0xe1) {

            $webcode = 0x4521 + $c2;
        } else if($c1 == 0xe2) {

            $webcode = 0x4621 + $c2;
        } else if($c1 == 0xe3) {

            $webcode = 0x4f21 + $c2;
        } else if($c1 == 0xe4) {

            $webcode = 0x5021 + $c2;
        } else if($c1 == 0xe5) {

            $webcode = 0x5121 + $c2;
        }
        
        return $webcode;
    }
    
    static function s_unicode_to_sjis($unicode) {
        $sjis = 0;
        
        $c1 = (int)($unicode / 256);
        $c2 = (int)($unicode % 256);
        
        $c2--;
        
        if($c1 == 0xe0) {

            $sjis = 0xf941 + $c2;
            if($c2 >= 0x3e) $sjis++;
        } else if($c1 == 0xe1) {

            $sjis = 0xf741 + $c2;
            if($c2 >= 0x3e) $sjis++;
        } else if($c1 == 0xe2) {

            $sjis = 0xf7a1 + $c2;
        } else if($c1 == 0xe3) {

            $sjis = 0xf9a1 + $c2;
        } else if($c1 == 0xe4) {

            $sjis = 0xfb41 + $c2;
            if($c2 >= 0x3e) $sjis++;
        } else if($c1 == 0xe5) {

            $sjis = 0xfba1 + $c2;
        }
        
        return $sjis;
    }
    
    static function ez_number_to_sjis($number) {
        $n2s = array(
            array(1, 3, 0xf659), array(4, 11, 0xf748), array(12, 12, 0xf69a), array(13, 13, 0xf6ea), array(14, 14, 0xf796), array(15, 16, 0xf65e), array(17, 24, 0xf750), array(25, 25, 0xf797), array(26, 43, 0xf758), array(44, 44, 0xf660), array(45, 45, 0xf693), array(46, 46, 0xf7b1), array(47, 47, 0xf661), array(48, 48, 0xf6eb), array(49, 49, 0xf77c), array(50, 50, 0xf6d3), array(51, 51, 0xf7b2), array(52, 52, 0xf69b), array(53, 53, 0xf6ec), array(54, 55, 0xf76a), array(56, 56, 0xf77d), array(57, 57, 0xf798), array(58, 58, 0xf654), array(59, 59, 0xf77e), array(60, 60, 0xf662), array(61, 64, 0xf76c), array(65, 65, 0xf69c), array(66, 66, 0xf770), array(67, 67, 0xf780), array(68, 68, 0xf6d4), array(69, 69, 0xf663), array(70, 71, 0xf771), array(72, 72, 0xf6ed), array(73, 73, 0xf773), array(74, 74, 0xf6b8), array(75, 75, 0xf640), array(76, 76, 0xf644), array(77, 77, 0xf64e), array(78, 78, 0xf6b9), array(79, 79, 0xf7ac), array(80, 80, 0xf6d5), array(81, 82, 0xf774), array(83, 83, 0xf674), array(84, 84, 0xf7ad), array(85, 85, 0xf7b3), array(86, 86, 0xf6d6), array(87, 87, 0xf799), array(88, 89, 0xf776), array(90, 90, 0xf790), array(91, 91, 0xf675), array(92, 92, 0xf781), array(93, 93, 0xf7b4), array(94, 94, 0xf6ee), array(95, 95, 0xf664), array(96, 96, 0xf694), array(97, 97, 0xf782), array(98, 98, 0xf65c), array(99, 99, 0xf642), array(100, 103, 0xf783), array(104, 104, 0xf6ef), array(105, 105, 0xf787), array(106, 106, 0xf676), array(107, 107, 0xf665), array(108, 108, 0xf6fa), array(109, 109, 0xf79a), array(110, 110, 0xf6f0), array(111, 111, 0xf79b), array(112, 112, 0xf684), array(113, 113, 0xf6bd), array(114, 115, 0xf79c), array(116, 116, 0xf6d7), array(117, 118, 0xf778), array(119, 120, 0xf6f1), array(121, 121, 0xf788), array(122, 122, 0xf677), array(123, 123, 0xf79e), array(124, 124, 0xf6f3), array(125, 125, 0xf68a), array(126, 126, 0xf79f), array(127, 128, 0xf791), array(129, 129, 0xf6f4), array(130, 130, 0xf7a0), array(131, 131, 0xf789), array(132, 132, 0xf77a), array(133, 133, 0xf6a7), array(134, 134, 0xf6ba), array(135, 135, 0xf7a1), array(136, 136, 0xf77b), array(137, 137, 0xf78a), array(138, 138, 0xf6f5), array(139, 139, 0xf7a2), array(140, 141, 0xf6d8), array(142, 142, 0xf78b), array(143, 143, 0xf678), array(144, 144, 0xf6a8), array(145, 145, 0xf6f6), array(146, 146, 0xf685), array(147, 147, 0xf78c), array(148, 148, 0xf68b), array(149, 149, 0xf679), array(150, 150, 0xf7a3), array(151, 151, 0xf7ae), array(152, 152, 0xf7a4), array(153, 154, 0xf7af), array(155, 155, 0xf6f7), array(156, 156, 0xf686), array(157, 157, 0xf78d), array(158, 158, 0xf67a), array(159, 159, 0xf793), array(160, 160, 0xf69d), array(161, 162, 0xf7a5), array(163, 163, 0xf6da), array(164, 164, 0xf7a7), array(165, 166, 0xf6f8), array(167, 167, 0xf666), array(168, 169, 0xf68c), array(170, 170, 0xf6a1), array(171, 171, 0xf7a8), array(172, 172, 0xf68e), array(173, 175, 0xf7a9), array(176, 179, 0xf655), array(180, 181, 0xf6fb), array(182, 189, 0xf740), array(190, 190, 0xf641), array(191, 191, 0xf65d), array(192, 204, 0xf667), array(205, 208, 0xf67b), array(209, 212, 0xf680), array(213, 214, 0xf78e), array(215, 217, 0xf687), array(218, 218, 0xf643), array(219, 222, 0xf68f), array(223, 223, 0xf645), array(224, 228, 0xf695), array(229, 230, 0xf646), array(231, 233, 0xf69e), array(234, 238, 0xf6a2), array(239, 245, 0xf6a9), array(246, 246, 0xf648), array(247, 254, 0xf6b0), array(255, 256, 0xf6bb), array(257, 261, 0xf649), array(262, 264, 0xf6be), array(265, 269, 0xf64f), array(270, 287, 0xf6c1), array(288, 297, 0xf6db), array(298, 299, 0xf794), array(300, 304, 0xf6e5), array(305, 333, 0xf7b5), array(334, 357, 0xf7e5), array(358, 420, 0xf340), array(421, 499, 0xf380), array(500, 518, 0xf7d2), array(700, 745, 0xf3cf), array(746, 808, 0xf440), array(809, 828, 0xf480)
        );

        foreach ($n2s as $t) {
            if($number >= $t[0] && $number <= $t[1]) {
                return $t[2] + $number - $t[0];
            }
        }

        return 0;
    }
    
    static function ez_sjis_to_number($sjis) {
        $s2n = array(
            array(0xf340, 0xf37e, 358), array(0xf380, 0xf3ce, 421), array(0xf3cf, 0xf3fc, 700), array(0xf440, 0xf47e, 746), array(0xf480, 0xf493, 809), array(0xf640, 0xf640, 75), array(0xf641, 0xf641, 190), array(0xf642, 0xf642, 99), array(0xf643, 0xf643, 218), array(0xf644, 0xf644, 76), array(0xf645, 0xf645, 223), array(0xf646, 0xf647, 229), array(0xf648, 0xf648, 246), array(0xf649, 0xf64d, 257), array(0xf64e, 0xf64e, 77), array(0xf64f, 0xf653, 265), array(0xf654, 0xf654, 58), array(0xf655, 0xf658, 176), array(0xf659, 0xf65b, 1), array(0xf65c, 0xf65c, 98), array(0xf65d, 0xf65d, 191), array(0xf65e, 0xf65f, 15), array(0xf660, 0xf660, 44), array(0xf661, 0xf661, 47), array(0xf662, 0xf662, 60), array(0xf663, 0xf663, 69), array(0xf664, 0xf664, 95), array(0xf665, 0xf665, 107), array(0xf666, 0xf666, 167), array(0xf667, 0xf673, 192), array(0xf674, 0xf674, 83), array(0xf675, 0xf675, 91), array(0xf676, 0xf676, 106), array(0xf677, 0xf677, 122), array(0xf678, 0xf678, 143), array(0xf679, 0xf679, 149), array(0xf67a, 0xf67a, 158), array(0xf67b, 0xf67e, 205), array(0xf680, 0xf683, 209), array(0xf684, 0xf684, 112), array(0xf685, 0xf685, 146), array(0xf686, 0xf686, 156), array(0xf687, 0xf689, 215), array(0xf68a, 0xf68a, 125), array(0xf68b, 0xf68b, 148), array(0xf68c, 0xf68d, 168), array(0xf68e, 0xf68e, 172), array(0xf68f, 0xf692, 219), array(0xf693, 0xf693, 45), array(0xf694, 0xf694, 96), array(0xf695, 0xf699, 224), array(0xf69a, 0xf69a, 12), array(0xf69b, 0xf69b, 52), array(0xf69c, 0xf69c, 65), array(0xf69d, 0xf69d, 160), array(0xf69e, 0xf6a0, 231), array(0xf6a1, 0xf6a1, 170), array(0xf6a2, 0xf6a6, 234), array(0xf6a7, 0xf6a7, 133), array(0xf6a8, 0xf6a8, 144), array(0xf6a9, 0xf6af, 239), array(0xf6b0, 0xf6b7, 247), array(0xf6b8, 0xf6b8, 74), array(0xf6b9, 0xf6b9, 78), array(0xf6ba, 0xf6ba, 134), array(0xf6bb, 0xf6bc, 255), array(0xf6bd, 0xf6bd, 113), array(0xf6be, 0xf6c0, 262), array(0xf6c1, 0xf6d2, 270), array(0xf6d3, 0xf6d3, 50), array(0xf6d4, 0xf6d4, 68), array(0xf6d5, 0xf6d5, 80), array(0xf6d6, 0xf6d6, 86), array(0xf6d7, 0xf6d7, 116), array(0xf6d8, 0xf6d9, 140), array(0xf6da, 0xf6da, 163), array(0xf6db, 0xf6e4, 288), array(0xf6e5, 0xf6e9, 300), array(0xf6ea, 0xf6ea, 13), array(0xf6eb, 0xf6eb, 48), array(0xf6ec, 0xf6ec, 53), array(0xf6ed, 0xf6ed, 72), array(0xf6ee, 0xf6ee, 94), array(0xf6ef, 0xf6ef, 104), array(0xf6f0, 0xf6f0, 110), array(0xf6f1, 0xf6f2, 119), array(0xf6f3, 0xf6f3, 124), array(0xf6f4, 0xf6f4, 129), array(0xf6f5, 0xf6f5, 138), array(0xf6f6, 0xf6f6, 145), array(0xf6f7, 0xf6f7, 155), array(0xf6f8, 0xf6f9, 165), array(0xf6fa, 0xf6fa, 108), array(0xf6fb, 0xf6fc, 180), array(0xf740, 0xf747, 182), array(0xf748, 0xf74f, 4), array(0xf750, 0xf757, 17), array(0xf758, 0xf769, 26), array(0xf76a, 0xf76b, 54), array(0xf76c, 0xf76f, 61), array(0xf770, 0xf770, 66), array(0xf771, 0xf772, 70), array(0xf773, 0xf773, 73), array(0xf774, 0xf775, 81), array(0xf776, 0xf777, 88), array(0xf778, 0xf779, 117), array(0xf77a, 0xf77a, 132), array(0xf77b, 0xf77b, 136), array(0xf77c, 0xf77c, 49), array(0xf77d, 0xf77d, 56), array(0xf77e, 0xf77e, 59), array(0xf780, 0xf780, 67), array(0xf781, 0xf781, 92), array(0xf782, 0xf782, 97), array(0xf783, 0xf786, 100), array(0xf787, 0xf787, 105), array(0xf788, 0xf788, 121), array(0xf789, 0xf789, 131), array(0xf78a, 0xf78a, 137), array(0xf78b, 0xf78b, 142), array(0xf78c, 0xf78c, 147), array(0xf78d, 0xf78d, 157), array(0xf78e, 0xf78f, 213), array(0xf790, 0xf790, 90), array(0xf791, 0xf792, 127), array(0xf793, 0xf793, 159), array(0xf794, 0xf795, 298), array(0xf796, 0xf796, 14), array(0xf797, 0xf797, 25), array(0xf798, 0xf798, 57), array(0xf799, 0xf799, 87), array(0xf79a, 0xf79a, 109), array(0xf79b, 0xf79b, 111), array(0xf79c, 0xf79d, 114), array(0xf79e, 0xf79e, 123), array(0xf79f, 0xf79f, 126), array(0xf7a0, 0xf7a0, 130), array(0xf7a1, 0xf7a1, 135), array(0xf7a2, 0xf7a2, 139), array(0xf7a3, 0xf7a3, 150), array(0xf7a4, 0xf7a4, 152), array(0xf7a5, 0xf7a6, 161), array(0xf7a7, 0xf7a7, 164), array(0xf7a8, 0xf7a8, 171), array(0xf7a9, 0xf7ab, 173), array(0xf7ac, 0xf7ac, 79), array(0xf7ad, 0xf7ad, 84), array(0xf7ae, 0xf7ae, 151), array(0xf7af, 0xf7b0, 153), array(0xf7b1, 0xf7b1, 46), array(0xf7b2, 0xf7b2, 51), array(0xf7b3, 0xf7b3, 85), array(0xf7b4, 0xf7b4, 93), array(0xf7b5, 0xf7d1, 305), array(0xf7d2, 0xf7e4, 500), array(63461, 63484, 0x14e)
        );

        foreach ($s2n as $t) {
            if($sjis >= $t[0] && $sjis <= $t[1]) {
                return $t[2] + $sjis - $t[0];
            }
        }
        
        return 0;
    }

}

?>