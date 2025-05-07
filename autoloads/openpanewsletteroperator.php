<?php

class OpenPANewsletterOperator
{
    public static $allowedClasses = [];

    function __construct()
    {
        $this->Operators = [
            'can_add_to_newsletter',
            'newsletter_edition_hash',
            'has_newsletter',
            'is_sendy_enabled',
            'sendy_url',
            'sendy_brand_id',
            'sendy_default_list_id',
            'sendy_lists',
            'sendy_use_gdpr',
            'can_create_sendy_campaign',
        ];
        self::$allowedClasses = OpenPAINI::variable(
            'NewsletterClasses',
            'Classes',
            ['avviso', 'comunicato_stampa', 'event']
        );
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
        return [
            'can_add_to_newsletter' => [
                'ignore_ini_classes' => ['type' => 'boolean', 'required' => false, 'default' => false],
            ],
            'can_create_sendy_campaign' => [
                'object' => ['type' => 'object', 'required' => true, 'default' => null],
            ],
            'sendy_url' => [
                'with_brand' => ['type' => 'boolean', 'required' => false, 'default' => false],
            ],
        ];
    }

    function modify(
        &$tpl,
        &$operatorName,
        &$operatorParameters,
        &$rootNamespace,
        &$currentNamespace,
        &$operatorValue,
        &$namedParameters
    ) {
        if (!eZContentClass::classIDByIdentifier('cjw_newsletter_edition')) {
            return false;
        }

        eZDB::setErrorHandling(eZDB::ERROR_HANDLING_EXCEPTIONS);

        try {
            switch ($operatorName) {
                case 'can_create_sendy_campaign':
                    $operatorValue = OpenPASendy::instance()->canCreateSingleContentCampaign($namedParameters['object']);
                    break;

                case 'sendy_lists':
                    $operatorValue = OpenPASendy::instance()->getListIdNameList();
                    break;

                case 'sendy_default_list_id':
                    $operatorValue = OpenPASendy::instance()->getDefaultListId();
                    break;

                case 'sendy_use_gdpr':
                    $operatorValue = OpenPASendy::instance()->useGdpr();
                    break;

                case 'sendy_brand_id':
                    $operatorValue = OpenPASendy::instance()->getBrandId();
                    break;

                case 'sendy_url':
                    if ($namedParameters['with_brand']) {
                        $operatorValue = OpenPASendy::instance()->getApiUrl() . '/app?i=' . OpenPASendy::instance()->getBrandId();
                    }else {
                        $operatorValue = parse_url(OpenPASendy::instance()->getApiUrl(), PHP_URL_HOST);
                    }
                    break;

                case 'is_sendy_enabled':
                    $operatorValue = OpenPASendy::instance()->isEnabled();
                    break;

                case 'can_add_to_newsletter':
                    {
                        $canAdd = false;
                        $currentNode = $operatorValue;

                        if ($currentNode instanceof eZContentObjectTreeNode) {
                            $user = eZUser::currentUser();
                            $result = $user->hasAccessTo('newsletter', 'index');
                            $checkAccess = $result['accessWord'] != 'no';

                            $editionDraftCount = 0;
                            if (eZINI::instance('cjw_newsletter.ini')->hasVariable(
                                'NewsletterSettings',
                                'RootFolderNodeId'
                            )) {
                                $editionDraftCount = eZContentObjectTreeNode::subTreeCountByNodeID(
                                    [
                                        'ClassFilterType' => 'include',
                                        'ClassFilterArray' => ['cjw_newsletter_edition'],
                                        'LoadDataMap' => false,
                                        'ExtendedAttributeFilter' => [
                                            'id' => 'CjwNewsletterEditionFilter',
                                            'params' => ['status' => 'draft'],
                                        ],
                                    ],
                                    eZINI::instance('cjw_newsletter.ini')->variable(
                                        'NewsletterSettings',
                                        'RootFolderNodeId'
                                    )
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
                        $editionDraftNodeList = self::getDraftEditions();
                        $selectHash = [];
                        foreach ($editionDraftNodeList as $edition) {
                            $selectHash[$edition->attribute('node_id')] = $edition->attribute('parent')->attribute(
                                    'name'
                                ) . ' ' . $edition->attribute('name');
                        }
                        $operatorValue = $selectHash;
                    }
                    break;

                case 'has_newsletter':
                    {
                        if (OpenPASendy::instance()->isEnabled()){
                            $operatorValue = count(OpenPASendy::instance()->getListIdNameList()) > 0;
                        }else {
                            $listNodeCount = 0;
                            if (eZINI::instance('cjw_newsletter.ini')->hasVariable(
                                'NewsletterSettings',
                                'RootFolderNodeId'
                            )) {
                                $listNodeCount = eZContentObjectTreeNode::subTreeCountByNodeID(
                                    [
                                        'ClassFilterType' => 'include',
                                        'ClassFilterArray' => ['cjw_newsletter_list'],
                                        'LoadDataMap' => false,
                                        'ExtendedAttributeFilter' => [
                                            'id' => 'CjwNewsletterListFilter',
                                            'params' => ['siteaccess' => ['current_siteaccess']],
                                        ],

                                    ],
                                    eZINI::instance('cjw_newsletter.ini')->variable(
                                        'NewsletterSettings',
                                        'RootFolderNodeId'
                                    )
                                );
                            }
                            $operatorValue = $listNodeCount > 0;
                        }
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

    public static function getDraftEditions(): array
    {
        $editionDraftNodeList = [];
        if (eZINI::instance('cjw_newsletter.ini')->hasVariable('NewsletterSettings', 'RootFolderNodeId')) {
            $editionDraftNodeList = (array)eZContentObjectTreeNode::subTreeByNodeID(
                [
                    'ClassFilterType' => 'include',
                    'ClassFilterArray' => ['cjw_newsletter_edition'],
                    'LoadDataMap' => false,
                    'ExtendedAttributeFilter' => [
                        'id' => 'CjwNewsletterEditionFilter',
                        'params' => ['status' => 'draft'],
                    ],
                ],
                eZINI::instance('cjw_newsletter.ini')->variable('NewsletterSettings', 'RootFolderNodeId')
            );
        }

        return $editionDraftNodeList;
    }
}
