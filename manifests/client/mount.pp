class sshfs::client::mount {
  file { $sshfs::client::local_mount_point:
    ensure => directory,
    owner  => $sshfs::client::local_share_user_name,
    group  => $sshfs::client::local_share_group_name,
    mode   => '0775',
  } -> mount { $sshfs::client::local_mount_point:
    ensure   => mounted,
    atboot   => true,
    device   => "${sshfs::client::remote_share_user_name}@${sshfs::client::remote_share_host}:${sshfs::client::remote_share_path}",
    dump     => 0,
    fstype   => $sshfs::client::fstype,
    options  => "nonempty,transform_symlinks,user,allow_other,default_permissions,idmap=user,identityfile=${sshfs::client::private_key_path},uid=${sshfs::client::local_share_user_id},gid=${sshfs::client::local_share_group_id},${sshfs::client::extra_mount_options}",
    pass     => 0,
    remounts => false,
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
