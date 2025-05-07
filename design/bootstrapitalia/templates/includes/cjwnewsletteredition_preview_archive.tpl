{if is_set( $show_iframes )|not() }
    {def $show_iframes = true()}
{/if}

{if is_set( $iframe_height )|not() }
    {def $iframe_height = 200}
{/if}

{def $list_attribute_content = $newsletter_edition_attribute_content.list_attribute_content
     $edition_send_current = $newsletter_edition_attribute_content.edition_send_current
     $output_format_array = $edition_send_current.output_format_array
     $edition_send_id = $edition_send_current.id
     $archive_url = concat('/newsletter/archive/' , $edition_send_current.hash )}

{*<p>
    <a href={$archive_url|ezurl} target="_blank" class="btn btn-info text-sans-serif">
        {'Archive view'|i18n('cjw_newsletter/cjwnewsletteredition_preview_archive')}
    </a>
</p>*}

{foreach $output_format_array as $output_format_id => $output_format_name}
    {def $src_url = concat('/newsletter/preview_archive/' , $edition_send_id, '/', $output_format_id)}        
        <a class="btn btn-info pull-right" href={$src_url|ezurl} target="new_{$output_format_id}" style="margin-bottom: -50px;z-index: 1;position: relative;"><i class="fa fa-expand"></i> <span class="sr-only">{'Fullscreen'|i18n('cjw_newsletter/cjwnewsletteredition_preview')}</span></a>
        {if $show_iframes}
            <iframe src={$src_url|ezurl} width="100%" height="{$iframe_height}" style="min-height:500px" name="EDITION_PREVIEW_{$output_format_id}">
                <p>your browser does not support iframes!</p>
            </iframe>
        {/if}
    {undef $src_url}
{/foreach}
