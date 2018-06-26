
{def $newsletter_edition_attribute = $node.data_map.newsletter_edition
     $newsletter_edition_attribute_content = $newsletter_edition_attribute.content
     $newsletter_list_attribute_content = $newsletter_edition_attribute.content.list_attribute_content
     $newsletter_edition_status = $newsletter_edition_attribute_content.status}

{* Newsletter status *}
{include uri='design:cjw_newsletter_edition_status.tpl'}

{* Newsletter testmail *}
{include uri='design:cjw_newsletter_edition_send_testmail.tpl'}

{if $newsletter_edition_status|ne('draft')}
    {* Newsletter testmail *}
    {include uri='design:cjw_newsletter_edition_send_statistic.tpl'}
    
    {* Newsletter preview iframes *}
    {include uri='design:cjw_newsletter_edition_preview_archive.tpl'}

{else}
    {* Newsletter preview iframes *}
    {include uri='design:cjw_newsletter_edition_preview.tpl'}
{/if}
