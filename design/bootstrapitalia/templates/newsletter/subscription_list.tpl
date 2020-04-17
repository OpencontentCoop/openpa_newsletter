{*  newsletter/subscription_list.tpl

    list all subscription for a newsletter list
*}
{ezpagedata_set('left_menu', false())}
{ezpagedata_set('extra_menu', false())}
{ezcss_require(array('cjw_newsletter.css'))}

{if $node.class_identifier|eq( 'cjw_newsletter_list' )}


{def $subscription_icon_css_class_array = hash( '0', 'icon12 icon_s_pending',
                                                '1', 'icon12 icon_s_confirmed',
                                                '2', 'icon12 icon_s_approved',
                                                '3', 'icon12 icon_s_removed',
                                                '4', 'icon12 icon_s_removed',
                                                '6', 'icon12 icon_s_bounced',
                                                '7', 'icon12 icon_s_bounced',
                                                '8', 'icon12 icon_s_blacklisted',
                                                'bounced', 'icon12 icon_s_bounced',
                                                'removed', 'icon12 icon_s_removed',
                                                 )}
{def $subscription_icon_css_class_16_array = hash( '0', 'icon16 icon_s_pending',
                                                '1', 'icon16 icon_s_confirmed',
                                                '2', 'icon16 icon_s_approved',
                                                '3', 'icon16 icon_s_removed',
                                                '4', 'icon16 icon_s_removed',
                                                '6', 'icon16 icon_s_bounced',
                                                '7', 'icon16 icon_s_bounced',
                                                '8', 'icon16 icon_s_blacklisted',
                                                'bounced', 'icon16 icon_s_bounced',
                                                'removed', 'icon16 icon_s_removed',
                                                 )}

{def $limit = 50}

{if ezpreference( 'admin_subscription_list_limit' )}
    {switch match=ezpreference( 'admin_subscription_list_limit' )}
        {case match=1}
            {set $limit=10}
        {/case}
        {case match=2}
            {set $limit=25}
        {/case}
        {case match=3}
            {set $limit=50}
        {/case}
    {/switch}
{/if}

{* subscription list *}
{def $newsletter_list_node = $node}
{def $status = ''}

{if is_set( $view_parameters.status )}
    {set $status = $view_parameters.status}
{/if}


