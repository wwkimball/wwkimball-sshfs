class sshfs::server::filesystem {
  # Ensure the share directory exists and is owned by the specified user and
  # group.
  file { $sshfs::server::share_path:
    ensure  => directory,
    owner   => $sshfs::server::share_user,
    group   => $sshfs::server::share_group,
    mode    => '0775',
    require => [
      Group[$sshfs::server::share_group],
      User[$sshfs::server::share_user],
    ]
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
