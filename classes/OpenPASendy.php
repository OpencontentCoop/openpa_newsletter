<?php

class OpenPASendy
{
    const STORAGE_NAME_LISTS = 'sendy_selected_lists';

    const STORAGE_BRAND_ID = 'sendy_brand_id';

    const STORAGE_SINGLE_CAMPAIGN = 'sendy_single_campaign';

    private static $instance;

    const SENDY_VERSION = '4.0.6';

    /**
     * @var eZINI
     */
    private $ini;

    private $brandId;

    public static function instance(): OpenPASendy
    {
        if (!isset(self::$instance)) {
            self::$instance = new OpenPASendy();
        }
        return self::$instance;
    }

    private function __construct()
    {
        $this->ini = eZINI::instance('sendy.ini');
    }

    public function getApiUrl(): string
    {
        return rtrim($this->ini->variable('GeneralSettings', 'ApiUrl'), '/');
    }

    public function getApiKey(): string
    {
        return $this->ini->variable('GeneralSettings', 'ApiKey');
    }

    public function getBrandId(): string
    {
        if (!isset($this->brandId)) {
            $brand = $this->getStorage(self::STORAGE_BRAND_ID);
            if (!$brand) {
                $this->setStorage(
                    self::STORAGE_BRAND_ID,
                    json_encode(
                        $this->ini->variable('GeneralSettings', 'BrandId')
                    )
                );
                $brand = $this->getStorage(self::STORAGE_BRAND_ID);
            }

            $this->brandId = $brand ? json_decode($brand) : '';
        }

        return $this->brandId;
    }

    public static function setBrandId($brandId): void
    {
        self::instance()->setStorage(self::STORAGE_BRAND_ID, json_encode($brandId));
        unset(self::instance()->brandId);
    }

    public function isEnabled(): bool
    {
        return !empty($this->getBrandId()) && !empty($this->getApiKey());
    }

    public static function setSingleCampaignCreation(bool $enabled): void
    {
        if ($enabled) {
            self::instance()->setStorage(self::STORAGE_SINGLE_CAMPAIGN, 1);
        } else {
            self::instance()->removeStorage(self::STORAGE_SINGLE_CAMPAIGN);
        }
    }

    public function getDefaultListId()
    {
        $lists = $this->getLists();

        return $lists[0]['id'] ?? null;
    }

    public function useGdpr(): bool
    {
        return $this->ini->variable('SubscribeSettings', 'Gdpr') == 'true';
    }

    public function isSilent(): bool
    {
        return $this->ini->variable('SubscribeSettings', 'Silent') == 'true';
    }

    public function useBoolean(): bool
    {
        return $this->ini->variable('SubscribeSettings', 'Boolean') == 'true';
    }

    public function getListIdNameList(): array
    {
        $subscriptionLists = [];
        $lists = $this->getLists();
        $currentSiteAccess = eZSiteAccess::current()['name'];
        foreach ($lists as $list) {
            if (in_array($currentSiteAccess, $list['enabled'])) {
                $subscriptionLists[$list['id']] = $list['label'] ?? $list['name'];
            }
        }

        return $subscriptionLists;
    }

    public function getLists(): array
    {
        if (!isset($this->lists)) {
            $lists = $this->getStorage(self::STORAGE_NAME_LISTS);
            if (!$lists) {
                $lists = $this->initStorageLists();
            }
            $this->lists = (array)json_decode($lists, true);
        }
//        $remoteLists = (array)$this->getRemoteLists();
        return $this->lists;
    }

    public function setLists(
        array $lists
    ) {
        $this->setStorage(self::STORAGE_NAME_LISTS, json_encode($lists));
    }

    private function initStorageLists()
    {
        $this->setStorage(self::STORAGE_NAME_LISTS, json_encode($this->getLocaleLists()));
        return $this->getStorage(self::STORAGE_NAME_LISTS);
    }

    private function getRemoteLists(): array
    {
        $lists = [];
        if ($this->isEnabled()) {
            $query = http_build_query([
                'brand_id' => $this->getBrandId(),
                'api_key' => $this->getApiKey(),
                'include_hidden' => 'no',
            ]);
            $context = stream_context_create([
                'ssl' => ['verify_peer' => false, 'verify_peer_name' => false],
            ]);
            $response = file_get_contents(
                $this->getApiUrl() . '/api/lists/get-lists.php?' . $query,
                false,
                $context
            );
            $lists = (array)json_decode($response, true);
        }

        return $lists;
    }

