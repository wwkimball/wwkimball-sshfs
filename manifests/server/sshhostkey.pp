class sshfs::server::sshhostkey {
  # Export this server's SSH host key so all clients can import it.  Without
  # this, all SSH connections to this sshfs server will hang, waiting for human
  # review and manual acceptance of this key.
  @@sshkey { "sshfs-server-rsa-${::facts['networking']['fqdn']}":
    name => $::facts['networking']['fqdn'],
    type => 'ssh-rsa',
    key  => $::facts['ssh']['rsa']['key'],
    tag  => 'sshfs-server-key',
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
