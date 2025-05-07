{ezpagedata_set( 'has_container', true() )}
{ezpagedata_set( 'show_path',false() )}
{ezpagedata_set('is_homepage', false())}
{ezpagedata_set( 'has_container', true() )}

{def $openpa = object_handler($node)}
{def $newsletter_edition_attribute = $node.data_map.newsletter_edition
     $newsletter_edition_attribute_content = $newsletter_edition_attribute.content
     $newsletter_list_attribute_content = $newsletter_edition_attribute.content.list_attribute_content
     $newsletter_edition_status = $newsletter_edition_attribute_content.status
     $email_receiver_test = $newsletter_list_attribute_content.email_receiver_test
     $archived_at = 0}

{foreach $newsletter_edition_attribute_content.edition_send_array.all as $edition_send_object}
    {if and($edition_send_object.status|eq(3), $edition_send_object.mailqueue_process_finished|gt(0))}
        {set $archived_at = $edition_send_object.mailqueue_process_finished}
    {/if}
{/foreach}

<section class="container">
    <div class="row">  
        <div class="col">
            <div class="cmp-breadcrumbs" role="navigation">
            <nav class="breadcrumb-container" aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="{'newsletter/index'|ezurl(no)}">{'Newsletter dashboard'|i18n( 'cjw_newsletter/index' )}</a><span class="separator">/</span></li>
                    <li class="breadcrumb-item"><a href="{$node.parent.url_alias|ezurl(no)}">{$node.parent.name|wash()}</a><span class="separator">/</span></li>
                    <li class="breadcrumb-item active" aria-current="page">{$node.name|wash()}</li>
                </ol>
            </nav>
            </div>
        </div>
    </div>
    <div class="row">        
        <div class="col-lg-12 pb-lg-2">
            <h1>
                {$node.name|wash()}
                <small class="badge bg-info" style="font-size:.7em">
                    {switch match=$newsletter_edition_status}
                    {case match='draft'}
                        In lavorazione
                    {/case}
                    {case match='process'}
                        In lavorazione
                    {/case}
                    {case match='archive'}
                        Archiviata il {cond( $archived_at|gt(0), $archived_at|l10n( shortdatetime ), '' )}
                    {/case}
                    {case match='abort'}
                        Archiviata il {cond( $archived_at|gt(0), $archived_at|l10n( shortdatetime ), '' )}
                    {/case}
                    {case}{/case}
                    {/switch}
                </small>
            </h1>
            {if $node|has_attribute('short_description')}
                <div class="lead">{attribute_view_gui attribute=$node|attribute('short_description')}</div>
            {/if}
            {if and($newsletter_edition_status|eq('draft'), is_sendy_enabled()|not())}
                <div class="row my-3 p-3 bg-light rounded">
                    <div class="col">
                        <form action={'newsletter/send'|ezurl()}  method="post">
                            <input type="hidden" name="TopLevelNode" value="{$node.object.main_node_id}" /><input type="hidden" name="ContentNodeID" value="{$node.node_id}" /><input type="hidden" name="ContentObjectID" value="{$node.object.id}" /><input type="hidden" name="mail_newsletter" value="true" />
                            {if $node.data_map.newsletter_edition.content.is_draft}
                                <input class="btn btn-success" type="submit" name="SendNewsletterButton" value="{"Send Newsletter"|i18n("cjw_newsletter/send")}" />
                            {/if}
                        </form>
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
            {/if}

        </div>
    </div>
</section>

<section class="container mb-5">
    <div class="row">
        <div class="col-12 col-sm-12 col-md-6">
            <article id="contents" class="it-page-section mb-4 anchor-offset">
                {include uri='design:atoms/grid.tpl'
                         items_per_row=1
                         i_view=card_teaser
                         image_class=imagelargeoverlay
                         items=$node.children}
            </article>
        </div>
        <div class="col-12 col-sm-12 col-md-6">
            {if $newsletter_edition_status|ne('draft')}
                {include uri="design:includes/cjwnewsletteredition_preview_archive.tpl" newsletter_edition_attribute=$newsletter_edition_attribute show_iframes=true() iframe_height="100%"}
            {else}
                {include uri="design:includes/cjwnewsletteredition_preview.tpl" newsletter_edition_attribute=$newsletter_edition_attribute show_iframes=true() iframe_height="100%"}
            {/if}
        </div>
    </div>
</section>

{if and($openpa.content_tools.editor_tools, module_params().function_name|ne('versionview'))}
    {include uri=$openpa.content_tools.template}
{/if}
{undef $openpa}
{literal}
    <style>
        .breadcrumb-container .breadcrumb .breadcrumb-item + .breadcrumb-item::before {
            content: "";
        }
    </style>
{/literal}