<form action={'newsletter/send'|ezurl()} method="post">
    <strong>{"Send Test Newsletter at"|i18n("cjw_newsletter/send")}: 'test1@example.com;test2@example.com'</strong>

    {def $email_receiver_test = $newsletter_list_attribute_content.email_receiver_test}

    <div class="Grid Grid--withGutter">
        <div class="Grid-cell u-md-size1of2 u-lg-size1of2">
            {* Testemail input*}
            <input class="Form-input" type="text" name="EmailReseiverTestInput" value="{$email_receiver_test}" />
        </div>

        <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" />
        <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
        <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
        <input type="hidden" name="mail_newsletter" value="true" />

        <div class="Grid-cell u-md-size1of2 u-lg-size1of2">
            {* Newsletter test email button. *}
            <input type="submit" class="button" name="SendNewsletterTestButton" value="{"Send Test Newsletter"|i18n("cjw_newsletter/send")}" />
        </div>
    </div>

</form>
