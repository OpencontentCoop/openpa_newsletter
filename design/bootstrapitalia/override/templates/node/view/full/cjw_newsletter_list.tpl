{def $openpa = object_handler($node)}
{ezpagedata_set( 'show_path',false() )}

{ezpagedata_set( 'has_container', true() )}
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
        <div class="col-lg-12 py-lg-2">
            <h1>{$node.name|wash()}</h1>            
            {include uri='design:openpa/full/parts/main_attributes.tpl'}
        </div>        
    </div>
</section>

{if $node.children_count}
<div class="section section-muted section-inset-shadow p-4">
    {node_view_gui content_node=$node view=children view_parameters=$view_parameters}
</div>
{/if}

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
{if and( openpaini('GeneralSettings','valutation', 1), $homepage.node_id|ne($node.node_id), $node.class_identifier|ne('frontpage'), $node.class_identifier|ne('homepage') ) }
    {include name=valuation node_id=$node.node_id uri='design:openpa/valuation.tpl'}
{/if}
{undef $openpa}
