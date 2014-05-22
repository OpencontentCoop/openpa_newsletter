<?php

$Module = array( 'name' => 'OpenPA Newsletter',
                 'variable_params' => true );

$ViewList = array();

$ViewList['link'] = array(
    'functions' => array( 'link' ),
    'script' => 'link.php',    
    'params' => array( 'ObjectID', 'NodeID', 'NewsletterListID' ),
    'unordered_params' => array()
);


$FunctionList = array();
$FunctionList['link'] = array();

?>
