###########
# Kubebox #
###########

# Usage:
#   $(kubebox) COMMAND [OPTIONS...]

define kubebox
	$(docker_compose_run) kubebox
endef
