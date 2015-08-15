# = Class profile::base
# This profile is used on every basic linux install
# it includes the following modules:
#
# ntp: set the ntp server
# timezone: set the current timezone of the server
# puppet::client: update puppet to the desired version
# locale: compile and set the default locals for the whole system
# stats::client : sets up collectd to send data to monitoring server
#
# == Parameters
#
#   None
#
class profile::base {
  class {'::ntp':
    servers =>  ['0.ch.pool.ntp.org', '1.ch.pool.ntp.org', '2.ch.pool.ntp.org', '3.ch.pool.ntp.org'],
  }
  class { '::timezone':
    region   => 'Europe',
    locality => 'Zurich',
  }
  class{ '::locales':
    default_locale => 'en_US.UTF-8',
    locales        => ['en_US.UTF-8 UTF-8', 'fr_CH.UTF-8 UTF-8'],
  }
  include ::profile::selinux
}
