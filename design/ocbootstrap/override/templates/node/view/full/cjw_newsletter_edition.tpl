{ezpagedata_set( 'left_menu', false() )}
{def $openpa = object_handler($node)}

{if $openpa.content_tools.editor_tools}
    {include uri=$openpa.content_tools.template}
{/if}

<div class="content-view-full class-{$node.class_identifier} row">

    <div class="content-title">
        <h1>{$node.name|wash()}</h1>
    </div>


    <div class="content-main wide">

        {include uri=$openpa.content_main.template}

        {include uri=$openpa.content_detail.template}

        {include uri=$openpa.content_infocollection.template}

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
        
        <h2>Contenuti</h2>
        {include uri=$openpa.control_children.template}

    </div>

</div>

{include uri='design:parts/load_website_toolbar.tpl' current_user=fetch(user, current_user)}