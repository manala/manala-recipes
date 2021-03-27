########
# Helm #
########

# Usage:
#   $(call helm, COMMAND [OPTIONS...])

define helm
	$(call docker_run, helm $(strip $(1)))
endef
