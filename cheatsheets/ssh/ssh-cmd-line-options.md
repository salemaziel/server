# SSH command line options

Some of the most important command-line options for the OpenSSH client are:

-1 Use protocol version 1 only.

-2 Use protocol version 2 only.

-4 Use IPv4 addresses only.

-6 Use IPv6 addresses only.

-A Enable forwarding of the authentication agent connection.

-a Disable forwarding of the authentication agent connection.

-C Use data compression

-c cipher_spec Selects the cipher specification for encrypting the session.

-D [bind_address:]port Dynamic application-level port forwarding. This allocates a socket to listen to port on the local side. When a connection is made to this port, the connection is forwarded over the secure channel, and the application protocol is then used to determine where to connect to from the remote machine.

-E log_file Append debug logs to log_file instead of standard error.

-F configfile Specifies a per-user configuration file. The default for the per-user configuration file is ~/.ssh/config.

-g Allows remote hosts to connect to local forwarded ports.

-i identity_file A file from which the identity key (private key) for public key authentication is read.

-J [user@]host[:port] Connect to the target host by first making a ssh connection to the pjump host[(/iam/jump-host) and then establishing a TCP forwarding to the ultimate destination from there.

-l login_name Specifies the user to log in as on the remote machine.

-p port Port to connect to on the remote host.

-q Quiet mode.

-V Display the version number.

-v Verbose mode.

-X Enables X11 forwarding.