<?php

class OpenPANewsletterServerFunctions extends ezjscServerFunctions
{
    const STATUS_SUCCESS = 'success';

    const STATUS_WARNING = 'warning';

    const STATUS_ERROR = 'danger';

    public static function subscribe()
    {
        $http = eZHTTPTool::instance();

        $responseCode = self::STATUS_SUCCESS;
        $responseText = ezpI18n::tr('openpa_newsletter', 'Registration successful!');
        $errorText = ezpI18n::tr('openpa_newsletter', 'Error processing your request: contact support');
        $listErrorText = ezpI18n::tr('openpa_newsletter', 'Error processing the request for subscription to the list');
        $alreadySubscribedText = ezpI18n::tr('openpa_newsletter', 'The address is already registered on the list');
        $missingListText = ezpI18n::tr('openpa_newsletter', 'At least one list must be selected');

        try {
            $ini = eZINI::instance('sendy.ini');
            $generalSettings = $ini->group('GeneralSettings');
            if ($generalSettings['EnableSendy'] == 'enabled') {

                if ($http->hasPostVariable('hp') && $http->postVariable('hp') != '') {
                    throw new Exception("Spam detected");
                }

                $subscribeSettings = $ini->group('SubscribeSettings');
                $name = $http->hasPostVariable('name') ? $http->postVariable('name') : false;
                $email = $http->hasPostVariable('email') ? $http->postVariable('email') : false;
                $lists = $http->hasPostVariable('list') ? $http->postVariable('list') : false;
                $gdpr = $http->hasPostVariable('gdpr');

                if (empty($lists)){
                    throw new InvalidArgumentException($missingListText);
                }

                $subscriptionLists = [];
                if (count($subscribeSettings['ListArray']) > 0) {
                    foreach ($subscribeSettings['ListArray'] as $listSetting) {
                        [$listId, $listName] = explode(';', $listSetting);
                        $subscriptionLists[$listId] = $listName;
                    }
                    foreach ($lists as $list) {
                        if (!isset($subscriptionLists[$list])) {
                            throw new Exception("Invalid list id: $list");
                        }
                    }
                } elseif ($lists[0] != $subscribeSettings['DefaultListId']) {
                    throw new Exception("Invalid list");
                }

                if ($subscribeSettings['Gdpr'] == 'true' && !$gdpr) {
                    throw new Exception("Missing GDPR field");
                }

                $results = [];
                $texts = [];
                foreach ($lists as $list) {
                    $subscribe = self::doSubscribe($name, $email, $list);
                    $listName = isset($subscriptionLists[$list]) ? $subscriptionLists[$list] : '';
                    $result = [
                        'list' => $list,
                        'subscription' => $subscribe['message'],
                    ];

                    if ($subscribe['code'] == self::STATUS_ERROR) {
                        $responseCode = self::STATUS_ERROR;
                        switch ($subscribe['message']) {
                            case "Already subscribed.":
                                $texts[] = "$alreadySubscribedText $listName";
                                break;
                            default:
                                $texts[] = "$listErrorText $listName (" . $subscribe['message'] . ")";
                        }
                    } else {
                        $status = self::getSubscriptionStatus($email, $list);
                        $result['status'] = $status['message'];
                        if ($status['code'] == self::STATUS_ERROR) {
                            $texts[] = "$listErrorText $listName (" . $status['message'] . ")";
                        } elseif ($status['code'] == self::STATUS_WARNING) {
                            switch ($status['message']) {
                                case "Unconfirmed":
                                    $texts[] = ezpI18n::tr('cjw_newsletter/subscribe_success', 'You are registered for our newsletter.') . ' '
                                        . ezpI18n::tr('cjw_newsletter/subscribe_success', 'An email was sent to your address %email.', null, ['%email' => $email]) . ' '
                                        . ezpI18n::tr('cjw_newsletter/subscribe_success', 'Please note that your subscription is only active if you clicked confirmation link in these email.');
                                    break;
                                default:
                                    $texts[] = ezpI18n::tr('openpa_newsletter',
                                        'There are problems with the email address entered: at this moment the address is in status %status%', '',
                                        ['%status%' => $status['message']]
                                    );
                            }
                        }
                    }
                    $results[] = $result;
                }

                $responseMessages = $results;
                if (!empty($texts)) {
                    $responseText = implode("\n", $texts);
                }

            } else {
                throw new Exception('Configuration Error');
            }
        } catch (InvalidArgumentException $e) {
            $responseCode = self::STATUS_ERROR;
            $responseMessages = [$e->getMessage()];
            $responseText = $missingListText;
            eZDebug::writeError($e->getMessage(), __METHOD__);
        } catch (Exception $e) {
            $responseCode = self::STATUS_ERROR;
            $responseMessages = [$e->getMessage()];
            $responseText = $errorText;
            eZDebug::writeError($e->getMessage(), __METHOD__);
        }

        header('Content-Type: application/json');
        echo json_encode([
            'code' => $responseCode,
            'messages' => $responseMessages,
            'text' => $responseText,
        ]);
        eZExecution::cleanExit();
    }

