<form id="sendy-create" method="POST" accept-charset="utf-8">
    <input type="hidden" name="id" value="{$newsletter_edition_attribute.id}" />
    <input type="hidden" name="version" value="{$newsletter_edition_attribute.version}" />
    <button class="btn btn-success" type="submit">
        Crea campagna in {ezini('GeneralSettings', 'ApiUrl', 'sendy.ini')}
    </button>
</form>
<script>
    {literal}
    $(document).ready(function () {
        $('#sendy-create').on('submit', function (e) {
            var form = $(this);
            var data = form.serializeArray();
            $.ez('newsletter::createcampaign', data, function (response) {
                form.html('<div class="alert alert-'+response.code+' bg-white text-'+response.code+'">'+response.text+'</div>');
            });
            e.preventDefault();
        });
    });
    {/literal}
</script>