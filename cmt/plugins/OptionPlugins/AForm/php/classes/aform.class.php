<?php
require_once('class.baseobject.php');

class Aform extends BaseObject
{
    public $_table = 'mt_aform';
    protected $_prefix = "aform_";
    protected $_has_meta = false;


    function Save() {
        if (empty($this->aform_class))
            $this->aform_class = 'aform';
        return parent::Save();
    }
}
?>
