#!/bin/bash


# If user has provided -a username, use that as the running_username
find_running_username() {
  running_username=${group_username}

  if [ -z "${running_username}" ]; then
    # need to determine what user to run tsm commands as. Since this script most commonly
    # run by sudo, $USER will be root, which we don't want to run commands as.
    running_username=$(/usr/bin/printenv SUDO_USER || logname 2>/dev/null || /usr/bin/printenv USER || echo "") # final echo ensures failure exit code doesn't cause script to exit
    if [ -z "${running_username}" ]; then
      errcho "Unable to determine which user is running this script (this is unusual). Canceling."
      errcho ""
      exit 1
    fi
  fi
}

