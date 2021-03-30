#########
# Stern #
#########

# Usage:
#   $(stern) COMMAND [OPTIONS...]

define stern
	$(docker_compose_run) stern
endef
