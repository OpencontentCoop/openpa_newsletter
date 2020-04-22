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
        $responseText = "Iscrizione effettuata con successo!";
        $errorText = "Errore elaborando la richiesta: contatta il supporto";
        $listErrorText = "Errore elaborando la richiesta di iscrizione alla lista";
        $statusBlacklistedText = "Ci sono dei problemi con l'indirizzo email inserito: in questo momento l'indirizzo è in stato ";
        $alreadySubscribedText = "L'indirizzo risulta già iscritto alla lista";

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

                $subscriptionLists = [];
                if (count($subscribeSettings['ListArray']) > 0) {
                    foreach ($subscribeSettings['ListArray'] as $listSetting) {
                        list($id, $name) = explode(';', $listSetting);
                        $subscriptionLists[$id] = $name;
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
                                    $texts[] = $statusBlacklistedText . $status['message'];
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
            'text' => $responseText
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
        $opts = array('http' => array('method' => 'POST', 'header' => 'Content-type: application/x-www-form-urlencoded', 'content' => http_build_query($postdata)));
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
        $opts = array('http' => array('method' => 'POST', 'header' => 'Content-type: application/x-www-form-urlencoded', 'content' => http_build_query($postdata)));
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
        $responseText = "Campagna creata con successo: ora puoi inviare la newsletter da " . $generalSettings['ApiUrl'];
        $errorText = "Errore elaborando la richiesta: contatta il supporto";

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
                $emailReturnPath = $listAttributeContent->attribute('email_return_path');

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
                    str_replace('http', 'https', $url) . '/newsletter/unsubscribe/#_hash_unsubscribe_#'
                ];
                $replace = [
                    '[unsubscribe]',
                    '[unsubscribe]'
                ];
                $text = str_replace($search, $replace, $outputFormatStringArray[0]['body']['text']);

                $search = [
                    '<a href="' . $url . '/newsletter/unsubscribe/#_hash_unsubscribe_#' . '">annulla sottoscrizione</a>',
                    '<a href="' . str_replace('http', 'https', $url) . '/newsletter/unsubscribe/#_hash_unsubscribe_#' . '">annulla sottoscrizione</a>',
                ];
                $replace = [
                    '<unsubscribe>annulla sottoscrizione</unsubscribe>',
                    '<unsubscribe>annulla sottoscrizione</unsubscribe>',
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
                $opts = array('http' => array('method' => 'POST', 'header' => 'Content-type: application/x-www-form-urlencoded', 'content' => http_build_query($postdata)));
                $context = stream_context_create($opts);
                $response = file_get_contents(rtrim($generalSettings['ApiUrl'], '/') . '/api/campaigns/create.php', false, $context);

                if (strpos($response, 'Campaign created') === false){
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
            'text' => $responseText
        ]);
        eZExecution::cleanExit();
    }
}