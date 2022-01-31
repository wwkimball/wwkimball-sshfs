class sshfs::client::user {
  if $sshfs::client::manage_local_share_user {
    user { $sshfs::client::local_share_user_name:
      ensure   => $sshfs::client::local_share_user_ensure,
      uid      => 0 + $sshfs::client::local_share_user_id,
      gid      => $sshfs::client::local_share_group_name,
      comment  => 'sshfs access user',
      password => '*',  # Restrict access to SSH, only
      system   => false,
    }
  }

  if $sshfs::client::manage_private_key {
    $key_path = dirname($sshfs::client::private_key_path)

    # The key must have been provided.
    if undef == $sshfs::client::private_key {
      fail("You must provide the content of the sshfs::client::private_key when sshfs::client::manage_private_key is true.")
    }

    # Manage the key directory only if it is unmanaged
    if !defined(File[$key_path]) {
	    file { $key_path:
	      ensure => directory,
	      owner  => 'root',
	      group  => 'root',
	      mode   => '0700',
	    }
    }

    file { $sshfs::client::private_key_path:
      ensure    => file,
      content   => $sshfs::client::private_key,
      owner     => 'root',
      group     => 'root',
      mode      => '0400',
      require   => [ File[$key_path] ],
      show_diff => false,
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
