#!/usr/bin/env sh

# https://github.com/acmesh-official/get.acme.sh

_exists() {
  cmd="$1"
  if [ -z "$cmd" ] ; then
    echo "Usage: _exists cmd"
    return 1
  fi
  if type command >/dev/null 2>&1 ; then
    command -v $cmd >/dev/null 2>&1
  else
    type $cmd >/dev/null 2>&1
  fi
  ret="$?"
  return $ret
}

# Set the default branch to master
if [ -z "$BRANCH" ]; then
  BRANCH="master"
fi

# Parse email argument
#format "email=my@example.com"
_email="$1"
if [ -z "$_email" ]; then
  echo "Please enter your email address: "
  read -r user_email
  _email="--email $user_email"
elif [ "$_email" ]; then
  shift
  _email="--$(echo "$_email" | tr '=' ' ')"
fi

# Set the URL for acme.sh installation script
_url="https://raw.githubusercontent.com/acmesh-official/acme.sh/$BRANCH/acme.sh"

# Check if curl or wget is available
_get=""
if _exists curl && [ "${ACME_USE_WGET:-0}" = "0" ]; then
  _get="curl -L"
elif _exists wget ; then
  _get="wget -O -"
else
  echo "Sorry, you must have curl or wget installed first."
  echo "Please install either of them and try again."
  exit 1
fi


# Install acme.sh using the specified email and additional arguments
if ! $_get "$_url" | sh -s -- --install-online $_email "$@"; then
  echo "Installation error"
  echo "If you are in China, please refer to the following link for installation instructions:"
  echo "https://github.com/acmesh-official/acme.sh/wiki/Install-in-China"
fi
