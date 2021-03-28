##################
# Docker Compose #
##################

# Usage:
#   $(docker_run) [COMMAND] [ARG...]

ifneq ($(container),docker)
define docker_run
	docker-compose \
		$(if $(_DOCKER_COMPOSE_FILE),--file $(_DOCKER_COMPOSE_FILE)) \
		$(if $(_DOCKER_PROJECT_NAME),--project-name $(_DOCKER_PROJECT_NAME)) \
		run \
		$(if $(_DOCKER_USER),--user $(_DOCKER_USER)) \
		--rm \
		$(foreach volume,$(_DOCKER_VOLUMES),--volume $(realpath $(volume)):$(realpath $(volume)):cached) \
		--volume $(realpath $(_ROOT_DIR)):$(realpath $(_ROOT_DIR)):cached \
		--workdir $(realpath $(_ROOT_DIR)) \
		$(_DOCKER_SERVICE)
endef
else
define docker_run
endef
endif

# Usage:
#   $(docker_clean)

ifneq ($(container),docker)
define docker_clean
	docker-compose \
		$(if $(_DOCKER_COMPOSE_FILE),--file $(_DOCKER_COMPOSE_FILE)) \
		$(if $(_DOCKER_PROJECT_NAME),--project-name $(_DOCKER_PROJECT_NAME)) \
		down \
		--rmi all \
		--volumes \
		--remove-orphans
endef
else
define docker_clean
	$(call message_error, Unable to execute command inside a docker container)
	exit 1
endef
endif
