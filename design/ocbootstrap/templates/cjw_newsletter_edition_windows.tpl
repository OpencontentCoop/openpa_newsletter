
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

{* only show children if edition is in draft status *}
{*if $newsletter_edition_status|eq('draft')*}

    {* Children window.*}
    {if $node.object.content_class.is_container}
    <div class="global-view-full">
        <h2>Contenuti</h2>
        {foreach $node.children as $child sequence array( 'col-even', 'col-odd' ) as $style}
        <div class="{$style} col col-notitle float-break">
            {node_view_gui view=line content_node=$child}
        </div>
        {/foreach}
    </div>
    {/if}

{*/if*}