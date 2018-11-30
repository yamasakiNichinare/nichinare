<?php
# Movable Type (r) (C) 2001-2010 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id: init.community.php 117483 2010-01-07 08:27:20Z ytakayama $

require_once('class.baseobject.php');
BaseObject::install_meta( 'blog', 'allow_anon_recommend', 'vinteger' );
?>