    private function getLocaleLists(): array
    {
        $siteAccesses = eZINI::instance()->variable('RegionalSettings', 'TranslationSA');
        if (empty($siteAccesses)) {
            $siteAccesses = [eZSiteAccess::current()['name'] => eZLocale::instance()->languageName()];
        }
        $subscribeSettings = $this->ini->group('SubscribeSettings');
        $subscriptionLists = [];
        $defaultListId = $this->ini->variable('SubscribeSettings', 'DefaultListId');
        if (!empty($defaultListId)) {
            $subscriptionLists[$defaultListId] = [
                'id' => $defaultListId,
                'name' => '',
                'label' => 'Newsletter',
                'enabled' => array_keys($siteAccesses),
            ];
        }
        foreach ($subscribeSettings['ListArray'] as $listSetting) {
            [$listId, $listName] = explode(';', $listSetting);
            $subscriptionLists[$listId] = [
                'id' => $listId,
                'name' => '',
                'label' => $listName,
                'enabled' => array_keys($siteAccesses),
            ];
        }

        return array_values($subscriptionLists);
    }

    public function createCampaign(
        string $siteUrl,
        string $emailSenderName,
        string $emailSender,
        string $emailReplyTo,
        string $subject,
        string $text,
        string $html
    ) {
        $search = [
            $siteUrl . '/newsletter/unsubscribe/#_hash_unsubscribe_#',
            str_replace('http', 'https', $siteUrl) . '/newsletter/unsubscribe/#_hash_unsubscribe_#',
        ];
        $replace = [
            '[unsubscribe]',
            '[unsubscribe]',
        ];
        $text = str_replace($search, $replace, $text);

        $search = [
            '<a href="' . $siteUrl . '/newsletter/unsubscribe/#_hash_unsubscribe_#' . '">' . ezpI18n::tr(
                'openpa_newsletter',
                'Unsubscribe'
            ) . '</a>',
            '<a href="' . str_replace(
                'http',
                'https',
                $siteUrl
            ) . '/newsletter/unsubscribe/#_hash_unsubscribe_#' . '">' . ezpI18n::tr(
                'openpa_newsletter',
                'Unsubscribe'
            ) . '</a>',
        ];
        $replace = [
            '<unsubscribe>' . ezpI18n::tr('openpa_newsletter', 'Unsubscribe') . '</unsubscribe>',
            '<unsubscribe>' . ezpI18n::tr('openpa_newsletter', 'Unsubscribe') . '</unsubscribe>',
        ];
        $html = str_replace($search, $replace, $html);

        $postdata = [
            'from_name' => $emailSenderName,
            'from_email' => $emailSender,
            'reply_to' => $emailReplyTo,
            'title' => $subject,
            'subject' => $subject,
            'plain_text' => $text,
            'html_text' => $html,
            'brand_id' => $this->getBrandId(),
            'api_key' => $this->getApiKey(),
        ];
        $opts = [
            'ssl' => ['verify_peer' => false, 'verify_peer_name' => false],
            'http' => [
                'method' => 'POST',
                'header' => 'Content-type: application/x-www-form-urlencoded',
                'content' => http_build_query($postdata),
            ],
        ];
        $context = stream_context_create($opts);
        $response = file_get_contents($this->getApiUrl() . '/api/campaigns/create.php', false, $context);

        if (strpos($response, 'Campaign created') === false && strpos($response, 'Campaign scheduled') === false) {
            throw new Exception($response);
        }

        return $response;
    }

    public function createCreateSingleContentCampaign(
        eZContentObject $contentObject,
        string $language = null
    ) {
        $url = 'https://' . eZINI::instance()->variable('SiteSettings', 'SiteURL');
        $address = OpenPASMTPTransport::getEmailSenderAddress();
        $builder = new OpenPACampaignFromContentBuilder($contentObject, $language);
        $this->createCampaign(
            $url,
            eZINI::instance()->variable('SiteSettings', 'SiteName'),
            $address,
            $address,
            $builder->getSubject(),
            $builder->getPlainText(),
            $builder->getHtmlText()
        );
    }

    public function canCreateSingleContentCampaign($object = null): bool {
        if (self::isBootstrapItalia2Design()) {
            $canCreate = $this->getStorage(self::STORAGE_SINGLE_CAMPAIGN);
            if ($canCreate && $object instanceof eZContentObject) {
                $canCreate = (new OpenPACampaignFromContentBuilder($object))->canCreate();
            }
            return $canCreate;
        }
        return false;
    }

    private static function isBootstrapItalia2Design(): bool
    {
        return eZINI::instance()->variable('DesignSettings', 'SiteDesign') === 'bootstrapitalia2'
            || in_array(
                'bootstrapitalia2',
                eZINI::instance()->variable('DesignSettings', 'AdditionalSiteDesignList')
            );
    }

    protected function getStorage(
        $key
    ) {
        $siteData = eZSiteData::fetchByName($key);
        if (!$siteData instanceof eZSiteData) {
            return false;
        }
        return $siteData->attribute('value');
    }

    protected function removeStorage(
        $key
    ) {
        $siteData = eZSiteData::fetchByName($key);
        if ($siteData instanceof eZSiteData) {
            $siteData->remove();
        }
    }

    protected function setStorage(
        $key,
        $value
    ) {
        $siteData = eZSiteData::fetchByName($key);
        if (!$siteData instanceof eZSiteData) {
            $siteData = eZSiteData::create($key, $value);
        }
        $siteData->setAttribute('value', $value);
        $siteData->store();
    }
}