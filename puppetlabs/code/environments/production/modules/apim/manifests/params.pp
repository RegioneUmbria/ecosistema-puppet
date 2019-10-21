# ----------------------------------------------------------------------------
#  Copyright (c) 2018 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------

# Claas apim::params
# This class includes all the necessary parameters.
class apim::params {
  
  # ###########################################################################################
  #                             GATEWAY GENERIC
  # ###########################################################################################
  
  if ($::nodename == "extgw01") or ($::nodename == "extgw02") or ($::nodename == "intgw01") or ($::nodename == "intgw02"){

    $service_description = 'WSO2 API Manager - Gateway'
  
    # Define the templates
    $template_list = [
      'repository/conf/api-manager.xml',
      'repository/conf/datasources/master-datasources.xml',
      'repository/conf/carbon.xml',
      'repository/conf/registry.xml',
      'repository/conf/user-mgt.xml',
      'repository/conf/axis2/axis2.xml',
      'repository/conf/identity/identity.xml',
      'repository/conf/tomcat/catalina-server.xml',
      'repository/conf/data-bridge/data-bridge-config.xml',
      'repository/conf/identity/EndpointConfig.properties',
      'repository/conf/log4j.properties',
      'repository/deployment/server/synapse-configs/default/api/_AuthorizeAPI_.xml',
      'repository/deployment/server/synapse-configs/default/api/_RevokeAPI_.xml',
      'repository/deployment/server/synapse-configs/default/api/_TokenAPI_.xml',
      'repository/deployment/server/synapse-configs/default/api/_UserInfoAPI_.xml',
      'repository/conf/consent-mgt-config.xml',
      'repository/conf/broker.xml',
      'repository/resources/security/sslprofiles.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_auth_failure_handler_.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_auth_failure_handler_custom.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_throttle_out_handler_.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_throttle_out_handler_custom.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/fault.xml',
    ]
	
    $remove_file_list = [
        'repository/deployment/server/jaggeryapps',
        'repository/deployment/server/webapps/am#sample#calculator#v1.war',
        'repository/deployment/server/webapps/am#sample#pizzashack#v1.war',
        'repository/deployment/server/webapps/api#am#admin#v0.14.war',
        'repository/deployment/server/webapps/api#am#publisher#v0.14.war',
        'repository/deployment/server/webapps/api#am#store#v0.14.war',
        'repository/deployment/server/webapps/authenticationendpoint.war',
        'repository/deployment/server/webapps/client-registration#v0.14.war',
        'repository/deployment/server/webapps/oauth2.war',
        'repository/deployment/server/webapps/throttle#data#v1.war',
        'repository/deployment/server/webapps/api#identity#consent-mgt#v1.0.war',
        'repository/components/lib/it.umbriadigitale.workflow.jar',
    ]

    # Master-datasources config params. STAT DB e MB STORE DB non vengono utilizzati dai gateway, però vanno mantenuti di default -----
  
    #  Altri param del gateway
    $enable_thrift_server = 'false'
    $thrift_server_host = 'localhost'
    $key_validator_client_type = 'WSClient'
  
    $api_key_url = "https://${apim_keymanager_host}:${apim_keymanager_port}/services/"
    $api_traffic_manager_receiver_url_group = "{tcp://${apim_store_publisher_traffic_manager_name}:${apim_traffic_manager_receiver_url_port}, tcp://${apim_store_publisher_traffic_worker_name}:${apim_traffic_manager_receiver_url_port}}"
    $api_traffic_manager_auth_url_group = "{ssl://${apim_store_publisher_traffic_manager_name}:${apim_traffic_manager_auth_url_port}, ssl://${apim_store_publisher_traffic_worker_name}:${apim_traffic_manager_auth_url_port}}"
    $api_policy_service_url = "https://${apim_traffic_manager_host}:${apim_traffic_manager_port}/services/"
    
    $policy_deployer_enabled = 'false'
  
    #  Analytics
    $analytics_enable = 'true'
    $stream_processor_url = '{tcp://api-an.tuodominio.it:7612}'
    $stream_processor_username = '${admin.username}'
    $stream_processor_password = '${admin.password}'
    $stream_processor_restapi_url = 'https://FQDN_analytics_host:analytics_port'
    $stream_processor_restapi_username = '${admin.username}'
    $stream_processor_restapi_password = '${admin.password}'
    
    $is_gateway = 'true'
  }

