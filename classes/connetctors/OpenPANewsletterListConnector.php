<?php

use Opencontent\Ocopendata\Forms\Connectors\AbstractBaseConnector;

class OpenPANewsletterListConnector extends AbstractBaseConnector
{
    /**
     * @var false|mixed
     */
    private $siteAccesses;

    private $hasRemoteListAccess = false;

    public function __construct($identifier)
    {
        parent::__construct($identifier);
        $this->siteAccesses = eZINI::instance()->variable('RegionalSettings', 'TranslationSA');
        if (empty($this->siteAccesses)) {
            $this->siteAccesses = [eZSiteAccess::current()['name'] => eZLocale::instance()->languageName()];
        }
        $this->hasRemoteListAccess = version_compare(OpenPASendy::SENDY_VERSION, '6.0.0', '>=');
    }


    protected function getData()
    {
        return ['lists' => OpenPASendy::instance()->getLists()];
    }

    protected function getSchema()
    {
        $schema = [
            'title' => '',
            "type" => "object",
            'properties' => [
                'lists' => [
                    'type' => 'array',
                    "items" => [
                        "type" => "object",
                        'properties' => [
                            'id' => [
                                'type' => 'string',
                                'readonly' => $this->hasRemoteListAccess,
                                'title' => 'Sendy Id',
                                'required' => true,
                            ],
                            'name' => [
                                'type' => 'string',
                                'readonly' => $this->hasRemoteListAccess,
                                'title' => 'Sendy Name',
                            ],
                            'label' => [
                                'type' => 'string',
                                'title' => 'Titolo',
                                'required' => true,
                            ],
                            'enabled' => [
                                'type' => 'array',
                                'title' => 'Permetti sottoscrizione',
                                'enum' => array_keys($this->siteAccesses),
                            ],
                        ],
                    ],
                ],
            ],
        ];

        return $schema;
    }

    protected function getOptions()
    {
        return [
            'form' => [
                'attributes' => [
                    "action" => $this->getHelper()->getServiceUrl('action', $this->getHelper()->getParameters()),
                    'method' => 'post',
                    'enctype' => 'multipart/form-data',
                ],
            ],
            'helper' => '',
            'fields' => [
                'lists' => [
                    'type' => 'table',
                    'showActionsColumn' => !$this->hasRemoteListAccess,
                    'items' => [
                        'fields' => [
                            'enabled' => [
                                'type' => 'checkbox',
                                'hideInitValidationError' => true,
                                'showMessages' => false,
                                'optionLabels' => array_values($this->siteAccesses),
                            ],
                        ],
                    ],
                ],
            ],
        ];
    }

    protected function getView()
    {
        // TODO: Implement getView() method.
    }

    protected function submit()
    {
        $data = $_POST;
        $lists = $data['lists'] ?? [];
        foreach ($data['lists'] as $key => $value) {
            $lists[$key] = array_merge([
                'id' => '',
                'name' => '',
                'label' => '',
                'enabled' => [],
            ], $value);
        }

        OpenPASendy::instance()->setLists($lists);

        return $data;
    }

    protected function upload()
    {
        throw new Exception('Not implemented');
    }

}