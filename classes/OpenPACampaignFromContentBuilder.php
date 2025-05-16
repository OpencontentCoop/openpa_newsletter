<?php

class OpenPACampaignFromContentBuilder
{
    /**
     * @var eZContentObject
     */
    private $object;

    /**
     * @var string
     */
    private $language;

    private $fields = [
        'article' => [
            'subject' => [
                'content_type',
                'published',
                'title',
            ],
            'body' => [
                'abstract',
                'body',
            ],
            'attachments' => [
                'image',
                'files',
            ],
        ],
    ];

    public function __construct(eZContentObject $object, string $language = null)
    {
        $this->object = $object;
        $this->language = $language ?? eZLocale::currentLocaleCode();
    }

    public function canCreate(): bool
    {
        return $this->object->attribute('class_identifier') === 'article';
    }

    public function getSubject(): string
    {
        $subjectFields = $this->fields['article']['subject'];
        $subjects = [];
        foreach ($this->object->availableLanguages() as $language) {
            if ($language == $this->language) {
                $dataMap = $this->object->fetchDataMap(false, $language);
                $localizeSubjects = [];
                foreach ($subjectFields as $field) {
                    if (isset($dataMap[$field]) && $dataMap[$field]->hasContent()) {
                        $localizeSubjects[] = $this->getAttributeAsMailString($dataMap[$field]);
                    }
                }
                $subjects[] = implode(' ', $localizeSubjects);
            }
        }

        return implode('/', $subjects);
    }

    public function getHtmlText(): string
    {
        $bodyFields = $this->fields['article']['body'];

        $bodies = [];
        foreach ($this->object->availableLanguages() as $language) {
            if ($language == $this->language) {
                $dataMap = $this->object->fetchDataMap(false, $language);
                $localizeBodies = [];
                foreach ($bodyFields as $field) {
                    if (isset($dataMap[$field]) && $dataMap[$field]->hasContent()) {
                        $localizeBodies[] = $this->getAttributeAsMailString($dataMap[$field]);
                    }
                }
                $body = implode(' ', $localizeBodies);
                $body = str_replace(['<h4', '<h5', '<h6'], '<h3', $body);
                $body = str_replace(['</h4>', '</h5>', '</h6>'], '</h3>', $body);
                $body = strip_tags($body, '<h1><h2><h3><p><a><ul><li><b><strong><em>');
                $bodies[] = $body;
            }
        }

        $attachmentsFields = $this->fields['article']['attachments'];
        $attachments = [];
        foreach ($this->object->availableLanguages() as $language) {
            if ($language == $this->language) {
                $dataMap = $this->object->fetchDataMap(false, $language);
                foreach ($attachmentsFields as $field) {
                    if (isset($dataMap[$field]) && $dataMap[$field]->hasContent()) {
                        $this->getAttributeAsMailAttachment($dataMap[$field], $attachments);
                    }
                }
            }
        }

        if (count($attachments) > 0) {
            $attachString = [];
            foreach ($attachments as $attachment) {
                if (!isset($attachment['url'])){
                    $attachString[] = '<h3>' . $attachment['label'] . '</h3>';
                }else {
                    $attachString[] = '<p>';
                    $attachString[] = '<a href="' . $attachment['url'] . '">' . $attachment['label'] . '</a>';
                    $attachString[] = '</p>';
                }
            }
            $bodies[] = implode('', $attachString);
        }

        $ini = eZINI::instance();
        if ($ini->hasVariable('RegionalSettings', 'TranslationSA')) {
            $translationSiteAccesses = $ini->variable('RegionalSettings', 'TranslationSA');
            foreach ($translationSiteAccesses as $siteAccessName => $translationName) {
                $saIni = eZSiteAccess::getIni($siteAccessName);
                $locale = $saIni->variable('RegionalSettings', 'ContentObjectLocale');
                if ($locale == $this->language) {
                    $host = $saIni->variable('SiteSettings', 'SiteURL');
                    $host = eZSys::serverProtocol() . "://" . $host;
                    $bodies[] = '<a href="' . $host . '/' .
                        eZURLAliasML::cleanURL('content/view/full/' . $this->object->mainNodeID()) .
                    '">Link</a>';
                    break;
                }
            }
        } else {
            $fullUrl = eZURLAliasML::cleanURL('content/view/full/' . $this->object->mainNodeID());
            eZURI::transformURI($fullUrl, false, 'full');
            $bodies[] = '<a href="' . $fullUrl . '">' . ezpI18n::tr('bootstrapitalia', 'Read more') . '</a>';
        }

        return implode("\n\n", $bodies);
    }

