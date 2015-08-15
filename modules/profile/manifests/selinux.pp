# = Class: profile::selinux
# This class enable SELinux and force a reboot to activate SELinux
#
# == Parameters
# [*mode*]
#   The mode to set : 'enforcing', 'permissive' or 'disabled'
#   Default: 'permissive'
#
#
class profile::selinux ($mode = 'permissive') {

  class { '::selinux':
    mode  => $mode,
  }

  reboot { 'after':
    subscribe => Class['::selinux'],
  }

}
