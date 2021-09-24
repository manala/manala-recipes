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

##################
# Docker Compose #
##################

_DOCKER_COMPOSE = docker-compose

# Internal usage:
#   $(_docker_compose) [COMMAND] [ARGS...]

ifndef DOCKER
define _docker_compose
	$(_DOCKER_COMPOSE_ENV) \
	$(_DOCKER_COMPOSE) \
		$(if $(_DOCKER_COMPOSE_PROJECT_DIRECTORY),--project-directory $(_DOCKER_COMPOSE_PROJECT_DIRECTORY)) \
		$(if $(_DOCKER_COMPOSE_PROJECT_NAME),--project-name $(_DOCKER_COMPOSE_PROJECT_NAME)) \
		$(foreach file, $(_DOCKER_COMPOSE_FILE), \
			--file $(file) \
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
		$(if $(_DOCKER_COMPOSE_USER),--user $(_DOCKER_COMPOSE_USER)) \
		$(_DOCKER_COMPOSE_SERVICE)
endef
