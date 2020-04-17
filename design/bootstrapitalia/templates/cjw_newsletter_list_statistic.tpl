{def $user_count_statistic = $list_node.data_map.newsletter_list.content.user_count_statistic}

{if is_set( $status )|not()}
    {def $status = ''}
{/if}

{if is_set( $icons )}


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

{def $string = "Subscriptions statistic"|i18n( 'cjw_newsletter/subscription_list' )}
<div class="d-flex justify-content-between mt-3 mb-2">
    <a class="chip text-decoration-none{if $status|eq('')} chip-primary{/if}" href={concat( 'newsletter/subscription_list/', $list_node.node_id )|ezurl}>
        <div class="avatar size-xs"><img src={'images/newsletter/icons/crystal-newsletter/16x16/newsletter_user.png'|ezdesign} width="16" height="16" title="{"Subscriptions statistic"|i18n( 'cjw_newsletter/subscription_list' )}"/></div>
        <span class="chip-label text-nowrap">{'Subscriptions'|i18n('cjw_newsletter/contentstructuremenu')} ({$user_count_statistic.all|wash})</span>
    </a>

    {* Pending *}
    <a class="chip text-decoration-none{if $status|eq('pending')} chip-primary{/if}" href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/pending' )|ezurl}>
        <div class="avatar size-xs"><img src={'1x1.gif'|ezimage} alt="" title="" class="{$subscription_icon_css_class_array[0]}"/></div>
        <span class="chip-label text-nowrap">{'Pending'|i18n('cjw_newsletter/subscription_list')} ({$user_count_statistic.pending|wash})</span>
    </a>

    {* Confirmed *}
    <a class="chip text-decoration-none{if $status|eq('confirmed')} chip-primary{/if}" href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/confirmed' )|ezurl}>
        <div class="avatar size-xs"><img src={'1x1.gif'|ezimage} alt="" title="" class="{$subscription_icon_css_class_array[1]}"/></div>
        <span class="chip-label text-nowrap">{'Confirmed'|i18n('cjw_newsletter/subscription_list')} ({$user_count_statistic.confirmed|wash})</span>
    </a>

    {* Approved *}
    <a class="chip text-decoration-none{if $status|eq('approved')} chip-primary{/if}" href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/approved' )|ezurl}>
        <div class="avatar size-xs"><img src={'1x1.gif'|ezimage} alt="" title="" class="{$subscription_icon_css_class_array[2]}"/></div>
        <span class="chip-label text-nowrap">{'Approved'|i18n('cjw_newsletter/subscription_list')} ({$user_count_statistic.approved|wash})</span>
    </a>

    {* Bounced *}
    <a class="chip text-decoration-none{if $status|eq('bounced')} chip-primary{/if}" href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/bounced' )|ezurl}>
        <div class="avatar size-xs"><img src={'1x1.gif'|ezimage} alt="" title="" class="{$subscription_icon_css_class_array['bounced']}"/></div>
        <span class="chip-label text-nowrap">{'Bounced'|i18n('cjw_newsletter/subscription_list')} ({$user_count_statistic.bounced|wash})</span>
    </a>

    {* Removed *}
    <a class="chip text-decoration-none{if $status|eq('removed')} chip-primary{/if}" href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/removed' )|ezurl}>
        <div class="avatar size-xs"><img src={'1x1.gif'|ezimage} alt="" title="" class="{$subscription_icon_css_class_array['removed']}"/></div>
        <span class="chip-label text-nowrap">{'Removed'|i18n('cjw_newsletter/subscription_list')} ({$user_count_statistic.removed|wash})</span>
    </a>

    {* Blacklisted *}
    <a class="chip text-decoration-none{if $status|eq('blacklisted')} chip-primary{/if}" href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/blacklisted' )|ezurl}>
        <div class="avatar size-xs"><img src={'1x1.gif'|ezimage} alt="" title="" class="{$subscription_icon_css_class_array[8]}"/></div>
        <span class="chip-label text-nowrap">{'Blacklisted'|i18n('cjw_newsletter/subscription_list')} ({$user_count_statistic.blacklisted|wash})</span>
    </a>
</div>

{else}

<table class="table table-condensed" cellspacing="0">
    <tr>
        <th>{'All'|i18n('cjw_newsletter/subscription_list')}</th>
        <th>{'Pending'|i18n('cjw_newsletter/subscription_list')}</th>
        <th>{'Confirmed'|i18n('cjw_newsletter/subscription_list')}</th>
        <th>{'Approved'|i18n('cjw_newsletter/subscription_list')}</th>
        <th>{'Bounced'|i18n('cjw_newsletter/subscription_list')}</th>
        <th>{'Removed'|i18n('cjw_newsletter/subscription_list')}</th>
        <th>{'Blacklisted'|i18n('cjw_newsletter/subscription_list')}</th>
    </tr>
    <tr>
        <td><a href={concat( 'newsletter/subscription_list/', $list_node.node_id )|ezurl}>{$user_count_statistic.all|wash}</a></td>
        <td><a href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/pending' )|ezurl}>{$user_count_statistic.pending|wash}</a></td>
        <td><a href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/confirmed' )|ezurl}>{$user_count_statistic.confirmed|wash}</a></td>
        <td><a href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/approved' )|ezurl}><b>{$user_count_statistic.approved|wash}</b></a></td>
        <td><a href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/bounced' )|ezurl}>{$user_count_statistic.bounced|wash}</a></td>
        <td><a href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/removed' )|ezurl}>{$user_count_statistic.removed|wash}</a></td>
        <td><a href={concat( 'newsletter/subscription_list/', $list_node.node_id, '/(status)/blacklisted' )|ezurl}>{$user_count_statistic.blacklisted|wash}</a></td>
    </tr>
</table>

{/if}