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
        
        {include uri='design:parts/children/tree.tpl'}

    </div>

</div>

{include uri='design:parts/load_website_toolbar.tpl' current_user=fetch(user, current_user)}