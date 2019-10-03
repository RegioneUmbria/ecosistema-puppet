#----------------------------------------------------------------------------
# DA COMPILARE
#----------------------------------------------------------------------------

# Run stages
stage { 'custom': }
stage { 'final': }

# Order stages
Stage['main'] -> Stage['custom'] -> Stage['final']

node default {
  
  # parametri comuni per tutte le istanze/moduli
  # ------------ Admin password
  $admin_username = 'admin'
  $admin_password = 'changethispassword'

if ($::nodename == "extgw01") or ($::nodename == "extgw02") or ($::nodename == "intgw01") or ($::nodename == "intgw02") or ($::nodename == "km01") or ($::nodename == "km02") or ($::nodename == "sttm01") or ($::nodename == "sttm02") {

  #Array dei file che verranno inclusi nelle cartelle di installazione di WSO2. NON modificare. Puo' essere personalizzato all'interno del file params.pp
  $file_list = [
    
  ]
  
  #Questi file verranno copiati sotto la cartella di installazione di WSO2 e sono comuni a tutte le istanze/moduli
  $common_file_list = [
    'repository/resources/security/',
    'repository/components/lib/',
  ]
  
  #Questi file verranno rimossi dalla cartella di installazione di WSO2 e sono comuni a tutte le istanze/moduli
  $remove_file_list = [
    'repository/deployment/server/webapps/am#sample#calculator#v1.war',
    'repository/deployment/server/webapps/am#sample#pizzashack#v1.war',
  ]
  
  # ------ General
  $user = 'wso2'
  $user_id = 1004
  $user_group = 'wso2'
  $user_home = '/home/$user'
  $user_group_id = 502
  $product = 'wso2am'
  $product_version = '2.6.0'
  $service_name = 'wso2am'
  $jdk_version = 'jdk1.8.0_192'
  $start_script_template = 'bin/wso2server.sh'
  $ports_offset = 0
  
  # ----------- JKS
  #attenzione nel cambiare il path poiche' in alcuni template di WSO2 il path e' cablato manualmente e non viene utilizzato questo parametro
  $key_store = '${carbon.home}/repository/resources/security/wso2carbon.jks'
  $key_store_type = 'JKS'
  $key_store_password = 'changethispassword'
  $key_store_key_alias = 'wso2carbon'
  $key_store_key_password = 'changethispassword'

  #attenzione nel cambiare il path poiche' in alcuni template di WSO2 il path e' cablato manualmente e non viene utilizzato questo parametro
  $internal_key_store = '${carbon.home}/repository/resources/security/wso2carbon.jks'
  $internal_key_store_type = 'JKS'
  $internal_key_store_password = 'changethispassword'
  $internal_key_store_key_alias = 'wso2carbon'
  $internal_key_store_key_password = 'changethispassword'

  #attenzione nel cambiare il path poiche' in alcuni template di WSO2 il path e' cablato manualmente e non viene utilizzato questo parametro
  $trust_store = '${carbon.home}/repository/resources/security/client-truststore.jks'
  $trust_store_type = 'JKS'
  $trust_store_password = 'changethispassword'

  # ----------- Hostmapping
  $apim_store_publisher_traffic_manager_name = 'wso2am-sttm-node1.tuodominio.it'
  $apim_store_publisher_traffic_worker_name = 'wso2am-sttm-node2.tuodominio.it'
  $jndi_node_port = '5672'
  
  # ----------- Server mapping
  $apim_apistore_host = 'apistore.tuodominio.it'
  $apim_keymanager_host = 'api-km.tuodominio.it'
  $apim_keymanager_port = '9443'
  
  $apim_gateway_lan_api_endpoint_host = 'wso2am-intgw-node1.tuodominio.it'
  $apim_gateway_lan_secure_api_token_revoke_endpoint_port = '8243'

  $apim_traffic_manager_host = 'api-tm.tuodominio.it'
  $apim_traffic_manager_port = '9443'
  $apim_traffic_manager_auth_url_port = '9711'
  $apim_traffic_manager_receiver_url_port = '9611'
  $apim_traffic_manager_jms_url_port = '5672'
  $apim_traffic_manager_username = '${admin.username}'
  $apim_traffic_manager_password = '${admin.password}'
 
  $apim_store_host = 'api-pubstore.tuodominio.it'
  $apim_store_port = '9443'

  $apim_publisher_host = 'api-pubstore.tuodominio.it'
  $apim_publisher_port = '9443'

  # ----------- Datasources 
  $datasource_carbon_url = 'jdbc:h2:repository/database/WSO2CARBON_DB;DB_CLOSE_ON_EXIT=FALSE'
  $datasource_carbon_username = 'wso2carbon'
  $datasource_carbon_password = 'wso2carbon'
  $datasource_carbon_driver = 'org.h2.Driver'
  $datasource_carbon_max_active = '80'
  $datasource_carbon_max_wait = '60000'
  $datasource_carbon_test_on_borrow = 'true'
  $datasource_carbon_validation_query = 'SELECT 1'
  $datasource_carbon_validation_interval = '30000'
  $datasource_carbon_default_auto_commit = 'false'
  
  $datasource_common_postgres_username = 'wso2am'
  $datasource_common_postgres_password = 'changethispassword'
  $datasource_common_postgres_default_auto_commit = 'false'
  $datasource_common_max_active = '80'
  $datasource_common_max_wait = '60000'
  $datasource_common_postgres_test_on_borrow = 'true'
  $datasource_common_validation_query = 'SELECT 1; COMMIT'
  $datasource_common_validation_interval = '30000'
  
  #Usato da tutte le istanze tranne che dai Traffic Manager e dai Gateway
  #In questo caso, poiche' il Traffic Manager e' la stessa istanza dello Store, viene utilizzato da tutte le istanze tranne che dai Gateway
  $datasource_am_db_name = 'WSO2_AM_DB'
  $datasource_am_db_jndi = 'jdbc/WSO2AM_DB'
  $datasource_am_db_driver = 'org.postgresql.Driver'
  $datasource_am_db_url = 'jdbc:postgresql://wso2am-database.tuodominio.it:5432/api26_mgtdb'
  $datasource_am_db_username = "${datasource_common_postgres_username}"
  $datasource_am_db_password = "${datasource_common_postgres_password}"

  #Usato da tutte le istanze tranne che dai Traffic Manager
  #In questo caso, poiche' il Traffic Manager e' la stessa istanza dello Store, viene utilizzato da tutte le istanze
  $datasource_user_db_name = 'WSO2_USER_DB'
  $datasource_user_db_jndi = 'jdbc/WSO2_USER_DB'
  $datasource_user_db_driver = 'org.postgresql.Driver'
  $datasource_user_db_url = 'jdbc:postgresql://wso2am-database.tuodominio.it:5432/api26_userdb'
  $datasource_user_db_username = "${datasource_common_postgres_username}"
  $datasource_user_db_password = "${datasource_common_postgres_password}"
  $datasource_user_db_default_auto_commit = 'true'
  $datasource_user_db_validation_query = "${datasource_common_validation_query}"

  #Usato da tutte le istanze tranne che dai Traffic Manager
  #In questo caso, poiche' il Traffic Manager e' la stessa istanza dello Store, viene utilizzato da tutte le istanze
  $datasource_config_db_name = 'WSO2_CONFIG_DB'
  $datasource_config_db_jndi = 'jdbc/WSO2_CONFIG_DB'
  $datasource_config_db_driver = 'org.postgresql.Driver'
  $datasource_config_db_url = 'jdbc:postgresql://wso2am-database.tuodominio.it:5432/api26_configdb'
  $datasource_config_db_username = "${datasource_common_postgres_username}"
  $datasource_config_db_password = "${datasource_common_postgres_password}"
  $datasource_config_db_validation_query = "${datasource_common_validation_query}"
  
  #Usato da tutte le istanze tranne che dai Traffic Manager
  #In questo caso, poiche' il Traffic Manager e' la stessa istanza dello Store, viene utilizzato da tutte le istanze
  $datasource_gov_db_name = 'WSO2_GOV_DB'
  $datasource_gov_db_jndi = 'jdbc/WSO2_GOV_DB'
  $datasource_gov_db_driver = 'org.postgresql.Driver'
  $datasource_gov_db_url = 'jdbc:postgresql://wso2am-database.tuodominio.it:5432/api26_govregdb'
  $datasource_gov_db_username = "${datasource_common_postgres_username}"
  $datasource_gov_db_password = "${datasource_common_postgres_password}"
  $datasource_gov_db_validation_query = "${datasource_common_validation_query}"
  
  #Nessuna istanza lo utilizza, ma serve ai Gateway per la prima connessione in fase di avvio, quindi va configurato
  $datasource_stat_db_name = 'WSO2AM_STATS_DB'
  $datasource_stat_db_jndi = 'jdbc/WSO2AM_STATS_DB'
  $datasource_stat_db_url = 'jdbc:h2:../tmpStatDB/WSO2AM_STATS_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000;AUTO_SERVER=TRUE'
  $datasource_stat_db_username = 'wso2carbon'
  $datasource_stat_db_password = 'wso2carbon'
  $datasource_stat_db_driver = 'org.h2.Driver'

  #Utilizzato solo dai Traffic Manager - consigliato laciarlo su H2
  $datasource_mb_db_name = 'WSO2_MB_STORE_DB'
  $datasource_mb_db_jndi = 'jdbc/WSO2_MB_STORE_DB'
  $datasource_mb_store_db_url = 'jdbc:h2:repository/database/WSO2MB_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000'
  $datasource_mb_store_db_username = 'wso2carbon'
  $datasource_mb_store_db_password = 'wso2carbon'
  $datasource_mb_store_db_driver = 'org.h2.Driver' 

  $local_reg_datasource_jndi = 'jdbc/WSO2CarbonDB'
  
  # ----------- Specific
  $enable_advance_throttling = 'true'
  $enable_jwt_generation = 'true'
  $enable_thrift_server = 'true'
  $enable_block_condition = 'true'
  $thrift_server_host = 'localhost'
  $key_validator_client_type = 'ThriftClient'
  $enable_data_publisher = 'true'
  $enable_websocket = 'true'

  #is_traffic_manager - Lasciare a false. Verra' poi settato a true nel caso di un Traffic Manager
  $is_traffic_manager = 'false'
  #is_gateway - Lasciare a false. Verra' poi settato a true nel caso di un Gateway
  $is_gateway = 'false'
 
  #SEZ. A - I seguenti parametri non vanno modificati. Verranno poi sovrascritti solo per le istanze STTM (Store + Traffic Manager) -----
  $auth_manager_url = 'https://localhost:${mgt.transport.https.port}${carbon.context}services/'
  $auth_manager_username = '${admin.username}'
  $auth_manager_password = '${admin.password}'
  $auth_manager_check_permission_remotely = 'false'
  
  $api_gateway_ext_name = 'GW INT'
  $api_gateway_ext_description = ''
  $api_gateway_ext_url = 'https://localhost:${mgt.transport.https.port}${carbon.context}services/'
  $api_gateway_ext_username = '${admin.username}'
  $api_gateway_ext_password = '${admin.password}'
  $api_gateway_ext_endpoint = 'http://${carbon.local.ip}:${http.nio.port},https://${carbon.local.ip}:${https.nio.port}'
  $api_gateway_ext_ws_endpoint = 'ws://${carbon.local.ip}:9099'
  
  $api_gateway_int_name = 'GW EXT'
  $api_gateway_int_description = ''
  $api_gateway_int_url = 'https://localhost:${mgt.transport.https.port}${carbon.context}services/'
  $api_gateway_int_username = '${admin.username}'
  $api_gateway_int_password = '${admin.password}'
  $api_gateway_int_endpoint = 'http://${carbon.local.ip}:${http.nio.port},https://${carbon.local.ip}:${https.nio.port}'
  $api_gateway_int_ws_endpoint = 'ws://${carbon.local.ip}:9099'
  
  $api_revoke_url = 'https://localhost:${https.nio.port}/revoke'
  #FINE SEZ. A
  
  #SEZ. B - I seguenti parametri non vanno modificati. Verranno poi sovrascritti solo per le istanze STTM (Store + Traffic Manager) e Gateway -----
  $api_key_url = 'https://localhost:${mgt.transport.https.port}${carbon.context}services/'
  $api_key_username = '${admin.username}'
  $api_key_password = '${admin.password}'
  
  $api_policy_service_url = 'https://localhost:${mgt.transport.https.port}${carbon.context}services/'
  $policy_deployer_enabled = 'true'
  #FINE SEZ. B
  
  #SEZ. C - I seguenti parametri non vanno modificati. Verranno poi sovrascritti solo per le istanze Gateway -----
  $api_traffic_manager_receiver_url_group = 'tcp://${carbon.local.ip}:${receiver.url.port}'
  $api_traffic_manager_auth_url_group = 'ssl://${carbon.local.ip}:${auth.url.port}'
  #FINE SEZ. C
  
  $api_store_url = "https://${apim_store_host}:${apim_store_port}/store"
  $api_store_username = '${admin.username}'
  $api_store_password = '${admin.password}'
  
  $api_publisher_url = "https://${apim_publisher_host}:${apim_publisher_port}/publisher"
  
  
  # ----- Configurazione DBCONFIG in Registry.xml ----
  $registry_mount_readonly = 'false'
  $registry_mount_root = '/'
  $registry_mount_cache = 'true'
  $registry_mount_path = '/_system/config'
  $registry_mount_target_path = '/_system/config'
  
  # ----- Configurazione DBGov in Registry.xml ----
  $registry_gov_mount_readonly = 'false'
  $registry_gov_mount_root = '/'
  $registry_gov_mount_cache = 'true'
  $registry_gov_mount_path = '/_system/governance'
  $registry_gov_mount_target_path = '/_system/governance'
  
  # ------------- Clustering -----------
  $clustering_enabled = 'true'
  $clustering_local_member_host = '4000'
  $clustering_membership_scheme = 'wka'
  
  $wka_member_port_1 = '4000'
  $wka_member_port_2 = '4000'
  
  #  Analytics - di default disabilitato. Verra' abilitato sulle configurazioni dei Gateway e dei STTM (Store + Traffic Manager)
  $analytics_enable = 'false'
  $stream_processor_url = '{tcp://localhost:7612}'
  $stream_processor_username = '${admin.username}'
  $stream_processor_password = '${admin.password}'
  $stream_processor_restapi_url = 'https://localhost:7444'
  $stream_processor_restapi_username = '${admin.username}'
  $stream_processor_restapi_password = '${admin.password}'
 
  # Lastaccesstime (registry)
  $lastaccess='lastaccesstime'
  
}
  
  class { "::${::profile}": }
  class { "::${::profile}::custom":
    stage => 'custom'
  }
  class { "::${::profile}::startserver":
    stage => 'final'
  }
}