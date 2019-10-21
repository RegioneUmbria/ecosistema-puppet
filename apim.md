# Come installare WSO2 API Manager 2.6.0
L'utilizzo di puppet per l'installazione di WSO2 API Manager permette di automatizzare:
- la creazione di un utente e un gruppo linux sul server
- l'installazione di WSO2 API Manager 2.6.0
- la configurazione di WSO2 API Manager 2.6.0 in coerenza all'architettura riportata [in questa pagina](./README.md)
- la configurazione del servizio linux per l'avvio automatico di WSO2 API Manager 2.6.0

I file puppet utilizzati per questa installazione derivano dai file puppet di WSO2. I file originali sono stati modificati ed adattati a partire da quelli del repository [WSO2-puppet-apim](https://github.com/wso2/puppet-apim).

> **Nota**: Nella guida si assume che venga utilizzato il database PostgreSQL. E' tuttavia possibile cambiare il database. In questo caso deve essere utilizzato un altro driver che deve essere sostituito a quello di PostgreSQL nella directory `puppetlabs/code/environments/production/modules/apim/files/repository/components/lib`

## Installazione
1. Installare [Amazon Corretto](https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/downloads-list.html) come JDK nei server dove verranno installate le istanze di WSO2. E' possibile utilizzare altre distribuzioni di JDK. A questo link la [lista delle distribuzioni supportate](https://docs.wso2.com/display/compatibility/Tested+Operating+Systems+and+JDKs)
2. Scaricare il pacchetto di installazione di WSO2 AM 2.6.0 (nel caso di sistemi Ubuntu utilizzare il file .deb) e copiarlo nella directory `puppetlabs/code/environments/production/modules/apim/files/` del **Puppet master**
3. Modificare i [parametri di configurazione](#Parametri-di-configurazione)
4. Per iniziare l'installazione dell'istanza, eseguire in ogni server il **Puppet agent** così come segue:
    1. Per i gateway esterni (extgw01 per il nodo 1 e extgw02 per il nodo 2):
        ```bash
        export FACTER_profile=apim
		export FACTER_nodename=extgw01
		export FACTER_environment=production
        puppet agent -vt
        ```
	2. Per i gateway interni (intgw01 per il nodo 1 e intgw02 per il nodo 2):
        ```bash
        export FACTER_profile=apim
		export FACTER_nodename=intgw01
		export FACTER_environment=production
        puppet agent -vt
        ```
	3. Per i traffic manager + store e publisher (sttm01 per il nodo 1 e sttm02 per il nodo 2):
        ```bash
        export FACTER_profile=apim
		export FACTER_nodename=sttm01
		export FACTER_environment=production
        puppet agent -vt
        ```
	4. Per i key manager (km01 per il nodo 1 e km02 per il nodo 2):
        ```bash
        export FACTER_profile=apim
		export FACTER_nodename=km02
		export FACTER_environment=production
        puppet agent -vt
        ```

# Parametri di configurazione
Prima di eseguire puppet per l'installazione di WSO2 nei vari server, è necessario modificare i file di configurazione come di seguito indicato.

## Configurazioni globali per l'API Manager (site.pp)

Per modificare i parametri di configurazione globali dell'API Manager è necessario modificare il file `site.pp` che si trova nella directory `puppetlabs/code/environments/production/manifests`.
In particolare in questo file sono presenti due parametri che hanno effetto sulla configurazione di APIM:

- `$admin_username`
- `$admin_password`

> **Nota**: I due parametri sopra riportati sono condivisi con gli altri componenti dell'architettura

Tolti i due parametri, prima indicati, tutti gli altri parametri si riferiscono alle diverse componenti dell'API Manager. I principali parametri di configurazione su cui intervenire sono:

- Password per i keystore
- Connessioni JDBC verso i database utilizzati dall'API Manager
- URL
- Porte

In particolare, per quanto riguarda le URL, è stata inserita la stringa `tuodominio` che va sostituita, in tutte le sue occorrenze, con il vero dominio su cui verrà installato l'API Manager.
Per quanto riguarda le porte, sono state lasciate quelle di default che possono essere modificate in base alle proprie esigenze. 

## Configurazioni specifiche per i diversi moduli dell'API Manager (GW, STTM, KM)
Una volta configurati i parametri globali dell'API Manager, è necessario intervenire sui parametri di configurazione dei diversi componenti dell'API Manager. Il file sui cui intervenire è `params.pp` che si trova in `puppetlabs/code/environments/production/modules/apim/manifests`. 
In questo caso i parametri di configurazione sono divisi in sezioni corrispondenti alle diverse componenti dell'API Manager.
I parametri su cui intervenire riguardano:

- Connessioni JDBC verso i database
- URL
- Porte

Ancora una volta, per quanto riguarda le URL deve essere sostituita la stringa `tuodomionio` con il dominio reale.

# Personalizzazioni e componenti aggiuntivi
I file puppet installano anche i seguenti componenti aggiuntivi/personalizzazioni:

- Tema personalizzato API store Regione Umbria
- Script di compressione dei log dell'API Manager
- Libreria custom per notifiche email in fase di sottoscrizione ad una API e generazione chiavi
- Fault sequence custom adattate alle Linee Guida Modello di Interoperabilità
- Error page custom

## Tema personalizzato API store Regione Umbria
Il tema personalizzato per la Regione Umbria si chiama `udtheme` e si trova nella directory `puppetlabs/code/environments/production/modules/apim/files/repository/deployment/server/jaggeryapps/store/site/themes/wso2/subthemes`. Questo tema viene copiato automaticamente quando si lancia l'installazione di puppet. Per conoscere come si personalizzano i temi di WSO2 si faccia riferimento alla [guida ufficiale di WSO2](https://docs.wso2.com/display/AM260/Adding+a+New+API+Store+Theme).

## Script di compressione dei log
Lo script di compressione dei log si chiama `log-compress.sh` e si trova in `puppetlabs/code/environments/production/modules/apim/files/system/usr/wso2`. 

## Libreria custom per notifiche email in fase di sottoscrizione ad una API e generazione chiavi
La sottoscrizione ad una API ed il relativo rilascio di chiavi di produzione possono essere sottoposte ad un processo di approvazione. Questo processo viene implementando attraverso la configurazione (da eseguire dopo l'installazione di WSO2) dei *workflow* descritti nella documentazione WSO2 [Managing Workflow Extension](https://docs.wso2.com/display/AM260/Managing+Workflow+Extensions). In particolare:

- [API Subscription Workflow](https://docs.wso2.com/display/AM260/Adding+an+API+Subscription+Workflow#UsingBPS)
- [Adding an Application Registration Workflow](https://docs.wso2.com/display/AM260/Adding+an+Application+Registration+Workflow)

E' stata inoltre implementata una libreria custom che a fronte di una richiesta di sottoscrizione ad una API e una richiesta di generazione delle chiavi, invia una email di notifica ad un indirizzo preimpostato. La libreria si chiama `it.umbriadigitale.workflow.jar`, si trova in `environments/production/modules/apim/files/repository/components/lib` e viene installata da puppet.  
A differenza di quanto descritto nella documentazione ufficiale di WSO2 la configurazione dei workflow nel file di registro */_system/governance/apimgt/applicationdata/workflow-extensions.xml* deve essere effettuata come indicato di seguito:
```
<WorkFlowExtensions>
...
	<ProductionApplicationRegistration executor="it.umbriadigitale.ApplicationRegistrationWorkflowExecutor">
		<Property name="serviceEndpoint">http://wso2ei-bps.tuodominio.it:9770/services/ApplicationRegistrationWorkFlowProcess/</Property>
		<Property name="username">admin</Property>
		<Property name="password">changethispassword</Property>
		<Property name="callbackURL">https://api-pubstore.tuodominio.it:8243/services/WorkflowCallbackService</Property>

		<Property name="emailTo">amministratore@tuodominio.it</Property>
		<Property name="emailAddressFrom">amministratore@tuodominio.it</Property>
		<Property name="emailPasswordFrom">changethispassword</Property>
		<Property name="smtpAdress">smtp.tuodominio.it</Property>
		<Property name="smtpPort">587</Property>
		<Property name="linkAdminPortal">https://apiadmin.tuodominio.it:9443</Property>
		<Property name="enviroment">PRODUZIONE</Property>
	</ProductionApplicationRegistration>

...

	<SubscriptionCreation executor="it.umbriadigitale.SubscriptionCreationWorkflowExecutor">
		<Property name="serviceEndpoint">http://wso2ei-bps.tuodominio.it:9770/services/SubscriptionApprovalWorkFlowProcess/</Property>
		<Property name="username">admin</Property>
		<Property name="password">changethispassword</Property>
		<Property name="callbackURL">https://api-pubstore.tuodominio.it:8243/services/WorkflowCallbackService</Property>

		<Property name="emailTo">amministratore@tuodominio.it</Property>
		<Property name="emailAddressFrom">amministratore@tuodominio.it</Property>
		<Property name="emailPasswordFrom">changethispassword</Property>
		<Property name="smtpAdress">smtp.tuodominio.it</Property>
		<Property name="smtpPort">587</Property>
		<Property name="linkAdminPortal">https://apiadmin.tuodominio.it:9443</Property>
		<Property name="enviroment">PRODUZIONE</Property>
	</SubscriptionCreation>
...
</WorkFlowExtensions>
```

> **Nota**: Per utilizzare i workflow sopra citati è necessario installare WSO2 BP (componente di WSO2 EI). L'installazione di WSO2 BP non è inclusa nella guida, ma può essere facilmente eseguita seguendo la documentazione ufficiale di WSO2.

## Fault sequence custom per adattarle alle Linee Guida Modello di Interoperabilità
In coerenza a quanto riportato nel paragrafo [2.4.3. Uniformità e Naming](https://docs.italia.it/italia/piano-triennale-ict/lg-modellointeroperabilita-docs/it/bozza/doc/doc_02_cap_04.html#uniformita-e-naming) delle Linee Guida Modello di Interoperabilità del Team Digitale, in particolare seguendo lo schema [RFC 7807 - Problem Details for HTTP APIs - IETF Tools](https://tools.ietf.org/html/rfc7807), sono state modificate le seguenti fault sequence:
- *fault.xml*	(This is the primary fault sequence that gets invoked when an error occurs during the execution of an API resources)
- *_auth_failure_handler.xml*	(This sequence is called when an API authentication error is encountered)
- *_throttle_out_handler.xml*	(This sequence is called when a given request to an API gets throttled out)

Le sequence si trovano sotto la cartella `puppetlabs/code/environments/production/modules/apim/templates/carbon-home/repository/deployment/server/synapse-configs/default/sequences`.

Di seguito un esempio di risposta a seguito di una invocazione di una API senza Access Token:
```
{
	"detail": "Required OAuth credentials not provided. Make sure your API invocation call has a header: Authorization: Bearer ACCESS_TOKEN",
	"instance": "urn:uuid:cb196a12-5763-4a66-9423-ee39357d8c3b",
	"status": 401,
	"title": "Missing Credentials",
	"type": "https://apistore.tuodominio.it/apierrorcode/errors.html#900902"
}
```
La pagina https://apistore.tuodominio.it/apierrorcode/errors.html#900902, presente nella cartella `puppetlabs/code/environments/production/modules/apim/files/repository/deployment/server/webapps/apierrorcode`, contiene il dettaglio dell'errore.

Per maggiori informazioni sulla personalizzazione delle sequence consultare la sezione [Error Handling](https://docs.wso2.com/display/AM260/Error+Handling) della documentazione di WSO2.

## Error page custom
Sotto la cartella `puppetlabs/code/environments/production/modules/apim/files/repository/deployment/server/jaggeryapps/store/site/pages` si trovano le pagine di errore personalizzate:
- 401.html
- 403.html
- 404.html
- 500.html
- error-page.html
E' possibile modificarle applicando loghi e descrizioni personalizzate.

# Servizi Linux
Al termine dell'installazione, viene creato un servzio con cui avviare/fermare WSO2 API Manager (GW,TM,STTM):

```bash
service wso2am start|stop|restart
```