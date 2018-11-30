
//---------------------------------------------------------
// ���ѡ�Ⱦ���Ѵ� ��ǽ�ɲå�����ץ�
//
// 2005/2/26 Kazuhiko Arase
//
// String �ˡ��ʲ��Υ᥽�åɤ��ĥ���ޤ���
//
// ��Ⱦ��Ascii�Ѵ�
// toHankakuAscii()
//
// ������Ascii�Ѵ�
// toZenkakuAscii()
//
// ��Ⱦ�ѥ����Ѵ�
// toHankakuKana()
//
// �����ѥ����Ѵ�
// toZenkakuKana()
//
// ��Ⱦ���Ѵ�
// toHankaku()
//
// �������Ѵ�
// toZenkaku()
//
// ��ɸ���Ѵ�(Ⱦ��Ascii, ���ѥ���)
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

                // �Ѵ��ơ��֥�˳���̵��
                converted += s.substring(i, i + 1);
            }

            return converted;
        }
    };

    //---------------------------------------------------------
    // ����-Ⱦ�� �ޥåԥ� (ASCII)
    //

    var asciiMap = new ConversionMap();

    asciiMap.add(" ", "��");
    asciiMap.add("!", "��");

    // 2�Ű�����
    //asciiMap.add("\"", "��");
    asciiMap.add("\"", "��");
    asciiMap.add("\"", "��");

    asciiMap.add("#", "��");
    asciiMap.add("$", "��");
    asciiMap.add("%", "��");
    asciiMap.add("&", "��");
    asciiMap.add("'", "��");
    asciiMap.add("(", "��");
    asciiMap.add(")", "��");
    asciiMap.add("*", "��");
    asciiMap.add("+", "��");
    asciiMap.add(",", "��");
    asciiMap.add("-", "��");
    asciiMap.add(".", "��");
    asciiMap.add("/", "��");
    asciiMap.add("0", "��");
    asciiMap.add("1", "��");
    asciiMap.add("2", "��");
    asciiMap.add("3", "��");
    asciiMap.add("4", "��");
    asciiMap.add("5", "��");
    asciiMap.add("6", "��");
    asciiMap.add("7", "��");
    asciiMap.add("8", "��");
    asciiMap.add("9", "��");
    asciiMap.add(":", "��");
    asciiMap.add(";", "��");
    asciiMap.add("<", "��");
    asciiMap.add("=", "��");
    asciiMap.add(">", "��");
    asciiMap.add("?", "��");
    asciiMap.add("@", "��");
    asciiMap.add("A", "��");
    asciiMap.add("B", "��");
    asciiMap.add("C", "��");
    asciiMap.add("D", "��");
    asciiMap.add("E", "��");
    asciiMap.add("F", "��");
    asciiMap.add("G", "��");
    asciiMap.add("H", "��");
    asciiMap.add("I", "��");
    asciiMap.add("J", "��");
    asciiMap.add("K", "��");
    asciiMap.add("L", "��");
    asciiMap.add("M", "��");
    asciiMap.add("N", "��");
    asciiMap.add("O", "��");
    asciiMap.add("P", "��");
    asciiMap.add("Q", "��");
    asciiMap.add("R", "��");
    asciiMap.add("S", "��");
    asciiMap.add("T", "��");
    asciiMap.add("U", "��");
    asciiMap.add("V", "��");
    asciiMap.add("W", "��");
    asciiMap.add("X", "��");
    asciiMap.add("Y", "��");
    asciiMap.add("Z", "��");
    asciiMap.add("[", "��");

    // �ߵ���
    //asciiMap.add("\\", "��");
    asciiMap.add("\\", "��");

    asciiMap.add("]", "��");
    asciiMap.add("^", "��");
    asciiMap.add("_", "��");

    // ñ�������
    //asciiMap.add("`", "��");
    asciiMap.add("`", "��");
    asciiMap.add("`", "��");

    asciiMap.add("a", "��");
    asciiMap.add("b", "��");
    asciiMap.add("c", "��");
    asciiMap.add("d", "��");
    asciiMap.add("e", "��");
    asciiMap.add("f", "��");
    asciiMap.add("g", "��");
    asciiMap.add("h", "��");
    asciiMap.add("i", "��");
    asciiMap.add("j", "��");
    asciiMap.add("k", "��");
    asciiMap.add("l", "��");
    asciiMap.add("m", "��");
    asciiMap.add("n", "��");
    asciiMap.add("o", "��");
    asciiMap.add("p", "��");
    asciiMap.add("q", "��");
    asciiMap.add("r", "��");
    asciiMap.add("s", "��");
    asciiMap.add("t", "��");
    asciiMap.add("u", "��");
    asciiMap.add("v", "��");
    asciiMap.add("w", "��");
    asciiMap.add("x", "��");
    asciiMap.add("y", "��");
    asciiMap.add("z", "��");
    asciiMap.add("{", "��");
    asciiMap.add("|", "��");
    asciiMap.add("}", "��");
    asciiMap.add("~", "��");


    //---------------------------------------------------------
    // ����-Ⱦ�� �ޥåԥ� (��������)
    //


    var kanaMap = new ConversionMap();

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "��");

    kanaMap.add("��", "��");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "����");
    kanaMap.add("��", "����");
    kanaMap.add("��", "����");
    kanaMap.add("��", "����");
    kanaMap.add("��", "����");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "����");
    kanaMap.add("��", "����");
    kanaMap.add("��", "����");
    kanaMap.add("��", "����");
    kanaMap.add("��", "����");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "����");
    kanaMap.add("��", "����");
    kanaMap.add("��", "��");
    kanaMap.add("��", "�Î�");
    kanaMap.add("��", "�Ď�");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "�ʎ�");
    kanaMap.add("��", "�ˎ�");
    kanaMap.add("��", "�̎�");
    kanaMap.add("��", "�͎�");
    kanaMap.add("��", "�Ύ�");

    kanaMap.add("��", "�ʎ�");
    kanaMap.add("��", "�ˎ�");
    kanaMap.add("��", "�̎�");
    kanaMap.add("��", "�͎�");
    kanaMap.add("��", "�Ύ�");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "����");


    kanaMap.add("��", "��");
    kanaMap.add("��", "��");

    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");
    kanaMap.add("��", "��");



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

// ��ǽ���󥹥ȡ���
InstallZenHanConversion();



