
//---------------------------------------------------------
// �S�p�E���p�ϊ� �@�\�ǉ��X�N���v�g
//
// 2005/2/26 Kazuhiko Arase
//
// String �ɁA�ȉ��̃��\�b�h���g�����܂��B
//
// �E���pAscii�ϊ�
// toHankakuAscii()
//
// �E�S�pAscii�ϊ�
// toZenkakuAscii()
//
// �E���p�J�i�ϊ�
// toHankakuKana()
//
// �E�S�p�J�i�ϊ�
// toZenkakuKana()
//
// �E���p�ϊ�
// toHankaku()
//
// �E�S�p�ϊ�
// toZenkaku()
//
// �E�W���ϊ�(���pAscii, �S�p�J�i)
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

                // �ϊ��e�[�u���ɊY������
                converted += s.substring(i, i + 1);
            }

            return converted;
        }
    };

    //---------------------------------------------------------
    // �S�p-���p �}�b�s���O (ASCII)
    //

    var asciiMap = new ConversionMap();

    asciiMap.add(" ", "�@");
    asciiMap.add("!", "�I");

    // 2�d���p��
    //asciiMap.add("\"", "�W");
    asciiMap.add("\"", "�g");
    asciiMap.add("\"", "�h");

    asciiMap.add("#", "��");
    asciiMap.add("$", "��");
    asciiMap.add("%", "��");
    asciiMap.add("&", "��");
    asciiMap.add("'", "�f");
    asciiMap.add("(", "�i");
    asciiMap.add(")", "�j");
    asciiMap.add("*", "��");
    asciiMap.add("+", "�{");
    asciiMap.add(",", "�C");
    asciiMap.add("-", "�|");
    asciiMap.add(".", "�D");
    asciiMap.add("/", "�^");
    asciiMap.add("0", "�O");
    asciiMap.add("1", "�P");
    asciiMap.add("2", "�Q");
    asciiMap.add("3", "�R");
    asciiMap.add("4", "�S");
    asciiMap.add("5", "�T");
    asciiMap.add("6", "�U");
    asciiMap.add("7", "�V");
    asciiMap.add("8", "�W");
    asciiMap.add("9", "�X");
    asciiMap.add(":", "�F");
    asciiMap.add(";", "�G");
    asciiMap.add("<", "��");
    asciiMap.add("=", "��");
    asciiMap.add(">", "��");
    asciiMap.add("?", "�H");
    asciiMap.add("@", "��");
    asciiMap.add("A", "�`");
    asciiMap.add("B", "�a");
    asciiMap.add("C", "�b");
    asciiMap.add("D", "�c");
    asciiMap.add("E", "�d");
    asciiMap.add("F", "�e");
    asciiMap.add("G", "�f");
    asciiMap.add("H", "�g");
    asciiMap.add("I", "�h");
    asciiMap.add("J", "�i");
    asciiMap.add("K", "�j");
    asciiMap.add("L", "�k");
    asciiMap.add("M", "�l");
    asciiMap.add("N", "�m");
    asciiMap.add("O", "�n");
    asciiMap.add("P", "�o");
    asciiMap.add("Q", "�p");
    asciiMap.add("R", "�q");
    asciiMap.add("S", "�r");
    asciiMap.add("T", "�s");
    asciiMap.add("U", "�t");
    asciiMap.add("V", "�u");
    asciiMap.add("W", "�v");
    asciiMap.add("X", "�w");
    asciiMap.add("Y", "�x");
    asciiMap.add("Z", "�y");
    asciiMap.add("[", "�m");

    // �~�L��
    //asciiMap.add("\\", "�_");
    asciiMap.add("\\", "��");

    asciiMap.add("]", "�n");
    asciiMap.add("^", "�O");
    asciiMap.add("_", "�Q");

    // �P����p��
    //asciiMap.add("`", "�V");
    asciiMap.add("`", "�e");
    asciiMap.add("`", "�f");

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
    asciiMap.add("{", "�o");
    asciiMap.add("|", "�b");
    asciiMap.add("}", "�p");
    asciiMap.add("~", "�`");


    //---------------------------------------------------------
    // �S�p-���p �}�b�s���O (�J�^�J�i)
    //


    var kanaMap = new ConversionMap();

    kanaMap.add("�B", "�");
    kanaMap.add("�u", "�");
    kanaMap.add("�v", "�");
    kanaMap.add("�A", "�");
    kanaMap.add("�E", "�");
    kanaMap.add("��", "�");

    kanaMap.add("�@", "�");
    kanaMap.add("�B", "�");
    kanaMap.add("�D", "�");
    kanaMap.add("�F", "�");
    kanaMap.add("�H", "�");

    kanaMap.add("��", "�");
    kanaMap.add("��", "�");
    kanaMap.add("��", "�");

    kanaMap.add("�b", "�");

    kanaMap.add("�[", "�");

    kanaMap.add("�A", "�");
    kanaMap.add("�C", "�");
    kanaMap.add("�E", "�");
    kanaMap.add("�G", "�");
    kanaMap.add("�I", "�");

    kanaMap.add("�J", "�");
    kanaMap.add("�L", "�");
    kanaMap.add("�N", "�");
    kanaMap.add("�P", "�");
    kanaMap.add("�R", "�");

    kanaMap.add("�K", "��");
    kanaMap.add("�M", "��");
    kanaMap.add("�O", "��");
    kanaMap.add("�Q", "��");
    kanaMap.add("�S", "��");

    kanaMap.add("�T", "�");
    kanaMap.add("�V", "�");
    kanaMap.add("�X", "�");
    kanaMap.add("�Z", "�");
    kanaMap.add("�\", "�");

    kanaMap.add("�U", "��");
    kanaMap.add("�W", "��");
    kanaMap.add("�Y", "��");
    kanaMap.add("�[", "��");
    kanaMap.add("�]", "��");

    kanaMap.add("�^", "�");
    kanaMap.add("�`", "�");
    kanaMap.add("�c", "�");
    kanaMap.add("�e", "�");
    kanaMap.add("�g", "�");

    kanaMap.add("�_", "��");
    kanaMap.add("�a", "��");
    kanaMap.add("�d", "��");
    kanaMap.add("�f", "��");
    kanaMap.add("�h", "��");

    kanaMap.add("�i", "�");
    kanaMap.add("�j", "�");
    kanaMap.add("�k", "�");
    kanaMap.add("�l", "�");
    kanaMap.add("�m", "�");

    kanaMap.add("�n", "�");
    kanaMap.add("�q", "�");
    kanaMap.add("�t", "�");
    kanaMap.add("�w", "�");
    kanaMap.add("�z", "�");

    kanaMap.add("�o", "��");
    kanaMap.add("�r", "��");
    kanaMap.add("�u", "��");
    kanaMap.add("�x", "��");
    kanaMap.add("�{", "��");

    kanaMap.add("�p", "��");
    kanaMap.add("�s", "��");
    kanaMap.add("�v", "��");
    kanaMap.add("�y", "��");
    kanaMap.add("�|", "��");

    kanaMap.add("�}", "�");
    kanaMap.add("�~", "�");
    kanaMap.add("��", "�");
    kanaMap.add("��", "�");
    kanaMap.add("��", "�");

    kanaMap.add("��", "�");
    kanaMap.add("��", "�");
    kanaMap.add("��", "�");

    kanaMap.add("��", "�");
    kanaMap.add("��", "�");
    kanaMap.add("��", "�");
    kanaMap.add("��", "�");
    kanaMap.add("��", "�");

    kanaMap.add("��", "�");
    kanaMap.add("��", "�");

    kanaMap.add("��", "��");


    kanaMap.add("�J", "�");
    kanaMap.add("�K", "�");

    kanaMap.add("��", "�");
    kanaMap.add("��", "�");
    kanaMap.add("��", "�");
    kanaMap.add("��", "�");
    kanaMap.add("��", "�");



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

// �@�\�C���X�g�[��
InstallZenHanConversion();



