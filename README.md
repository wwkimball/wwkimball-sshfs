# wwkimball-sshfs

This module automates using [sshfs](https://linux.die.net/man/1/sshfs) to
establish -- somewhat limited -- file servers and clients.  This offers a viable
alternative to NFS or SMB for small-scale file-serving use-cases.  You need only
SSH and the light-weight sshfs client; sshfs effectively uses SFTP (FTP over
SSH) to synchronize the server and client file-systems.

Note that this implementation can be limited by the normal behavior of SSH.  For
example, if your `umask` is at the default value, you will find that users other
than the `local_share_user_name` -- even when they are members of the
`local_share_group_name` -- can create files or directories that they instantly
become unable to edit.  Again, this is a limitation of SSH and by virtue, sshfs,
not of this Puppet module.  This Puppet module merely creates and maintains the
link between clients and servers.  It is up to you to work out your ownership,
permissions, and umask concerns to make sshfs effective for your specific
use-case.

Some tips can help:

1. The default settings work for the most simple use-cases.  Don't change them
   when you are starting out.  Rather, provide only `sshfs::server::public_key`
   and `sshfs::client::private_key` and then try out the link, which will be
   found at /var/sshfs on the server and /mnt/sshfs on your clients.
2. Never use root as your share users or groups unless you are certain that only
   your root user will ever access the share and you specifically need root
   level access across the link.  Not only can that expose more of your
   file-server than you probably need, but it will severely limit what your
   non-root clients' users can access (if you create any).
3. If you have a client with a user other than sshfs who needs full read and
   write access to the link, then set both the
   `sshfs::client::local_share_user_id` and
   `sshfs::client::local_share_user_name` to that user's ID and name.  If your
   user is already Puppet managed, then be sure to also disable
   `sshfs::client::manage_local_share_user`.  This will grant that user full
   access to the local side of the link.  For this use-case, don't mess with
   `sshfs::server::share_user` or `sshfs::server::share_group`.  The server-side
   and client-side of the sshfs links **do not** need to be the same user or
   group.
4. If you have more than one user on the client side of a link who needs full
   read and write access across the link, then things get more complicated.  You
   may need to employ additional Puppet modules to take better control over the
   applicable `umask` on both the client and server sides of the sshfs link in
   order to permit more than one user to have write access.  This is because the
   applicable permissions to sshfs-exposed resources are impacted by the `umask`
   at the time the resource is created and that control is beyond the scope of
   this Puppet module.  In short, you will need your client-side users to be
   members of the same group that is specified via
   `sshfs::client::local_share_group_name` *and* the applicable `umask` at the
   time of resource creation on *both* the client and the server must permit
   group write access.  The default `umask` on most systems is *not* so relaxed.
   You may find that the client-side `umask` is most likely 0077, 0027, 0022.
   None of these default values permit group write access.  You can adjust the
   applicable client-side `umask` for the user by default, or for the session
   during which you intend to work across the sshfs share, or even for the
   duration of a single script or command.  Setting something like `umask 0002`
   would be ideal in any of these cases.  However, some server-side SSH
   configurations override or otherwise further restrict the applicable `umask`.
   When a permissive client-side `umask` is combined with a more restricted
   server-side `umask`, the most restrictive setting normally prevails.  This is
   complex and is the nature of SSH and how it exists amid Linux access control
   systems.
