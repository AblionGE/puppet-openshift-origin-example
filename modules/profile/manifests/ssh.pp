# == Class: profile::ssh
#
# This class install ssh, open the firewall on the port specified 
# as parameter and ensure that the server.
# is running.
#
#
# === Parameters
#
# [*port*]
#   the port to which the ssh server should listen to.
#   default is port 22
#   integer
#
class profile::ssh ($port=22){
  class{'::ssh':
    server_options => {
      'X11Forwarding' => 'no',
    },
  }
}
