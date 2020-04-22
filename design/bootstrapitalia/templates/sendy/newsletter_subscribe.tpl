<form id="sendy-subscribe" method="POST" accept-charset="utf-8" class="position-relative clearfix">
    <div class="form-group mb-0">
        <label class="text-white font-weight-semibold active" for="email" style="transition: none 0s ease 0s; width: auto;">Iscriviti per riceverla</label>
        <input type="email" name="email" id="email" class="form-control" placeholder="mail@example.com" required/>
    </div>

    {if ezini('SubscribeSettings', 'ListArray', 'sendy.ini')|count()|gt(0)}
        {foreach ezini('SubscribeSettings', 'ListArray', 'sendy.ini') as $idName}
            {def $list = $idName|explode(';')}
            <div class="form-check">
                <input type="checkbox" class="form-check-input" id="list-{$list[0]|wash()}" name="list[]" value="{$list[0]|wash()}">
                <label class="form-check-label text-white font-weight-normal" for="list-{$list[0]|wash()}">{$list[1]|wash()}</label>
            </div>
            {undef $list}
        {/foreach}
    {else}
        <input type="hidden" name="list[]" value="{ezini('SubscribeSettings', 'DefaultListId', 'sendy.ini')}"/>
    {/if}

    {if ezini('SubscribeSettings', 'Gdpr', 'sendy.ini')|eq('true')}
        <div class="form-group my-3">
            <label class="text-white font-weight-normal position-relative" for="gdpr" style="padding-left: 20px;display: inline-block;line-height: 1.2">
                <input required="required" name="gdpr" type="checkbox" id="gdpr" class="position-absolute" style="margin: 4px 0 0 -20px;" />
                Dichiaro di aver preso visione dell'<a href="#" data-toggle="modal" data-target="#informativa">informativa sul trattamento dei dati personali</a>
            </label>
        </div>

    {/if}
    <div style="display:none;"><label for="hp">HP</label><input type="text" name="hp" id="hp"/></div>

    <button class="btn btn-secondary btn-icon pull-right" type="submit">
        <svg class="icon icon-white">
            {display_icon('it-mail', 'svg', 'icon icon-white')}
        </svg>
        <span>Iscriviti</span>
    </button>
</form>

<div id="informativa" class="modal fade">
    <div class="modal-dialog modal-lg">
        <div class="card no-after">
            <div class="card-body">
                <div class="clearfix">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="clearfix card-text text-sans-serif">
                    {include uri='design:newsletter/informativa.tpl'}
                    <a class="btn btn-info pull-right" href="#" data-dismiss="modal" aria-hidden="true">Chiudi</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    {literal}
    $(document).ready(function () {
        $('#sendy-subscribe').on('submit', function (e) {
            var form = $(this);
            var data = form.serializeArray();
            $.ez('newsletter::subscribe', data, function (response) {
                form.prepend('<div style="z-index: 10" class="position-absolute h-100 w-100 alert alert-dismissible fade show alert-'+response.code+' bg-white text-'+response.code+'">'+response.text+
                    '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button></div>');
            });
            e.preventDefault();
        });
    });
    {/literal}
</script>