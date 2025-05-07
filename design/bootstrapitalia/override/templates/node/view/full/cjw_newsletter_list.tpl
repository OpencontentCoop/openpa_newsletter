{def $openpa = object_handler($node)}
{ezpagedata_set( 'show_path',false() )}
{ezpagedata_set('is_homepage', false())}
{ezpagedata_set( 'has_container', true() )}

<section class="container">
    <div class="row">
        <div class="col">
            <div class="cmp-breadcrumbs" role="navigation">
                <nav class="breadcrumb-container" aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="{'newsletter/index'|ezurl(no)}">{'Newsletter dashboard'|i18n( 'cjw_newsletter/index' )}</a><span class="separator">/</span></li>
                        <li class="breadcrumb-item active" aria-current="page">{$node.name|wash()}</li>
                    </ol>
                </nav>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 py-lg-2">
            <h1>{$node.name|wash()}</h1>
            {if $node|has_attribute('short_description')}
                <div class="lead">{attribute_view_gui attribute=$node|attribute('short_description')}</div>
            {/if}
        </div>        
    </div>
</section>

{if $node.children_count}
<div class="container mb-5">
    {foreach fetch_alias( children, hash( parent_node_id, $node.node_id, sort_by, array('published', false())) ) as $child}
    <div class="it-list-wrapper">
        <ul class="it-list">
            <li>
                <div class="list-item">
                    <div class="it-right-zone">
                        <a href="{$child.url_alias|ezurl(no)}">{$child.name|wash()}</a>
                        {def $archived_at = 0}
                        {foreach $child.data_map.newsletter_edition.content.edition_send_array.all as $edition_send_object}
                            {if and($edition_send_object.status|eq(3), $edition_send_object.mailqueue_process_finished|gt(0))}
                                {set $archived_at = $edition_send_object.mailqueue_process_finished}
                            {/if}
                        {/foreach}
                        <span class="it-multiple">
                            {switch match=$child.data_map.newsletter_edition.content.status}
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
                        </span>
                        {undef $archived_at}
                    </div>
                </div>
            </li>
        </ul>
    </div>
    {/foreach}
</div>
{/if}

{if and($openpa.content_tools.editor_tools, module_params().function_name|ne('versionview'))}
    {include uri=$openpa.content_tools.template}
{/if}
{undef $openpa}
{literal}
    <style>
        .it-list-wrapper .it-list .list-item .it-right-zone {
            padding: 16px 0 16px 0;
            flex-grow: 1;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .it-list-wrapper .it-list .list-item .it-right-zone span.it-multiple {
            display: flex;
            justify-content: flex-end;
            flex-wrap: wrap;
        }
        .it-list-wrapper .it-list .list-item {
            transition: all .3s;
            margin-top: -1px;
            display: flex;
            align-items: center;
            text-decoration: none;
            border-bottom: 1px solid #c5c7c9;
            overflow-wrap: anywhere;
        }
        .breadcrumb-container .breadcrumb .breadcrumb-item + .breadcrumb-item::before {
            content: "";
        }
    </style>
{/literal}