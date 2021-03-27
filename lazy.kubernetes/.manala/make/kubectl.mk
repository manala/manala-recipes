###########
# Kubectl #
###########

# Usage:
#   $(call kubectl, COMMAND [OPTIONS...])

define kubectl
	$(call docker_run, kubectl $(strip $(1)))
endef
