
//---------------------------------------------------------
// 全角・半角変換 機能追加スクリプト
//
// 2005/2/26 Kazuhiko Arase
//
// String に、以下のメソッドを拡張します。
//
// ・半角Ascii変換
// toHankakuAscii()
//
// ・全角Ascii変換
// toZenkakuAscii()
//
// ・半角カナ変換
// toHankakuKana()
//
// ・全角カナ変換
// toZenkakuKana()
//
// ・半角変換
// toHankaku()
//
// ・全角変換
// toZenkaku()
//
// ・標準変換(半角Ascii, 全角カナ)
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

                // 変換テーブルに該当無し
                converted += s.substring(i, i + 1);
            }

            return converted;
        }
    };

    //---------------------------------------------------------
    // 全角-半角 マッピング (ASCII)
    //

    var asciiMap = new ConversionMap();

    asciiMap.add(" ", "　");
    asciiMap.add("!", "！");

    // 2重引用符
    //asciiMap.add("\"", "＂");
    asciiMap.add("\"", "“");
    asciiMap.add("\"", "”");

    asciiMap.add("#", "＃");
    asciiMap.add("$", "＄");
    asciiMap.add("%", "％");
    asciiMap.add("&", "＆");
    asciiMap.add("'", "’");
    asciiMap.add("(", "（");
    asciiMap.add(")", "）");
    asciiMap.add("*", "＊");
    asciiMap.add("+", "＋");
    asciiMap.add(",", "，");
    asciiMap.add("-", "－");
    asciiMap.add("-", "―");
    asciiMap.add("-", "‐");
    asciiMap.add("-", "ー");
    asciiMap.add("-", "ｰ");
    asciiMap.add(".", "．");
    asciiMap.add("/", "／");
    asciiMap.add("0", "０");
    asciiMap.add("1", "１");
    asciiMap.add("2", "２");
    asciiMap.add("3", "３");
    asciiMap.add("4", "４");
    asciiMap.add("5", "５");
    asciiMap.add("6", "６");
    asciiMap.add("7", "７");
    asciiMap.add("8", "８");
    asciiMap.add("9", "９");
    asciiMap.add(":", "：");
    asciiMap.add(";", "；");
    asciiMap.add("<", "＜");
    asciiMap.add("=", "＝");
    asciiMap.add(">", "＞");
    asciiMap.add("?", "？");
    asciiMap.add("@", "＠");
    asciiMap.add("A", "Ａ");
    asciiMap.add("B", "Ｂ");
    asciiMap.add("C", "Ｃ");
    asciiMap.add("D", "Ｄ");
    asciiMap.add("E", "Ｅ");
    asciiMap.add("F", "Ｆ");
    asciiMap.add("G", "Ｇ");
    asciiMap.add("H", "Ｈ");
    asciiMap.add("I", "Ｉ");
    asciiMap.add("J", "Ｊ");
    asciiMap.add("K", "Ｋ");
    asciiMap.add("L", "Ｌ");
    asciiMap.add("M", "Ｍ");
    asciiMap.add("N", "Ｎ");
    asciiMap.add("O", "Ｏ");
    asciiMap.add("P", "Ｐ");
    asciiMap.add("Q", "Ｑ");
    asciiMap.add("R", "Ｒ");
    asciiMap.add("S", "Ｓ");
    asciiMap.add("T", "Ｔ");
    asciiMap.add("U", "Ｕ");
    asciiMap.add("V", "Ｖ");
    asciiMap.add("W", "Ｗ");
    asciiMap.add("X", "Ｘ");
    asciiMap.add("Y", "Ｙ");
    asciiMap.add("Z", "Ｚ");
    asciiMap.add("[", "［");

    // 円記号
    //asciiMap.add("\\", "＼");
    asciiMap.add("\\", "￥");

    asciiMap.add("]", "］");
    asciiMap.add("^", "＾");
    asciiMap.add("_", "＿");

    // 単一引用符
    //asciiMap.add("`", "＇");
    asciiMap.add("`", "‘");
    asciiMap.add("`", "’");

    asciiMap.add("a", "ａ");
    asciiMap.add("b", "ｂ");
    asciiMap.add("c", "ｃ");
    asciiMap.add("d", "ｄ");
    asciiMap.add("e", "ｅ");
    asciiMap.add("f", "ｆ");
    asciiMap.add("g", "ｇ");
    asciiMap.add("h", "ｈ");
    asciiMap.add("i", "ｉ");
    asciiMap.add("j", "ｊ");
    asciiMap.add("k", "ｋ");
    asciiMap.add("l", "ｌ");
    asciiMap.add("m", "ｍ");
    asciiMap.add("n", "ｎ");
    asciiMap.add("o", "ｏ");
    asciiMap.add("p", "ｐ");
    asciiMap.add("q", "ｑ");
    asciiMap.add("r", "ｒ");
    asciiMap.add("s", "ｓ");
    asciiMap.add("t", "ｔ");
    asciiMap.add("u", "ｕ");
    asciiMap.add("v", "ｖ");
    asciiMap.add("w", "ｗ");
    asciiMap.add("x", "ｘ");
    asciiMap.add("y", "ｙ");
    asciiMap.add("z", "ｚ");
    asciiMap.add("{", "｛");
    asciiMap.add("|", "｜");
    asciiMap.add("}", "｝");
    asciiMap.add("~", "～");


    //---------------------------------------------------------
    // 全角-半角 マッピング (カタカナ)
    //


    var kanaMap = new ConversionMap();

    kanaMap.add("。", "｡");
    kanaMap.add("「", "｢");
    kanaMap.add("」", "｣");
    kanaMap.add("、", "､");
    kanaMap.add("・", "･");
    kanaMap.add("ヲ", "ｦ");

    kanaMap.add("ァ", "ｧ");
    kanaMap.add("ィ", "ｨ");
    kanaMap.add("ゥ", "ｩ");
    kanaMap.add("ェ", "ｪ");
    kanaMap.add("ォ", "ｫ");

    kanaMap.add("ャ", "ｬ");
    kanaMap.add("ュ", "ｭ");
    kanaMap.add("ョ", "ｮ");

    kanaMap.add("ッ", "ｯ");

    kanaMap.add("ー", "ｰ");

    kanaMap.add("ア", "ｱ");
    kanaMap.add("イ", "ｲ");
    kanaMap.add("ウ", "ｳ");
    kanaMap.add("エ", "ｴ");
    kanaMap.add("オ", "ｵ");

    kanaMap.add("カ", "ｶ");
    kanaMap.add("キ", "ｷ");
    kanaMap.add("ク", "ｸ");
    kanaMap.add("ケ", "ｹ");
    kanaMap.add("コ", "ｺ");

    kanaMap.add("ガ", "ｶﾞ");
    kanaMap.add("ギ", "ｷﾞ");
    kanaMap.add("グ", "ｸﾞ");
    kanaMap.add("ゲ", "ｹﾞ");
    kanaMap.add("ゴ", "ｺﾞ");

    kanaMap.add("サ", "ｻ");
    kanaMap.add("シ", "ｼ");
    kanaMap.add("ス", "ｽ");
    kanaMap.add("セ", "ｾ");
    kanaMap.add("ソ", "ｿ");

    kanaMap.add("ザ", "ｻﾞ");
    kanaMap.add("ジ", "ｼﾞ");
    kanaMap.add("ズ", "ｽﾞ");
    kanaMap.add("ゼ", "ｾﾞ");
    kanaMap.add("ゾ", "ｿﾞ");

    kanaMap.add("タ", "ﾀ");
    kanaMap.add("チ", "ﾁ");
    kanaMap.add("ツ", "ﾂ");
    kanaMap.add("テ", "ﾃ");
    kanaMap.add("ト", "ﾄ");

    kanaMap.add("ダ", "ﾀﾞ");
    kanaMap.add("ヂ", "ﾁﾞ");
    kanaMap.add("ヅ", "ﾂﾞ");
    kanaMap.add("デ", "ﾃﾞ");
    kanaMap.add("ド", "ﾄﾞ");

    kanaMap.add("ナ", "ﾅ");
    kanaMap.add("ニ", "ﾆ");
    kanaMap.add("ヌ", "ﾇ");
    kanaMap.add("ネ", "ﾈ");
    kanaMap.add("ノ", "ﾉ");

    kanaMap.add("ハ", "ﾊ");
    kanaMap.add("ヒ", "ﾋ");
    kanaMap.add("フ", "ﾌ");
    kanaMap.add("ヘ", "ﾍ");
    kanaMap.add("ホ", "ﾎ");

    kanaMap.add("バ", "ﾊﾞ");
    kanaMap.add("ビ", "ﾋﾞ");
    kanaMap.add("ブ", "ﾌﾞ");
    kanaMap.add("ベ", "ﾍﾞ");
    kanaMap.add("ボ", "ﾎﾞ");

    kanaMap.add("パ", "ﾊﾟ");
    kanaMap.add("ピ", "ﾋﾟ");
    kanaMap.add("プ", "ﾌﾟ");
    kanaMap.add("ペ", "ﾍﾟ");
    kanaMap.add("ポ", "ﾎﾟ");

    kanaMap.add("マ", "ﾏ");
    kanaMap.add("ミ", "ﾐ");
    kanaMap.add("ム", "ﾑ");
    kanaMap.add("メ", "ﾒ");
    kanaMap.add("モ", "ﾓ");

    kanaMap.add("ヤ", "ﾔ");
    kanaMap.add("ユ", "ﾕ");
    kanaMap.add("ヨ", "ﾖ");

    kanaMap.add("ラ", "ﾗ");
    kanaMap.add("リ", "ﾘ");
    kanaMap.add("ル", "ﾙ");
    kanaMap.add("レ", "ﾚ");
    kanaMap.add("ロ", "ﾛ");

    kanaMap.add("ワ", "ﾜ");
    kanaMap.add("ン", "ﾝ");

    kanaMap.add("ヴ", "ｳﾞ");


    kanaMap.add("゛", "ﾞ");
    kanaMap.add("゜", "ﾟ");

    kanaMap.add("ヰ", "ｲ");
    kanaMap.add("ヱ", "ｴ");
    kanaMap.add("ヮ", "ﾜ");
    kanaMap.add("ヵ", "ｶ");
    kanaMap.add("ヶ", "ｹ");



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

// 機能インストール
InstallZenHanConversion();



