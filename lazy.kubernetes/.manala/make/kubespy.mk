###########
# Kubespy #
###########

# Usage:
#   $(kubespy) COMMAND [OPTIONS...]

define kubespy
	$(docker_compose_run) kubespy
endef
