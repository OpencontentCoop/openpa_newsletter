{def $content = fetch(content, object, hash(remote_id, 'informativa_newsletter'))}
{if and($content, $content|has_attribute('description'))}
    <h4>{$content.name|wash()}</h4>
    {attribute_view_gui attribute=$content|attribute('description')}

{else}
    <h4>Informativa newsletter</h4>
    <p>
        Dichiaro di essere informato, ai sensi e per gli effetti degli artt. 13 e 14 del Regolamento UE 2016/679 e
        dell’art.
        13 del D.Lgs. 196/2003, che i dati personali raccolti saranno trattati, con strumenti cartacei e con strumenti
        informatici, esclusivamente nell’ambito del servizio per il quale la presente dichiarazione viene resa, in
        esecuzione di un compito o di una funzione di interesse pubblico.
    </p>
    <p>
        Titolare del trattamento è
        il {openpaini('NewsletterSettings', 'NomeTitolareTrattamento', ezini('SiteSettings', 'SiteName'))},
        Responsabile della Protezione dei Dati è
        il {openpaini('NewsletterSettings', 'NomeResponsabileTrattamento', 'Consorzio dei Comuni Trentini')},
        con sede a {openpaini('NewsletterSettings', 'SedeResponsabileTrattamento', 'Trento in via Torre Verde 23')}
        (e-mail ​<a href="mailto:{openpaini('NewsletterSettings', 'MailResponsabileTrattamento', 'servizioRPD@comunitrentini.it')}">{openpaini('NewsletterSettings', 'MailResponsabileTrattamento', 'servizioRPD@comunitrentini.it')}</a>,
        sito internet <a href="http://{openpaini('NewsletterSettings', 'SitoResponsabileTrattamento', 'www.comunitrentini.it')}">{openpaini('NewsletterSettings', 'SitoResponsabileTrattamento', 'www.comunitrentini.it')}</a>.
        Dichiaro di essere a conoscenza di poter esercitare il diritto di accesso e gli altri diritti di cui agli artt.
        15 e seguenti del Regolamento UE 2016/679 e dell’art. 7 e seguenti del D.Lgs. 196/2003.
    </p>
{/if}
