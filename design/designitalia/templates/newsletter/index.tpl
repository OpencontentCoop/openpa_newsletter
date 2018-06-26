{def $newsletter_root_node_id = ezini( 'NewsletterSettings', 'RootFolderNodeId', 'cjw_newsletter.ini' )}
{def $page_uri = 'newsletter/index'
     $limit = 10}

<div class="openpa-full">
    
    {* Newsletter system boxes *}
    {def $newsletter_system_node_list = fetch('content', 'tree',
                                                hash( 'parent_node_id', $newsletter_root_node_id,
                                                      'class_filter_type', 'include',
                                                      'class_filter_array', array( 'cjw_newsletter_system' ),
                                                      'sort_by', array( 'name', true() ),
                                                     ))}
    {foreach $newsletter_system_node_list as $newsletter_system_node}
        {if $newsletter_system_node.can_create}
		{include uri='design:newsletter/index_newsletter_system_info_box.tpl'
                 name='NlSystemBox'
                 newsletter_system_node=$newsletter_system_node}
		{/if}
    {/foreach}

    {undef $newsletter_system_node_list}


</div>

