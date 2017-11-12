class sshfs::client::package {
  package { $sshfs::client::package_name:
    ensure => $sshfs::client::package_ensure,
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
