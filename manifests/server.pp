# This submodule manages resources on a node that will serve file-share
# resources over key-based SSH.  These resources include user accounts, SSH
# keys, and top-level directories for the various mountable shares.
#
class sshfs::server(
  Boolean                   $manage_public_key,
  Boolean                   $manage_share_group,
  Boolean                   $manage_share_user,
  Enum['present', 'absent'] $public_key_ensure,
  String[1]                 $public_key_type,
  Boolean                   $purge_public_keys,
  String[2]                 $share_group,
  Enum['present', 'absent'] $share_group_ensure,
  Variant[Integer, String]  $share_group_id,
  Stdlib::Unixpath          $share_path,
  String[2]                 $share_user,
  Enum['present', 'absent'] $share_user_ensure,
  Variant[Integer, String]  $share_user_id,
  Optional[String[1]]       $public_key          = undef,
) {
  class { '::sshfs::server::sshhostkey': }
  -> class { '::sshfs::server::group': }
  -> class { '::sshfs::server::user': }
  -> class { '::sshfs::server::filesystem': }
  -> Class['sshfs::server']
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
