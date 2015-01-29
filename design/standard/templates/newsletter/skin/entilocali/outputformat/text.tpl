{set-block variable=$subject scope=root}{ezini('NewsletterMailSettings', 'EmailSubjectPrefix', 'cjw_newsletter.ini')} {$contentobject.name|wash}{/set-block}

{def $site_url=ezini('SiteSettings', 'SiteURL', 'site.ini')}
{def $site_name=ezini('SiteSettings', 'SiteName', 'site.ini')}

{def $main_node=$contentobject.contentobject.main_node}
{def $notizie=fetch( 'content','list', hash( 'parent_node_id', $main_node.node_id,
                                                  'class_filter_type', 'include',
                                                  'class_filter_array', array( 'cjw_newsletter_article' ),                                                  
                                                  'sort_by',$main_node.sort_array
                                               ))}  
{def $comunicati=fetch( 'content','list', hash( 'parent_node_id', $main_node.node_id,
                                                'class_filter_type', 'include',
                                                'class_filter_array', array( 'comunicato_stampa', 'avviso' ),
                                                'limit', 6,
                                                'sort_by',$main_node.sort_array
                                               ))}
{def $appuntamenti=fetch( 'content','list', hash( 'parent_node_id', $main_node.node_id,
                                                  'class_filter_type', 'include',
                                                  'class_filter_array', array( 'event' ),
                                                  'limit', 6,
                                                  'sort_by',$main_node.sort_array
                                               ))}   

<h1>{$main_node.parent.name|wash()} - {$main_node.name|wash()}</h1> 
{def $timestamp=currentdate()}{$timestamp|l10n('date')}
{if $main_node.data_map.description.has_content}
    {attribute_view_gui attribute=$main_node.data_map.description}
{/if} 

{if $notizie}
{foreach $notizie as $item}
	<h3>{$item.name|wash()}</h3>		
    {$item|abstract()}    	
{/foreach}
{/if}

{if $comunicati}
<h2>News</h2>
{foreach $comunicati as $item}
	<h3>{$item.name|wash()}</h3>
	{attribute_view_gui attribute=$item.data_map.publish_date}
	{if $item|has_abstract()}          
    {$item|abstract()|openpa_shorten(200)}
    {/if}
	Vai alla testo completo: {$site_url}{$item.object.main_node.url_alias|ezurl('no')}
{/foreach}
{/if}

{if $appuntamenti}
<h2>Appuntamenti</h2>
{foreach $comunicati as $item}
	<h3>{$item.name|wash()}</h3>
	{attribute_view_gui attribute=$item.data_map.publish_date}
	{if $item|has_abstract()}          
    {$item|abstract()|openpa_shorten(200)}
    {/if}
	Vai alla testo completo: {$site_url}{$item.object.main_node.url_alias|ezurl('no')}
{/foreach}
{/if}

<br />
<br />
{'To unsubscribe from this newsletter please visit the following link'|i18n('cjw_newsletter/skin/default')}:
url:{'/newsletter/unsubscribe/#_hash_unsubscribe_#'|ezurl('no')}
<br />

{if and( is_set( $main_node.parent.data_map.footer_link), $main_node.parent.data_map.footer_link.has_content )}
{foreach $main_node.parent.data_map.footer_link.content.relation_list as $relation}  
  {def $related = fetch( content, object, hash( object_id, $relation.contentobject_id ) )}        
    {$related.name}: http://{concat($site_url, $related.main_node.url_alias|ezurl('no'))}
  {delimiter} <br /> {/delimiter}
  {undef $related}
{/foreach}
{/if}
<br />

&copy; {currentdate()|datetime( 'custom', '%Y' )} {$site_url}