<div class="content-detail">
    <strong>{'Newsletter edition preview archive'|i18n( 'cjw_newsletter/cjw_newsletter_edition_status' )}</strong>


    {def $show_iframes = true()}
    {if ezpreference( 'admin_navigation_content' )|eq(0)}
        {set $show_iframes = false()}
    {/if}
        {* show iframes or icons*}
        {include uri="design:includes/cjwnewsletteredition_preview_archive.tpl" newsletter_edition_attribute=$newsletter_edition_attribute show_iframes=$show_iframes height="100"}
    </div>
    {undef $show_iframes}

    <form action={'newsletter/send'|ezurl()}  method="post">
        <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" /><input type="hidden" name="ContentNodeID" value="{$node.node_id}" /><input type="hidden" name="ContentObjectID" value="{$node.object.id}" /><input type="hidden" name="mail_newsletter" value="true" />
        <div class="block">
            <div class="left">
                {* Newsletter button. *}

                {if and( $node.can_remove,$node.data_map.newsletter_edition.content.is_draft )}
                    <input class="button" type="submit" name="SendNewsletterButton" value="{"Send Newsletter"|i18n("cjw_newsletter/send")}"  onclick="return confirm('{'Do you really want to send out this newsletter to all recipients of this Newsletterlist?'|i18n( 'cjw_newsletter/cjw_newsletter_edition_preview' )}')" />
                {/if}

            </div>{* Custom content action buttons. *}
            <div class="right">
            </div>
            <div class="break">
            </div>
        </div>
    </form>
</div>
