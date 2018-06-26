{def $openpa = object_handler($node)}
{if $openpa.content_tools.editor_tools}
    {include uri=$openpa.content_tools.template}
{/if}
{def $show_left = false()}

<div class="openpa-full class-{$node.class_identifier}">
    <div class="title">
        
        {let hide_status=""}
        {section show=$node.is_invisible}
        {set hide_status=concat( '(', $node.hidden_status_string, ')' )}
        {/section}

        {include uri='design:openpa/full/parts/node_languages.tpl'}
        <h2>{$node.name|wash()} {$hide_status}</h2>
    </div>
    <div class="content-container">
        <div class="content">

            {include uri=$openpa.content_main.template}

            {include uri=$openpa.content_detail.template}

            <div class="Callout Callout--must u-text-r-xs u-margin-bottom-m u-margin-top-m">
                <h2>Edizioni</h2>
                {include uri=$openpa.control_children.template}
            </div>

        </div>
        
    </div>
    {if $openpa.content_date.show_date}
        {include uri=$openpa.content_date.template}
    {/if}
</div>


