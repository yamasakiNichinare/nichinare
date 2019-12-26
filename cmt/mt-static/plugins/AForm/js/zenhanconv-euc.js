
//---------------------------------------------------------
// Á´³Ñ¡¦È¾³ÑÊÑ´¹ µ¡Ç½ÄÉ²Ã¥¹¥¯¥ê¥×¥È
//
// 2005/2/26 Kazuhiko Arase
//
// String ¤Ë¡¢°Ê²¼¤Î¥á¥½¥Ã¥É¤ò³ÈÄ¥¤·¤Þ¤¹¡£
//
// ¡¦È¾³ÑAsciiÊÑ´¹
// toHankakuAscii()
//
// ¡¦Á´³ÑAsciiÊÑ´¹
// toZenkakuAscii()
//
// ¡¦È¾³Ñ¥«¥ÊÊÑ´¹
// toHankakuKana()
//
// ¡¦Á´³Ñ¥«¥ÊÊÑ´¹
// toZenkakuKana()
//
// ¡¦È¾³ÑÊÑ´¹
// toHankaku()
//
// ¡¦Á´³ÑÊÑ´¹
// toZenkaku()
//
// ¡¦É¸½àÊÑ´¹(È¾³ÑAscii, Á´³Ñ¥«¥Ê)
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

                // ÊÑ´¹¥Æ¡¼¥Ö¥ë¤Ë³ºÅöÌµ¤·
                converted += s.substring(i, i + 1);
            }

            return converted;
        }
    };

    //---------------------------------------------------------
    // Á´³Ñ-È¾³Ñ ¥Þ¥Ã¥Ô¥ó¥° (ASCII)
    //

    var asciiMap = new ConversionMap();

    asciiMap.add(" ", "¡¡");
    asciiMap.add("!", "¡ª");

    // 2½Å°úÍÑÉä
    //asciiMap.add("\"", "üþ");
    asciiMap.add("\"", "¡È");
    asciiMap.add("\"", "¡É");

    asciiMap.add("#", "¡ô");
    asciiMap.add("$", "¡ð");
    asciiMap.add("%", "¡ó");
    asciiMap.add("&", "¡õ");
    asciiMap.add("'", "¡Ç");
    asciiMap.add("(", "¡Ê");
    asciiMap.add(")", "¡Ë");
    asciiMap.add("*", "¡ö");
    asciiMap.add("+", "¡Ü");
    asciiMap.add(",", "¡¤");
    asciiMap.add("-", "¡Ý");
    asciiMap.add(".", "¡¥");
    asciiMap.add("/", "¡¿");
    asciiMap.add("0", "£°");
    asciiMap.add("1", "£±");
    asciiMap.add("2", "£²");
    asciiMap.add("3", "£³");
    asciiMap.add("4", "£´");
    asciiMap.add("5", "£µ");
    asciiMap.add("6", "£¶");
    asciiMap.add("7", "£·");
    asciiMap.add("8", "£¸");
    asciiMap.add("9", "£¹");
    asciiMap.add(":", "¡§");
    asciiMap.add(";", "¡¨");
    asciiMap.add("<", "¡ã");
    asciiMap.add("=", "¡á");
    asciiMap.add(">", "¡ä");
    asciiMap.add("?", "¡©");
    asciiMap.add("@", "¡÷");
    asciiMap.add("A", "£Á");
    asciiMap.add("B", "£Â");
    asciiMap.add("C", "£Ã");
    asciiMap.add("D", "£Ä");
    asciiMap.add("E", "£Å");
    asciiMap.add("F", "£Æ");
    asciiMap.add("G", "£Ç");
    asciiMap.add("H", "£È");
    asciiMap.add("I", "£É");
    asciiMap.add("J", "£Ê");
    asciiMap.add("K", "£Ë");
    asciiMap.add("L", "£Ì");
    asciiMap.add("M", "£Í");
    asciiMap.add("N", "£Î");
    asciiMap.add("O", "£Ï");
    asciiMap.add("P", "£Ð");
    asciiMap.add("Q", "£Ñ");
    asciiMap.add("R", "£Ò");
    asciiMap.add("S", "£Ó");
    asciiMap.add("T", "£Ô");
    asciiMap.add("U", "£Õ");
    asciiMap.add("V", "£Ö");
    asciiMap.add("W", "£×");
    asciiMap.add("X", "£Ø");
    asciiMap.add("Y", "£Ù");
    asciiMap.add("Z", "£Ú");
    asciiMap.add("[", "¡Î");

    // ±ßµ­¹æ
    //asciiMap.add("\\", "¡À");
    asciiMap.add("\\", "¡ï");

    asciiMap.add("]", "¡Ï");
    asciiMap.add("^", "¡°");
    asciiMap.add("_", "¡²");

    // Ã±°ì°úÍÑÉä
    //asciiMap.add("`", "üý");
    asciiMap.add("`", "¡Æ");
    asciiMap.add("`", "¡Ç");

    asciiMap.add("a", "£á");
    asciiMap.add("b", "£â");
    asciiMap.add("c", "£ã");
    asciiMap.add("d", "£ä");
    asciiMap.add("e", "£å");
    asciiMap.add("f", "£æ");
    asciiMap.add("g", "£ç");
    asciiMap.add("h", "£è");
    asciiMap.add("i", "£é");
    asciiMap.add("j", "£ê");
    asciiMap.add("k", "£ë");
    asciiMap.add("l", "£ì");
    asciiMap.add("m", "£í");
    asciiMap.add("n", "£î");
    asciiMap.add("o", "£ï");
    asciiMap.add("p", "£ð");
    asciiMap.add("q", "£ñ");
    asciiMap.add("r", "£ò");
    asciiMap.add("s", "£ó");
    asciiMap.add("t", "£ô");
    asciiMap.add("u", "£õ");
    asciiMap.add("v", "£ö");
    asciiMap.add("w", "£÷");
    asciiMap.add("x", "£ø");
    asciiMap.add("y", "£ù");
    asciiMap.add("z", "£ú");
    asciiMap.add("{", "¡Ð");
    asciiMap.add("|", "¡Ã");
    asciiMap.add("}", "¡Ñ");
    asciiMap.add("~", "¡Á");


    //---------------------------------------------------------
    // Á´³Ñ-È¾³Ñ ¥Þ¥Ã¥Ô¥ó¥° (¥«¥¿¥«¥Ê)
    //


    var kanaMap = new ConversionMap();

    kanaMap.add("¡£", "Ž¡");
    kanaMap.add("¡Ö", "Ž¢");
    kanaMap.add("¡×", "Ž£");
    kanaMap.add("¡¢", "Ž¤");
    kanaMap.add("¡¦", "Ž¥");
    kanaMap.add("¥ò", "Ž¦");

    kanaMap.add("¥¡", "Ž§");
    kanaMap.add("¥£", "Ž¨");
    kanaMap.add("¥¥", "Ž©");
    kanaMap.add("¥§", "Žª");
    kanaMap.add("¥©", "Ž«");

    kanaMap.add("¥ã", "Ž¬");
    kanaMap.add("¥å", "Ž­");
    kanaMap.add("¥ç", "Ž®");

    kanaMap.add("¥Ã", "Ž¯");

    kanaMap.add("¡¼", "Ž°");

    kanaMap.add("¥¢", "Ž±");
    kanaMap.add("¥¤", "Ž²");
    kanaMap.add("¥¦", "Ž³");
    kanaMap.add("¥¨", "Ž´");
    kanaMap.add("¥ª", "Žµ");

    kanaMap.add("¥«", "Ž¶");
    kanaMap.add("¥­", "Ž·");
    kanaMap.add("¥¯", "Ž¸");
    kanaMap.add("¥±", "Ž¹");
    kanaMap.add("¥³", "Žº");

    kanaMap.add("¥¬", "Ž¶ŽÞ");
    kanaMap.add("¥®", "Ž·ŽÞ");
    kanaMap.add("¥°", "Ž¸ŽÞ");
    kanaMap.add("¥²", "Ž¹ŽÞ");
    kanaMap.add("¥´", "ŽºŽÞ");

    kanaMap.add("¥µ", "Ž»");
    kanaMap.add("¥·", "Ž¼");
    kanaMap.add("¥¹", "Ž½");
    kanaMap.add("¥»", "Ž¾");
    kanaMap.add("¥½", "Ž¿");

    kanaMap.add("¥¶", "Ž»ŽÞ");
    kanaMap.add("¥¸", "Ž¼ŽÞ");
    kanaMap.add("¥º", "Ž½ŽÞ");
    kanaMap.add("¥¼", "Ž¾ŽÞ");
    kanaMap.add("¥¾", "Ž¿ŽÞ");

    kanaMap.add("¥¿", "ŽÀ");
    kanaMap.add("¥Á", "ŽÁ");
    kanaMap.add("¥Ä", "ŽÂ");
    kanaMap.add("¥Æ", "ŽÃ");
    kanaMap.add("¥È", "ŽÄ");

    kanaMap.add("¥À", "ŽÀŽÞ");
    kanaMap.add("¥Â", "ŽÁŽÞ");
    kanaMap.add("¥Å", "ŽÂŽÞ");
    kanaMap.add("¥Ç", "ŽÃŽÞ");
    kanaMap.add("¥É", "ŽÄŽÞ");

    kanaMap.add("¥Ê", "ŽÅ");
    kanaMap.add("¥Ë", "ŽÆ");
    kanaMap.add("¥Ì", "ŽÇ");
    kanaMap.add("¥Í", "ŽÈ");
    kanaMap.add("¥Î", "ŽÉ");

    kanaMap.add("¥Ï", "ŽÊ");
    kanaMap.add("¥Ò", "ŽË");
    kanaMap.add("¥Õ", "ŽÌ");
    kanaMap.add("¥Ø", "ŽÍ");
    kanaMap.add("¥Û", "ŽÎ");

    kanaMap.add("¥Ð", "ŽÊŽÞ");
    kanaMap.add("¥Ó", "ŽËŽÞ");
    kanaMap.add("¥Ö", "ŽÌŽÞ");
    kanaMap.add("¥Ù", "ŽÍŽÞ");
    kanaMap.add("¥Ü", "ŽÎŽÞ");

    kanaMap.add("¥Ñ", "ŽÊŽß");
    kanaMap.add("¥Ô", "ŽËŽß");
    kanaMap.add("¥×", "ŽÌŽß");
    kanaMap.add("¥Ú", "ŽÍŽß");
    kanaMap.add("¥Ý", "ŽÎŽß");

    kanaMap.add("¥Þ", "ŽÏ");
    kanaMap.add("¥ß", "ŽÐ");
    kanaMap.add("¥à", "ŽÑ");
    kanaMap.add("¥á", "ŽÒ");
    kanaMap.add("¥â", "ŽÓ");

    kanaMap.add("¥ä", "ŽÔ");
    kanaMap.add("¥æ", "ŽÕ");
    kanaMap.add("¥è", "ŽÖ");

    kanaMap.add("¥é", "Ž×");
    kanaMap.add("¥ê", "ŽØ");
    kanaMap.add("¥ë", "ŽÙ");
    kanaMap.add("¥ì", "ŽÚ");
    kanaMap.add("¥í", "ŽÛ");

    kanaMap.add("¥ï", "ŽÜ");
    kanaMap.add("¥ó", "ŽÝ");

    kanaMap.add("¥ô", "Ž³ŽÞ");


    kanaMap.add("¡«", "ŽÞ");
    kanaMap.add("¡¬", "Žß");

    kanaMap.add("¥ð", "Ž²");
    kanaMap.add("¥ñ", "Ž´");
    kanaMap.add("¥î", "ŽÜ");
    kanaMap.add("¥õ", "Ž¶");
    kanaMap.add("¥ö", "Ž¹");



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

// µ¡Ç½¥¤¥ó¥¹¥È¡¼¥ë
InstallZenHanConversion();



