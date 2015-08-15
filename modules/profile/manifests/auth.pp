# = Class: profile::admin
# This class manage a list of administrator user and groups  of the machine authenticated by their gaspar username and passwords.
# This module can authorize both specific user by username or specific group by group name
# This module mainly use the sti/kerberos module with sudo access.
#
# == Parameters
#
# [*admin_users*]
#   Define a list of admin users that have access to the machine and can run sudo without password.
#   Default: []
#
# [*admin_groups*]
#   Define a list of admin groups that have access to the machine and can run sudo without password.
#   Default: []
#
class profile::auth ($admin_users=[], $admin_groups=[]){
  #surround group with parenthesis and join with spaces
  $groups = join(suffix(prefix($admin_groups, '('), ')'), ' ')
  $users =  join($admin_users, ' ')

  include ::sudo

  if $admin_groups != [] {
    $joined_group = join(prefix($admin_groups, '%'), ',')
    $admin_group = "User_Alias ADMIN_GROUPS = ${joined_group}"

    sudo::conf {'admin_groups':
      priority => 10,
      content  => $admin_group,
    }
    sudo::conf {'admin_group_right':
      priority => 20,
      content  => 'ADMIN_GROUPS ALL=(ALL) NOPASSWD: ALL',
    }
  }

  if $admin_users != [] {
    $joined_user = join($admin_users, ',')
    $admin_user = "User_Alias ADMIN_USERS = ${joined_user}"
    sudo::conf {'admin_users':
      priority => 10,
      content  => $admin_user,
    }
    sudo::conf {'admin_users_right':
      priority => 20,
      content  => 'ADMIN_USERS ALL=(ALL) NOPASSWD: ALL',
    }
  }

  ensure_packages(['zsh', 'bash', 'ksh'])
}