    public function getPlainText(): string
    {
        return '';
    }

    private function getAttributeAsMailString(eZContentObjectAttribute $attribute)
    {
        $content = $attribute->content();

        if ($content instanceof eZXMLText){
            return str_replace('&nbsp;', ' ', $content->attribute('output')->attribute('output_text'));
        }

        if ($content instanceof eZTags) {
            return $content->keywordString(', ');
        }

        if ($content instanceof eZDate || $content instanceof eZDateTime) {
            return $content->toString(true);
        }

        return $attribute->toString();
    }

    private function getAttributeAsMailAttachment(eZContentObjectAttribute $attribute, &$attachments)
    {
        switch ($attribute->attribute('data_type_string')) {
            case eZObjectRelationListType::DATA_TYPE_STRING:
                $relationList = OpenPABase::fetchObjects(explode('-', $attribute->toString()));
                foreach ($relationList as $related) {
                    $dataMap = $related->dataMap();
                    if (isset($dataMap['image']) && $dataMap['image']->hasContent()) {
                        $attachments[] = [
                            'label' => $dataMap['image']->attribute('contentclass_attribute')->name($this->language),
                        ];
                        $this->getAttributeAsMailAttachment($dataMap['image'], $attachments);
                    }
                }
                break;

            case eZImageType::DATA_TYPE_STRING:
                /** @var eZImageAliasHandler $content */
                $content = $attribute->content();
                $original = $content->attribute('original');
                $url = $original['full_path'];
                eZURI::transformURI( $url, true );
                $attachments[] = [
                    'url' => $url,
                    'label' => $attribute->object()->attribute('name'),
                ];
                break;

            case eZBinaryFileType::DATA_TYPE_STRING:
                /** @var \eZBinaryFile $file */
                $file = $attribute->content();
                $url = 'content/download/' . $attribute->attribute('contentobject_id')
                    . '/' . $attribute->attribute('id')
                    . '/' . $attribute->attribute('version')
                    . '/' . urlencode($file->attribute('original_filename'));
                eZURI::transformURI($url, true, 'full');

                $attachments[] = [
                    'label' => $attribute->attribute('contentclass_attribute')->name($this->language),
                ];
                $attachments[] = [
                    'url' => $url,
                    'label' => OpenPABootstrapItaliaOperators::cleanFileName($file->attribute('original_filename')),
                ];
                break;

            case OCMultiBinaryType::DATA_TYPE_STRING:
                $attachments[] = [
                    'label' => $attribute->attribute('contentclass_attribute')->name($this->language),
                ];
                /** @var eZMultiBinaryFile[] $files */
                $files = $attribute->content();
                foreach ($files as $file) {
                    $url = 'ocmultibinary/download/' . $attribute->attribute('contentobject_id')
                        . '/' . $attribute->attribute('id')
                        . '/' . $attribute->attribute('version')
                        . '/' . urlencode($file->attribute('filename'))
                        . '/file'
                        . '/' . urlencode($file->attribute('original_filename'));
                    eZURI::transformURI($url, false, 'full');

                    $attachments[] = [
                        'url' => $url,
                        'label' => $file->attribute('display_name'),
                    ];
                }
                break;
        }
    }
}