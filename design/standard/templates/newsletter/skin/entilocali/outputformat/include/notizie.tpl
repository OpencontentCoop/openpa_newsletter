{def $main_width = 658
     $colspan = 3}

{foreach $items as $item}
    
  {if $item.data_map.image.has_content}
    {set $colspan = 4}
    {set $main_width = 518}
  {/if}


<table border="0" bgcolor="#f7f7f7" width="660" cellspacing="0" cellpadding="0" style="background-color: #f7f7f7; margin: 20px 0; border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">
  <tr>
    <td colspan="{$colspan}">
      <img border="0" width="660" height="5" style="display:block;margin:0; outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;" alt="" src={"images/newsletter/skin/entilocali/box-top.gif"|ezdesign()}>
    </td>
  </tr>
  <tr>
    <td width="1" bgcolor="#D5D7D5">
      <img border="0" width="1" height="1" style="display:block;margin:0" alt="" src={"images/newsletter/skin/entilocali/spacer.gif"|ezdesign()} />
    </td>
    {if $item.data_map.image.has_content}
    <td width="140" valign="top" align="center" style="padding-top: 8px">
      {attribute_view_gui attribute=$item.data_map.image image_class=newsletter_default use_colorbox=false()}
    </td>
    {/if}
    <td width="{$main_width}" valign="top" align="left">
      <div style="color: #404040;margin: 8px;">
        {include uri='design:newsletter/skin/entilocali/outputformat/include/notizia.tpl' item=$item}           
      </div>
    </td>
    <td width="1" bgcolor="#D5D7D5">
      <img border="0" width="1" height="1" style="display:block;margin:0" alt="" src={"images/newsletter/skin/entilocali/spacer.gif"|ezdesign()} />
    </td>
  </tr>
  <tr>
    <td colspan="4">
      <img border="0" width="660" height="5" style="display:block;margin:0" alt="" src={"images/newsletter/skin/entilocali/box-bottom.gif"|ezdesign()} />
    </td>
  </tr>
</table>
{/if}