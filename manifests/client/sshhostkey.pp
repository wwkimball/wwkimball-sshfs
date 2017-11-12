class sshfs::client::sshhostkey {
  # Import (and implicitly trust) the sshfs server's SSH host key.
  Sshkey <<| tag == 'sshfs-server-key' |>>
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
