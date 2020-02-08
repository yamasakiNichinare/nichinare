# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package AForm::L10N::en_us;

use strict;
use base qw( AForm::L10N );
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    '_PLUGIN_DESCRIPTION' => 'This plugin adds functions of inquiry form, form management and inquiry data downloading, etc...',
    '_PLUGIN_AUTHOR' => 'ARK-Web\'s MT Plugin Developers',
    'AForm' => 'AForm',
    'AForms' => 'AForms',

    'AForm Field Types' => 'Basic Parts',
    'AForm Field Type Label' => 'Label',
    'AForm Field Type Text' => 'Text',
    'AForm Field Type Textarea' => 'Textarea',
    'AForm Field Type Select' => 'Select',
    'AForm Field Type Checkbox' => 'Checkbox',
    'AForm Field Type Radio' => 'Radio',

    'AForm Field Extra Types' => 'Custom Parts',
    'AForm Field Extra Type Email' => 'Email',
    'AForm Field Extra Type Telephone' => 'Telephone',
    'AForm Field Extra Type URL' => 'URL',
);

1;
