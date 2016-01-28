<table cellpadding="0" cellspacing="0" border="0" align="center" width="100%" style="border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">
    {if and( is_set( $main_node.parent.data_map.banner ), $main_node.parent.data_map.banner.has_content ) )}
      <tr>
        <td bgcolor="#222222" style="padding:20px 20px 0">      
          <p>
            <a style="display: block;width: 700px;overflow: hidden" href="http://{ezini( 'SiteSettings', 'SiteURL' )}" title="{ezini( 'SiteSettings', 'SiteName' )}">
              <img style="border: none; padding: 0; display: block; outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;"
                   src={$main_node.parent.data_map.banner.content['original'].url|ezroot}
                   alt="{ezini( 'SiteSettings', 'SiteName' )}" />
            </a>
          </p>
          <div style="color:#FFFFFF;padding-top: 20px">
            {$main_node.parent.name|wash()} - <strong>{$main_node.name|wash()}</strong> -        
            {$timestamp|l10n('date')}
          </div>
        </td>
      </tr>
    {else}
      <tr>
        <td rowspan="2" bgcolor="#222222" style="padding:20px 20px 0">            
            <a href="http://{ezini( 'SiteSettings', 'SiteURL' )}" title="{ezini( 'SiteSettings', 'SiteName' )}">
              <img style="border: none; display: block; outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;"
                   src={$ente.data_map.stemma.content['logo'].url|ezroot}                              
                   alt="{ezini( 'SiteSettings', 'SiteName' )}" />
            </a>
        </td>
        <td height="78" valign="bottom" bgcolor="#222222">
          <h1 style="color:#FFFFFF;font-family:'Arial Narrow',arial,helvetica,sans-serif;font-size:2.5em;font-weight:normal;line-height:1;padding:0">
            {$site_name}
          </h1>
        </td>
      </tr>
      <tr>
        <td height="22" valign="top" bgcolor="#222222">
          <div style="color:#FFFFFF">
            {$main_node.parent.name|wash()} - <strong>{$main_node.name|wash()}</strong> -        
            {$timestamp|l10n('date')}
          </div>
        </td>
      </tr>
    {/if}  
  
  <tr><td colspan="2" bgcolor="#222222" height="10"></td></tr>
  <tr><td colspan="2" bgcolor="#154985" height="5"></td></tr>
</table>  