##################
# Docker Compose #
##################

# Usage:
#   $(call docker_run, COMMAND [ARGS...])

ifneq ($(container),docker)
define docker_run
	docker-compose \
	  $(if $(DOCKER_COMPOSE_FILE),--file $(DOCKER_COMPOSE_FILE)) \
		$(if $(DOCKER_PROJECT_NAME),--project-name $(DOCKER_PROJECT_NAME)) \
		run \
		$(if $(DOCKER_USER),--user $(DOCKER_USER)) \
		--rm \
		$(DOCKER_SERVICE) $(strip $(1))
endef
else
define docker_run
	$(strip $(1))
endef
endif

# Usage:
#   $(call docker_exec, SERVICE, COMMAND [ARGS...])

ifneq ($(container),docker)
define docker_exec
	docker-compose \
	  $(if $(DOCKER_COMPOSE_FILE),--file $(DOCKER_COMPOSE_FILE)) \
		$(if $(DOCKER_PROJECT_NAME),--project-name $(DOCKER_PROJECT_NAME)) \
		exec \
		$(if $(DOCKER_USER),--user $(DOCKER_USER)) \
		$(DOCKER_SERVICE) $(strip $(1))
endef
else
define docker_exec
	$(call message_error, Unable to execute command inside a docker container)
	exit 1
endef
endif

# Usage:
#   $(call docker_clean)

ifneq ($(container),docker)
define docker_clean
	docker-compose \
	  $(if $(DOCKER_COMPOSE_FILE),--file $(DOCKER_COMPOSE_FILE)) \
		$(if $(DOCKER_PROJECT_NAME),--project-name $(DOCKER_PROJECT_NAME)) \
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
