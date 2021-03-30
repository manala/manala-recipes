##################
# Docker Compose #
##################

# Usage:
#   $(docker_compose_run) [COMMAND] [ARG...]

ifneq ($(container),docker)
define docker_compose_run
	docker-compose \
		$(if $(_DOCKER_PROJECT_NAME),--project-name $(_DOCKER_PROJECT_NAME)) \
		$(foreach file, $(_DOCKER_COMPOSE_FILES), \
			--file $(file) \
		) \
		run \
		--rm \
		$(_DOCKER_SERVICE)
endef
else
define docker_compose_run
endef
endif

# Usage:
#   $(docker_compose_clean)

ifneq ($(container),docker)
define docker_compose_clean
	docker-compose \
		$(if $(_DOCKER_PROJECT_NAME),--project-name $(_DOCKER_PROJECT_NAME)) \
		$(foreach file, $(_DOCKER_COMPOSE_FILES), \
			--file $(file) \
		) \
		down \
		--rmi all \
		--volumes \
		--remove-orphans
endef
else
define docker_compose_clean
	$(call message_error, Unable to execute command inside a docker container)
	exit 1
endef
endif
