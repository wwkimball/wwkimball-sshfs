class sshfs::server::user {
  if $sshfs::server::manage_share_user {
    $ssh_directory = "/home/${sshfs::server::share_user}/.ssh"

    # Forbid root (disallow destructive access)
    if 'root' == $sshfs::server::share_user {
      fail('root is forbidden as an sshfs user because it is too dangerous.')
    }

    user { $sshfs::server::share_user:
      ensure => $sshfs::server::share_user_ensure,
      uid    => 0 + $sshfs::server::share_user_id,
      gid    => $sshfs::server::share_group,
      system => false,
    } -> file {
      default:
        ensure => directory,
	      owner  => $sshfs::server::share_user,
	      group  => $sshfs::server::share_group,
	      mode   => '0700',;

      "/home/${sshfs::server::share_user}":;

      $ssh_directory:;
    }
  }

  if $sshfs::server::manage_share_key {
    # Both the key and its type must be provided.
    if undef == $sshfs::server::share_key
      or undef == $sshfs::server::share_key_type
    {
      fail("You must provide both sshfs::server::share_key and sshfs::server::share_key_type when sshfs::server::manage_share_key is true.")
    }

    ssh_authorized_key { "${sshfs::server::share_user}-ssh-public-key":
      ensure  => $sshfs::server::share_key_ensure,
      type    => $sshfs::server::share_key_type,
      key     => $sshfs::server::share_key,
      require => [
        User[$sshfs::server::share_user],
        File[$ssh_directory],
      ],
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
