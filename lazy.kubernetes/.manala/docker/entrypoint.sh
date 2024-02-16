#!/bin/sh

set -e

# As a consequence of running the container as root user,
# tty is not writable by sued user
if [ -t 1 ]; then
  chmod 666 "$(tty)"
  GPG_TTY="$(tty)"
  export GPG_TTY
fi

# Home cache
if [ -n "${MANALA_CACHE_DIR}" ]; then
  HOME_DIR=${MANALA_CACHE_DIR}/home
  if [ ! -d "${HOME_DIR}" ]; then
    cp --archive /home/lazy/. "${HOME_DIR}"
  fi
  usermod --home "${HOME_DIR}" lazy 2>/dev/null
fi

# Templates
if [ -d ".manala/etc" ]; then
  GOMPLATE_LOG_FORMAT=simple gomplate --input-dir=.manala/etc --output-dir=/etc 2>/dev/null
fi

# Docker bridge
if [ -n "${DOCKER_HOST}" ]; then
  ln --symbolic /etc/services/available/docker-bridge /etc/services/enabled/
fi

# Ssh auth bridge
if [ -n "${SSH_AUTH_SOCK}" ]; then
  ln --symbolic /etc/services/available/ssh-auth-bridge /etc/services/enabled/
fi

# Services
s6-svscan /etc/services/enabled &

# Command
exec tini -- gosu lazy "$@"
