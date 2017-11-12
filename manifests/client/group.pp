class sshfs::client::group {
  if $sshfs::client::manage_local_share_group {
    group { $sshfs::client::local_share_group_name:
      ensure => $sshfs::client::local_share_group_ensure,
      gid    => 0 + $sshfs::client::local_share_group_id,
      system => false,
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
