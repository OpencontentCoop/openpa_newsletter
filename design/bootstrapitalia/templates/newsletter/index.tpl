{ezpagedata_set( 'show_path',false() )}
{def $newsletter_root_node_id = ezini( 'NewsletterSettings', 'RootFolderNodeId', 'cjw_newsletter.ini' )}
{def $page_uri = 'newsletter/index'
     $limit = 10}

{* Newsletter system boxes *}
{def $newsletter_system_node_list = fetch('content', 'tree', hash( 'parent_node_id', $newsletter_root_node_id, 'class_filter_type', 'include', 'class_filter_array', array( 'cjw_newsletter_system' ), 'sort_by', array( 'name', true() )))}
{def $newsletter_list_node_list = array()}
{foreach $newsletter_system_node_list as $newsletter_system_node}
    {set $newsletter_list_node_list = fetch('content', 'list', hash( 'parent_node_id', $newsletter_system_node.node_id, 'class_filter_type', 'include','class_filter_array', array( 'cjw_newsletter_list' )))}
{/foreach}

<div class="row pt-3">
    <div class="col-12 mb-3">
        <h1 class="h3">{'Newsletter dashboard'|i18n( 'cjw_newsletter/index' )}</a></h1>
    </div>
</div>
<div class="row">
    <div class="col">
        <div class="card-wrapper card-space">
            <div class="card card-bg card-big border-bottom-card">
                <div class="card-body">
                    <h3 class="card-title h5">Edizioni in lavorazione</h3>
                    <p class="card-text font-serif">
                        Le edizioni permettono di collezionare i contenuti presenti nel sito per comporre una campagna da inviare poi a una o più liste {if is_sendy_enabled()}attraverso il sistema di invio {sendy_url()}.{/if}
                        Quando un'edizione è stata inviata è possibile marcarla come archiviata. <b>È possibile aggiungere contenuti solo alle edizioni in lavorazione.</b>
                        <br>
                    </p>

                    {foreach $newsletter_list_node_list as $newsletter_list_node}
                        <div class="it-list-wrapper mb-4">
                            <div class="d-flex align-items-center justify-content-between border-bottom">
                                <h6 class="link-list-heading mb-0 font-weight-bold">{$newsletter_list_node.name|wash()}</h6>
                                {if $newsletter_list_node.can_create}
                                    <form action="{'content/action'|ezurl(no)}" name="CreateNewNewsletterEdition" method="post" class="d-inline">
                                        <input type="hidden" value="{$newsletter_list_node.object.initial_language_code}" name="ContentLanguageCode"/>
                                        <input type="hidden" value="{$newsletter_list_node.node_id}" name="ContentNodeID"/>
                                        <input type="hidden" value="{$newsletter_list_node.node_id}" name="NodeID"/>
                                        <input type="hidden" value="cjw_newsletter_edition" name="ClassIdentifier"/>
                                        <input type="hidden" value="/newsletter/index" name="RedirectURIAfterPublish"/>
                                        <input type="hidden" value="/newsletter/index" name="RedirectIfDiscarded"/>
                                        <button class="btn btn-xs btn-link font-weight-bold" type="submit" name="NewButton">
                                            <span style="letter-spacing: .9px;text-transform:uppercase;vertical-align: middle;">Crea edizione</span>
                                            {display_icon('it-plus', 'svg', 'icon icon-xs')}
                                        </button>
                                    </form>
                                {/if}
                            </div>
                            {def $edition_draft_node_list = fetch('content','list', hash('parent_node_id', $newsletter_list_node.node_id, 'extended_attribute_filter', hash( 'id', 'CjwNewsletterEditionFilter', 'params', hash( 'status', 'draft' ) )) )}
                            <ul class="it-list">
                            {if $edition_draft_node_list|count|gt(0)}
                                {foreach $edition_draft_node_list as $edition_draft_node}
                                    <li>
                                        <div class="list-item">
                                            <div class="it-right-zone">
                                                <a href="{$edition_draft_node.url_alias|ezurl(no)}">
                                                    <span class="mr-2 me-2">{$edition_draft_node.name|wash()}</span>
                                                    {foreach $edition_draft_node.object.languages as $l}
                                                        <img src="{$l.locale|flag_icon}" width="18" height="12" alt="{$l.locale}" />
                                                    {/foreach}
                                                    <span class="badge badge-info bg-info text-white ml-2 ms-2">{$edition_draft_node.children_count} contenuti</span>
                                                </a>
                                                {if $edition_draft_node.can_edit}
                                                <span class="it-multiple">
                                                    <form action="{'content/action'|ezurl(no)}" method="post">
                                                        <input type="hidden" value="{$edition_draft_node.node_id}" name="TopLevelNode"/>
                                                        <input type="hidden" value="{$edition_draft_node.node_id}" name="ContentNodeID"/>
                                                        <input type="hidden" value="{$edition_draft_node.contentobject_id}" name="ContentObjectID" />
                                                        <input type="hidden" value="{'newsletter/index'}" name="RedirectIfDiscarded" />
                                                        <input type="hidden" value="{$edition_draft_node.object.initial_language_code}" name="ContentObjectLanguageCode"/>
                                                        <input type="hidden" value="/newsletter/index" name="RedirectURIAfterPublish"/>
                                                        <input type="hidden" value="/newsletter/index" name="RedirectIfDiscarded"/>
                                                        <button class="btn btn-link p-0" type="submit" name="EditButton" title="{'Edit newsletter'|i18n( 'cjw_newsletter/index' )}" aria-label="{'Edit newsletter'|i18n( 'cjw_newsletter/index' )}">
                                                          <span class="fa-stack">
                                                              <i class="fa fa-square fa-stack-2x"></i>
                                                              <i class="fa fa-pencil fa-stack-1x fa-inverse"></i>
                                                          </span>
                                                        </button>
                                                    </form>

                                                    {def $newsletter_edition_attribute = $edition_draft_node.data_map.newsletter_edition
                                                         $newsletter_edition_attribute_content = $newsletter_edition_attribute.content
                                                         $list_attribute_content = $newsletter_edition_attribute_content.list_attribute_content
                                                         $skin_name = $list_attribute_content.skin_name
                                                         $list_main_siteaccess =  $list_attribute_content.main_siteaccess
                                                         $contentobject_id = $newsletter_edition_attribute_content.contentobject_id
                                                         $contentobject_version = $newsletter_edition_attribute_content.contentobject_attribute_version}

                                                        {def $src_url = concat('/newsletter/preview/' , $contentobject_id, '/', $contentobject_version, '/0/', $list_main_siteaccess, '/',$skin_name,'/')}
                                                        <a class="btn btn-link p-0" href="{$src_url|ezurl(no)}" target="_blank">
                                                            <span class="fa-stack">
                                                              <i class="fa fa-square fa-stack-2x"></i>
                                                              <i class="fa fa-eye fa-stack-1x fa-inverse"></i>
                                                          </span>
                                                        </a>
                                                        {undef $src_url}

                                                    <form action="{'content/action'|ezurl(no)}" method="post">
                                                        <input type="hidden" value="{$edition_draft_node.node_id}" name="TopLevelNode"/>
                                                        <input type="hidden" value="{$edition_draft_node.node_id}" name="ContentNodeID"/>
                                                        <input type="hidden" value="{$edition_draft_node.contentobject_id}" name="ContentObjectID" />
                                                        <input type="hidden" value="{'newsletter/index'}" name="RedirectIfDiscarded" />
                                                        <input type="hidden" value="{ezini( 'RegionalSettings', 'ContentObjectLocale' )}" name="ContentLanguageCode"/>
                                                        <input type="hidden" value="/newsletter/index" name="RedirectURIAfterRemove"/>
                                                        <input type="hidden" value="/newsletter/index" name="RedirectIfCancel"/>
                                                        <button class="btn btn-link p-0" type="submit" name="ActionRemove" title="{'Remove'|i18n( 'design/admin/node/view/full' )}" aria-label="{'Remove'|i18n( 'design/admin/node/view/full' )}">
                                                          <span class="fa-stack">
                                                              <i class="fa fa-square fa-stack-2x text-danger"></i>
                                                              <i class="fa fa-trash fa-stack-1x fa-inverse"></i>
                                                          </span>
                                                        </button>
                                                    </form>
                                                    {if is_sendy_enabled()}
                                                    <form class="sendy-create ml-5 ms-5" method="POST" accept-charset="utf-8">
                                                        <input type="hidden" name="id" value="{$newsletter_edition_attribute.id}" />
                                                        <input type="hidden" name="version" value="{$newsletter_edition_attribute.version}" />
                                                        <button class="btn btn-link p-0" type="submit" title="Crea campagna in {sendy_url()}">
                                                            <span class="fa-stack">
                                                              <i class="fa fa-square fa-stack-2x text-primary"></i>
                                                              <i class="fa fa-paper-plane fa-stack-1x fa-inverse"></i>
                                                            </span>
                                                        </button>
                                                    </form>
                                                    <form class="archive-newsletter" method="POST" accept-charset="utf-8">
                                                        <input type="hidden" name="id" value="{$newsletter_edition_attribute.id}" />
                                                        <input type="hidden" name="version" value="{$newsletter_edition_attribute.version}" />
                                                        <button class="btn btn-link p-0" type="submit" title="Archivia">
                                                            <span class="fa-stack">
                                                              <i class="fa fa-square fa-stack-2x text-danger"></i>
                                                              <i class="fa fa-archive fa-stack-1x fa-inverse"></i>
                                                            </span>
                                                        </button>
                                                    </form>
                                                    {/if}

                                                    {undef $newsletter_edition_attribute $newsletter_edition_attribute_content $list_attribute_content $skin_name $list_main_siteaccess $contentobject_id $contentobject_version}

                                                </span>
                                                {/if}
                                            </div>
                                        </div>
                                    </li>
                                {/foreach}
                            {else}
                                <li>
                                    <div class="list-item">
                                        <div class="it-right-zone">
                                            <em>Nessuna edizione</em>
                                        </div>
                                    </div>
                                </li>
                            {/if}
                            {undef $edition_draft_node_list}
                            </ul>
                        </div>
                    {/foreach}
                    {if is_sendy_enabled()}
                    <a class="read-more" href="https://{sendy_url()}/app?i={sendy_brand_id()}" target="_blank">
                        <span class="text">Gestisci campagne</span>
                        {display_icon('it-arrow-right', 'svg', 'icon')}
                    </a>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row mt-4">
    <div class="col">
        <div class="card-wrapper card-space">
            <div class="card card-bg card-big border-bottom-card">
                <div class="card-body">
                    <h3 class="card-title h5">Modelli di newsletter</h3>
                    <p class="card-text font-serif">
                        Un modello di newsletter permette di creare il layout di base per ciascuna edizione: dalle informazioni del modello vengono ricavati il titolo, l'immagine della testata e i link del piè di pagina.
                        Il logo e la palette di colori sono invece ricavati dalle impostazioni del sito.
                    </p>
                    <div class="it-list-wrapper">
                        <ul class="it-list">
                            {foreach $newsletter_list_node_list as $newsletter_list_node}
                                <li>
                                    <div class="list-item">
                                        <div class="it-right-zone">
                                            <a href="{$newsletter_list_node.url_alias|ezurl(no)}">
                                                <span class="mr-2 me-2">{$newsletter_list_node.name|wash()}</span>
                                                {foreach $newsletter_list_node.object.languages as $l}
                                                    <img src="{$l.locale|flag_icon}" width="18" height="12" alt="{$l.locale}" />
                                                {/foreach}
                                            </a>
                                            <span class="it-multiple">
                                                <form action="{'content/action'|ezurl(no)}" method="post">
                                                    <input type="hidden" value="{$newsletter_list_node.node_id}" name="TopLevelNode"/>
                                                    <input type="hidden" value="{$newsletter_list_node.node_id}" name="ContentNodeID"/>
                                                    <input type="hidden" value="{$newsletter_list_node.contentobject_id}" name="ContentObjectID" />
                                                    <input type="hidden" value="{'newsletter/index'}" name="RedirectIfDiscarded" />
                                                    <input type="hidden" value="{$newsletter_list_node.object.initial_language_code}" name="ContentObjectLanguageCode"/>
                                                    <input type="hidden" value="/newsletter/index" name="RedirectURIAfterPublish"/>
                                                    <input type="hidden" value="/newsletter/index" name="RedirectIfDiscarded"/>
                                                    <button class="btn btn-link p-0" type="submit" name="EditButton" title="{'Edit newsletter'|i18n( 'cjw_newsletter/index' )}" aria-label="{'Edit newsletter'|i18n( 'cjw_newsletter/index' )}">
                                                      <span class="fa-stack">
                                                          <i class="fa fa-square fa-stack-2x"></i>
                                                          <i class="fa fa-pencil fa-stack-1x fa-inverse"></i>
                                                      </span>
                                                    </button>
                                                </form>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                            {/foreach}
                        </ul>
                    </div>
                    {if and( count($newsletter_list_node_list), $newsletter_system_node_list[0].can_create)}
                        <form action="{'content/action'|ezurl(no)}" name="CreateNewNewsletterList" method="post" class="d-inline" style="position: absolute;bottom: 24px;">
                            <input type="hidden" value="{ezini( 'RegionalSettings', 'ContentObjectLocale' )}" name="ContentLanguageCode"/>
                            <input type="hidden" value="{$newsletter_system_node_list[0].node_id}" name="ContentNodeID"/>
                            <input type="hidden" value="{$newsletter_system_node_list[0].node_id}" name="NodeID"/>
                            <input type="hidden" value="cjw_newsletter_list" name="ClassIdentifier"/>
                            <input type="hidden" value="/newsletter/index" name="RedirectURIAfterPublish"/>
                            <input type="hidden" value="/newsletter/index" name="RedirectIfDiscarded"/>
                            <button class="btn p-0 btn-xs btn-link font-weight-bold" type="submit" name="NewButton">
                                <span style="letter-spacing: .9px;text-transform:uppercase;vertical-align: middle;">Crea nuovo</span>
                                {display_icon('it-plus', 'svg', 'icon icon-xs')}
                            </button>
                        </form>
                    {/if}
                </div>
            </div>
        </div>
    </div>
