<table width="100%">
<tr>
  <td>
    <p style="color: #fff; font-size: 12px; margin: 20px 20px 0;">
      Per annullare la sottoscrizionie a questa newsletter clicca sul seguente link:
      <a style="color: #fff;" href="{'/newsletter/unsubscribe/#_hash_unsubscribe_#'|ezurl('no')}">annulla sottoscrizione</a>
    </p>
    <p style="color: #fff; font-size: 12px; margin: 10px 20px 20px;">
      &copy; {$timestamp|datetime( 'custom', '%Y' )} <a href="http://{$site_url}/" title="vai al sito {$site_name}" style="color: #fff;">{$site_name}</a>
      {if and( is_set( $main_node.parent.data_map.footer_link ), $main_node.parent.data_map.footer_link.has_content )}      
       - 
        {foreach $main_node.parent.data_map.footer_link.content.relation_list as $relation}
          {def $related = fetch( content, object, hash( object_id, $relation.contentobject_id ) )}        
            <a style="color: #fff;" href="http://{concat($site_url, $related.main_node.url_alias|ezurl('no'))}">{$related.name|wash()}</a>
          {delimiter} - {/delimiter}
          {undef $related}
        {/foreach}      
      {/if} 
    </p>
  </td>            
</tr>
</table>