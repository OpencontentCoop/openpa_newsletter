<h2 style="color: #404040 !important;font-family: georgia,serif;font-size: 1.6em;font-weight: normal;line-height: 1.5;padding:0;margin:0;">
{$item.name|wash()}
</h2>
{if $item.data_map.publish_date}
<p style="font-size: 0.9em;margin: 4px 0 0;">{attribute_view_gui attribute=$item.data_map.publish_date}</p>
{/if}

{if $item|has_abstract()}          
  <p>{$item|abstract()|openpa_shorten(200)}</p>
{/if}
<p style="text-align: right;padding:0;">
<a href="http://{concat($site_url, $item.object.main_node.url_alias|ezurl('no'))}" title="Per saperne di più" style="color: #006699">Per saperne di più</a> 
<img border="0" style="margin:0;outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;" alt="" src={"images/newsletter/skin/entilocali/arrow-left.gif"|ezdesign()} />
</p>