###############
# Kube Prompt #
###############

# Usage:
#   $(kube_prompt) COMMAND [OPTIONS...]

define kube_prompt
	$(docker_compose_run) kube_prompt
endef
