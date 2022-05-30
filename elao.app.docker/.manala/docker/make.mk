##########
# Docker #
##########

ifeq ($(container),docker)
DOCKER := 1
DOCKER_SHELL := $(SHELL)
DOCKER_MAKE := $(MAKE)
else
DOCKER_SHELL = $(_docker_compose_exec) /bin/sh
DOCKER_MAKE = $(_docker_compose_exec) make
endif

###################
# Mutagen Compose #
###################

_MUTAGEN_COMPOSE = $(shell command -v mutagen-compose)

#######
# Git #
#######

_GIT_CONFIG = $(wildcard ~/.gitconfig)
_GITHUB_CONFIG = $(wildcard ~/.config/gh)

##################
# Docker Compose #
##################

_DOCKER_COMPOSE = $(if $(_MUTAGEN_COMPOSE), \
	$(_MUTAGEN_COMPOSE), \
	$(shell command -v docker) compose \
)
_DOCKER_COMPOSE_ENV = \
	DOCKER_BUILDKIT=1 \
	MANALA_HOST_OS=$(OS) \
	MANALA_HOST_PATH=$(abspath $(_DIR)) \
	$(if $(SYMFONY_IDE),SYMFONY_IDE="$(SYMFONY_IDE)&/srv/app/>$(PROJECT_PATH)/") \
	$(if $(_GIT_CONFIG),MANALA_GIT_CONFIG=$(_GIT_CONFIG)) \
	$(if $(_GITHUB_CONFIG),MANALA_GITHUB_CONFIG=$(_GITHUB_CONFIG))
_DOCKER_COMPOSE_FILE = \
	$(_DIR)/.manala/docker/compose.yaml \
	$(_DIR)/.manala/docker/compose/init.sysv.yaml \
 	$(_DIR)/.manala/docker/compose/development.yaml \
	$(if $(_MUTAGEN_COMPOSE),$(_DIR)/.manala/docker/compose/mutagen.yaml) \
	$(if $(_GIT_CONFIG),$(_DIR)/.manala/docker/compose/git.yaml) \
	$(if $(_GITHUB_CONFIG),$(_DIR)/.manala/docker/compose/github.yaml) \
	$(if $(SYMFONY_IDE),$(_DIR)/.manala/docker/compose/symfony.yaml)
_DOCKER_COMPOSE_PROJECT_NAME = $(PROJECT_NAME)
_DOCKER_COMPOSE_PROJECT_DIRECTORY = $(_DIR)/.manala/docker
_DOCKER_COMPOSE_PROFILE = development
_DOCKER_COMPOSE_EXEC_SERVICE = app
_DOCKER_COMPOSE_EXEC_USER = app
_DOCKER_COMPOSE_EXEC_WORKDIR = /srv/app/$(_CURRENT_DIR)

# Debug
ifdef DEBUG
_DOCKER_COMPOSE_ENV += BUILDKIT_PROGRESS=plain
endif

# Ssh Agent
ifdef SSH_AUTH_SOCK
_DOCKER_COMPOSE_FILE += $(_DIR)/.manala/docker/compose/ssh-agent.yaml
	# See: https://docs.docker.com/desktop/mac/networking/#ssh-agent-forwarding
	ifdef OS_DARWIN
_DOCKER_COMPOSE_ENV += SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock
_DOCKER_COMPOSE_ENV += MANALA_SSH_AUTH_SOCK_BIND=/run/host-services/ssh-auth.sock.bind
	endif
endif

# Internal usage:
#   $(_docker_compose) [COMMAND] [ARGS...]

ifndef DOCKER
define _docker_compose
	$(_DOCKER_COMPOSE_ENV) \
	$(if $(_DOCKER_COMPOSE_PROJECT_NAME),COMPOSE_PROJECT_NAME=$(_DOCKER_COMPOSE_PROJECT_NAME)) \
	$(_DOCKER_COMPOSE) \
		$(if $(_DOCKER_COMPOSE_PROJECT_DIRECTORY),--project-directory $(_DOCKER_COMPOSE_PROJECT_DIRECTORY)) \
		$(if $(_DOCKER_COMPOSE_PROFILE),--profile $(_DOCKER_COMPOSE_PROFILE)) \
		$(foreach FILE, $(_DOCKER_COMPOSE_FILE), \
			--file $(FILE) \
		)
endef
else
define _docker_compose
	$(call message_error, Unable to execute command inside a docker container) ; \
		exit 1 ;
endef
endif

# Internal usage:
#   $(_docker_compose_exec) COMMAND [ARGS...]

define _docker_compose_exec
	$(_docker_compose) exec \
		$(if $(_DOCKER_COMPOSE_EXEC_USER),--user $(_DOCKER_COMPOSE_EXEC_USER)) \
		$(if $(_DOCKER_COMPOSE_EXEC_WORKDIR),--workdir $(_DOCKER_COMPOSE_EXEC_WORKDIR)) \
		$(_DOCKER_COMPOSE_EXEC_SERVICE)
endef
