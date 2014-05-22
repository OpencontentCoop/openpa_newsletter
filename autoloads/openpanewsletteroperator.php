<?php

class OpenPANewsletterOperator
{

    //@todo sposta su ini o su gruppo di classi
    public static $allowedClasses = array( 'avviso', 'comunicato_stampa', 'event' );

    function OpenPANewsletterOperator()
    {
        $this->Operators= array( 'can_add_to_newsletter', 'newsletter_edition_hash' );
    }

    function operatorList()
    {
        return $this->Operators;
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return array();
    }
    
    function modify( &$tpl, &$operatorName, &$operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
		$fetchParams = array( 'ClassFilterType' => 'include',
                              'ClassFilterArray' => array( 'cjw_newsletter_edition' ),
                              'LoadDataMap' => false,
                              'ExtendedAttributeFilter' => array( 'id' => 'CjwNewsletterEditionFilter',
                                                                  'params' => array( 'status' => 'draft' ) ) );
        
        switch ( $operatorName )
        {
			
            case 'can_add_to_newsletter':
            {
                $canAdd = false;
                $currentNode = $operatorValue;
                
                if ( $currentNode instanceof eZContentObjectTreeNode )
                {
                    $user = eZUser::currentUser();
                    $result = $user->hasAccessTo( 'newsletter', 'index' );
                    $checkAccess = $result['accessWord'] != 'no';
                    
                    $editionDraftCount = eZContentObjectTreeNode::subTreeCountByNodeID( $fetchParams,
                                                                                        eZINI::instance( 'content.ini' )->variable( 'NodeSettings', 'MediaRootNode' ) );
                    
                    $classAllowed = in_array( $currentNode->attribute( 'class_identifier' ), self::$allowedClasses );
                    
                    $canAdd = $checkAccess && $editionDraftCount > 0 && $classAllowed;
                }
                
                $operatorValue = $canAdd;
            } break;
            
            case 'newsletter_edition_hash':
            {
                $editionDraftNodeList = eZContentObjectTreeNode::subTreeByNodeID( $fetchParams,
                                                                                  eZINI::instance( 'content.ini' )->variable( 'NodeSettings', 'MediaRootNode' ) );
                
                $selectHash = array();
                foreach( $editionDraftNodeList as $edition )
                {
                    $selectHash[$edition->attribute( 'node_id' )] = $edition->attribute( 'parent' )->attribute( 'name' ) . ' ' . $edition->attribute( 'name' );
                }
                
                $operatorValue = $selectHash;
            } break;
        }
    }
}

?>