    private static function doSubscribe($name, $email, $list)
    {
        $ini = eZINI::instance('sendy.ini');
        $generalSettings = $ini->group('GeneralSettings');
        $subscribeSettings = $ini->group('SubscribeSettings');
        $postdata = [
            'email' => $email,
            'list' => $list,
            'api_key' => $generalSettings['ApiKey'],
        ];
        if ($name) {
            $postdata['name'] = $name;
        }
        if ($subscribeSettings['Gdpr'] == 'true') {
            $postdata['gdpr'] = 'true';
        }
        if ($subscribeSettings['Silent'] == 'true') {
            $postdata['silent'] = 'true';
        }
        if ($subscribeSettings['Boolean'] == 'true') {
            $postdata['boolean'] = 'true';
        }
        $opts = [
            'ssl' => ['verify_peer' => false, 'verify_peer_name' => false],
            'http' => ['method' => 'POST', 'header' => 'Content-type: application/x-www-form-urlencoded', 'content' => http_build_query($postdata)],
        ];
        $context = stream_context_create($opts);
        $response = file_get_contents(rtrim($generalSettings['ApiUrl'], '/') . '/subscribe', false, $context);

        $responseMap = [
            "true" => self::STATUS_SUCCESS,
            "1" => self::STATUS_SUCCESS,

            "Some fields are missing." => 'exception',
            "API key not passed" => 'exception',
            "Invalid API key" => 'exception',
            "Invalid email address." => self::STATUS_ERROR,
            "Already subscribed." => self::STATUS_ERROR,
            "Bounced email address." => self::STATUS_ERROR,
            "Email is suppressed." => self::STATUS_ERROR,
            "Invalid list ID." => self::STATUS_ERROR,
        ];

        if ($responseMap[$response] === 'exception') {
            throw new Exception($response);
        }

        return ['message' => $response, 'code' => $responseMap[$response]];
    }

    private static function getSubscriptionStatus($email, $list)
    {
        $ini = eZINI::instance('sendy.ini');
        $generalSettings = $ini->group('GeneralSettings');
        $postdata = [
            'email' => $email,
            'list_id' => $list,
            'api_key' => $generalSettings['ApiKey'],
        ];
        $opts = [
            'ssl' => ['verify_peer' => false, 'verify_peer_name' => false],
            'http' => ['method' => 'POST', 'header' => 'Content-type: application/x-www-form-urlencoded', 'content' => http_build_query($postdata)],
        ];
        $context = stream_context_create($opts);
        $response = file_get_contents(rtrim($generalSettings['ApiUrl'], '/') . '/api/subscribers/subscription-status.php', false, $context);

        $responseStatusMap = [
            "Subscribed" => self::STATUS_SUCCESS,
            "Unsubscribed" => self::STATUS_SUCCESS,

            "Unconfirmed" => self::STATUS_WARNING,
            "Bounced" => self::STATUS_WARNING,
            "Soft bounced" => self::STATUS_WARNING,
            "Complained" => self::STATUS_WARNING,

            "No data passed" => 'exception',
            "API key not passed" => 'exception',
            "Invalid API key" => 'exception',
            "Email not passed" => 'exception',
            "List ID not passed" => 'exception',
            "Email does not exist in list" => self::STATUS_ERROR,
        ];

        if ($responseStatusMap[$response] === 'exception') {
            throw new Exception($response);
        }

        return ['message' => $response, 'code' => $responseStatusMap[$response]];
    }