  if $::nodename == "extgw01" {
    # -------------------------------------------------------------------------------------------
    #                             EXT GW 1
    # -------------------------------------------------------------------------------------------
    $hostname = 'api-extgw.tuodominio.it'
    $mgt_hostname = 'wso2am-extgw-node1.tuodominio.it'
	
    $service_profile = ''
	
    $clustering_sub_domain = 'mgt'
    $clustering_domain = 'api-extgw.tuodominio.it.domain'
    $wka_member_host_1 = 'wso2am-extgw-node1.tuodominio.it'
    $wka_member_host_2 = 'wso2am-extgw-node2.tuodominio.it'
	
  } elsif $::nodename == "extgw02" {
    # -------------------------------------------------------------------------------------------
    #                             EXT GW 2
    # -------------------------------------------------------------------------------------------
    $hostname = 'api-extgw.tuodominio.it'
    $mgt_hostname = 'wso2am-extgw-node2.tuodominio.it'
	
    $service_profile = '--optimize -Dprofile=gateway-worker -DworkerNode=true'
	
    $clustering_sub_domain = 'worker'
    $clustering_domain = 'api-extgw.tuodominio.it.domain'
    $wka_member_host_1 = 'wso2am-extgw-node1.tuodominio.it'
    $wka_member_host_2 = 'wso2am-extgw-node2.tuodominio.it'
	
  } elsif $::nodename == "intgw01" {
    # -------------------------------------------------------------------------------------------
    #                             INT GW 1
    # -------------------------------------------------------------------------------------------
    $hostname = 'api-intgw.tuodominio.it'
    $mgt_hostname = 'wso2am-intgw-node1.tuodominio.it'
	
    $service_profile = ''
	
    $clustering_sub_domain = 'mgt'
    $clustering_domain = 'api-intgw.tuodominio.it.domain'
    $wka_member_host_1 = 'wso2am-intgw-node1.tuodominio.it'
    $wka_member_host_2 = 'wso2am-intgw-node2.tuodominio.it'
    
  } elsif $::nodename == "intgw02" {
    # -------------------------------------------------------------------------------------------
    #                             INT GW 2
    # -------------------------------------------------------------------------------------------
    $hostname = 'api-intgw.tuodominio.it'
    $mgt_hostname = 'wso2am-intgw-node2.tuodominio.it'
	
    $service_profile = '--optimize -Dprofile=gateway-worker -DworkerNode=true'
	
    $clustering_sub_domain = 'worker'
    $clustering_domain = 'api-intgw.tuodominio.it.domain'
    $wka_member_host_1 = 'wso2am-intgw-node1.tuodominio.it'
    $wka_member_host_2 = 'wso2am-intgw-node2.tuodominio.it'
	
  }
  
  

