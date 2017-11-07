# This submodule manages resources on a node that will mount remote file-shares
# via sshfs.
#
class sshfs::client(
  String[1]        $package_ensure,
  String[2]        $package_name,
  String[32]       $private_key,
  String[2]        $share_user,
  String[2]        $share_group,
  Variant[Integer, String] $share_group_id,
  String[1]        $share_host,
  Stdlib::Unixpath $share_path,
  Stdlib::Unixpath $mount_point,
) {
  $identity_file = "/root/.ssh/${share_user}"

  # Import (and implicitly trust) the sshfs server's SSH host key.
  Sshkey <<| tag == 'sshfs-server-key' |>>

  package { $package_name:
    ensure => $package_ensure,
  }

  # This module needs the name of the sshfs user and that user's private key
  # identity-file.  This module will create the private key file and store it
  # "in a safe place" (/root/.ssh/sshfs).
  if !defined(File['/root/.ssh']) {
    file { '/root/.ssh':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0700',
    }
  }

  file { $identity_file:
    ensure  => file,
    content => $private_key,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
  }

  if !defined(Group[$share_group]) {
    group { $share_group:
      gid    => 0 + $share_group_id,
      before => [
        File[$mount_point],
        Mount[$mount_point],
      ],
    }
  }

  file { $mount_point:
    ensure => directory,
    owner  => 'root',
    group  => $share_group,
    mode   => '0775',
  } -> mount { $mount_point:
    ensure   => mounted,
    atboot   => true,
    device   => "${share_user}@${share_host}:${share_path}",
    dump     => 0,
    pass     => 0,
    remounts => false,
    fstype   => 'fuse.sshfs',
    options  => "x-systemd.automount,_netdev,user,idmap=user,transform_symlinks,allow_other,default_permissions,nonempty,identityfile=${identity_file},uid=0,gid=${share_group_id}",
    require  => [ Package[$package_name], ],
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
