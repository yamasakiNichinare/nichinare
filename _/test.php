<?php 

phpinfo(); 
exit;

# print 'fuga';
# exit;


$file = 'people.txt';
// �t�@�C�����I�[�v�����Ċ����̃R���e���c���擾���܂�
$current = file_get_contents($file);
// �V�����l�����t�@�C���ɒǉ����܂�
$current .= "John Smith\n";
// ���ʂ��t�@�C���ɏ����o���܂�
file_put_contents($file, $current);

?>


