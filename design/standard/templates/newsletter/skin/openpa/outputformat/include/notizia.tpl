<h2 style="color: #404040 !important;font-family: arial,serif;font-size: 1.6em;font-weight: normal;line-height: 0.9;padding:0;margin:0;">
{$item.name|wash()}
</h2>

{if $item.data_map.publish_date}
<p style="font-size: 0.9em;margin: 4px 0 0;">{attribute_view_gui attribute=$item.data_map.publish_date}</p>
{/if}

{$item|abstract()}