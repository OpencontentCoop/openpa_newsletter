<?php

class OpenPANewsletterOperator
{
    public static $allowedClasses = array();

    function __construct()
    {
        $this->Operators = array('can_add_to_newsletter', 'newsletter_edition_hash', 'has_newsletter');
        self::$allowedClasses = OpenPAINI::variable('NewsletterClasses', 'Classes', array('avviso', 'comunicato_stampa', 'event'));
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
        return array(
            'can_add_to_newsletter' => array(
                'ignore_ini_classes' => array('type' => 'boolean', 'required' => false, 'default' => false),
            ),
        );
    }

    function modify(&$tpl, &$operatorName, &$operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters)
    {
        if (!eZContentClass::classIDByIdentifier('cjw_newsletter_edition')) {
            return false;
        }

        eZDB::setErrorHandling(eZDB::ERROR_HANDLING_EXCEPTIONS);

        try {

            switch ($operatorName) {

                case 'can_add_to_newsletter':
                    {
                        $canAdd = false;
                        $currentNode = $operatorValue;

                        if ($currentNode instanceof eZContentObjectTreeNode) {
                            $user = eZUser::currentUser();
                            $result = $user->hasAccessTo('newsletter', 'index');
                            $checkAccess = $result['accessWord'] != 'no';

                            $editionDraftCount = 0;
                            if (eZINI::instance('cjw_newsletter.ini')->hasVariable('NewsletterSettings', 'RootFolderNodeId')) {
                                $editionDraftCount = eZContentObjectTreeNode::subTreeCountByNodeID(
                                    array(
                                        'ClassFilterType' => 'include',
                                        'ClassFilterArray' => array('cjw_newsletter_edition'),
                                        'LoadDataMap' => false,
                                        'ExtendedAttributeFilter' => array(
                                            'id' => 'CjwNewsletterEditionFilter',
                                            'params' => array('status' => 'draft')
                                        )
                                    ),
                                    eZINI::instance('cjw_newsletter.ini')->variable('NewsletterSettings', 'RootFolderNodeId')
                                );

                            }
                            if ($namedParameters['ignore_ini_classes']) {
                                $classAllowed = true;
                            } else {
                                $classAllowed = in_array(
                                    $currentNode->attribute('class_identifier'),
                                    self::$allowedClasses
                                );
                            }

                            $canAdd = $checkAccess && $editionDraftCount > 0 && $classAllowed;
                        }

                        $operatorValue = $canAdd;
                    }
                    break;

                case 'newsletter_edition_hash':
                    {
                        $editionDraftNodeList = array();
                        if (eZINI::instance('cjw_newsletter.ini')->hasVariable('NewsletterSettings', 'RootFolderNodeId')) {
                            $editionDraftNodeList = (array)eZContentObjectTreeNode::subTreeByNodeID(
                                array(
                                    'ClassFilterType' => 'include',
                                    'ClassFilterArray' => array('cjw_newsletter_edition'),
                                    'LoadDataMap' => false,
                                    'ExtendedAttributeFilter' => array(
                                        'id' => 'CjwNewsletterEditionFilter',
                                        'params' => array('status' => 'draft')
                                    )
                                ),
                                eZINI::instance('cjw_newsletter.ini')->variable('NewsletterSettings', 'RootFolderNodeId')
                            );
                        }
                        $selectHash = array();
                        foreach ($editionDraftNodeList as $edition) {
                            $selectHash[$edition->attribute('node_id')] = $edition->attribute('parent')->attribute('name') . ' ' . $edition->attribute('name');
                        }

                        $operatorValue = $selectHash;
                    }
                    break;

                case 'has_newsletter':
                    {
                        $listNodeCount = 0;
                        if (eZINI::instance('cjw_newsletter.ini')->hasVariable('NewsletterSettings', 'RootFolderNodeId')) {
                            $listNodeCount = eZContentObjectTreeNode::subTreeCountByNodeID(
                                array(
                                    'ClassFilterType' => 'include',
                                    'ClassFilterArray' => array('cjw_newsletter_list'),
                                    'LoadDataMap' => false,
                                    'ExtendedAttributeFilter' => array(
                                        'id' => 'CjwNewsletterListFilter',
                                        'params' => array('siteaccess' => array('current_siteaccess'))
                                    )

                                ),
                                eZINI::instance('cjw_newsletter.ini')->variable('NewsletterSettings', 'RootFolderNodeId')
                            );
                        }

                        $operatorValue = $listNodeCount > 0;
                    }
                    break;
            }
        } catch (eZDBException $e) {
            eZDebug::writeError($e->getMessage(), __METHOD__);
            $operatorValue = null;
        }

        eZDB::setErrorHandling(eZDB::ERROR_HANDLING_STANDARD);

        return true;
    }
}
