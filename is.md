# Come installare WSO2 IS
L'utilizzo di puppet per l'installazione di WSO2 IS permette di automatizzare:
- la creazione di un utente e un gruppo linux sul server
- l'installazione di WSO2 IS 5.7.0
- la configurazione di WSO2 IS 5.7.0 in coerenza all'architettura riportata [in questa pagina](./README.md)
- la configurazione del servizio linux per l'avvio automatico di WSO2 IS 5.7.0

I file puppet utilizzati per questa installazione derivano dai file puppet di WSO2. I file originali sono stati modificati ed adattati a partire da quelli del repository [WSO2-puppet-is](https://github.com/wso2/puppet-is).
Il repository contiene i file di installazione di WSO2 IS 5.7.0. I file specifici di IS si trovano nella directory `puppetlabs/code/environments/production/modules/is`.
WSO2 IS in questa architettura è utilizzato per autenticare gli utenti che accedono all'API Store. WSO2 IS è utilizzato come gateway verso il sistema di gestione dell'identità della Regione Umbria. WSO2 IS utilizza SPID per l'autenticazione degli utenti.

> **Nota**: Nella guida si assume che venga utilizzato il database PostgreSQL. E' tuttavia possibile cambiare il database. In questo caso deve essere utilizzato un altro driver che deve essere sostituito a quello di PostgreSQL nella directory `puppetlabs/code/environments/production/modules/is/files/repository/components/lib`

I file puppet permettono di installare due nodi di WSO2 IS in bilanciamento di carico.

## Installazione
1. Installare [Amazon Corretto](https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/downloads-list.html) come JDK nei server dove verranno installate le istanze di WSO2. E' possibile utilizzare altre distribuzioni di JDK. A questo link la [lista delle distribuzioni supportate](https://docs.wso2.com/display/compatibility/Tested+Operating+Systems+and+JDKs)
2. Scaricare il pacchetto di installazione di WSO2 IS 5.7.0 (nel caso di sistemi Ubuntu utilizzare il file .deb) e copiarlo nella directory `puppetlabs/code/environments/production/modules/is/files/` del **Puppet master**
3. Modificare i [parametri di configurazione](#Parametri-di-configurazione)
4. Per iniziare l'installazione dell'istanza, eseguire in ogni server il **Puppet agent** così come segue:
    ```bash
    export FACTER_profile=is
	export FACTER_nodename=node1
	export FACTER_environment=production
    puppet agent -vt
    ```
	Per il nodo 2 sostituire in `FACTER_nodename=node1` con `FACTER_nodename=node2`

# Parametri di configurazione
Prima di eseguire puppet per l'installazione di WSO2 nei vari server, è necessario modificare i file di configurazione come di seguito indicato.

## Configurazione globali per WSO2 IS (site.pp)
Per modificare i parametri di configurazione globali dell'Identity Server è necessario modificare il file `site.pp` che si trova nella directory `puppetlabs/code/environments/production/manifests`.
In particolare in questo file sono presenti solo due parametri che hanno effetto sulla configurazione di IS:

- `$admin_username`
- `$admin_password`

> **Nota**: I due parametri sopra riportati sono condivisi con gli altri componenti dell'architettura

## Configurazione specifiche per IS
Una volta configurati parametri globali, è necessario intervenire sui parametri di configurazione dell'Identity server. Il file sui cui intervenire è `params.pp` che si trova in `puppetlabs/code/environments/production/modules/is/manifests`. 
I parametri su cui intervenire riguardano:

- Connessioni JDBC verso i database
- URL
- Porte

Per quanto riguarda le URL deve essere sostituita la stringa `tuodomionio` con il dominio reale.  
Per quanto riguarda le porte, sono state lasciate quelle di default che possono essere modificate in base alle proprie esigenze. 

# Personalizzazioni e componenti aggiuntivi
I file puppet installano anche i seguenti componenti aggiuntivi:

- Script di compressione dei log di IS

## Script di compressione dei log
Lo script di compressione dei log si chiama `log-compress.sh` e si trova in `puppetlabs/code/environments/production/modules/is/files/system/usr/wso2`. 

# Servizi Linux
Al termine dell'installazione, viene creato un servzio con cui avviare/fermare WSO2 IS:

```bash
service wso2is start|stop|restart
```
