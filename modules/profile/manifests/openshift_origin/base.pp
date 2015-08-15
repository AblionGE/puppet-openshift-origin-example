# = Class profile::openshift_origin::base
# This is the base for an OO component
# It contains all useful information for the installation
#
# == Parameters
# [*broker_hostname*]
#   The hostname for the broker
# [*broker_ipaddress*]
#   The IP address for the broker
# [*msgserver_hostname*]
#   The hostname for the msgserver
# [*msgserver_ipaddress*]
#   The IP address for the msgserver
# [*node_hostname*]
#   The hostname for the node
# [*node_ipaddress*]
#   The IP address for the node
# [*datastore_hostname*]
#   The hostname for the datastore
# [*datastore_ipaddress*]
#   The IP address for the datastore
# [*nameserver_hostname*]
#   The hostname for the datastore
# [*nameserver_ipaddress*]
#   The IP address for the nameserver
#
class profile::openshift_origin::base (
    $broker_hostname=$::hostname,
    $broker_ipaddress=$::ipaddress,
    $msgserver_hostname=$::hostname,
    $msgserver_ipaddress=$::ipaddress,
    $node_hostname=$::hostname,
    $node_ipaddress=$::ipaddress,
    $datastore_hostname=$::hostname,
    $datastore_ipaddress=$::ipaddress,
    $nameserver_hostname=$::hostname,
    $nameserver_ipaddress=$::ipaddress
    ){

  require profile::selinux
  require yum::repo::epel
  require yum::repo::jenkins
  require yum::repo::openshift_server
  include profile::mount
  Class['Yum::Repo::Jenkins'] -> Class['Openshift_origin::Cartridges::Jenkins']
  Class['Yum::Repo::Epel'] -> Class['Openshift_origin::Client_tools']
  Class['Yum::Repo::Openshift_server'] -> Class['Openshift_origin::Client_tools']
  Class['Profile::Selinux'] -> Class['Openshift_origin']
  Class['Profile::Mount'] -> Class['Profile::Selinux']
 
  $domain = "apps.${::domain}"

  $config = {
    # Hostname values
    broker_hostname                 => "${broker_hostname}.${::domain}",
    nameserver_hostname             => "${nameserver_hostname}.${::domain}",
    msgserver_hostname              => "${msgserver_hostname}.${::domain}",
    datastore_hostname              => "${datastore_hostname}.${::domain}",
    node_hostname                   => "${node_hostname}.${::domain}",

    # IP address values
    broker_ip_addr                  => $broker_ipaddress,
    nameserver_ip_addr              => $nameserver_ipaddress,
    node_ip_addr                    => $node_ipaddress,
    conf_node_external_eth_dev      => 'eth0',

    # RPM Sources
    install_method                  => 'none',

    # OpenShift Config
    domain                          => $domain,
    conf_valid_gear_sizes           => 'small',
    conf_default_gear_capabilities  => 'small',
    conf_default_gear_size          => 'small',
    openshift_user1                 => 'demo',
    openshift_password1             => 'changeme',

    # Datastore Config
    mongodb_port                    => 27017,
    mongodb_replicasets             => false,
    mongodb_broker_user             => 'openshift',
    mongodb_broker_password         => 'changeme',
    mongodb_admin_user              => 'admin',
    mongodb_admin_password          => 'changeme',

    # MsgServer config
    msgserver_cluster               => false,
    mcollective_user                => 'mcollective',
    mcollective_password            => 'changeme',

    # DNS Config
    update_network_conf_files       => false,
    bind_key                        => 'yV9qIn/KuCqvnu7SNtRKU3oZQMMxF1ET/GjkXt5pf5JBcHSKY8tqRagiocCbUX56GOM/iuP//D0TteLc3f1N2g==',

    # NTP config
    configure_ntp                   => false,
  }
}
