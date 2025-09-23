#!/bin/sh

set -e

# Ssh agent bridge
if [ -n "${SSH_AUTH_SOCK}" ]; then
  sh -c " \
    while true; do \
      rm -f /var/run/ssh-auth-bridge.sock ;
      socat -d0 \
        UNIX-LISTEN:/var/run/ssh-auth-bridge.sock,fork,mode=777 \
        UNIX-CONNECT:/var/run/ssh-auth.sock ; \
      sleep 1; \
    done \
  " &
fi

# Docker bridge
if [ -n "${DOCKER_HOST}" ]; then
  sh -c " \
    while true; do \
      rm -f /var/run/docker-bridge.sock ;
      socat -d0 -t 600 \
        UNIX-LISTEN:/var/run/docker-bridge.sock,fork,mode=777 \
        UNIX-CONNECT:/var/run/docker.sock ; \
      sleep 1; \
    done \
  " &
fi

exec "$@"