    public static function createcampaign()
    {
        $http = eZHTTPTool::instance();

        $ini = eZINI::instance('sendy.ini');
        $generalSettings = $ini->group('GeneralSettings');

        $responseCode = self::STATUS_SUCCESS;
        $responseMessages = [];
        $responseText = ezpI18n::tr('openpa_newsletter',
            "Campaign created successfully: now you can send the newsletter from %sendy_api_url%. After sending it, click on the 'Mark as sent' button to archive this newsletter", '',
            ['%sendy_api_url%' => $generalSettings['ApiUrl']]
        );
        $errorText = ezpI18n::tr('openpa_newsletter', 'Error processing your request: contact support');

        try {
            $canSend = eZUser::currentUser()->hasAccessTo('newsletter', 'send');
            if ($canSend['accessWord'] != 'yes') {
                throw new Exception('Unauthorized');
            }

            if ($generalSettings['EnableSendy'] == 'enabled') {
                $attributeId = (int)$http->postVariable('id');
                $attributeVersion = (int)$http->postVariable('version');
                $attribute = eZContentObjectAttribute::fetch($attributeId, $attributeVersion);
                if (!$attribute instanceof eZContentObjectAttribute) {
                    throw new Exception('Edition not found');
                }
                if ($attribute->attribute('data_type_string' !== CjwNewsletterEditionType::DATA_TYPE_STRING)) {
                    throw new Exception('Invalid data');
                }

                /** @var CjwNewsletterEdition $editionObject */
                $editionObject = $attribute->attribute('content');
                $outputXml = $editionObject->createOutputXml();

                $listAttributeContent = $editionObject->attribute('list_attribute_content');
                $emailSender = $listAttributeContent->attribute('email_sender');
                $emailSenderName = $listAttributeContent->attribute('email_sender_name');
                $emailReplyTo = $listAttributeContent->attribute('email_reply_to');

                $sendObject = new CjwNewsletterEditionSend(['output_xml' => $outputXml]);
                $outputFormatStringArray = $sendObject->getParsedOutputXml();
                foreach ($outputFormatStringArray as $outputFormatId => $outputFormatNewsletterContentArray) {
                    if ($outputFormatNewsletterContentArray['html_mail_image_include'] == 1) {
                        $outputFormatStringArray[$outputFormatId] = CjwNewsletterEdition::prepareImageInclude($outputFormatNewsletterContentArray);
                    }
                }

                $subject = $outputFormatStringArray[0]['subject'];
                $url = $outputFormatStringArray[0]['ez_url'];

                $search = [
                    $url . '/newsletter/unsubscribe/#_hash_unsubscribe_#',
                    str_replace('http', 'https', $url) . '/newsletter/unsubscribe/#_hash_unsubscribe_#',
                ];
                $replace = [
                    '[unsubscribe]',
                    '[unsubscribe]',
                ];
                $text = str_replace($search, $replace, $outputFormatStringArray[0]['body']['text']);

                $search = [
                    '<a href="' . $url . '/newsletter/unsubscribe/#_hash_unsubscribe_#' . '">' . ezpI18n::tr('openpa_newsletter', 'Unsubscribe') . '</a>',
                    '<a href="' . str_replace('http', 'https', $url) . '/newsletter/unsubscribe/#_hash_unsubscribe_#' . '">' . ezpI18n::tr('openpa_newsletter', 'Unsubscribe') . '</a>',
                ];
                $replace = [
                    '<unsubscribe>' . ezpI18n::tr('openpa_newsletter', 'Unsubscribe') . '</unsubscribe>',
                    '<unsubscribe>' . ezpI18n::tr('openpa_newsletter', 'Unsubscribe') . '</unsubscribe>',
                ];
                $html = str_replace($search, $replace, $outputFormatStringArray[0]['body']['html']);


                $postdata = [
                    'from_name' => $emailSenderName,
                    'from_email' => $emailSender,
                    'reply_to' => $emailReplyTo,
                    'title' => $subject,
                    'subject' => $subject,
                    'plain_text' => $text,
                    'html_text' => $html,
                    'brand_id' => $generalSettings['BrandId'],
                    'api_key' => $generalSettings['ApiKey'],
                ];
                $opts = [
                    'ssl' => ['verify_peer' => false, 'verify_peer_name' => false],
                    'http' => ['method' => 'POST', 'header' => 'Content-type: application/x-www-form-urlencoded', 'content' => http_build_query($postdata)],
                ];
                $context = stream_context_create($opts);
                $response = file_get_contents(rtrim($generalSettings['ApiUrl'], '/') . '/api/campaigns/create.php', false, $context);

                if (strpos($response, 'Campaign created') === false) {
                    $responseCode = self::STATUS_ERROR;
                    $responseText = $response;
                }

            } else {
                throw new Exception('Configuration Error');
            }
        } catch (Exception $e) {
            $responseCode = self::STATUS_ERROR;
            $responseMessages = [$e->getMessage()];
            $responseText = $errorText;
            eZDebug::writeError($e->getMessage(), __METHOD__);
        }

        header('Content-Type: application/json');
        echo json_encode([
            'code' => $responseCode,
            'messages' => $responseMessages,
            'text' => $responseText,
        ]);
        eZExecution::cleanExit();
    }

