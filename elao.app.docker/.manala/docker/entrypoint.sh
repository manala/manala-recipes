#!/bin/sh

set -e

# Ssh agent bridge
if [ -n "${SSH_AUTH_SOCK}" ]; then
  sh -c " \
    while sleep 1; do \
      rm -f /var/run/ssh-auth-bridge.sock ;
      socat \
        UNIX-LISTEN:/var/run/ssh-auth-bridge.sock,fork,mode=777 \
        UNIX-CONNECT:/var/run/ssh-auth.sock ; \
    done \
  " &
fi

# Docker bridge
if [ -n "${DOCKER_HOST}" ]; then
  sh -c " \
    while sleep 1; do \
      rm -f /var/run/docker-bridge.sock ;
      socat -t 600 \
        UNIX-LISTEN:/var/run/docker-bridge.sock,fork,mode=777 \
        UNIX-CONNECT:/var/run/docker.sock ; \
    done \
  " &
fi

# Ssh key
if [ -n "${SSH_AUTH_SOCK}" ] && [ -n "${MANALA_SSH_KEY}" ]; then
  printf "Start ssh-agent as app user\n"
  su app -c "ssh-agent -a ${SSH_AUTH_SOCK}"
  printf "Add ssh key\n"
  su app -c "echo \"${MANALA_SSH_KEY}\" | ssh-add -"
fi

exec "$@"
