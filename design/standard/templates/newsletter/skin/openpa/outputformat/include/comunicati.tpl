{if $items|count()|eq(1)}

  {def $item = $items[0]
       $main_width = 658
       $colspan = 3}
    
  {if $item|has_attribute('image')}
    {set $colspan = 4}
    {set $main_width = 518}
  {/if}


<table border="0" bgcolor="#f7f7f7" width="660" cellspacing="0" cellpadding="0" style="background-color: #f7f7f7; margin: 20px 0; border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">
  <tr>
    <td colspan="{$colspan}">
      <img border="0" width="660" height="5" style="display:block;margin:0; outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;" alt="" src={"images/newsletter/skin/openpa/box-top.gif"|ezdesign()}>
    </td>
  </tr>
  <tr>
    <td width="1" bgcolor="#D5D7D5">
      <img border="0" width="1" height="1" style="display:block;margin:0" alt="" src={"images/newsletter/skin/openpa/spacer.gif"|ezdesign()} />
    </td>
    {if $item|has_attribute('image')}
    <td width="140" valign="top" align="center" style="padding-top: 8px">
      {attribute_view_gui attribute=$item|attribute('image') image_class=newsletter_content use_colorbox=false()}
    </td>
    {/if}
    <td width="{$main_width}" valign="top" align="left">
      <div style="color: #404040;margin: 8px;">
        {include uri='design:newsletter/skin/openpa/outputformat/include/comunicato.tpl' item=$item}           
      </div>
    </td>
    <td width="1" bgcolor="#D5D7D5">
      <img border="0" width="1" height="1" style="display:block;margin:0" alt="" src={"images/newsletter/skin/openpa/spacer.gif"|ezdesign()} />
    </td>
  </tr>
  <tr>
    <td colspan="4">
      <img border="0" width="660" height="5" style="display:block;margin:0" alt="" src={"images/newsletter/skin/openpa/box-bottom.gif"|ezdesign()} />
    </td>
  </tr>
</table>

{else}

  {def $item1 = $items[0]
       $item2 = $items[1] 
       $main_width_1 = 329
       $main_width_2 = 328
       $colspan = 5
  }

  {if $item1|has_attribute('image')}
    {set $main_width_1 = 189
         $colspan = 6}
    {if $item2|has_attribute('image')}
      {* entrambi hanno immagine*}
      {set $main_width_2 = 188
           $colspan = 7}    
    {/if}
  {else}
    {if $item2|has_attribute('image')}
      {* solo item2 ha immagine*}
      {set $main_width_2 = 188
           $colspan = 6}    
    {/if}
  {/if}
<table border="0" bgcolor="#f7f7f7" width="660" cellspacing="0" cellpadding="0" style="background-color:#f7f7f7; margin: 20px 0; border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">
  <tr>
    <td colspan="{$colspan}">
      <img border="0" width="660" height="5" style="display:block;margin:0; outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;" alt="" src={"images/newsletter/skin/openpa/box-top.gif"|ezdesign()}>
    </td>
  </tr>
  <tr>
    <td width="1" bgcolor="#D5D7D5">
      <img border="0" width="1" height="1" style="display:block;margin:0" alt="" src={"images/newsletter/skin/openpa/spacer.gif"|ezdesign()} />
    </td>
    {if $item1|has_attribute('image')}
    <td width="140" valign="top" align="center" style="padding-top: 8px">
      {attribute_view_gui attribute=$item1|attribute('image') image_class=newsletter_content use_colorbox=false()}
    </td>
    {/if}
    <td width="{$main_width_1}" valign="top" align="left">
      <div style="color: #404040;margin: 8px;">
        {include uri='design:newsletter/skin/openpa/outputformat/include/comunicato.tpl' item=$item1}   
      </div>
    </td>
    <td width="1" bgcolor="#D5D7D5">
      <img border="0" width="1" height="1" style="display:block;margin:0" alt="" src={"images/newsletter/skin/openpa/spacer.gif"|ezdesign()} />
    </td>
    {if $item2|has_attribute('image')}
    <td width="140" valign="top" align="center" style="padding-top: 8px">
      {attribute_view_gui attribute=$item2|attribute('image') image_class=newsletter_content use_colorbox=false()}
    </td>
    {/if}
    <td width="{$main_width_2}" valign="top" align="left">
      <div style="color: #404040;margin: 8px;">
        {include uri='design:newsletter/skin/openpa/outputformat/include/comunicato.tpl' item=$item2}   
      </div>
    </td>
    <td width="1" bgcolor="#D5D7D5">
      <img border="0" width="1" height="1" style="display:block;margin:0" alt="" src={"images/newsletter/skin/openpa/spacer.gif"|ezdesign()} />
    </td>
  </tr>
  <tr>
    <td colspan="{$colspan}">
      <img border="0" width="660" height="5" style="display:block;margin:0" alt="" src={"images/newsletter/skin/openpa/box-bottom.gif"|ezdesign()} />
    </td>
  </tr>
</table>
{/if}
