{def $newsletter_root_node_id = ezini( 'NewsletterSettings', 'RootFolderNodeId', 'cjw_newsletter.ini' )}
{def $page_uri = 'newsletter/index'
     $limit = 10}

<div class="global-view-full">
    
    {*
	<div class="block">
        Pannello di controllo &middot;
        <a href={'/newsletter/user_list/'|ezurl}>Utenti iscritti alla newsletter</a>
    </div>
	*}

    <h1 class="context-title">{'Newsletter dashboard'|i18n( 'cjw_newsletter/index' )}</a></h1>
           

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




    {* last actions 

    {def $last_edition_node_list = fetch( 'content', 'tree',
                                                            hash( 'parent_node_id', $newsletter_root_node_id,
                                                                  'class_filter_type', 'include',
                                                                  'class_filter_array', array( 'cjw_newsletter_edition' ),
                                                                  'limit', $limit,
                                                                  'offset', $view_parameters.offset,
                                                                  'sort_by', array( 'modified', false() )
                                                                 ) )
         $last_edition_node_list_count = fetch( 'content', 'tree_count',
                                                            hash( 'parent_node_id', $newsletter_root_node_id,
                                                                  'class_filter_type', 'include',
                                                                  'class_filter_array', array( 'cjw_newsletter_edition' )
                                                                 ) )}

    <div class="content-view-children">
        <div class="block">
            <h2 class="context-title">{'Last actions'|i18n( 'cjw_newsletter/index' )}</a></h2>

            {include uri = 'design:includes/cjwnewsletteredition_statistic_list.tpl'
                     name = 'EditionList'
                     edition_node_list = $last_edition_node_list
                     edition_node_list_count = $last_edition_node_list_count
                     show_actions_colum = false()}

                <div class="context-toolbar subitems-context-toolbar">
                    {include    name = 'Navigator'
                                uri = 'design:navigator/google.tpl'
                                page_uri = $page_uri
                                item_count = $last_edition_node_list_count
                                view_parameters = $view_parameters
                                item_limit = $limit}

                </div>
        </div>
    </div>
	*}
</div>