</div>
{if is_sendy_enabled()}
<div class="row mt-4">
    <div class="col">
        <div class="card-wrapper card-space">
            <div class="card card-bg card-big border-bottom-card">
                <div class="card-body">
                    <h3 class="card-title h5">Liste di sottoscrizione</h3>
                    <p class="card-text font-serif">
                        Seleziona le liste a cui gli utenti possono iscriversi e che compariranno nella <a href="{'newsletter/subscribe'|ezurl(no)}" target="_blank">pagina di iscrizione <i class="fa fa-external-link"></i></a>.
                        Le liste sono ottenute dal <a href="https://{sendy_url()}/list?i={sendy_brand_id()}" target="_blank">sistema di invio {sendy_url()} <i class="fa fa-external-link"></i></a><br>
                        Per ciascuna lista puoi specificare il titolo che verrà visualizzata nel form di sottoscrizione
                    </p>
                    <div id="lists" class="alpaca-field-table"></div>
                    <a class="read-more" href="https://{sendy_url()}/list?i={sendy_brand_id()}" target="_blank">
                        <span class="text">Gestisci liste</span>
                        {display_icon('it-arrow-right', 'svg', 'icon')}
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
{/if}
{def $informativa = fetch(content, object, hash(remote_id, 'informativa_newsletter'))}
{if $informativa}
    <div class="row mt-4">
        <div class="col">
            <div class="card-wrapper card-space">
                <div class="card card-bg card-big border-bottom-card no-after">
                    <div class="card-body">
                        <h3 class="card-title h5">Informativa</h3>
                        <p class="card-text font-serif">
                            Visualizza e modifica il testo dell'informativa della newsletter
                        </p>
                        <div class="it-list-wrapper">
                            <ul class="it-list">
                                <li>
                                    <div class="list-item">
                                        <div class="it-right-zone">
                                            <a href="{$informativa.main_node.url_alias|ezurl(no)}">
                                                <span class="mr-2 me-2">{$informativa.name|wash()}</span>
                                                {foreach $informativa.languages as $l}
                                                    <img src="{$l.locale|flag_icon}" width="18" height="12" alt="{$l.locale}" />
                                                {/foreach}
                                            </a>
                                            <span class="it-multiple">
                                                <form action="{'content/action'|ezurl(no)}" method="post">
                                                    <input type="hidden" value="{$informativa.main_node_id}" name="TopLevelNode"/>
                                                    <input type="hidden" value="{$informativa.main_node_id}" name="ContentNodeID"/>
                                                    <input type="hidden" value="{$informativa.id}" name="ContentObjectID" />
                                                    <input type="hidden" value="{'newsletter/index'}" name="RedirectIfDiscarded" />
                                                    <input type="hidden" name="ContentObjectLanguageCode" value="{ezini( 'RegionalSettings', 'ContentObjectLocale' )}" />
                                                    <input type="hidden" value="/newsletter/index" name="RedirectURIAfterPublish"/>
                                                    <input type="hidden" value="/newsletter/index" name="RedirectIfDiscarded"/>
                                                    <button class="btn btn-link p-0" type="submit" name="EditButton" title="{'Edit newsletter'|i18n( 'cjw_newsletter/index' )}" aria-label="{'Edit newsletter'|i18n( 'cjw_newsletter/index' )}">
                                                      <span class="fa-stack">
                                                          <i class="fa fa-square fa-stack-2x"></i>
                                                          <i class="fa fa-pencil fa-stack-1x fa-inverse"></i>
                                                      </span>
                                                    </button>
                                                </form>
                                            </span>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
{/if}

