###########
# Kubectl #
###########

# Usage:
#   $(kubectl) COMMAND [OPTIONS...]

define kubectl
	$(docker_run) kubectl
endef