    public static function archive()
    {
        $http = eZHTTPTool::instance();

        $ini = eZINI::instance('sendy.ini');
        $generalSettings = $ini->group('GeneralSettings');

        $responseCode = self::STATUS_SUCCESS;
        $responseMessages = [];
        $responseText = "";
        $errorText = ezpI18n::tr('openpa_newsletter', 'Error processing your request: contact support');;

        try {
            $canSend = eZUser::currentUser()->hasAccessTo('newsletter', 'send');
            if ($canSend['accessWord'] != 'yes') {
                throw new Exception('Unauthorized');
            }

            if ($generalSettings['EnableSendy'] == 'enabled') {
                $attributeId = (int)$http->postVariable('id');
                $attributeVersion = (int)$http->postVariable('version');
                $attribute = eZContentObjectAttribute::fetch($attributeId, $attributeVersion);
                if (!$attribute instanceof eZContentObjectAttribute) {
                    throw new Exception('Edition not found');
                }
                if ($attribute->attribute('data_type_string' !== CjwNewsletterEditionType::DATA_TYPE_STRING)) {
                    throw new Exception('Invalid data');
                }

                /** @var CjwNewsletterEdition $editionObject */
                $editionObject = $attribute->attribute('content');
                /** @var CjwNewsletterEditionSend $sendObject */
                $sendObject = CjwNewsletterEditionSend::create($editionObject);
                //$sendObject->setAttribute('status', CjwNewsletterEditionSend::STATUS_ABORT);
                $sendObject->setAttribute('status', CjwNewsletterEditionSend::STATUS_MAILQUEUE_PROCESS_FINISHED);
                $sendObject->store();
                eZContentCacheManager::clearContentCache($attribute->attribute('contentobject_id'));

            } else {
                throw new Exception('Configuration Error');
            }

        } catch (Exception $e) {
            $responseCode = self::STATUS_ERROR;
            $responseMessages = [$e->getMessage()];
            $responseText = $errorText;
            eZDebug::writeError($e->getMessage(), __METHOD__);
        }

        header('Content-Type: application/json');
        echo json_encode([
            'code' => $responseCode,
            'messages' => $responseMessages,
            'text' => $responseText,
        ]);
        eZExecution::cleanExit();
    }

    public static function getDraftEditions()
    {
        $response = [];
        $list = OpenPANewsletterOperator::getDraftEditions();
        foreach ($list as $edition) {
            $response[] = [
                'node_id' => (int)$edition->attribute('node_id'),
                'name' => $edition->attribute('name'),
                'list' => $edition->attribute('parent')->attribute('name'),
            ];
        }

        header('Content-Type: application/json');
        echo json_encode([
            'editions' => $response,
        ]);
        eZExecution::cleanExit();
    }
}
