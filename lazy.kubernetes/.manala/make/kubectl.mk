###########
# Kubectl #
###########

# Usage:
#   $(kubectl) COMMAND [OPTIONS...]

define kubectl
	$(docker_compose_run) kubectl
endef
