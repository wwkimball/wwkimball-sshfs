class sshfs::server::group {
  if $sshfs::server::manage_share_group {
    # Forbid root (blocks non-root users from utilizing the remote share)
    if 'root' == $sshfs::server::share_group {
      fail('root is forbidden as an sshfs group because it is too restrictive.')
    }

    group { $sshfs::server::share_group:
      ensure => $sshfs::server::share_group_ensure,
      gid    => 0 + $sshfs::server::share_group_id,
      system => false,
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
