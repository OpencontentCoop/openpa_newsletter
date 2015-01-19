<?php

class ObjectHandlerServiceControlNewsletter extends ObjectHandlerServiceBase
{
    function run()
    {

    }

    public static function init( $options = array() )
    {
        //installa estensioni
        OpenPALog::warning( 'Installazione estensioni' );
        $block = 'ExtensionSettings';
        $settingName = 'ActiveAccessExtensions';
        $value = array( 'cjw_newsletter', 'openpa_newsletter' );
        $iniFile = "site.ini";

        $frontend = OpenPABase::getFrontendSiteaccessName();
        $backend = OpenPABase::getBackendSiteaccessName();
        $debug = OpenPABase::getDebugSiteaccessName();

        foreach( array( $frontend, $backend, $debug ) as $siteAccessName )
        {
            $path = "settings/siteaccess/{$siteAccessName}/";
            $ini = new eZINI( $iniFile . '.append', $path, null, null, null, true, true );
            $value = array_unique( array_merge( (array) $ini->variable( $block, $settingName ), $value ) );
            $ini->setVariable( $block, $settingName, $value );
            if ( !$ini->save() ) throw new Exception( "Non riesco a salvare site.ini" );
        }
        eZCache::clearById( 'global_ini' );

        //installa classi
        OpenPALog::warning( 'Installazione classi' );
        OpenPAClassTools::installClasses( array( 'cjw_newsletter_article', 'cjw_newsletter_edition', 'cjw_newsletter_list', 'cjw_newsletter_root', 'cjw_newsletter_system' ) );

        //installa sezione
        OpenPALog::warning( 'Installazione sezione' );
        $section = OpenPABase::initSection( 'CJW Newsletter', 'cjw_newsletter', 'eznewsletternavigationpart' );

        // crea alberatura
        $parentNode = OpenPAAppSectionHelper::instance()->rootNode( true );
        if ( !$parentNode instanceof eZContentObjectTreeNode )
        {
            throw new Exception( "Errore in creazione App section" );
        }

        OpenPALog::warning( 'Creazione Root' );
        $params = array(
            'parent_node_id' => $parentNode->attribute( 'node_id' ),
            'section_id' => $section->attribute( 'id' ),
            'class_identifier' => 'cjw_newsletter_root',
            'attributes' => array(
                'title' => 'Newsletter'
            )
        );
        /** @var eZContentObject $contentObject */
        $contentObject = eZContentFunctions::createAndPublishObject( $params );
        if( !$contentObject instanceof eZContentObject )
        {
            throw new Exception( 'Errore in creazione Newsletter Root' );
        }
        $rootNode = $contentObject->attribute( 'main_node' );

        OpenPALog::warning( 'Creazione System' );
        $params = array(
            'parent_node_id' => $rootNode->attribute( 'node_id' ),
            'section_id' => $section->attribute( 'id' ),
            'class_identifier' => 'cjw_newsletter_system',
            'attributes' => array(
                'title' => 'Newsletter system'
            )
        );
        /** @var eZContentObject $contentObject */
        $contentObject = eZContentFunctions::createAndPublishObject( $params );
        if( !$contentObject instanceof eZContentObject )
        {
            throw new Exception( 'Errore in creazione Newsletter System' );
        }
        $systemNode = $contentObject->attribute( 'main_node' );

        OpenPALog::warning( 'Creazione List' );
        $params = array(
            'parent_node_id' => $systemNode->attribute( 'node_id' ),
            'section_id' => $section->attribute( 'id' ),
            'class_identifier' => 'cjw_newsletter_list',
            'attributes' => array(
                'title' => 'Newsletter'
            )
        );
        /** @var eZContentObject $contentObject */
        $contentObject = eZContentFunctions::createAndPublishObject( $params );
        if( !$contentObject instanceof eZContentObject )
        {
            throw new Exception( 'Errore in creazione Newsletter List' );
        }
        $listNode = $contentObject->attribute( 'main_node' );

        OpenPALog::warning( 'Salvo configurazioni' );
        $path = "settings/siteaccess/{$backend}/";
        $iniFile = "cjw_newsletter.ini";
        $ini = new eZINI( $iniFile . '.append', $path, null, null, null, true, true );
        $ini->setVariable( 'NewsletterSettings', 'RootFolderNodeId', $rootNode->attribute( 'node_id' ) );
        $ini->setVariable( 'NewsletterMailSettings', 'EmailSubjectPrefix', "[" . eZINI::instance()->variable( 'SiteSettings', 'SiteName' ) . "]" );
        if ( !$ini->save() ) throw new Exception( "Non riesco a salvare cjw_newsletter.ini" );

        eZFileHandler::symlink( eZSys::rootDir() . "/settings/siteaccess/{$backend}/{$iniFile}.append.php", eZSys::rootDir() . "/settings/siteaccess/{$frontend}/{$iniFile}.append.php" );
        eZFileHandler::symlink( eZSys::rootDir() . "/settings/siteaccess/{$backend}/{$iniFile}.append.php", eZSys::rootDir() . "/settings/siteaccess/{$debug}/{$iniFile}.append.php" );

    }
}