{undef $newsletter_system_node_list}

{literal}
    <script>
      $(document).ready(function () {
        let load = function (){
          $('#lists').opendataForm({}, {
            connector: 'newsletter-list',
            onSuccess: function () {
              load();
            }
          });
        }
        load();

        $('.sendy-create').on('submit', function (e) {
          var form = $(this);
          var original = form.html()
          var data = form.serializeArray();
          form.html('<i class="fa fa-circle-o-notch fa-spin fa-fw"></i>');
          $.ez('newsletter::createcampaign', data, function (response) {
            alert(response.text)
            form.html(original)
          });
          e.preventDefault();
        });
        $('.archive-newsletter').on('submit', function (e) {
          var form = $(this);
          var original = form.html()
          var data = form.serializeArray();
          form.html('<i class="fa fa-circle-o-notch fa-spin fa-fw"></i>');
          $.ez('newsletter::archive', data, function (response) {
            if (response.code === 'danger'){
              alert(response.text)
              form.html(original)
            }else{
              form.parents('li').remove()
            }
          });
          e.preventDefault();
        });
      });
    </script>
    <style>
        .form-group.alpaca-field{
            margin-bottom:0 !important;
        }
        .form-check.alpaca-control{
            text-align:left !important;
        }
        .alpaca-form label.form-check-label{
            margin-bottom:0 !important;
        }
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
    </style>
{/literal}

