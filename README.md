# Cos'è l'Ecosistema Digitale della Regione Umbria?
L'Ecosistema digitale regionale è il sistema attraverso il quale la Regione Umbria espone le proprie API per favorire l'integrazione e lo scambio dei dati tra i sistemi. Per vedere le API attualmente disponibili vai allo [store](https://apistore.regione.umbria.it/store/) della Regione Umbria.

# Come utilizzare questo repository
Questo repository contiene i file di [Puppet](https://puppet.com/) per l'installazione in ambiente linux e la configurazione di:

- [WSO2 API Manager 2.6.0](https://docs.wso2.com/display/AM260/WSO2+API+Manager+Documentation)
- [WSO2 Identiy Server 5.7](https://docs.wso2.com/display/IS570/WSO2+Identity+Server+Documentation)
- [WSO2 Stream Processor 4.4.0](https://docs.wso2.com/display/SP440/Stream+Processor+Documentation) 

Per utilizzare questi file è necessario installare **Puppet agent** sui server in cui dovranno essere installati e configurati i diversi moduli WSO2 ed avere un server che funga da **Puppet master**.
Per maggiori informazioni su puppet fare riferimento alla [documentazione ufficiale](https://puppet.com/)  
Il repository contiene anche il file di configurazione di **HAProxy** da utilizzare come bilanciatore secondo il modello architetturale riportato di seguito.

# Struttura del repository
Il repository ha la seguente struttura:

- *puppetlabs/code/environments/production/modules/apim* Contiene tutti i file puppet per l'installazione di WSO2 API Manager
- *puppetlabs/code/environments/production/modules/is* Contiene tutti i file puppet per l'installazione di WSO2 Identity server
- *puppetlabs/code/environments/production/modules/sp* Contiene tutti i file puppet per l'installazione di WSO2 Stream processor (disponibile a breve)
- *haproxy/* Contiene il file di configurazione di HAProxy per implementare l'architettura riportata nella figura

## Architettura
I file puppet riportati nel repository permettono di installare WSO2 API Manager, WSO2 IS e WSO2 SP distribuiti su diversi server secondo l'architettura illustrata nella seguente immagine:

![Ecosistema Digitale Umbria - API](https://github.com/RegioneUmbria/Ecosistema-puppet/blob/master/images/archiettura.png)

> **Nota**: L'architettura riportata è scalabile apportando semplici modifiche alla configurazione di HAProxy e al cluster di ogni singolo componente.

### WSO2 API Manager
L'architettura per WSO2 APIM è composta da:

- 2 server per i Gateway esterni in bilanciamento di carico che ricevono le chiamate alle API dalla extranet (ext-gw)
- 2 server per i Gateway interni in bilanciamento di carico che ricevono le chiamate alle API dalla intranet (int-gw)
- 2 server per i Key Manager in bilanciamento di carico per la gestione delle chiavi (km)
- 2 server per i Traffic Manager in bilanciamento di carico per la gestione del traffico + API Store e Publisher (sttm)

### WSO2 IS (Identity server)
Gli Identity Server sono installati su due server in bilanciamento di carico. I due server vengono utilizzati per effettuare l'autenticazione tramite SPID all'API Store.

### WSO2 SP (Stream Processor)
Lo Stream Processor è utilizzato per due finalità:

- Gestire le analitiche dell'APIM
- Acquisire dati in tempo reale dagli altri sistemi tramite stream

# Sicurezza e Keystore
All'interno dei vari moduli puppet (apim, is, sp_worker) presenti in questo repository non sono stati inseriti due key store utilizzati da WSO2 per la gestione della sicurezza. I due keystore sono:

- wso2carbon.jks
- client-trust-store.jks

Questi due file jks devono essere inseriti in:

- `puppetlabs/code/environments/production/modules/apim/files/repository/resources/security` per WSO2 API Manager
- `puppetlabs/code/environments/production/modules/is/files/repository/resources/security` per WSO2 Identity Server
- `puppetlabs/code/environments/production/modules/sp_worker/files/resources/security` per WSO2 Stream Processor

> **Importante**: Per gli ambienti di produzione si consiglia di eseguire le [Security Guideline](https://docs.wso2.com/display/ADMIN44x/Security+Guidelines+for+Production+Deployment) di WSO2

# Installazione dei componenti
- [Guida installazione API Manager](./apim.md)
- [Guida installazione IS](./is.md)
- Guida installazione SP (disponibile a breve)

# Licenza
Il software è rilasciato secondo la licenza EUPL 1.2. Per maggiori informazioni fare riferimento al [testo della licenza](https://joinup.ec.europa.eu/sites/default/files/custom-page/attachment/eupl_v1.2_it.pdf)

# Contatti
Per maggiori informazioni, chiarimenti contattare il seguente indirizzo email [ecosistema@umbriadigitale.it](mailto:ecosistema@umbriadigitale.it)

