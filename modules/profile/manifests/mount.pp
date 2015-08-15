# = Class: profile::mount
# This class is used to mount manually the shared directory with VirtualBox
# It's needed when installing SELinux (that requires reboot which does not
# mount automatically the directory)
#
# It is used for testing locally modules (especially Openshift_origin)
#
#
# == Parameters
#
# None
#
class profile::mount {
  mount { '/vagrant':
    ensure  => 'mounted',
    atboot  => true,
    device  => 'vagrant',
    fstype  => 'vboxsf',
    options => 'defaults',
  }
}
