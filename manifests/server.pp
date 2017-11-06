# This submodule manages resources on a node that will serve file-share
# resources over key-based SSH.  These resources include user accounts, SSH
# keys, and top-level directories for the various mountable shares.
#
class sshfs::server(
  String[2]        $share_user,
  String[2]        $share_group,
  String[1]        $ssh_authorized_key_title,
  Stdlib::Unixpath $share_path,
) {
  # The user, its group, and public key must be managed elsewhere.  User
  # (account) resource management is a very complex subject that has been solved
  # many times over by other more-qualified Puppet modules.
  if !defined(User[$share_user]) {
    fail("You must manage the ${share_user} User via a Puppet module that specializes in user account management.")
  }
  if !defined(Group[$share_group]) {
    fail("You must manage the ${share_group} Group via a Puppet module that specializes in user account management.")
  }
  if !defined(Ssh_authorized_key[$ssh_authorized_key_title]) {
    fail("You must manage the ${ssh_authorized_key_title} SSH authorized (public) key via a Puppet module that specializes in user account management.")
  }

  # Ensure the share directory exists and is owned by the specified user and
  # group.
  file { $share_path:
    ensure => directory,
    owner  => $share_user,
    group  => $share_group,
    mode   => '0775',
  }

  # Export this server's SSH host key so all clients can import it.  Without
  # this, all SSH connections to this sshfs server will hang, waiting for human
  # review and manual acceptance of this key.
  @@sshkey { $facts['hostname']:
    type => 'ssh-rsa',
    key  => $facts['sshrsakey'],
    tag  => 'sshfs-server-key',
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
