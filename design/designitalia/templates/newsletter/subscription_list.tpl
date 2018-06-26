<div class="Prose">

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

  <h2>
	{'Subscription list <%subscription_list_name>'|i18n( 'cjw_newsletter/subscription_list',, hash( '%subscription_list_name', $newsletter_list_node.name ) )|wash}
  </h2>

    {include uri='design:cjw_newsletter_list_statistic.tpl'
             name='Statistic'
             list_node=$node
             icons=true()}


    {* Buttons. *}
    <div class="u-padding-top-l u-padding-bottom-l">
        <form name="CreateNewNewsletterUser" method="post" style="display:inline;" action={'newsletter/user_create'|ezurl}>
            <input type="hidden" name="AddSubscriptionForListId" value="{$node.contentobject_id}" />
            <input type="hidden" name="RedirectUrlActionCancel" value="newsletter/subscription_list/{$node.node_id}" />
            <input type="hidden" name="RedirectUrlActionStore" value="newsletter/subscription_list/{$node.node_id}" />
            <input class="defaultbutton" type="submit" name="NewSubscriptionButton" value="{'Create new Subscription'|i18n( 'cjw_newsletter/subscription_list' )}" />
        </form>

        <form name="CsvImport" method="post" action={$uri_csv_import|ezurl} style="display:inline">
            <input class="button" type="submit" name="importcsv" value="{'Import CSV'|i18n( 'cjw_newsletter/subscription_list' )}" title="{'Import contact from CSV file.'|i18n( 'cjw_newsletter/newsletter_list_subscription' )}" />
        </form>

        <form name="CsvExport" method="post" action={$uri_csv_export|ezurl} style="display:inline">
            <input class="button" type="submit" name="importcsv" value="{'Export CSV'|i18n( 'cjw_newsletter/subscription_list' )}" title="{'Export to CSV file.'|i18n( 'cjw_newsletter/newsletter_list_subscription' )}" />
        </form>
    </div>


</div>


<h2 class="context-title">{'Subscribers'|i18n( 'cjw_newsletter/subscription_list' )} [{$subscription_list_count}]</h2>

<div class="context-toolbar block float-break">        
    <div class="button-right">
        <p class="table-preferences">
            {if $status|eq('')}
                <span class="current">
                    {'All'|i18n('cjw_newsletter/subscription_list')}
                </span>
            {else}
                <a href={concat( $base_uri,'')|ezurl}>
                    {'All'|i18n('cjw_newsletter/subscription_list')}
                </a>
            {/if}

            {if $status|eq('pending')}
                <span class="current">
                   <img src={'1x1.gif'|ezimage} alt="{'Pending'|i18n('cjw_newsletter/subscription_list')}" title="{'Pending'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array[0]}" /> {'Pending'|i18n('cjw_newsletter/subscription_list')}
                </span>
            {else}
                <a href={concat($base_uri, '/(status)/pending' )|ezurl}>
                    <img src={'1x1.gif'|ezimage} alt="{'Pending'|i18n('cjw_newsletter/subscription_list')}" title="{'Pending'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array[0]}" /> {'Pending'|i18n('cjw_newsletter/subscription_list')}
                </a>
            {/if}

            {if $status|eq('confirmed')}
                <span class="current">
                    <img src={'1x1.gif'|ezimage} alt="{'Confirmed'|i18n('cjw_newsletter/subscription_list')}" title="{'Confirmed'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array[1]}" /> {'Confirmed'|i18n('cjw_newsletter/subscription_list')}
                </span>
            {else}
                <a href={concat($base_uri, '/(status)/confirmed' )|ezurl}>
                    <img src={'1x1.gif'|ezimage} alt="{'Confirmed'|i18n('cjw_newsletter/subscription_list')}" title="{'Confirmed'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array[1]}" /> {'Confirmed'|i18n('cjw_newsletter/subscription_list')}
                </a>
            {/if}
            {if $status|eq('approved')}
                <span class="current">
                    <img src={'1x1.gif'|ezimage} alt="{'Approved'|i18n('cjw_newsletter/subscription_list')}" title="{'Approved'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array[2]}" /> {'Approved'|i18n('cjw_newsletter/subscription_list')}
                </span>
            {else}
                <a href={concat($base_uri, '/(status)/approved' )|ezurl}>
                    <img src={'1x1.gif'|ezimage} alt="{'Approved'|i18n('cjw_newsletter/subscription_list')}" title="{'Approved'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array[2]}" /> {'Approved'|i18n('cjw_newsletter/subscription_list')}
                </a>
            {/if}
            {if $status|eq('bounced')}
                <span class="current">
                    <img src={'1x1.gif'|ezimage} alt="{'Bounced'|i18n('cjw_newsletter/subscription_list')}" title="{'Bounced'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array['bounced']}" /> {'Bounced'|i18n('cjw_newsletter/subscription_list')}
                </span>
            {else}
                <a href={concat($base_uri, '/(status)/bounced' )|ezurl}>
                    <img src={'1x1.gif'|ezimage} alt="{'Bounced'|i18n('cjw_newsletter/subscription_list')}" title="{'Bounced'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array['bounced']}" /> {'Bounced'|i18n('cjw_newsletter/subscription_list')}
                </a>
            {/if}
            {if $status|eq('removed')}
                <span class="current">
                    <img src={'1x1.gif'|ezimage} alt="{'Removed'|i18n('cjw_newsletter/subscription_list')}" title="{'Removed'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array['removed']}" /> {'Removed'|i18n('cjw_newsletter/subscription_list')}
                </span>
            {else}
                <a href={concat($base_uri, '/(status)/removed' )|ezurl}>
                    <img src={'1x1.gif'|ezimage} alt="{'Removed'|i18n('cjw_newsletter/subscription_list')}" title="{'Removed'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array['removed']}" /> {'Removed'|i18n('cjw_newsletter/subscription_list')}
                </a>
            {/if}
            {if $status|eq('blacklisted')}
                <span class="current">
                    <img src={'1x1.gif'|ezimage} alt="{'Blacklisted'|i18n('cjw_newsletter/subscription_list')}" title="{'Blacklisted'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array[8]}" /> {'Blacklisted'|i18n('cjw_newsletter/subscription_list')}
                </span>
            {else}
                <a href={concat($base_uri, '/(status)/blacklisted' )|ezurl}>
                    <img src={'1x1.gif'|ezimage} alt="{'Blacklisted'|i18n('cjw_newsletter/subscription_list')}" title="{'Blacklisted'|i18n('cjw_newsletter/subscription_list')}" class="{$subscription_icon_css_class_array[8]}" /> {'Blacklisted'|i18n('cjw_newsletter/subscription_list')}
                </a>
            {/if}
        </p>
    </div>
