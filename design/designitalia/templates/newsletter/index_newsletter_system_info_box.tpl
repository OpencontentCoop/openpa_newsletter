<div class="Prose">

        <h2>{$newsletter_system_node.name|wash()}</h2>		
        {def $newsletter_list_node_list = fetch('content', 'list',
                                                                hash( 'parent_node_id', $newsletter_system_node.node_id,
                                                                      'class_filter_type', 'include',
                                                                      'class_filter_array', array( 'cjw_newsletter_list' )
                                                                     ))}

        {foreach $newsletter_list_node_list as $newsletter_list_node}
        <table cellspacing="0" cellpadding="0" class="table">
            <tr>
                <th>
                    {$newsletter_list_node.name|wash()} / {$newsletter_list_node.data_map.title.content|wash()}
                </th>
                <th>
                    {if $newsletter_list_node.can_create}
                    <form action={'content/action'|ezurl()} name="CreateNewNewsletterEdition" method="post" class="pull-right">
                        <input type="hidden" value="{ezini( 'RegionalSettings', 'ContentObjectLocale' )}" name="ContentLanguageCode"/>
                        <input type="hidden" value="{$newsletter_list_node.node_id}" name="ContentNodeID"/>
                        <input type="hidden" value="{$newsletter_list_node.node_id}" name="NodeID"/>
                        <input type="hidden" value="cjw_newsletter_edition" name="ClassIdentifier"/>
                        <input class="button btn btn-primary" type="submit" name="NewButton" value="{'Create newsletter here'|i18n( 'cjw_newsletter/index' )}" />
                    </form>
                    {/if}
                </th>
                <th>
                    <strong><a href={concat('newsletter/subscription_list/',$newsletter_list_node.node_id)|ezurl()} class="btn btn-xs btn-primary">Utenti iscritti</a></strong>
                </th>
            </tr>

            {def $edition_draft_node_list = fetch('content','list',
                                                                hash('parent_node_id', $newsletter_list_node.node_id,
                                                                     'extended_attribute_filter',
                                                                        hash( 'id', 'CjwNewsletterEditionFilter',
                                                                              'params', hash( 'status', 'draft' ) )
                                                                                 ) )}
            {if $edition_draft_node_list|count|gt(0)}            
                {foreach $edition_draft_node_list as $edition_draft_node}
                    <tr>
                        <td colspan="2">
                            <a href={$edition_draft_node.url_alias|ezurl}>{$edition_draft_node.name|wash()}</a>
                        </td>
                        <td>
                            {if $edition_draft_node.can_edit}
                            <form action={'content/action'|ezurl()} method="post">
                                <input type="hidden" value="{$edition_draft_node.node_id}" name="TopLevelNode"/>
                                <input type="hidden" value="{$edition_draft_node.node_id}" name="ContentNodeID"/>
                                <input type="hidden" value="{$edition_draft_node.contentobject_id}" name="ContentObjectID" />
                                <input type="hidden" value="{'newsletter/index'}" name="RedirectIfDiscarded" />
                                <input type="hidden" name="ContentObjectLanguageCode" value="{$edition_draft_node.object.current_language}" />
                                <input class="button btn btn-xs btn-warning" type="submit" title="{'Edit newsletter'|i18n( 'cjw_newsletter/index' )}" value="{'Edit'|i18n( 'cjw_newsletter/index' )}" name="EditButton" />
                            </form>
                            {/if}
                        </td>
                    </tr>
                {/foreach}
            {/if}
            {undef $edition_draft_node_list}
        </table>
        {/foreach}    
</div>