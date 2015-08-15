# = Class: profile::yum
# This class setups the yum package repository
# additional package repository should use:
# yum::repo::$additional_repo
# You can find the list of additonal repos on
# https://github.com/example42/puppet-yum/tree/master/manifests/repo
#
class profile::yum  {
  class {'::yum':
    install_all_keys => true,
  }
}
