#!/bin/sh

set -e

# If ssh-agent bind differs from sock, establish an unprivileged relay
if [ -n "${SSH_AUTH_SOCK}" ] && [ -n "${MANALA_SSH_AUTH_SOCK_BIND}" ] && [ "${SSH_AUTH_SOCK}" != "${MANALA_SSH_AUTH_SOCK_BIND}" ]; then
  printf "Bind privileged ssh-agent socket\n"
  socat \
    UNIX-LISTEN:${SSH_AUTH_SOCK},fork,mode=777 \
    UNIX-CONNECT:${MANALA_SSH_AUTH_SOCK_BIND} &
fi

# Ssh key
if [ -n "${SSH_AUTH_SOCK}" ] && [ -n "${MANALA_SSH_KEY}" ]; then
  printf "Start ssh-agent as app user\n"
  su app -c "ssh-agent -a ${SSH_AUTH_SOCK}"
  printf "Add ssh key\n"
  su app -c "echo \"${MANALA_SSH_KEY}\" | ssh-add -"
fi

exec "$@"
