<form id="sendy-create" method="POST" accept-charset="utf-8">
    <input type="hidden" name="id" value="{$newsletter_edition_attribute.id}" />
    <input type="hidden" name="version" value="{$newsletter_edition_attribute.version}" />
    <button class="btn btn-success" type="submit">
        Crea campagna in {sendy_url()}
    </button>
</form>
<form id="archive-newsletter" method="POST" accept-charset="utf-8" class="mt-3">
    <input type="hidden" name="id" value="{$newsletter_edition_attribute.id}" />
    <input type="hidden" name="version" value="{$newsletter_edition_attribute.version}" />
    <button class="btn btn-danger" type="submit">
        Segna come inviata
    </button>
</form>
<script>
    {literal}
    $(document).ready(function () {
        $('#sendy-create').on('submit', function (e) {
            var form = $(this);
            var data = form.serializeArray();
            form.html('<i class="fa fa-circle-o-notch fa-spin fa-fw"></i>');
            $.ez('newsletter::createcampaign', data, function (response) {
                form.html('<div class="alert alert-'+response.code+' bg-white text-'+response.code+'">'+response.text+'</div>');
            });
            e.preventDefault();
        });
        $('#archive-newsletter').on('submit', function (e) {
            var form = $(this);
            var data = form.serializeArray();
            form.html('<i class="fa fa-circle-o-notch fa-spin fa-fw"></i>');
            $.ez('newsletter::archive', data, function (response) {
                if (response.code === 'danger'){
                    form.html('<div class="alert alert-'+response.code+' bg-white text-'+response.code+'">'+response.text+'</div>');
                }else {
                    location.reload();
                }
            });
            e.preventDefault();
        });
    });
    {/literal}
</script>