{ezcss_require(array(
    'alpaca.min.css',
    'alpaca-custom.css'
))}
{*
{ezscript_require(array(
    'handlebars.min.js',
    'jquery.fileupload.js',
    'jquery.fileupload-ui.js',
    'jquery.fileupload-process.js',
    'jquery.caret.min.js',
    'alpaca.js',
    'jquery.opendatabrowse.js',
    'fields/RelationBrowse.js',
    'fields/Ezxml.js',
    ezini('JavascriptSettings', 'IncludeScriptList', 'ocopendata_connectors.ini'),
    'jquery.opendataform.js'
))}
{def $plugin_list = ezini('EditorSettings', 'Plugins', 'ezoe.ini',,true() )
$ez_locale = ezini( 'RegionalSettings', 'Locale', 'site.ini')
$language = '-'|concat( $ez_locale )
$dependency_js_list = array( 'ezoe::i18n::'|concat( $language ) )}
{foreach $plugin_list as $plugin}
    {set $dependency_js_list = $dependency_js_list|append( concat( 'plugins/', $plugin|trim, '/editor_plugin.js' ))}
{/foreach}
<script id="tinymce_script_loader" type="text/javascript" src={"javascript/tiny_mce_jquery.js"|ezdesign} charset="utf-8"></script>
{ezscript( $dependency_js_list )}
{ezcss_require(array(
    'alpaca.min.css',
    'jquery.fileupload.css',
    'alpaca-custom.css'
))}
*}