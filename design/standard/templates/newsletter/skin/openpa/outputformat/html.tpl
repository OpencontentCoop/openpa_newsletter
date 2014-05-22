{set-block scope=global variable=cache_ttl}0{/set-block}
{set-block variable=$html_mail}<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> 

{def $site_url = ezini('SiteSettings', 'SiteURL', 'site.ini')}
{def $main_node = $contentobject.contentobject.main_node}
{set-block variable=$subject scope=root}[{$main_node.parent.name|wash()}] {$contentobject.name|wash}{/set-block}
{def $ente = fetch( content, node, hash( node_id, ezini('NodeSettings','RootNode','content.ini') ))}
{def $site_name = cond( $ente, $ente.name|wash(), ezini('SiteSettings','SiteName')|wash() )}
{def $timestamp=currentdate()}
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


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>{$#subject}</title>
  {include uri='design:newsletter/skin/openpa/outputformat/include/style.tpl'}  
</head>
<body style="width:100% !important; -webkit-text-size-adjust:100%; -ms-text-size-adjust:100%; margin:0; padding:0;">

<p style="color:#666666;font-family:arial,helvetica,sans-serif;font-size:11px;text-align:center">Non visualizzi correttamente questa email? <a href="http://{ezini( 'SiteSettings', 'SiteURL' )}/newsletter/archive/#_hash_newsletter_#">Leggila sul sito</a></p>

<table style="background-color: #D2D3D7; font-family: helvetica, arial, sans-serif; font-size: 12px; border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt; margin:0; padding:0; width:100% !important; line-height: 100% !important;" cellpadding="0" cellspacing="0" border="0" id="backgroundTable">
  {def $edition_data_map = $contentobject.data_map}
  <tr>
    <td valign="top"> 
    <table cellpadding="0" cellspacing="0" border="0" align="center" width="700" style="border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">
      
      {* header *}
      <tr><td>{include uri='design:newsletter/skin/openpa/outputformat/include/header.tpl'} </td></tr>
      
      {* body *}
      <tr>
        <td colspan="2" style="background-color:#FFFFFF;padding-bottom: 20px" align="center" >
          
          <div style="margin: 20px 0; text-align: left;width: 660px;">
            {if $main_node.data_map.description.has_content}
              <div style="border-bottom: 1px dotted #666;border-top: 1px dotted #666; margin: 10px 5px 20px; padding: 5px 0;font-size:14px">
                {attribute_view_gui attribute=$main_node.data_map.description}
              </div>
            {/if}
          </div>

          {if $notizie}
            {include uri='design:newsletter/skin/openpa/outputformat/include/notizie.tpl' items=$notizie}
          {/if}
          
          {if $comunicati}            
              {switch match=$comunicati|count()}
                  {case match=3}
                     {include uri='design:newsletter/skin/openpa/outputformat/include/comunicati.tpl' items=array( $comunicati[0] )}   
                     {include uri='design:newsletter/skin/openpa/outputformat/include/comunicati.tpl' items=array( $comunicati[1], $comunicati[2] )}
                  {/case}
                  {case match=4}
                     {include uri='design:newsletter/skin/openpa/outputformat/include/comunicati.tpl' items=array( $comunicati[0], $comunicati[1] )}                     
                     {include uri='design:newsletter/skin/openpa/outputformat/include/comunicati.tpl' items=array( $comunicati[2], $comunicati[3] )}                     
                  {/case}
                  {case match=5}                     
                     {include uri='design:newsletter/skin/openpa/outputformat/include/comunicati.tpl' items=array( $comunicati[0] )}   
                     {include uri='design:newsletter/skin/openpa/outputformat/include/comunicati.tpl' items=array( $comunicati[1], $comunicati[2] )}
                     {include uri='design:newsletter/skin/openpa/outputformat/include/comunicati.tpl' items=array( $comunicati[3], $comunicati[4] )}
                  {/case}
                  {case match=6}
                     {include uri='design:newsletter/skin/openpa/outputformat/include/comunicati.tpl' items=array( $comunicati[0], $comunicati[1] )}                     
                     {include uri='design:newsletter/skin/openpa/outputformat/include/comunicati.tpl' items=array( $comunicati[2], $comunicati[3] )}                     
                     {include uri='design:newsletter/skin/openpa/outputformat/include/comunicati.tpl' items=array( $comunicati[4], $comunicati[5] )}                     
                  {/case}
                  {case}
                     {include uri='design:newsletter/skin/openpa/outputformat/include/comunicati.tpl' items=$comunicati}
                  {/case}
              {/switch}
          {/if}
          
          {if $appuntamenti}                    
              <h2 style="color: #404040 !important; font-family: arial,serif;font-size: 1.7em;font-weight: normal;line-height: 0.9;padding:0;margin:24px 28px 6px; text-align: left;">                
                Appuntamenti
              </h2>
              {switch match=$appuntamenti|count()}

                {case match=3}
                    {include uri='design:newsletter/skin/openpa/outputformat/include/appuntamenti.tpl' items=array( $appuntamenti[0] )}   
                    {include uri='design:newsletter/skin/openpa/outputformat/include/appuntamenti.tpl' items=array( $appuntamenti[1], $appuntamenti[2] )}
                {/case}
                {case match=4}
                   {include uri='design:newsletter/skin/openpa/outputformat/include/appuntamenti.tpl' items=array( $appuntamenti[0], $appuntamenti[1] )}                     
                   {include uri='design:newsletter/skin/openpa/outputformat/include/appuntamenti.tpl' items=array( $appuntamenti[2], $appuntamenti[3] )}                     
                {/case}
                {case match=5}                     
                   {include uri='design:newsletter/skin/openpa/outputformat/include/appuntamenti.tpl' items=array( $appuntamenti[0] )}   
                   {include uri='design:newsletter/skin/openpa/outputformat/include/appuntamenti.tpl' items=array( $appuntamenti[1], $appuntamenti[2] )}
                   {include uri='design:newsletter/skin/openpa/outputformat/include/appuntamenti.tpl' items=array( $appuntamenti[3], $appuntamenti[4] )}
                {/case}
                {case match=6}
                   {include uri='design:newsletter/skin/openpa/outputformat/include/appuntamenti.tpl' items=array( $appuntamenti[0], $appuntamenti[1] )}                     
                   {include uri='design:newsletter/skin/openpa/outputformat/include/appuntamenti.tpl' items=array( $appuntamenti[2], $appuntamenti[3] )}                     
                   {include uri='design:newsletter/skin/openpa/outputformat/include/appuntamenti.tpl' items=array( $appuntamenti[4], $appuntamenti[5] )}                     
                {/case}
                {case}
                   {include uri='design:newsletter/skin/openpa/outputformat/include/appuntamenti.tpl' items=$appuntamenti}
                {/case}

              {/switch}
          {/if}          
        </td>
      </tr>
      {* footer *}
      <tr><td colspan="2" bgcolor="#154985" height="5"></td></tr>
      <tr><td colspan="2" bgcolor="#222222;">{include uri='design:newsletter/skin/openpa/outputformat/include/footer.tpl'}</td></tr>   
    </table>

    </td>
  </tr>
</table>  

</body>
</html>
{/set-block}{$html_mail|cjw_newsletter_str_replace(
                            array( '<body>',
                                   '<li>',
                                   '<p>',
                                   '<h1>',
                                   '<h2>',
                                   '<h3>',
                                   ' />',

                                   '     ',
                                   '   ',
                                   '  ',
                                   '  ',
                                   '> <'
                                    ),
                            array( '<body bgcolor="#e1ebd2" text="#666666" link="#666666" vlink="#666666" alink="#666666" style="margin:0;padding:0;">',
                                   '<li style="color:#666666;font-family:arial,helvetica,sans-serif;font-size:1em;padding:0;line-height:1.2;">',
                                   '<p style="color:#666666;font-family:arial,helvetica,sans-serif;font-size:1em;margin: 4px 0;padding:0;line-height:1.2;">',
                                   '<h1 style="color:#666666;font-family:arial,helvetica,sans-serif;font-size:1.75em;font-weight:bold;line-height:1;padding:0">',
                                   '<h2 style="color:#666666;font-family:arial,helvetica,sans-serif;font-size:1.3em;font-weight:bold;line-height:1;padding:0">',
                                   '<h3 style="color:#666666;font-family:arial,helvetica,sans-serif;font-size:1.2em;font-weight:bold;line-height:1;padding:0">',
                                   '>',

                                   '',
                                   '',
                                   ' ',
                                   ' ',
                                   '><'
                                    )
                                   )}
