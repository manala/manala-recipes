# Makefile variables refactoring - 2023-02

In order to ease maintenance across recipes, some makefile variables have been renamed, please adjust your Makefiles(s) in your project(s).

## Dir

_DIR         -> MANALA_DIR
_ROOT        -> MANALA_CURRENT_ROOT
_CURRENT_DIR -> MANALA_CURRENT_DIR
_CACHE_DIR   -> MANALA_CACHE_DIR

## Os

OS         -> MANALA_OS
OS_LINUX   -> MANALA_OS_LINUX
OS_DARWIN  -> MANALA_OS_DARWIN
OS_WINDOWS -> MANALA_OS_WINDOWS

## Docker

DOCKER                       -> MANALA_DOCKER
DOCKER_SHELL                 -> MANALA_DOCKER_SHELL
DOCKER_MAKE                  -> MANALA_DOCKER_MAKE
_docker                      -> manala_docker
docker_run                   -> manala_docker_shell
docker_exec                  -> manala_docker_shell
_docker_compose_exec         -> manala_docker_shell
_docker_compose              -> manala_docker_compose
_DOCKER_COMPOSE              -> MANALA_DOCKER_COMPOSE_BIN
_DOCKER_COMPOSE_ENV          -> MANALA_DOCKER_COMPOSE_ENV
_DOCKER_COMPOSE_FILE         -> MANALA_DOCKER_COMPOSE_FILE
_DOCKER_COMPOSE_PROFILE      -> MANALA_DOCKER_COMPOSE_PROFILE
_DOCKER_COMPOSE_SERVICE      -> [dropped]
_DOCKER_COMPOSE_USER         -> [dropped]
_DOCKER_COMPOSE_EXEC_SERVICE -> [dropped]
_DOCKER_COMPOSE_EXEC_USER    -> [dropped]
_DOCKER_COMPOSE_EXEC_WORKDIR -> [dropped]

## Text

COLOR_RESET     -> MANALA_COLOR_RESET
COLOR_ERROR     -> MANALA_COLOR_ERROR
COLOR_INFO      -> MANALA_COLOR_INFO
COLOR_WARNING   -> MANALA_COLOR_WARNING
COLOR_COMMENT   -> MANALA_COLOR_COMMENT
time            -> manala_time
message         -> manala_message
message_success -> manala_message_success
message_warning -> manala_message_warning
message_error   -> manala_message_error
log             -> manala_log
log_warning     -> manala_log_warning
log_error       -> manala_log_error
confirm         -> manala_confirm
confirm_if      -> manala_confirm_if
confirm_if_not  -> manala_confirm_if_not
error_if_not    -> manala_error_if_not
rand            -> manala_rand

## Help

HELP         -> MANALA_HELP
HELP_PROJECT -> MANALA_HELP_PROJECT
help         -> manala_help
help_section -> manala_help_section
