###########
# Ansible #
###########

# Usage:
#   $(ansible) [ARG...]

define ansible
	$(docker_compose_run) ansible
endef

# Usage:
#   $(ansible-playbook) [ARG...]

define ansible-playbook
	$(docker_compose_run) ansible-playbook
endef