</div>

{* Subscription list table. *}

<table class="list table table-striped" cellspacing="0">
    <tr>
    {*
        <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection'|i18n( 'cjw_newsletter/subscription_list' )}" title="{'Invert selection'|i18n( 'cjw_newsletter/subscription_list' )}" onclick="ezjs_toggleCheckboxes( document.subscription_list, 'SubscriptionIDArray[]' ); return false;" /></th>
    *}
        <th class="tight">{'ID'|i18n('cjw_newsletter/subscription_list')}</th>
        <th>{'Email'|i18n( 'cjw_newsletter/subscription_list' )}</th>
        <th>{'First name'|i18n( 'cjw_newsletter/subscription_list' )}</th>
        <th>{'Last name'|i18n( 'cjw_newsletter/subscription_list' )}</th>
        <th>{'eZ Publish User'|i18n('cjw_newsletter/subscription_list')}</th>
        <th>{'Format'|i18n( 'cjw_newsletter/subscription_list' )}</th>
        <th>{'Status'|i18n( 'cjw_newsletter/subscription_list' )}</th>
        <th>{'Modified'|i18n( 'cjw_newsletter/subscription_list' )}</th>
        <th class="tight">&nbsp;</th>
    </tr>


    {foreach $subscription_list as $subscription sequence array( bglight, bgdark ) as $style}

    <tr class="{$style}">
    {*
        <td style="vertical-align: middle"><input type="checkbox" name="SubscriptionIDArray[]" value="{$subscription.id|wash}" title="{'Select subscriber for removal'|i18n( 'cjw_newsletter/subscription_list' )}" /></td>
    *}
        <td style="vertical-align: middle">{$subscription.id|wash}</td>
        <td style="vertical-align: middle"><a href={concat('newsletter/user_view/',$subscription.newsletter_user.id)|ezurl} title="{$subscription.newsletter_user.first_name} {$subscription.newsletter_user.last_name}">{$subscription.newsletter_user.email}</a></td>
        <td style="vertical-align: middle">{$subscription.newsletter_user.first_name|wash}</td>
        <td style="vertical-align: middle">{$subscription.newsletter_user.last_name|wash}</td>
        <td style="vertical-align: middle">
            {if $subscription.newsletter_user.ez_user_id|gt( '0' )}
                {def $user_object = fetch( 'content', 'object', hash( 'object_id', $subscription.newsletter_user.ez_user_id ) )}
                {if $user_object}
                    <a href="{$user_object.main_node.url_alias|ezurl( 'no' )}">{$user_object.name|wash}</a>
                {/if}
                {undef $user_object}
            {/if}
        </td>
        <td style="vertical-align: middle">{$subscription.output_format_array|implode(', ')}</td>
        <td style="vertical-align: middle"><img src={'16x16.gif'|ezimage} alt="{$subscription.status_string|wash}" class="{$subscription_icon_css_class_array[$subscription.status]}" title="{$subscription.status_string|wash} ({$subscription.status|wash})" /></td>
        <td style="vertical-align: middle">{cond( $subscription.modified|gt(0), $subscription.modified|l10n( shortdatetime ), 'n/a'|i18n( 'cjw_newsletter/subscription_list' ) )}</td>
        <td style="vertical-align: middle" class="tight" style="white-space: nowrap;">
            <form class="inline" action="{concat('newsletter/subscription_view/', $subscription.id )|ezurl( 'no' )}">
                <input class="button" type="submit" value="{'Details'|i18n( 'cjw_newsletter/user_list' )}" title="{'Subscription details'|i18n( 'cjw_newsletter/user_list' )}" name="SubscriptionDetails" />
            </form>
            <form class="inline" action="{concat( '/newsletter/subscription_view/', $subscription.id )|ezurl( 'no' )}" method="post">
                <input  {if or( $subscription.status|eq(2), $subscription.status|eq(3), $subscription.status|eq(8) )}class="button-disabled" disabled="disabled"{else}class="button"{/if} type="submit" value="{'Approve'|i18n( 'cjw_newsletter/subscription_list' )}" name="SubscriptionApproveButton" title="{'Approve subscription'|i18n( 'cjw_newsletter/subscription_list' )}" />
            </form>
            <form class="inline" action="{concat( 'newsletter/user_edit/', $subscription.newsletter_user.id, '?RedirectUrl=', $base_uri, '/(offset)/', $view_parameters.offset )|ezurl( 'no' )}" method="post">
                <input class="button" type="submit" value="{'Edit'|i18n( 'cjw_newsletter/user_list' )}" title="{'Edit newsletter user'|i18n( 'cjw_newsletter/user_list' )}" name="EditNewsletterUser" />
            </form>
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

{else}
    This View is only available for 'Newsletter List' objects
{/if}

</div>
