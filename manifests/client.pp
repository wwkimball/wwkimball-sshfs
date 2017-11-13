# This submodule manages resources on a node that will mount remote file-shares
# via sshfs.
#
class sshfs::client(
  String[1]                 $extra_mount_options,
  String[4]                 $fstype,
  Stdlib::Unixpath          $local_mount_point,
  Enum['present', 'absent'] $local_share_group_ensure,
  Variant[Integer, String]  $local_share_group_id,
  String[2]                 $local_share_group_name,
  Enum['present', 'absent'] $local_share_user_ensure,
  Variant[Integer, String]  $local_share_user_id,
  String[2]                 $local_share_user_name,
  Boolean                   $manage_local_share_group,
  Boolean                   $manage_local_share_user,
  Boolean                   $manage_private_key,
  String[1]                 $package_ensure,
  String[2]                 $package_name,
  Stdlib::Unixpath          $private_key_path,
  String[1]                 $remote_share_host,
  Stdlib::Unixpath          $remote_share_path,
  String[1]                 $remote_share_user_name,
  Optional[String[32]]      $private_key              = undef,
) {
  class { '::sshfs::client::sshhostkey': }
  -> class { '::sshfs::client::package': }
  -> class { '::sshfs::client::group': }
  -> class { '::sshfs::client::user': }
  -> class { '::sshfs::client::mount': }
  -> Class['sshfs::client']
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
