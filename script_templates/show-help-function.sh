#!/bin/bash

show_help() {
  cat <<EOM
  Usage: $(basename "$0") -s secrets-file -f config-file -r registration-file --accepteula [optional arguments] package-file

  Installs the package and sets up directories and permissions to properly run Tableau Server, then
  begins Tableau Services Manager setup. After successful completion, Tableau Server should be fully operational.
  
  If you wish this system to be added as an additional node in an existing cluster, provide the -b bootstrap argument
  with the bootstrap-file from the initial server.
  
  REQUIRED
    -s secrets-file                         The name of the secrets file, which provides the usernames for
                                            the TSM adminstrative user and Tableau Server administrator, and optionally
                                            their passwords. If passwords are not found in the secrets file,
                                            this script will prompt for them (not suitable for unattended
                                            installs).
                                            Tableau provides "${TEMPLATE_SECRETS_FILE}" as a template.
    -f config-file                          The name of the configuration and topology JSON file.
                                            Tableau provides "${TEMPLATE_CONFIG_FILE}" as a template.
    -r registration-file                    The name of the registration file.
                                            Tableau provides "${TEMPLATE_REGISTRATION_FILE}" as a template.
    --accepteula                            Indicate that you have accepted the End User License Agreement.
    package-file                            The rpm or deb file to install (e.g., tableau-server-10.0.0-1.x86_64.rpm)
  OPTIONAL
    -d data-directory                       Set a custom location for the data directory if it's not already set.
                                            When not set, the initialize-tsm script uses its default value.
    -c config-name                          Set the service configuration name.
                                            When not set, the initialize-tsm script uses its default value.
    -k license-key                          Specify product key used to activate Tableau Server.
                                            When not set, a trial license will be activated.
    -g                                      Do NOT add the current user to the "tsmadmin" administrative
                                            group, used for default access to Tableau Services Manager, or
                                            to the "tableau" group, used for easier access to log files.
    -a username                             The provided username will be used as the user to be added
                                            to the appropriate groups, instead of the user running this
                                            script. Providing both -a and -g is not allowed.
    -b bootstrap-file                       Location of the bootstrap file downloaded from the Tableau Services Manager
                                            on existing node. If this flag is provided, this node will be configured
                                            as an additional node for an existing cluster.
    -v                                      Verbose output.
    --force                                 Bypass warning messages.
    -i coordinationservice-client-port      Client port for the coordination service
    -e coordinationservice-peer-port        Peer port for the coordination service
    -m coordinationservice-leader-port      Leader port for the coordination service
    -t licenseservice-vendordaemon-port     Vendor daemon port for the licensing service
    -n agent-filetransfer-port              Filetransfer port for the agent service
    -o controller-port                      HTTPS port for the controller service
    -l port-range-min                       Lower port bound for automatic selection
    -x port-range-max                       Upper port bound for automatic selection
    --disable-port-remapping                Disable automatic port selection
    --unprivileged-user=<value>             Name of the unprivileged account to run Tableau Server.
                                            When not set, the initialize-tsm script uses its default value.
    --tsm-authorized-group=<value>          Name of the group(s) granted authorization to access Tableau Services Manager.
                                            When not set, the initialize-tsm script uses its default value.
    --disable-account-creation              Do not create groups or the user account. This option will prevent any calls to useradd
                                            or usermod (no users or groups will be created/edited). However, the values in: unprivileged-user,
                                            privileged-user and tsm-authorized-group will still be passed
                                            through for system configuration.
    --debug                                 Print each command as it is run for debugging purposes. Produces extensive
                                            output.
    --http_proxy=<value>                    HTTP forward proxy for Tableau Server. Its value should be http://<proxy_address>:<proxy_port>/
                                            For example, --http_proxy=http://1.2.3.4:3128/ or --http_proxy=http://example.com:3128/
    --https_proxy=<value>                   HTTPS forward proxy for Tableau Server. Its value should be http://<proxy_address>:<proxy_port>/
                                            For example, --https_proxy=http://1.2.3.4:3128/ or --https_proxy=http://example.com:3128/
                                            Take care to use http when you specify the URL for the https_proxy environmental variable.
                                            Do not specify the https protocol for the value of the https_proxy environmental variable.
    --no_proxy=<value>                      Environment variable that directs certain URLs to bypass the forward proxy. For example,
                                            --no_proxy=localhost,127.0.0.1,localaddress,.localdomain.com
    --use-repo=<value>                      Install package from a configured repository instead of package file. Value should be the name of the package.
                                            For example, --use-repo=tableau-server-2018-1-3.x86_64.rpm
EOM
}


show_help


