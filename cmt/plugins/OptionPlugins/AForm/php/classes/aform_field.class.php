<?php
require_once("class.baseobject.php");

class AformField extends BaseObject
{
    public $_table = 'mt_aform_field';
    protected $_prefix = "aform_field_";
    protected $_has_meta = false;


    function Find($where) {
        $fields = parent::Find($where);
        // set properties
        for( $i = 0; $i < count($fields); $i++ ){
            $fields[$i] = set_properties($fields[$i]);
        }
        return $fields;
    }

    function Save() {
        if (empty($this->aform_field_class))
            $this->aform_field_class = 'aform_field';
        return parent::Save();
    }
}


function set_properties( $field ){
    $json = new Services_JSON(SERVICES_JSON_LOOSE_TYPE);
    $json_data = $json->decode($field->property);

    $field->use_default = $json_data['use_default'];
    $field->default_label = $json_data['default_label'];
    $field->privacy_link = $json_data['privacy_link'];
    $field->is_replyed = $json_data['is_replyed'];
    $field->input_example = $json_data['input_example'];
    $field->max_length = $json_data['max_length'];
    $field->options = $json_data['options'];
    if( is_array($field->options) ){
        for( $i=0; $i < count($field->options); $i++ ){
            $field->options[$i]{"index"} = $i+1;
        }
    }
    return $field;
}

?>
