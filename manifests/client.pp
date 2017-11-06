# This submodule manages resources on a node that will mount remote file-shares
# via sshfs.
#
class sshfs::client(
  String[1]        $package_ensure,
  String[2]        $package_name,
  String[32]       $private_key,
  String[2]        $share_user,
  Stdlib::Unixpath $share_path,
) {
  # Import (and implicitly trust) the sshfs server's SSH host key.
  Sshkey <<| tag == 'sshfs-server-key' |>>

  # This module needs the name of the sshfs user and that user's private key
  # identity-file.  This module will create the private key file and store it
  # "in a safe place" (/root/.ssh/sshfs).
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
