#!/usr/bin/perl

#��������������������������������������������������������������������
#�� FullPath Checker v1.4 (2003/09/22)
#�� Copyright (c) KentWeb
#�� webmaster@kent-web.com
#�� http://www.kent-web.com/
#�� ---
#�� Special Thanks:
#��    HiRO-����A�Ă������
#��������������������������������������������������������������������
$ver = 'FullPath Checker v1.4';
#��������������������������������������������������������������������
#�� [���ӎ���]
#�� 1. ���̃X�N���v�g�̓t���[�\�t�g�ł��B���̃X�N���v�g���g�p����
#��    �����Ȃ鑹�Q�ɑ΂��č�҂͈�؂̐ӔC�𕉂��܂���B
#�� 2. �ݒu�Ɋւ��鎿��̓T�|�[�g�f���ɂ��肢�������܂��B
#��    ���ڃ��[���ɂ�鎿��͈�؂��󂯂������Ă���܂���B
#��������������������������������������������������������������������

# ��P�`�F�b�N
eval{ $path1 = `pwd`; };
if ($@ || !$path1) { $path1 = 'unknown'; }

# ��Q�`�F�b�N
if ($0 =~ /^(.*[\\\/])/) { $path2 = $1; }
else { $path2 = 'unknown'; }

# ��R�`�F�b�N�F�X�N���v�g�܂ł̃t���p�X
$path3 = $ENV{'SCRIPT_FILENAME'};
$path3 ||= 'unknown';

print "Content-type: text/html\n\n";
print <<"EOM";
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
<META HTTP-EQUIV="Content-type" CONTENT="text/html; charset=Shift_JIS">
<title>$ver</title></head>
<body bgcolor="#FFFFFF" text="#000000">
<h3>���́u�f�B���N�g���v�̃t���p�X�`�F�b�N�̌��ʂ͈ȉ��̂Ƃ���ł��B</h3>
- �uunknown�v�Əo��ꍇ�ɂ͎擾�Ɏ��s�����ꍇ�ł� -
<P>
<DL>
<DT>��1�`�F�b�N
<DD><font color="#DD0000" size="+1"><tt>$path1</tt></font><br><br>
<DT>��2�`�F�b�N
<DD><font color="#DD0000" size="+1"><tt>$path2</tt></font><br><br>
<DT>��3�`�F�b�N�F�X�N���v�g�܂ł̃t���p�X
<DD><font color="#DD0000" size="+1"><tt>$path3</tt></font>
</DL>
<!-- ���쌠�\\���i�폜�s�j-->
<P><div align="right" style="font-family:Verdana,Helvetica,Arial;font-size:11px">
<b>$ver</b><br>
Copyright (c) <a href="http://www.kent-web.com/">KentWeb</a>
</div>
</body>
</html>
EOM

exit;


__END__