  # ###########################################################################################
  #                             KEY MANAGER GENERIC
  # ###########################################################################################
  if ($::nodename == "km01") or ($::nodename == "km02"){
  
    $enable_websocket = 'false'
    
    $service_profile = '--optimize -Dprofile=api-key-manager'
    $service_description = 'WSO2 API Manager - Key manager'
  
    # Define the templates
    $template_list = [
        'repository/conf/api-manager.xml',
        'repository/conf/datasources/master-datasources.xml',
        'repository/conf/carbon.xml',
        'repository/conf/registry.xml',
        'repository/conf/user-mgt.xml',
        'repository/conf/axis2/axis2.xml',
        'repository/conf/identity/identity.xml',
        'repository/conf/tomcat/catalina-server.xml',
        'repository/conf/log4j.properties',
        'repository/conf/data-bridge/data-bridge-config.xml',
        'repository/conf/identity/EndpointConfig.properties',
        'repository/conf/consent-mgt-config.xml',
        'repository/conf/broker.xml',
        'repository/resources/security/sslprofiles.xml',
		'repository/deployment/server/synapse-configs/default/sequences/_auth_failure_handler_.xml',
		'repository/deployment/server/synapse-configs/default/sequences/_auth_failure_handler_custom.xml',
		'repository/deployment/server/synapse-configs/default/sequences/_throttle_out_handler_.xml',
		'repository/deployment/server/synapse-configs/default/sequences/_throttle_out_handler_custom.xml',
		'repository/deployment/server/synapse-configs/default/sequences/fault.xml',
    ]
    $remove_file_list = [
        'repository/deployment/server/jaggeryapps',
        'repository/deployment/server/webapps/am#sample#calculator#v1.war',
        'repository/deployment/server/webapps/am#sample#pizzashack#v1.war',
        'repository/deployment/server/webapps/api#am#admin#v0.14.war',
        'repository/deployment/server/webapps/api#am#publisher#v0.14.war',
        'repository/deployment/server/webapps/api#am#store#v0.14.war',
        'repository/components/lib/it.umbriadigitale.workflow.jar',
	]
	
    $enable_data_publisher = 'false'
    $key_validator_client_type = 'WSClient'
    $is_key_manager = 'true'
    $policy_deployer_enabled = 'false'
  }
 
  if $::nodename == "km01" {
    # -------------------------------------------------------------------------------------------
    #                             KM 1
    # -------------------------------------------------------------------------------------------
    $hostname = 'api-km.tuodominio.it'
    $mgt_hostname = 'wso2am-km-node1.tuodominio.it'
	
    $clustering_sub_domain = 'mgt'
    $clustering_domain = 'api-km.tuodominio.it.domain'
    $wka_member_host_1 = 'wso2am-km-node1.tuodominio.it'
    $wka_member_host_2 = 'wso2am-km-node2.tuodominio.it'
	
  } elsif $::nodename == "km02" {
    # -------------------------------------------------------------------------------------------
    #                             KM 2
    # -------------------------------------------------------------------------------------------
    $hostname = 'api-km.tuodominio.it'
    $mgt_hostname = 'wso2am-km-node2.tuodominio.it'
	
    $clustering_sub_domain = 'worker'
    $clustering_domain = 'api-km.tuodominio.it.domain'
    $wka_member_host_1 = 'wso2am-km-node1.tuodominio.it'
    $wka_member_host_2 = 'wso2am-km-node2.tuodominio.it'
	
  } 
  
  
  # ###########################################################################################
  #                             STORE PUBLISHER TRAFFIC MANAGER GENERIC
  # ###########################################################################################
  if ($::nodename == "sttm01") or ($::nodename == "sttm02") {
    
    $service_description = 'WSO2 API Manager - Default profile'
    $service_profile = ''
  
    #Questi file verranno copiati sotto la cartella di installazione di wso2
    $file_list = [
      'repository/deployment/server/jaggeryapps/store/',
      'repository/deployment/server/webapps/home/',
    ]
	 
    $datasource_mb_db_name = 'WSO2_MB_STORE_DB'
    $datasource_mb_db_jndi = 'jdbc/WSO2_MB_STORE_DB'
    $datasource_mb_store_db_username = "${datasource_common_postgres_username}"
    $datasource_mb_store_db_password = "${datasource_common_postgres_password}"
    $datasource_mb_store_db_driver = 'org.postgresql.Driver'

    $auth_manager_url = "https://${apim_keymanager_host}:${apim_keymanager_port}/services/"
    $auth_manager_username = '${admin.username}'
    $auth_manager_password = '${admin.password}'
    $auth_manager_check_permission_remotely = 'false'
	
    $api_gateway_ext_name = 'Gateway Esterno (pubblico)'
    $api_gateway_ext_description = 'Le API pubblicate su questo gateway verranno esposte su Internet'
    $api_gateway_ext_url = 'https://wso2am-extgw-node1.tuodominio.it:9443/services/'
    $api_gateway_ext_username = '${admin.username}'
    $api_gateway_ext_password = '${admin.password}'
    $api_gateway_ext_endpoint = 'http://api.tuodominio.it:80,https://api.tuodominio.it:443'
    $api_gateway_ext_ws_endpoint = 'ws://api.tuodominio.it:9099'
  
    $api_gateway_int_name = 'Gateway interno (privato)'
    $api_gateway_int_description = 'Le API pubblicate su questo gateway saranno visibili solo dai server del DCRU'
    $api_gateway_int_url = 'https://wso2am-intgw-node1.tuodominio.it:9443/services/'
    $api_gateway_int_username = '${admin.username}'
    $api_gateway_int_password = '${admin.password}'
    $api_gateway_int_endpoint = 'http://api-int.tuodominio.it:8280,https://api-int.regione.umbria.it:8243'
    $api_gateway_int_ws_endpoint = 'ws://api-int.tuodominio.it:9099'
	
    $api_revoke_url = "https://${apim_gateway_lan_api_endpoint_host}:${apim_gateway_lan_secure_api_token_revoke_endpoint_port}/revoke"
 
    #personalizzazioni site.json dello store
    $store_subtheme = 'udtheme'
    $store_tag_wise_mode = 'true'
	
    $store_sso_enabled = 'true'
    $store_sso_issuer = 'API_STORE'
    $store_sso_identity_provider_url = 'https://identity-apistore.tuodominio.it:443/samlsso'
    $store_sso_passive = 'true'
	
    $store_topics_per_page = '15'
    $store_replies_per_page = '15'
	
    $store_reverse_proxy_enabled = 'true'
    $store_reverse_proxy_host = "${apim_apistore_host}"
    $store_reverse_proxy_context = '/store'
	
    $bps_host = 'wso2ei-bps.tuodominio.it:9450'
    $admin_workflow_server_url = "https://${bps_host}/services/"
	
    $store_enabled_tutorial = 'false'
    
    $enable_thrift_server = 'false'
    $enable_block_condition = 'false'
    $enable_data_publisher = 'false'
    $is_traffic_manager = 'true'
	
	
    #  Analytics
    $analytics_enable = 'true'
    $stream_processor_url = '{tcp://api-an.tuodominio.it:7612}'
    $stream_processor_username = '${admin.username}'
    $stream_processor_password = '${admin.password}'
    $stream_processor_restapi_url = 'https://api-an.tuodominio.it:7444'
    $stream_processor_restapi_username = '${admin.username}'
    $stream_processor_restapi_password = '${admin.password}'

	$lastaccess='lastaccesstime_1'
  }
  
