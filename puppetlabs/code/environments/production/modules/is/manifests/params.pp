#----------------------------------------------------------------------------
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
#----------------------------------------------------------------------------

class is::params {

  $user = 'wso2'
  $user_id = 1003
  $user_group = 'wso2'
  $user_home = '/home/$user'
  $user_group_id = 1003
  $product = 'wso2is'
  $product_version = '5.7.0'
  $service_name = 'wso2is'
  $jdk_version = 'jdk1.8.0_192'
  
  $jvm_xms = '2560m'
  $jvm_xmx = '2560m'

  # Define the templates
  $start_script_template = 'bin/wso2server.sh'

  $template_list = [
    'repository/conf/carbon.xml',
    'repository/conf/user-mgt.xml',
    'repository/conf/registry.xml',
    'repository/conf/datasources/master-datasources.xml',
    'repository/conf/identity/EndpointConfig.properties',
    'repository/conf/identity/identity.xml',
    'repository/conf/identity/embedded-ldap.xml',
    'repository/conf/identity/sso-idp-config.xml',	
    'repository/conf/axis2/axis2.xml',
    'repository/deployment/server/jaggeryapps/dashboard/conf/site.json',
    'repository/conf/tomcat/catalina-server.xml',	
    'repository/conf/log4j.properties',	
  ]
  
  #Questi file verranno copiati sotto la cartella di installazione di wso2
  $file_list = [
    'repository/resources/security/',
    'repository/components/',
    'repository/deployment/',
  ]

  # carbon.xml configs
  $ports_offset = 0
  
  #se si cambia l'hostname va cambiato anche sul file /WEB-INF/web.xml di shindig.war e authenticationendpoint.war (/files/repository/deployment/server/webapps)
  $hostname = 'identity-apistore.tuodominio.it'
  
  #attenzione nel cambiare il path poiche' in alcuni template di WSO2 il path e' cablato manualmente e non viene utilizzato questo parametro
  $security_keystore_location = '${carbon.home}/repository/resources/security/wso2carbon.jks'
  $security_keystore_type = 'JKS'
  $security_keystore_password = 'changethispassword'
  $security_keystore_key_alias = 'wso2carbon'
  $security_keystore_key_password = 'changethispassword'

  #attenzione nel cambiare il path poiche' in alcuni template di WSO2 il path e' cablato manualmente e non viene utilizzato questo parametro
  $security_internal_keystore_location = '${carbon.home}/repository/resources/security/wso2carbon.jks'
  $security_internal_keystore_type = 'JKS'
  $security_internal_keystore_password = 'changethispassword'
  $security_internal_keystore_key_alias = 'wso2carbon'
  $security_internal_keystore_key_password = 'changethispassword'

  #attenzione nel cambiare il path poiche' in alcuni template di WSO2 il path e' cablato manualmente e non viene utilizzato questo parametro
  $security_trust_store_location = '${carbon.home}/repository/resources/security/client-truststore.jks'
  $security_trust_store_type = 'JKS'
  $security_trust_store_password = 'changethispassword' 
  
  # ------ Datasources 
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
  
  $datasource_common_postgres_default_auto_commit = 'false'
  $datasource_common_max_active = '80'
  $datasource_common_max_wait = '60000'
  $datasource_common_postgres_test_on_borrow = 'true'
  $datasource_common_validation_query = 'SELECT 1; COMMIT'
  $datasource_common_validation_interval = '30000'
  
  $datasource_identity_db_name = 'WSO2_IDENTITY_DB'
  $datasource_identity_db_jndi = 'jdbc/WSO2_IDENTITY_DB'
  $datasource_identity_db_driver = 'org.postgresql.Driver'
  $datasource_identity_db_url = 'jdbc:postgresql://wso2am-database.tuodominio.it:5432/is57_identitydb'
  $datasource_identity_db_username = 'wso2is'
  $datasource_identity_db_password = 'changethispassword'
  
  $datasource_identity_db_validation_query = "${datasource_common_validation_query}"
  
  $datasource_user_db_name = 'WSO2_USER_DB'
  $datasource_user_db_jndi = 'jdbc/WSO2_USER_DB'
  $datasource_user_db_driver = 'org.postgresql.Driver'
  $datasource_user_db_url = 'jdbc:postgresql://wso2am-database.tuodominio.it:5432/api26_userdb'
  $datasource_user_db_username = 'wso2am'
  $datasource_user_db_password = 'changethispassword'
  $datasource_user_db_default_auto_commit = 'true'
  $datasource_user_db_validation_query = "${datasource_common_validation_query}"
  
  $datasource_bps_db_name = 'BPS_DS'
  $datasource_bps_db_jndi = 'bpsds'
  
  $use_ldap_userstore = 'false'
  $use_jdbc_userstore = 'true'
  $use_proxyport = 'true'
  $enable_sso_consent_management = 'false'
  
  $registry_db_jndi = "${datasource_identity_db_jndi}"
  $registry_cache_id = "${datasource_identity_db_url}"
  
  $enable_hazelcast_clustering = 'true'
  $hazelcast_clustering_domain_name = "${hostname}.domain"
  $hazelcast_clustering_membership_scheme = 'wka'
  $hazelcast_clustering_host_name_node1 = 'wso2is-node1.tuodominio.it'
  $hazelcast_clustering_member_port_node1 = '4000'
  $hazelcast_clustering_host_name_node2 = 'wso2is-node2.tuodominio.it'
  $hazelcast_clustering_member_port_node2 = '4000'
  
  $assertion_consumer_service_url = "https://${hostname}/dashboard/acs"
  $default_assertion_consumer_service_url = "https://${hostname}/dashboard/acs"
  
  $dashboard_proxy_host = "${hostname}"
  $dashboard_proxy_https_port = '443'
  
  $portal_proxy_host = "${hostname}"
  $portal_proxy_https_port = '443'
  
  $use_axis_port_mapping = 'false'
  
  $force_local_cache = 'true'
  
  ################# CONFIGURAZIONI DIVERSE PER NODO ##################################
  
  if $::nodename == "node1" {
    
    $mgt_hostname = 'wso2is-node1.tuodominio.it'
    $enable_embedded_ldap = 'true'
    $registry_remote_instance_url = 'https://wso2is-node2.tuodominio.it:9443/registry'
	
  } 
  if $::nodename == "node2" {
    
    $mgt_hostname = 'wso2is-node2.tuodominio.it'
    $enable_embedded_ldap = 'false'
    $registry_remote_instance_url = 'https://wso2is-node1.tuodominio.it:9443/registry'
  }
}
