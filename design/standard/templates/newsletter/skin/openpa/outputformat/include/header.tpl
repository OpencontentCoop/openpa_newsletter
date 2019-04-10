<table cellpadding="0" cellspacing="0" border="0" align="center" width="100%" style="border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">
  <tr>
    <td bgcolor="#154985">
        {if and( is_set( $main_node.parent.data_map.banner ), $main_node.parent.data_map.banner.has_content )}
          <a style="display: block;width: 700px;overflow: hidden" href="http://{ezini( 'SiteSettings', 'SiteURL' )}" title="{ezini( 'SiteSettings', 'SiteName' )}">
            <img style="border: none; padding: 0; display: block; outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;"
                 src={$main_node.parent.data_map.banner.content['original'].url|ezroot}
                 alt="{ezini( 'SiteSettings', 'SiteName' )}" />
          </a>
        {elseif and( is_set( $ente.data_map.logo ), openpaini( 'Newsletter', 'SkinUseHomepageLogo', 'enabled' )|eq( 'enabled' ) )}
          <a style="display: block;width: 660px;overflow: hidden" href="http://{ezini( 'SiteSettings', 'SiteURL' )}" title="{ezini( 'SiteSettings', 'SiteName' )}">
            <img style="border: none; padding: 20px 20px 0 0; display: block; outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;"
                 src={$ente.data_map.logo.content['header_logo'].url|ezroot}
                 alt="{ezini( 'SiteSettings', 'SiteName' )}" />
          </a>
        {else}          
          <a style="display: block;width: 660px;overflow: hidden" href="http://{ezini( 'SiteSettings', 'SiteURL' )}" title="{ezini( 'SiteSettings', 'SiteName' )}">
            <img style="border: none; padding: 20px 20px 0 0; display: block; outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;"
                 src={'newsletter_logo.png'|ezimage}
                 alt="{ezini( 'SiteSettings', 'SiteName' )}" />
          </a>
        {/if}          
      </a>
    </td>    
  </tr>  
  <tr>
    <td bgcolor="#222222">
      <div style="color:#FFFFFF;padding:5px 10px 0">
        <p style="color:#FFFFFF;margin: 5px;">{$site_name} - {$main_node.parent.name|wash()}</p>
        <p style="color:#FFFFFF;margin: 5px;"><strong>{$main_node.name|wash()}</strong> - {$timestamp|l10n('date')}</p>
      </div>
    </td>
  </tr>
  <tr><td colspan="2" bgcolor="#154985" height="5"></td></tr>
</table>