  if $::nodename == "sttm01" {
    # -------------------------------------------------------------------------------------------
    #                             STTM 1
    # -------------------------------------------------------------------------------------------
	
    #TODO ripassare tutti i template e verificare dove c'è l'if con store/publisher e traffic manager
    # Define the templates
    $template_list = [
      'repository/conf/api-manager.xml',
      'repository/conf/datasources/master-datasources.xml',
      'repository/conf/carbon.xml',
      'repository/conf/registry.xml',
      'repository/conf/user-mgt.xml',
      'repository/conf/axis2/axis2.xml',
      'repository/conf/identity/identity.xml',
      'repository/conf/tomcat/catalina-server.xml',
      'repository/conf/log4j.properties',
      'repository/conf/data-bridge/data-bridge-config.xml',
      'repository/conf/identity/EndpointConfig.properties', 
      'repository/conf/jndi.properties',
      'repository/deployment/server/eventreceivers/blockingEventReceiver.xml',
      'repository/deployment/server/eventstreams/org.wso2.blocking.condition.stream_1.0.0.json',
      'repository/deployment/server/eventpublishers/blockingEventJMSPublisher1.xml',
      'repository/deployment/server/eventpublishers/blockingEventJMSPublisher2.xml',
      'repository/conf/jndi1.properties',
      'repository/conf/jndi2.properties',
      'repository/deployment/server/jaggeryapps/store/site/conf/site.json',
      'repository/deployment/server/jaggeryapps/admin/site/conf/site.json',
      'repository/deployment/server/jaggeryapps/store/site/conf/interactiveTutorial.json',
      'repository/deployment/server/synapse-configs/default/proxy-services/WorkflowCallbackService.xml',
      'repository/conf/consent-mgt-config.xml',
      'repository/conf/broker.xml',
      'repository/resources/security/sslprofiles.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_auth_failure_handler_.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_auth_failure_handler_custom.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_throttle_out_handler_.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_throttle_out_handler_custom.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/fault.xml',
    ]

    $sttm_username = '${admin.username}'
    $sttm_password = '${admin.password}'
    
    $hostname = 'api-pubstore.tuodominio.it'
    $mgt_hostname = 'wso2am-sttm-node1.tuodominio.it'
	
    $clustering_sub_domain = 'mgt'
    $clustering_domain = 'api-pubstore.tuodominio.it.domain'
    $wka_member_host_1 = 'wso2am-sttm-node1.tuodominio.it'
    $wka_member_host_2 = 'wso2am-sttm-node2.tuodominio.it'
    
    $datasource_mb_store_db_url = 'jdbc:postgresql://wso2am-database.tuodominio.it:5432/api26_mbstoredb1'
	$connection_factory_node_name = 'wso2am-sttm-node2.tuodominio.it'

  } elsif $::nodename == "sttm02" {
    # -------------------------------------------------------------------------------------------
    #                             STTM 2
    # -------------------------------------------------------------------------------------------
    $template_list = [
      'repository/conf/api-manager.xml',
      'repository/conf/datasources/master-datasources.xml',
      'repository/conf/carbon.xml',
      'repository/conf/registry.xml',
      'repository/conf/user-mgt.xml',
      'repository/conf/axis2/axis2.xml',
      'repository/conf/identity/identity.xml',
      'repository/conf/tomcat/catalina-server.xml',
      'repository/conf/log4j.properties',
      'repository/conf/data-bridge/data-bridge-config.xml',
      'repository/conf/identity/EndpointConfig.properties', 
      'repository/conf/jndi.properties',
      'repository/deployment/server/eventreceivers/blockingEventReceiver.xml',
      'repository/deployment/server/eventstreams/org.wso2.blocking.condition.stream_1.0.0.json',
      'repository/deployment/server/eventpublishers/blockingEventJMSPublisher1.xml',
      'repository/deployment/server/eventpublishers/blockingEventJMSPublisher2.xml',
      'repository/conf/jndi1.properties',
      'repository/conf/jndi2.properties',
      'repository/deployment/server/jaggeryapps/store/site/conf/site.json',
      'repository/deployment/server/jaggeryapps/admin/site/conf/site.json',
      'repository/deployment/server/jaggeryapps/store/site/conf/interactiveTutorial.json',
      'repository/deployment/server/synapse-configs/default/proxy-services/WorkflowCallbackService.xml',
      'repository/conf/consent-mgt-config.xml',
      'repository/conf/broker.xml',
      'repository/resources/security/sslprofiles.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_auth_failure_handler_.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_auth_failure_handler_custom.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_throttle_out_handler_.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/_throttle_out_handler_custom.xml',
	  'repository/deployment/server/synapse-configs/default/sequences/fault.xml',
    ]

    $hostname = 'api-pubstore.tuodominio.it'
    $mgt_hostname = 'wso2am-sttm-node2.tuodominio.it'
	
    $clustering_sub_domain = 'worker'
    $clustering_domain = 'api-pubstore.tuodominio.it.domain'
    $wka_member_host_1 = 'wso2am-sttm-node1.tuodominio.it'
    $wka_member_host_2 = 'wso2am-sttm-node2.tuodominio.it'
	
    $datasource_mb_store_db_url = 'jdbc:postgresql://wso2am-database.tuodominio.it:5432/api26_mbstoredb2'
	$connection_factory_node_name = 'wso2am-sttm-node1.tuodominio.it'
  } 

}
