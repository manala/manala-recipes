#!/bin/sh

set -e

# If ssh-agent bind differs from sock, establish an unpriviliged relay
if [ -n "${SSH_AUTH_SOCK}" ] && [ -n "${MANALA_SSH_AUTH_SOCK_BIND}" ] && [ "${SSH_AUTH_SOCK}" != "${MANALA_SSH_AUTH_SOCK_BIND}" ]; then
  socat \
    UNIX-LISTEN:${SSH_AUTH_SOCK},fork,mode=777 \
    UNIX-CONNECT:${MANALA_SSH_AUTH_SOCK_BIND} &
fi

exec "$@"
