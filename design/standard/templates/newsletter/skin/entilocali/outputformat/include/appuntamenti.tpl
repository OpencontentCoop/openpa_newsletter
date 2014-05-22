{if $items|count()|eq(1)}

  {def $item = $items[0]
       $main_width = 658
       $colspan = 3
       $from_year = false()
       $from_month = false()
       $from_day = false()
       $to_year = false()
       $to_month = false()
       $to_day = false()
       $same_day = false()
  }

<table border="0" bgcolor="#f7f7f7" width="660" cellspacing="0" cellpadding="0" style="background-color: #f7f7f7; margin: 0; border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">
  <tr>
    <td colspan="{$colspan}">
      <img border="0" width="660" height="5" style="display:block;margin:0; outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;" alt="" src={"images/newsletter/skin/entilocali/box-top.gif"|ezdesign()}>
    </td>
  </tr>
  <tr>
    <td width="1" bgcolor="#D5D7D5">
      <img border="0" width="1" height="1" style="display:block;margin:0" alt="" src={"images/newsletter/skin/entilocali/spacer.gif"|ezdesign()} />
    </td>
    <td width="{$main_width}" valign="top" align="left">
      <div style="color: #404040;margin: 8px;">
        {include uri='design:newsletter/skin/entilocali/outputformat/include/appuntamento.tpl' item=$item}   
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

{else}

  {def $item1 = $items[0]
       $item2 = $items[1] 
       $main_width_1 = 329
       $main_width_2 = 328
       $colspan = 5
       $from_year = false()
       $from_month = false()
       $from_day = false()
       $to_year = false()
       $to_month = false()
       $to_day = false()
       $same_day = false()
  }

<table border="0" bgcolor="#f7f7f7" width="660" cellspacing="0" cellpadding="0" style="background-color:#f7f7f7; margin: 0; border-collapse:collapse; mso-table-lspace:0pt; mso-table-rspace:0pt;">
  <tr>
    <td colspan="{$colspan}">
      <img border="0" width="660" height="5" style="display:block;margin:0; outline:none; text-decoration:none; -ms-interpolation-mode: bicubic;" alt="" src={"images/newsletter/skin/entilocali/box-top.gif"|ezdesign()}>
    </td>
  </tr>
  <tr>
    <td width="1" bgcolor="#D5D7D5">
      <img border="0" width="1" height="1" style="display:block;margin:0" alt="" src={"images/newsletter/skin/entilocali/spacer.gif"|ezdesign()} />
    </td>
    <td width="{$main_width_1}" valign="top" align="left">
      <div style="color: #404040;margin: 8px;">
        {include uri='design:newsletter/skin/entilocali/outputformat/include/appuntamento.tpl' item=$item1}   
      </div>
    </td>
    <td width="1" bgcolor="#D5D7D5">
      <img border="0" width="1" height="1" style="display:block;margin:0" alt="" src={"images/newsletter/skin/entilocali/spacer.gif"|ezdesign()} />
    </td>
    <td width="{$main_width_2}" valign="top" align="left">
      <div style="color: #404040;margin: 8px;">
        {include uri='design:newsletter/skin/entilocali/outputformat/include/appuntamento.tpl' item=$item2}   
      </div>
    </td>
    <td width="1" bgcolor="#D5D7D5">
      <img border="0" width="1" height="1" style="display:block;margin:0" alt="" src={"images/newsletter/skin/entilocali/spacer.gif"|ezdesign()} />
    </td>
  </tr>
  <tr>
    <td colspan="{$colspan}">
      <img border="0" width="660" height="5" style="display:block;margin:0" alt="" src={"images/newsletter/skin/entilocali/box-bottom.gif"|ezdesign()} />
    </td>
  </tr>
</table>
{/if}
