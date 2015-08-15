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
  require profile::openshift_origin::base

  class { 'profile::hostname':
    my_hostname => $broker_hostname,
  }
  $all_in_one_config = {
    roles                     => ['nameserver','msgserver','datastore','broker','node'],

    # Hostname values
    broker_hostname           => $::fqdn,
    nameserver_hostname       => $::fqdn,
    msgserver_hostname        => $::fqdn,
    datastore_hostname        => $::fqdn,
    node_hostname             => $::fqdn,

    # IP address values
    broker_ip_addr            => $::ipaddress,
    nameserver_ip_addr        => $::ipaddress,
    node_ip_addr              => $::ipaddress,

    # MsgServer config
    msgserver_cluster         => false,
  }

  $config = merge($::profile::openshift_origin::base::config, $all_in_one_config)
  ensure_resource('class', 'openshift_origin', $config)
}
