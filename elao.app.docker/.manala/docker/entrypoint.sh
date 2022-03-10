#!/bin/sh

set -e

# If ssh-agent bind differs from sock, establish an unpriviliged relay
if [ -n "${SSH_AUTH_SOCK}" ] && [ -n "${MANALA_SSH_AUTH_SOCK_BIND}" ] && [ "${SSH_AUTH_SOCK}" != "${MANALA_SSH_AUTH_SOCK_BIND}" ]; then
  socat \
    UNIX-LISTEN:${SSH_AUTH_SOCK},fork,mode=777 \
    UNIX-CONNECT:${MANALA_SSH_AUTH_SOCK_BIND} &
fi

# Ssh key
if [ -n "${MANALA_SSH_KEY}" ]; then
  install --directory --group app --owner app --mode 700 /home/app/.ssh
  printenv MANALA_SSH_KEY > /home/app/.ssh/id_rsa
  chown app:app /home/app/.ssh/id_rsa
  chmod 600 /home/app/.ssh/id_rsa
fi

exec "$@"
