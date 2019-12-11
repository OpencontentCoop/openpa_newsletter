<?php

class OpenPANewsletterInstaller implements OpenPAInstaller
{
    protected $options = array();

    public function setScriptOptions(eZScript $script)
    {
        return $script->getOptions(
            '[parent-node:]',
            '',
            array(
                'parent-node' => 'Nodo id contenitore (Nodo Applicazioni di default)'
            )
        );
    }

    public function beforeInstall($options = array())
    {
        $block = 'ExtensionSettings';
        $settingName = 'ActiveAccessExtensions';

        if (!in_array('cjw_newsletter', (array)eZINI::instance()->variable($block, $settingName))
            && !in_array('openpa_newsletter', (array)eZINI::instance()->variable($block, $settingName))) {
            throw new Exception("Occorre attivare le estensioni cjw_newsletter e cjw_newsletter prima");
        }
    }

    public function install()
    {
        OpenPALog::warning('Installazione schema db');
        $this->installSchema();

        OpenPALog::warning('Installazione classi');
        try {
            $this->installClasses();
        } catch (Exception $e) {
            OpenPALog::error($e->getMessage());
        }

        OpenPALog::warning('Installazione sezione');
        try {
            $section = OpenPABase::initSection('CJW Newsletter', 'cjw_newsletter', 'eznewsletternavigationpart');

            if (isset($this->options['parent-node'])) {
                $parentNodeId = $this->options['parent-node'];
            } else {
                $parentNodeId = OpenPAAppSectionHelper::instance()->rootNode(true)->attribute('node_id');
            }

            OpenPALog::warning('Installazione alberatura');

            $rootRemoteId = OpenPABase::getCurrentSiteaccessIdentifier() . '_newsletter_root';
            $contentObject = eZContentObject::fetchByRemoteID($rootRemoteId);
            if (!$contentObject instanceof eZContentObject) {
                OpenPALog::warning(' - Creazione Root');
                $params = array(
                    'remote_id' => $rootRemoteId,
                    'parent_node_id' => $parentNodeId,
                    'section_id' => $section->attribute('id'),
                    'class_identifier' => 'cjw_newsletter_root',
                    'attributes' => array(
                        'title' => 'Newsletter'
                    )
                );
                /** @var eZContentObject $contentObject */
                $contentObject = eZContentFunctions::createAndPublishObject($params);
            }
            if (!$contentObject instanceof eZContentObject) {
                throw new Exception('Errore in creazione Newsletter Root');
            }

            $rootNode = $contentObject->attribute('main_node');

            $systemRemoteId = OpenPABase::getCurrentSiteaccessIdentifier() . '_newsletter_system';
            $contentObject = eZContentObject::fetchByRemoteID($systemRemoteId);
            $alreadyExists = false;
            if (!$contentObject instanceof eZContentObject) {
                OpenPALog::warning(' - Creazione System');
                $params = array(
                    'remote_id' => $systemRemoteId,
                    'parent_node_id' => $rootNode->attribute('node_id'),
                    'section_id' => $section->attribute('id'),
                    'class_identifier' => 'cjw_newsletter_system',
                    'attributes' => array(
                        'title' => 'Newsletter system'
                    )
                );
                /** @var eZContentObject $contentObject */
                $contentObject = eZContentFunctions::createAndPublishObject($params);
            }else{
                $alreadyExists = true;
            }
            if (!$contentObject instanceof eZContentObject) {
                throw new Exception('Errore in creazione Newsletter System');
            }
            $systemNode = $contentObject->attribute('main_node');

            if (!$alreadyExists) {
                OpenPALog::warning(' - Creazione List');
                $params = array(
                    'parent_node_id' => $systemNode->attribute('node_id'),
                    'section_id' => $section->attribute('id'),
                    'class_identifier' => 'cjw_newsletter_list',
                    'attributes' => array(
                        'title' => 'Newsletter'
                    )
                );
                /** @var eZContentObject $contentObject */
                $contentObject = eZContentFunctions::createAndPublishObject($params);
                if (!$contentObject instanceof eZContentObject) {
                    throw new Exception('Errore in creazione Newsletter List');
                }
            }

        } catch (Exception $e) {
            OpenPALog::error($e->getMessage());
        }

    }

    private function installSchema()
    {
        $db = eZDB::instance();
        $schema = 'extension/cjw_newsletter/sql/postgresql/schema.sql';
        try {
            OpenPADBTools::insertFromSqlFile($db, $schema);
        } catch (Exception $e) {
            //OpenPALog::notice($e->getMessage());
        }
    }

    /**
     * @throws Exception
     */
    private function installClasses()
    {
        $classIdentifiers = [
            'cjw_newsletter_article',
            'cjw_newsletter_edition',
            'cjw_newsletter_list',
            'cjw_newsletter_root',
            'cjw_newsletter_system'
        ];
        foreach ($classIdentifiers as $classIdentifier) {
            $class = eZContentClass::fetchByIdentifier($classIdentifier);
            if (!$class instanceof eZContentClass) {
                $tool = new OCClassTools($classIdentifier, true, array(), 'https://openpa.comunitatrentina.it/openpa/classdefinition/');                                
                $tool->sync();
                $class = eZContentClass::fetchByIdentifier($classIdentifier);
            }

            if (!$class instanceof eZContentClass) {
                throw new Exception("Classe $classIdentifier non trovata");
            }
        }
    }

    public function afterInstall()
    {
        eZCache::clearById(['global_ini', 'template']);
    }

}