{if is_set( $show_iframes )|not() }
    {def $show_iframes = true()}
{/if}

{if is_set( $iframe_height )|not() }
    {def $iframe_height = 200}
{/if}

{def $list_attribute_content = $newsletter_edition_attribute_content.list_attribute_content
     $output_format_array = $list_attribute_content.output_format_array
     $skin_name = $list_attribute_content.skin_name
     $list_main_siteaccess =  $list_attribute_content.main_siteaccess
     $contentobject_id = $newsletter_edition_attribute_content.contentobject_id
     $contentobject_version = $newsletter_edition_attribute_content.contentobject_attribute_version}

{def $output_format_id = 0}
{def $src_url = concat('/newsletter/preview/' , $contentobject_id, '/', $contentobject_version, '/', $output_format_id, '/', $list_main_siteaccess, '/',$skin_name,'/')}
<a class="btn btn-info pull-right" href={$src_url|ezurl} target="new_{$output_format_id}" style="margin-bottom: -50px;z-index: 1;position: relative;"><i class="fa fa-expand"></i> <span class="sr-only">{'Fullscreen'|i18n('cjw_newsletter/cjwnewsletteredition_preview')}</span></a>
{if $show_iframes}
    <iframe src={$src_url|ezurl} width="100%" height="{$iframe_height}" style="min-height:500px" name="EDITION_PREVIEW_{$output_format_id}">
        <p>your browser does not support iframes!</p>
    </iframe>
{/if}
{undef $src_url $output_format_id}
