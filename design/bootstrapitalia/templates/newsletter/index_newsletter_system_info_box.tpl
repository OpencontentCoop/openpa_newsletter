<div class="block">

        <h3>{$newsletter_system_node.name|wash()}</h3>
        {def $newsletter_list_node_list = fetch('content', 'list',
                                                                hash( 'parent_node_id', $newsletter_system_node.node_id,
                                                                      'class_filter_type', 'include',
                                                                      'class_filter_array', array( 'cjw_newsletter_list' )
                                                                     ))}

        {foreach $newsletter_list_node_list as $newsletter_list_node}
        <table cellspacing="0" cellpadding="0" class="table table-striped">
            <tr>
                <th>
                    <a href="{$newsletter_list_node.url_alias|ezurl(no)}">{$newsletter_list_node.name|wash()}</a>
                </th>
                <th class="text-right">
                    {if $newsletter_list_node.can_edit}
                        <a href="{concat('content/edit/',$newsletter_list_node.contentobject_id, '/f')|ezurl(no)}" class="btn btn-xs btn-warning">Modifica</a>
                    {/if}
                    {if or(ezini_hasvariable('GeneralSettings', 'EnableSendy', 'sendy.ini')|not(), ezini('GeneralSettings', 'EnableSendy', 'sendy.ini')|ne('enabled'))}
                        <strong><a href="{concat('newsletter/subscription_list/',$newsletter_list_node.node_id)|ezurl(no)}" class="btn btn-xs btn-primary">Utenti iscritti</a></strong>
                    {/if}
                    {if $newsletter_list_node.can_create}
                    <form action={'content/action'|ezurl()} name="CreateNewNewsletterEdition" method="post" class="d-inline">
                        <input type="hidden" value="{ezini( 'RegionalSettings', 'ContentObjectLocale' )}" name="ContentLanguageCode"/>
                        <input type="hidden" value="{$newsletter_list_node.node_id}" name="ContentNodeID"/>
                        <input type="hidden" value="{$newsletter_list_node.node_id}" name="NodeID"/>
                        <input type="hidden" value="cjw_newsletter_edition" name="ClassIdentifier"/>
                        <input class="button btn btn-primary" type="submit" name="NewButton" value="{'Create newsletter here'|i18n( 'cjw_newsletter/index' )}" />
                    </form>
                    {/if}
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
                        <td>
                            <a href={$edition_draft_node.url_alias|ezurl}>{$edition_draft_node.name|wash()}</a>
                        </td>

                        <td class="text-right">
                            {if $edition_draft_node.can_edit}
                            <form action={'content/action'|ezurl()} method="post">
                                <input type="hidden" value="{$edition_draft_node.node_id}" name="TopLevelNode"/>
                                <input type="hidden" value="{$edition_draft_node.node_id}" name="ContentNodeID"/>
                                <input type="hidden" value="{$edition_draft_node.contentobject_id}" name="ContentObjectID" />
                                <input type="hidden" value="{'newsletter/index'}" name="RedirectIfDiscarded" />
                                <input type="hidden" name="ContentObjectLanguageCode" value="{$edition_draft_node.object.current_language}" />
                                <input class="btn btn-xs btn-warning" type="submit" title="{'Edit newsletter'|i18n( 'cjw_newsletter/index' )}" value="{'Edit'|i18n( 'cjw_newsletter/index' )}" name="EditButton" />
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
