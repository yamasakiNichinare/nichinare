
//---------------------------------------------------------
// ‘SŠpE”¼Šp•ÏŠ· ‹@”\’Ç‰ÁƒXƒNƒŠƒvƒg
//
// 2005/2/26 Kazuhiko Arase
//
// String ‚ÉAˆÈ‰º‚Ìƒƒ\ƒbƒh‚ğŠg’£‚µ‚Ü‚·B
//
// E”¼ŠpAscii•ÏŠ·
// toHankakuAscii()
//
// E‘SŠpAscii•ÏŠ·
// toZenkakuAscii()
//
// E”¼ŠpƒJƒi•ÏŠ·
// toHankakuKana()
//
// E‘SŠpƒJƒi•ÏŠ·
// toZenkakuKana()
//
// E”¼Šp•ÏŠ·
// toHankaku()
//
// E‘SŠp•ÏŠ·
// toZenkaku()
//
// E•W€•ÏŠ·(”¼ŠpAscii, ‘SŠpƒJƒi)
// toNormal()
//
/**
 * Modified by ARK-Web Co.,Ltd.
 * Base Version : 
 * Copyright (c) ARK-Web Co.,Ltd.
 */
function InstallZenHanConversion() {

    function ConversionMap() {
        this.map1 = {};
        this.map2 = {};
    }

    ConversionMap.prototype = {

        add : function(s1, s2) {

            if (!this.map1[s1]) {
                this.map1[s1] = s2;
            }

            if (!this.map2[s2]) {
                this.map2[s2] = s1;
            }
        },

        convert : function(s, reverse) {

            var map = !reverse? this.map1 : this.map2;

            var converted = "";

            for (var i = 0;i < s.length;i++) {

                if (i + 1 < s.length) {
                    var c = map[s.substring(i, i + 2)];
                    if (c) {
                        converted += c;
                        i++;
                        continue;
                    }
                }

                var c = map[s.substring(i, i + 1)];
                if (c) {
                    converted += c;
                    continue;
                }

                // •ÏŠ·ƒe[ƒuƒ‹‚ÉŠY“––³‚µ
                converted += s.substring(i, i + 1);
            }

            return converted;
        }
    };

    //---------------------------------------------------------
    // ‘SŠp-”¼Šp ƒ}ƒbƒsƒ“ƒO (ASCII)
    //

    var asciiMap = new ConversionMap();

    asciiMap.add(" ", "@");
    asciiMap.add("!", "I");

    // 2dˆø—p•„
    //asciiMap.add("\"", "úW");
    asciiMap.add("\"", "g");
    asciiMap.add("\"", "h");

    asciiMap.add("#", "”");
    asciiMap.add("$", "");
    asciiMap.add("%", "“");
    asciiMap.add("&", "•");
    asciiMap.add("'", "f");
    asciiMap.add("(", "i");
    asciiMap.add(")", "j");
    asciiMap.add("*", "–");
    asciiMap.add("+", "{");
    asciiMap.add(",", "C");
    asciiMap.add("-", "|");
    asciiMap.add(".", "D");
    asciiMap.add("/", "^");
    asciiMap.add("0", "‚O");
    asciiMap.add("1", "‚P");
    asciiMap.add("2", "‚Q");
    asciiMap.add("3", "‚R");
    asciiMap.add("4", "‚S");
    asciiMap.add("5", "‚T");
    asciiMap.add("6", "‚U");
    asciiMap.add("7", "‚V");
    asciiMap.add("8", "‚W");
    asciiMap.add("9", "‚X");
    asciiMap.add(":", "F");
    asciiMap.add(";", "G");
    asciiMap.add("<", "ƒ");
    asciiMap.add("=", "");
    asciiMap.add(">", "„");
    asciiMap.add("?", "H");
    asciiMap.add("@", "—");
    asciiMap.add("A", "‚`");
    asciiMap.add("B", "‚a");
    asciiMap.add("C", "‚b");
    asciiMap.add("D", "‚c");
    asciiMap.add("E", "‚d");
    asciiMap.add("F", "‚e");
    asciiMap.add("G", "‚f");
    asciiMap.add("H", "‚g");
    asciiMap.add("I", "‚h");
    asciiMap.add("J", "‚i");
    asciiMap.add("K", "‚j");
    asciiMap.add("L", "‚k");
    asciiMap.add("M", "‚l");
    asciiMap.add("N", "‚m");
    asciiMap.add("O", "‚n");
    asciiMap.add("P", "‚o");
    asciiMap.add("Q", "‚p");
    asciiMap.add("R", "‚q");
    asciiMap.add("S", "‚r");
    asciiMap.add("T", "‚s");
    asciiMap.add("U", "‚t");
    asciiMap.add("V", "‚u");
    asciiMap.add("W", "‚v");
    asciiMap.add("X", "‚w");
    asciiMap.add("Y", "‚x");
    asciiMap.add("Z", "‚y");
    asciiMap.add("[", "m");

    // ‰~‹L†
    //asciiMap.add("\\", "_");
    asciiMap.add("\\", "");

    asciiMap.add("]", "n");
    asciiMap.add("^", "O");
    asciiMap.add("_", "Q");

    // ’Pˆêˆø—p•„
    //asciiMap.add("`", "úV");
    asciiMap.add("`", "e");
    asciiMap.add("`", "f");

    asciiMap.add("a", "‚");
    asciiMap.add("b", "‚‚");
    asciiMap.add("c", "‚ƒ");
    asciiMap.add("d", "‚„");
    asciiMap.add("e", "‚…");
    asciiMap.add("f", "‚†");
    asciiMap.add("g", "‚‡");
    asciiMap.add("h", "‚ˆ");
    asciiMap.add("i", "‚‰");
    asciiMap.add("j", "‚Š");
    asciiMap.add("k", "‚‹");
    asciiMap.add("l", "‚Œ");
    asciiMap.add("m", "‚");
    asciiMap.add("n", "‚");
    asciiMap.add("o", "‚");
    asciiMap.add("p", "‚");
    asciiMap.add("q", "‚‘");
    asciiMap.add("r", "‚’");
    asciiMap.add("s", "‚“");
    asciiMap.add("t", "‚”");
    asciiMap.add("u", "‚•");
    asciiMap.add("v", "‚–");
    asciiMap.add("w", "‚—");
    asciiMap.add("x", "‚˜");
    asciiMap.add("y", "‚™");
    asciiMap.add("z", "‚š");
    asciiMap.add("{", "o");
    asciiMap.add("|", "b");
    asciiMap.add("}", "p");
    asciiMap.add("~", "`");


    //---------------------------------------------------------
    // ‘SŠp-”¼Šp ƒ}ƒbƒsƒ“ƒO (ƒJƒ^ƒJƒi)
    //


    var kanaMap = new ConversionMap();

    kanaMap.add("B", "¡");
    kanaMap.add("u", "¢");
    kanaMap.add("v", "£");
    kanaMap.add("A", "¤");
    kanaMap.add("E", "¥");
    kanaMap.add("ƒ’", "¦");

    kanaMap.add("ƒ@", "§");
    kanaMap.add("ƒB", "¨");
    kanaMap.add("ƒD", "©");
    kanaMap.add("ƒF", "ª");
    kanaMap.add("ƒH", "«");

    kanaMap.add("ƒƒ", "¬");
    kanaMap.add("ƒ…", "­");
    kanaMap.add("ƒ‡", "®");

    kanaMap.add("ƒb", "¯");

    kanaMap.add("[", "°");

    kanaMap.add("ƒA", "±");
    kanaMap.add("ƒC", "²");
    kanaMap.add("ƒE", "³");
    kanaMap.add("ƒG", "´");
    kanaMap.add("ƒI", "µ");

    kanaMap.add("ƒJ", "¶");
    kanaMap.add("ƒL", "·");
    kanaMap.add("ƒN", "¸");
    kanaMap.add("ƒP", "¹");
    kanaMap.add("ƒR", "º");

    kanaMap.add("ƒK", "¶Ş");
    kanaMap.add("ƒM", "·Ş");
    kanaMap.add("ƒO", "¸Ş");
    kanaMap.add("ƒQ", "¹Ş");
    kanaMap.add("ƒS", "ºŞ");

    kanaMap.add("ƒT", "»");
    kanaMap.add("ƒV", "¼");
    kanaMap.add("ƒX", "½");
    kanaMap.add("ƒZ", "¾");
    kanaMap.add("ƒ\", "¿");

    kanaMap.add("ƒU", "»Ş");
    kanaMap.add("ƒW", "¼Ş");
    kanaMap.add("ƒY", "½Ş");
    kanaMap.add("ƒ[", "¾Ş");
    kanaMap.add("ƒ]", "¿Ş");

    kanaMap.add("ƒ^", "À");
    kanaMap.add("ƒ`", "Á");
    kanaMap.add("ƒc", "Â");
    kanaMap.add("ƒe", "Ã");
    kanaMap.add("ƒg", "Ä");

    kanaMap.add("ƒ_", "ÀŞ");
    kanaMap.add("ƒa", "ÁŞ");
    kanaMap.add("ƒd", "ÂŞ");
    kanaMap.add("ƒf", "ÃŞ");
    kanaMap.add("ƒh", "ÄŞ");

    kanaMap.add("ƒi", "Å");
    kanaMap.add("ƒj", "Æ");
    kanaMap.add("ƒk", "Ç");
    kanaMap.add("ƒl", "È");
    kanaMap.add("ƒm", "É");

    kanaMap.add("ƒn", "Ê");
    kanaMap.add("ƒq", "Ë");
    kanaMap.add("ƒt", "Ì");
    kanaMap.add("ƒw", "Í");
    kanaMap.add("ƒz", "Î");

    kanaMap.add("ƒo", "ÊŞ");
    kanaMap.add("ƒr", "ËŞ");
    kanaMap.add("ƒu", "ÌŞ");
    kanaMap.add("ƒx", "ÍŞ");
    kanaMap.add("ƒ{", "ÎŞ");

    kanaMap.add("ƒp", "Êß");
    kanaMap.add("ƒs", "Ëß");
    kanaMap.add("ƒv", "Ìß");
    kanaMap.add("ƒy", "Íß");
    kanaMap.add("ƒ|", "Îß");

    kanaMap.add("ƒ}", "Ï");
    kanaMap.add("ƒ~", "Ğ");
    kanaMap.add("ƒ€", "Ñ");
    kanaMap.add("ƒ", "Ò");
    kanaMap.add("ƒ‚", "Ó");

    kanaMap.add("ƒ„", "Ô");
    kanaMap.add("ƒ†", "Õ");
    kanaMap.add("ƒˆ", "Ö");

    kanaMap.add("ƒ‰", "×");
    kanaMap.add("ƒŠ", "Ø");
    kanaMap.add("ƒ‹", "Ù");
    kanaMap.add("ƒŒ", "Ú");
    kanaMap.add("ƒ", "Û");

    kanaMap.add("ƒ", "Ü");
    kanaMap.add("ƒ“", "İ");

    kanaMap.add("ƒ”", "³Ş");


    kanaMap.add("J", "Ş");
    kanaMap.add("K", "ß");

    kanaMap.add("ƒ", "²");
    kanaMap.add("ƒ‘", "´");
    kanaMap.add("ƒ", "Ü");
    kanaMap.add("ƒ•", "¶");
    kanaMap.add("ƒ–", "¹");



    String.prototype.toHankakuAscii = function() {
        return asciiMap.convert(this, true);
    }

    String.prototype.toZenkakuAscii = function() {
        return asciiMap.convert(this, false);
    }

    String.prototype.toHankakuKana = function() {
        return kanaMap.convert(this, false);
    }

    String.prototype.toZenkakuKana = function() {
        return kanaMap.convert(this, true);
    }

    String.prototype.toHankaku = function() {
        return this.toHankakuKana().toHankakuAscii();
    }

    String.prototype.toZenkaku = function() {
        return this.toZenkakuKana().toZenkakuAscii();
    }

    String.prototype.toNormal = function() {
        return this.toZenkakuKana().toHankakuAscii();
    }
}

// ‹@”\ƒCƒ“ƒXƒg[ƒ‹
InstallZenHanConversion();



