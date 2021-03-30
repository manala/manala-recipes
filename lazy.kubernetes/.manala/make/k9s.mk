#######
# K9s #
#######

# Usage:
#   $(k9s) COMMAND [OPTIONS...]

define k9s
	$(docker_compose_run) k9s
endef
