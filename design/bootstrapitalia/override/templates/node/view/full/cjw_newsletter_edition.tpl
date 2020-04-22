{ezpagedata_set( 'has_container', true() )}
{ezpagedata_set( 'show_path',false() )}

{def $openpa = object_handler($node)}
{def $newsletter_edition_attribute = $node.data_map.newsletter_edition
     $newsletter_edition_attribute_content = $newsletter_edition_attribute.content
     $newsletter_list_attribute_content = $newsletter_edition_attribute.content.list_attribute_content
     $newsletter_edition_status = $newsletter_edition_attribute_content.status}
{def $email_receiver_test = $newsletter_list_attribute_content.email_receiver_test}

<section class="container">
    <div class="row">  
        <div class="col">
            <nav class="breadcrumb-container" aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="{'newsletter/index'|ezurl(no)}">Newsletter / Pannello di controllo</a></li>
                </ol>
            </nav>
        </div>
    </div>
    <div class="row">        
        <div class="col-lg-12 pb-lg-2">
            <h1>{$node.name|wash()}</h1>   
            {include uri='design:openpa/full/parts/main_attributes.tpl'}         
        </div>        
    </div>
</section>

<section class="container">
    <div class="row">
        <section class="col-lg-12">
            <article id="state" class="it-page-section mb-4 anchor-offset">
                <h4>{'Edition State'|i18n( 'cjw_newsletter/cjw_newsletter_edition_status' )}</h4>
                {switch match=$newsletter_edition_status}
                    {case match='draft'}
                        <img src={'images/newsletter/icons/crystal-newsletter/16x16/newsletter_draft.png'|ezdesign} alt="{$newsletter_edition_status}" title="{$newsletter_edition_status}" />
                        {'Status draft'|i18n( 'cjw_newsletter/cjw_newsletter_edition_status' )}
                        {*'Send Newsletter'|i18n( 'cjw_newsletter/cjw_newsletter_edition_status' )*}{*Newsletter verschicken*}
                    {/case}
                    {case match='process'}
                        <img src={'images/newsletter/icons/crystal-newsletter/16x16/newsletter_process.png'|ezdesign} alt="{$newsletter_edition_status}" title="{$newsletter_edition_status}" />
                        {'Status process'|i18n( 'cjw_newsletter/cjw_newsletter_edition_status' )}
                        {*'in the dispatch'|i18n( 'cjw_newsletter/cjw_newsletter_edition_status' )*}    {*im Versand*}
                    {/case}
                    {case match='archive'}
                        <img src={'images/newsletter/icons/crystal-newsletter/16x16/newsletter_archive.png'|ezdesign} alt="{$newsletter_edition_status}" title="{$newsletter_edition_status}" />
                        {'Status archive'|i18n( 'cjw_newsletter/cjw_newsletter_edition_status' )}
                        {*'sends'|i18n( 'cjw_newsletter/cjw_newsletter_edition_status' )*}      {*verschickt*}
                    {/case}
                    {case match='abort'}
                        <img src={'images/newsletter/icons/crystal-newsletter/16x16/newsletter_abort.png'|ezdesign} alt="{$newsletter_edition_status}" title="{$newsletter_edition_status}" />
                        {*'uncompletedly'|i18n( 'cjw_newsletter/cjw_newsletter_edition_status' )*}      {*abgebrochen*}
                        {'Status abort'|i18n( 'cjw_newsletter/cjw_newsletter_edition_status' )}
                    {/case}
                {/switch}
            </article>

            <article id="contents" class="it-page-section mb-4 anchor-offset">
                <h4>Contenuti</h4>
                {include uri='design:atoms/list_with_icon.tpl' items=$node.children}
                {if $newsletter_edition_status|ne('draft')}
                    {include uri="design:includes/cjwnewsletteredition_preview_archive.tpl" newsletter_edition_attribute=$newsletter_edition_attribute show_iframes=true() iframe_height="800"}
                {else}
                    {include uri="design:includes/cjwnewsletteredition_preview.tpl" newsletter_edition_attribute=$newsletter_edition_attribute show_iframes=true() iframe_height="800"}
                {/if}
            </article>

            {if $newsletter_edition_status|ne('draft')}
                
                <article id="send_statistic" class="it-page-section mb-4 anchor-offset">
                    <h4>{'Newsletter Edition send out statistic'|i18n( 'cjw_newsletter/cjw_newsletter_edition_send_statistic' )}</h4>

                    <table class="table table-striped" cellspacing="0">
                        <tr>
                            <th>{'Id'|i18n( 'cjw_newsletter/cjw_newsletter_edition_send_statistic' )}</th>
                            <th>{'Mail count'|i18n( 'cjw_newsletter/cjw_newsletter_edition_send_statistic' )}</th>
                            <th>{'Mail send'|i18n( 'cjw_newsletter/cjw_newsletter_edition_send_statistic' )}</th>
                            <th>{'Mail not send'|i18n( 'cjw_newsletter/cjw_newsletter_edition_send_statistic' )}</th>
                            <th>{'Mail bounced'|i18n( 'cjw_newsletter/cjw_newsletter_edition_send_statistic' )}</th>
                            <th>{'Creator'|i18n( 'cjw_newsletter/cjw_newsletter_edition_send_statistic' )}</th>
                            <th></th>
                        </tr>

                        {if $newsletter_edition_attribute_content.edition_send_array.current|count|ne( 0 )}
                            {def $current_edition_send_object = $newsletter_edition_attribute_content.edition_send_array.current[0]}
                        {/if}

                        {foreach $newsletter_edition_attribute_content.edition_send_array.all as $edition_send_object}
                         <tr>
                            <td>{if $current_edition_send_object.id|eq($edition_send_object.id)}({$edition_send_object.id}){else}{$edition_send_object.id}{/if}</td>
                            <td>{$edition_send_object.send_items_statistic.items_count}</td>
                            <td>{$edition_send_object.send_items_statistic.items_send}</td>
                            <td>{$edition_send_object.send_items_statistic.items_not_send}</td>
                            <td>{$edition_send_object.send_items_statistic.items_bounced}</td>
                            <td>{$edition_send_object.creator_id}</td>
                            <td>
                            {* only show abort button if not  finished (3) or aborted (9) *}
                            {if or( $edition_send_object.status|eq(3), $edition_send_object.status|eq(9) )}
                                {'Abort cronjob'|i18n( 'cjw_newsletter/cjw_newsletter_edition_send_statistic' )}
                            {else}
                                <a href={concat('newsletter/send_abort/',$edition_send_object.id)|ezurl}>
                                {'Abort cronjob'|i18n( 'cjw_newsletter/cjw_newsletter_edition_send_statistic' )}
                                </a>
                            {/if}</td>
                        </tr>
                        <tr>
                            <td colspan="7">
                                Cronjob Status: {*{$edition_send_object.status}*}
                                <ul>
                                    <li>{if $edition_send_object.status|eq(4)}<b>{/if}0 - wait_for_schedule ( {$edition_send_object.created|l10n( shortdatetime )} ){if $edition_send_object.status|eq(0)}</b>{/if}</li>
                                    <li>{if $edition_send_object.status|eq(0)}<b>{/if}0 - wait_for_process ( {$edition_send_object.created|l10n( shortdatetime )} ){if $edition_send_object.status|eq(0)}</b>{/if}</li>
                                    <li>{if $edition_send_object.status|eq(1)}<b>{/if}1 - mailqueue_created ( {cond( $edition_send_object.mailqueue_created|eq(0), '-',  $edition_send_object.mailqueue_created|l10n( shortdatetime ) )} ){if $edition_send_object.status|eq(1)}</b>{/if}</li>
                                    <li>{if $edition_send_object.status|eq(2)}<b>{/if}2 - mailqueue_process_started ( {cond( $edition_send_object.mailqueue_process_started|eq(0), '-',  $edition_send_object.mailqueue_process_started|l10n( shortdatetime ) )} ){if $edition_send_object.status|eq(2)}</b>{/if}</li>
                                    <li>{if $edition_send_object.status|eq(3)}<b>{/if}3 - mailqueue_process_finished ( {cond( $edition_send_object.mailqueue_process_finished|eq(0), '-',  $edition_send_object.mailqueue_process_finished|l10n( shortdatetime ) )} ){if $edition_send_object.status|eq(3)}</b>{/if}</li>
                                    <li>{if $edition_send_object.status|eq(9)}<b>{/if}9 - mailqueue_process_aborted ( {cond( $edition_send_object.mailqueue_process_aborted|eq(0), '-',  $edition_send_object.mailqueue_process_aborted|l10n( shortdatetime ) )} ){if $edition_send_object.status|eq(9)}</b>{/if}</li>
                                </ul>
                            </td>
                        </tr>
                    {/foreach}
                    </table>

                </article>                
            {else}                                

                <article id="send" class="it-page-section mb-4 anchor-offset">
                    <div class="row">
                        <div class="col">
                            {if and(ezini_hasvariable('GeneralSettings', 'EnableSendy', 'sendy.ini'), ezini('GeneralSettings', 'EnableSendy', 'sendy.ini')|eq('enabled'))}
                                {include uri='design:sendy/create_campaign.tpl' newsletter_edition_attribute=$newsletter_edition_attribute}
                            {else}
                                <form action={'newsletter/send'|ezurl()}  method="post">
                                    <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" /><input type="hidden" name="ContentNodeID" value="{$node.node_id}" /><input type="hidden" name="ContentObjectID" value="{$node.object.id}" /><input type="hidden" name="mail_newsletter" value="true" />
                                    {if $node.data_map.newsletter_edition.content.is_draft}
                                        <input class="btn btn-success" type="submit" name="SendNewsletterButton" value="{"Send Newsletter"|i18n("cjw_newsletter/send")}" />
                                    {/if}
                                </form>
                            {/if}
                        </div>

                        <div class="col">
                            <form action={'newsletter/send'|ezurl()} method="post">

                                <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" />
                                <input type="hidden" name="ContentNodeID" value="{$node.node_id}" />
                                <input type="hidden" name="ContentObjectID" value="{$node.object.id}" />
                                <input type="hidden" name="mail_newsletter" value="true" />
                                <div class="input-group">
                                    <input class="form-control" type="text" name="EmailReseiverTestInput" value="{$email_receiver_test}" />
                                    <div class="input-group-append">
                                        <input type="submit" class="btn btn-info" name="SendNewsletterTestButton" value="{"Send Test Newsletter"|i18n("cjw_newsletter/send")}" />
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </article>
            {/if}

        </section>
    </div>
    <script>{literal}$(document).ready(function () {
        $('.menu-wrapper a.nav-link').on('click', function () {
            $(this).addClass('active')
                .parent().addClass('active')
                .parents('.menu-wrapper').find('.active').not(this).removeClass('active')
        })
    }){/literal}</script>
</section>

{if and($openpa.content_tools.editor_tools, module_params().function_name|ne('versionview'))}
    {include uri=$openpa.content_tools.template}
{/if}

{if and(fetch( 'user', 'has_access_to', hash( 'module', 'websitetoolbar', 'function', 'use' ) ), module_params().function_name|ne('versionview'))}
    {include uri='design:parts/load_website_toolbar.tpl' current_user=fetch(user, current_user)}
{/if}

{def $homepage = fetch('openpa', 'homepage')}
{if $homepage.node_id|eq($node.node_id)}
    {ezpagedata_set('is_homepage', true())}
{/if}
{undef $openpa}
