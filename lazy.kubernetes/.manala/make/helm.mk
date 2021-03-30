########
# Helm #
########

# Usage:
#   $(helm) COMMAND [OPTIONS...]

define helm
	$(docker_compose_run) helm
endef
