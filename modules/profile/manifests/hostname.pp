# = Class: profile::hostname
# This class set the wanted hostname to the local machine
# By default this is ${::hostname} which is probably 'localhost'
#
# This class can only be used on CentOS
#
# == Parameters
#   [*my_hostname*]
#     The wanted hostname
#     Default: $::hostname
#
class profile::hostname (
    $my_hostname = $::hostname
) {
  exec { 'set_hostname':
    command => "/bin/hostname ${my_hostname}",
    unless  => "/bin/hostname | /bin/grep ${my_hostname}",
  }

  if $::operatingsystem == 'CentOS' {
    exec { 'set_etc_hostname':
      command => "/bin/sed -ri \'s/HOSTNAME=.*/HOSTNAME=${my_hostname}/\' /etc/sysconfig/network",
      unless  => "/bin/grep ${my_hostname} /etc/sysconfig/network",
    }
  } else {
    warning('The hostname can be set only on CentOS operating system')
  }
}
