###########
# Ansible #
###########

# Usage:
#   $(ansible) [ARG...]

define ansible
	$(docker_run) ansible
endef

# Usage:
#   $(ansible-playbook) [ARG...]

define ansible-playbook
	$(docker_run) ansible-playbook
endef
