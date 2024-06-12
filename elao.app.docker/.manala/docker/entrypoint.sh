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

# Templates
if [ -d ".manala/etc" ]; then
  GOMPLATE_LOG_FORMAT=simple gomplate --input-dir=.manala/etc --output-dir=/etc 2>/dev/null
fi

exec "$@"
