{set $from_year = cond( $item.data_map.from_time.has_content, $item.data_map.from_time.content.timestamp|datetime( custom, '%Y'), false() )
     $from_month = cond( $item.data_map.from_time.has_content, $item.data_map.from_time.content.timestamp|datetime( custom, '%m'), false() )
     $from_day = cond( $item.data_map.from_time.has_content, $item.data_map.from_time.content.timestamp|datetime( custom, '%j'), false() )
     $to_year = cond( $item.data_map.to_time.has_content, $item.data_map.to_time.content.timestamp|datetime( custom, '%Y'), false() )
     $to_month = cond( $item.data_map.to_time.has_content, $item.data_map.to_time.content.timestamp|datetime( custom, '%n'), false() )
     $to_day = cond( $item.data_map.to_time.has_content, $item.data_map.to_time.content.timestamp|datetime( custom, '%j'), false() )
     $same_day = false()
}

{if and( $from_year|eq( $to_year ), $from_month|eq( $to_month ), $from_day|eq( $to_day ) )}
    {set $same_day = true()}
{/if} 

<h2 style="color: #404040 !important;font-family: arial,serif;font-size: 1.2em;font-weight: bold;line-height: 0.9;padding:0;margin:0;">
{$item.name|wash()}
</h2>

{if $same_day}
   <p style="font-size: 1em;margin: 4px 0 0;">
      {$item.data_map.from_time.content.timestamp|l10n( 'date' )}
   </p>
{elseif $item.data_map.to_time.has_content}
   <p style="font-size: 1em;margin: 4px 0 0;">
      da {$item.data_map.from_time.content.timestamp|l10n( 'date' )} a {$item.data_map.to_time.content.timestamp|l10n( 'date' )} 
   </p>
{else}
   <p style="font-size: 1em;margin: 4px 0 0;">
      {$item.data_map.from_time.content.timestamp|l10n( 'date' )}
   </p>
{/if}

{if $item|has_abstract()}          
  <p style="margin:6px 0;">{$item|abstract()|openpa_shorten(200)}</p>
{elseif $item.data_map.informazioni.has_content}
<p style="margin:6px 0;">{$item.data_map.informazioni.content.output.output_text|openpa_shorten(150)}</p>        
{/if}

<p style="text-align: right;padding:0;">
<a href="http://{concat($site_url, $item.object.main_node.url_alias|ezurl('no'))}" title="Per saperne di più" style="color: #006699">Leggi tutto</a>
<img border="0" style="margin:0;outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;" alt="" src={"images/newsletter/skin/openpa/arrow-left.gif"|ezdesign()} />
</p>
