<h2 style="color: #404040 !important;font-family: georgia,serif;font-size: 1.6em;font-weight: normal;line-height: 1.5;padding:0;margin:0;">
    {$item.name|wash()}
</h2>

{if $item.data_map.publish_date}
    <p style="font-size: 0.9em;margin: 4px 0 0;">{attribute_view_gui attribute=$item.data_map.publish_date}</p>
{/if}

{$item.data_map.description.content.output.output_text}

{def $embeds = $item.data_map.description.content.output.output_text|search_embed()}

{foreach $embeds as $embed}
    {def $oembed = get_oembed_object($embed)}
    {if $oembed.thumbnail_url}
        <a href="{$embed}"><img src="{$oembed.thumbnail_url}" alt="{$oembed.title}" /></a>
    {/if}
{/foreach}


