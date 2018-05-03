<h2 style="color: #404040 !important;font-family: georgia,serif;font-size: 1.6em;font-weight: normal;line-height: 1.5;padding:0;margin:0;">
    {$item.name|wash()}
</h2>

{if $item.data_map.publish_date}
    <p style="font-size: 0.9em;margin: 4px 0 0;">{attribute_view_gui attribute=$item.data_map.publish_date}</p>
{/if}

{if $item|has_abstract()}
    {$item|abstract()|openpa_shorten(200)}
{/if}




