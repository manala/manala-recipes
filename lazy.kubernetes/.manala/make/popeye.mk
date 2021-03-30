##########
# Popeye #
##########

# Usage:
#   $(popeye) COMMAND [OPTIONS...]

define popeye
	$(docker_compose_run) popeye
endef