{def $subscription_list = fetch('newsletter', 'subscription_list', hash( 'list_contentobject_id', $node.contentobject_id,
                                                                         'offset', $view_parameters.offset,
                                                                         'status', $status,
                                                                         'limit', $limit ))
     $subscription_list_count = fetch('newsletter', 'subscription_list_count', hash( 'list_contentobject_id', $node.contentobject_id,
                                                                                     'status', $status ))
     $base_uri = concat( 'newsletter/subscription_list/', $node.node_id )
     $uri_csv_import = concat( 'newsletter/subscription_list_csvimport/', $node.node_id )
     $uri_csv_export = concat( 'newsletter/subscription_list_csvexport/', $node.node_id )
 }

    <div class="pull-right">
        <p class="table-preferences">
            {switch match=$limit}
            {case match=25}
                <a class="badge badge-primary text-decoration-none" style="min-width: auto" href={'/user/preferences/set/admin_subscription_list_limit/1'|ezurl} title="{'Show 10 items per page.'|i18n( 'design/admin/node/view/full' )}">10</a>
                <span class="badge badge-secondary text-decoration-none current" style="min-width: auto" >25</span>
                <a class="badge badge-primary text-decoration-none" style="min-width: auto"  href={'/user/preferences/set/admin_subscription_list_limit/3'|ezurl} title="{'Show 50 items per page.'|i18n( 'design/admin/node/view/full' )}">50</a>
            {/case}
            {case match=50}
                <a class="badge badge-primary text-decoration-none" style="min-width: auto"  href={'/user/preferences/set/admin_subscription_list_limit/1'|ezurl} title="{'Show 10 items per page.'|i18n( 'design/admin/node/view/full' )}">10</a>
                <a class="badge badge-primary text-decoration-none" style="min-width: auto"  href={'/user/preferences/set/admin_subscription_list_limit/2'|ezurl} title="{'Show 25 items per page.'|i18n( 'design/admin/node/view/full' )}">25</a>
                <span class="badge badge-secondary text-decoration-none current" style="min-width: auto" >50</span>
            {/case}
            {case}
                <span class="badge badge-secondary text-decoration-none current" style="min-width: auto" >10</span>
                <a class="badge badge-primary text-decoration-none" style="min-width: auto"  href={'/user/preferences/set/admin_subscription_list_limit/2'|ezurl} title="{'Show 25 items per page.'|i18n( 'design/admin/node/view/full' )}">25</a>
                <a class="badge badge-primary text-decoration-none" style="min-width: auto"  href={'/user/preferences/set/admin_subscription_list_limit/3'|ezurl} title="{'Show 50 items per page.'|i18n( 'design/admin/node/view/full' )}">50</a>
            {/case}
            {/switch}
        </p>
    </div>

    <h1>
        {'Subscription list <%subscription_list_name>'|i18n( 'cjw_newsletter/subscription_list',, hash( '%subscription_list_name', $newsletter_list_node.name ) )|wash}
    </h1>

    <div class="mb-4">
        <form name="CreateNewNewsletterUser" method="post" style="display:inline;"
              action={'newsletter/user_create'|ezurl}>
            <input type="hidden" name="AddSubscriptionForListId" value="{$node.contentobject_id}"/>
            <input type="hidden" name="RedirectUrlActionCancel" value="newsletter/subscription_list/{$node.node_id}"/>
            <input type="hidden" name="RedirectUrlActionStore" value="newsletter/subscription_list/{$node.node_id}"/>
            <input class="defaultbutton" type="submit" name="NewSubscriptionButton"
                   value="{'Create new Subscription'|i18n( 'cjw_newsletter/subscription_list' )}"/>
        </form>

        <form name="CsvImport" method="post" action={$uri_csv_import|ezurl} style="display:inline">
            <input class="button" type="submit" name="importcsv"
                   value="{'Import CSV'|i18n( 'cjw_newsletter/subscription_list' )}"
                   title="{'Import contact from CSV file.'|i18n( 'cjw_newsletter/newsletter_list_subscription' )}"/>
        </form>

        <form name="CsvExport" method="post" action={$uri_csv_export|ezurl} style="display:inline">
            <input class="button" type="submit" name="importcsv"
                   value="{'Export CSV'|i18n( 'cjw_newsletter/subscription_list' )}"
                   title="{'Export to CSV file.'|i18n( 'cjw_newsletter/newsletter_list_subscription' )}"/>
        </form>
    </div>

    {include uri='design:cjw_newsletter_list_statistic.tpl' name='Statistic' list_node=$node icons=true() status=$status}



    <table class="table table-condensed table-striped" cellspacing="0">
        <tr>
            <th class="tight">{'ID'|i18n('cjw_newsletter/subscription_list')}</th>
            <th>{'Email'|i18n( 'cjw_newsletter/subscription_list' )}</th>
            <th>{'First name'|i18n( 'cjw_newsletter/subscription_list' )}</th>
            <th>{'Last name'|i18n( 'cjw_newsletter/subscription_list' )}</th>
            <th>{'eZ User'|i18n('cjw_newsletter/subscription_list')}</th>
            <th>{'Format'|i18n( 'cjw_newsletter/subscription_list' )}</th>
            <th>{'Status'|i18n( 'cjw_newsletter/subscription_list' )}</th>
            <th>{'Modified'|i18n( 'cjw_newsletter/subscription_list' )}</th>
            <th class="tight">&nbsp;</th>
        </tr>

        {foreach $subscription_list as $subscription sequence array( bglight, bgdark ) as $style}

        <tr class="{$style}">
            <td>{$subscription.id|wash}</td>
            <td><a href={concat('newsletter/user_view/',$subscription.newsletter_user.id)|ezurl} title="{$subscription.newsletter_user.first_name} {$subscription.newsletter_user.last_name}">{$subscription.newsletter_user.email}</a></td>
            <td>{$subscription.newsletter_user.first_name|wash}</td>
            <td>{$subscription.newsletter_user.last_name|wash}</td>
            <td>
                {if $subscription.newsletter_user.ez_user_id|gt( '0' )}
                    {def $user_object = fetch( 'content', 'object', hash( 'object_id', $subscription.newsletter_user.ez_user_id ) )}
                    {if $user_object}
                        <a href="{$user_object.main_node.url_alias|ezurl( 'no' )}">{$user_object.name|wash}</a>
                    {/if}
                    {undef $user_object}
                {/if}
            </td>
            <td>{$subscription.output_format_array|implode(', ')}</td>
            <td><img src={'16x16.gif'|ezimage} alt="{$subscription.status_string|wash}" class="{$subscription_icon_css_class_array[$subscription.status]}" title="{$subscription.status_string|wash} ({$subscription.status|wash})" /></td>
            <td>{cond( $subscription.modified|gt(0), $subscription.modified|l10n( shortdatetime ), 'n/a'|i18n( 'cjw_newsletter/subscription_list' ) )}</td>
            <td class="tight">
                <div class="d-flex">
                <form class="inline" action="{concat('newsletter/subscription_view/', $subscription.id )|ezurl( 'no' )}">
                    <input class="btn btn-xs btn-info" type="submit" value="{'Details'|i18n( 'cjw_newsletter/user_list' )}" title="{'Subscription details'|i18n( 'cjw_newsletter/user_list' )}" name="SubscriptionDetails" />
                </form>
                <form class="inline" action="{concat( '/newsletter/subscription_view/', $subscription.id )|ezurl( 'no' )}" method="post">
                    <input  {if or( $subscription.status|eq(2), $subscription.status|eq(3), $subscription.status|eq(8) )}class="btn btn-xs btn-info btn-disabled" disabled="disabled"{else}class="button"{/if} type="submit" value="{'Approve'|i18n( 'cjw_newsletter/subscription_list' )}" name="SubscriptionApproveButton" title="{'Approve subscription'|i18n( 'cjw_newsletter/subscription_list' )}" />
                </form>
                <form class="inline" action="{concat( 'newsletter/user_edit/', $subscription.newsletter_user.id, '?RedirectUrl=', $base_uri, '/(offset)/', $view_parameters.offset )|ezurl( 'no' )}" method="post">
                    <input class="btn btn-xs btn-info" type="submit" value="{'Edit'|i18n( 'cjw_newsletter/user_list' )}" title="{'Edit newsletter user'|i18n( 'cjw_newsletter/user_list' )}" name="EditNewsletterUser" />
                </form>
                </div>
            </td>
        </tr>
        {/foreach}
    </table>


    {* Navigator. *}
    <div class="context-toolbar subitems-context-toolbar">
        {include name='Navigator'
                 uri='design:navigator/google.tpl'
                 page_uri=$base_uri
                 item_count=$subscription_list_count
                 view_parameters=$view_parameters
                 item_limit=$limit}
    </div>


{/if}

