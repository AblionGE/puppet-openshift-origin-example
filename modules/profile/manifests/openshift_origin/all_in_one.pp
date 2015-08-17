# = Class: profile::openshift_origin::all_in_one
# This class manages an All-In-One installation of Openshift Origin on one machine.
# This module needs to have installed epel, jenkins, openshift-server and SELinux.
# As the "plug-and-play" installation of the module "Openshift_origin" use stages,
# it is needed to import jenkins and openshift-server like here to force their
# installation before starting the installation of the module.
#
# This installation of OO is simple and will only run in a simple VM.
# Refer to the external documentation (Confluence) to make this demo works.
#
#
# == Parameters
#
# None
#
class profile::openshift_origin::all_in_one {
  require profile::selinux
  require yum::repo::epel
  require yum::repo::jenkins
  require yum::repo::openshift_server
  include profile::mount
  Class['Yum::Repo::Jenkins'] -> Class['Openshift_origin::Cartridges::Jenkins']
  Class['Yum::Repo::Epel'] -> Class['Openshift_origin::Client_tools']
  Class['Yum::Repo::Openshift_server'] -> Class['Profile::Selinux']
  Class['Profile::Mount'] -> Class['Profile::Selinux']
  Class['Profile::Selinux'] -> Class['Openshift_origin']
 
  $domain = "apps.myopenshift.com"
  $oo_hostname = "broker.openshift.local"
  $oo_ipaddress = $::ipaddress_eth1

  class { 'profile::hostname':
    my_hostname => 'openshift',
  }

  $config = {
    roles                           => ['nameserver','msgserver','datastore','broker','node'],

    # Hostname values
    broker_hostname                 => $oo_hostname,
    nameserver_hostname             => $oo_hostname,
    msgserver_hostname              => $oo_hostname,
    datastore_hostname              => $oo_hostname,
    node_hostname                   => $oo_hostname,

    # IP address values
    broker_ip_addr                  => $oo_ipaddress,
    nameserver_ip_addr              => $oo_ipaddress,
    node_ip_addr                    => $oo_ipaddress,

    conf_node_external_eth_dev      => 'eth1',

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
    bind_key                        => 'yV9qIn/KuCqvnu7SNtRKU3oZQMMxF1ET/GjkXt5pf5JBcHSKY8tqRagiocCbUX56GOM/iuP//D0TteLc3f1N2g==',
    dns_infrastructure_zone         => "openshift.local",
    dns_infrastructure_names        => [
      {
        hostname => $oo_hostname,
        ipaddr   => $oo_ipaddress,
      }
    ],
    dns_infrastructure_key          => 'UjCNCJgnqJPx6dFaQcWVwDjpEAGQY4Sc2H/llwJ6Rt+0iN8CP0Bm5j5pZsvvhZq7mxx7/MdTBBMWJIA9/yLQYg==',

    # NTP config
    configure_ntp                   => false,
  }

  ensure_resource('class', 'openshift_origin', $config)
}
