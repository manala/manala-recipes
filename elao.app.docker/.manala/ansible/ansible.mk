###########
# Ansible #
###########

MANALA_ANSIBLE_GALAXY_BIN = ansible-galaxy
MANALA_ANSIBLE_PLAYBOOK_BIN = ansible-playbook

# Debug
MANALA_ANSIBLE_PLAYBOOK_ENV += $(if $(MANALA_ANSIBLE_DEBUG), ANSIBLE_DEBUG=1)

# Usage:
#   $(manala_ansible_galaxy_collection_install) [REQUIREMENTS]

define manala_ansible_galaxy_collection_install
	$(MANALA_ANSIBLE_GALAXY_BIN) collection install \
		--timeout 60 \
		--upgrade \
		--requirements-file
endef

# Usage:
#   $(manala_ansible_playbook) [PLAYBOOK]

define manala_ansible_playbook
	$(if $(MANALA_ANSIBLE_PLAYBOOK_ENV), env $(MANALA_ANSIBLE_PLAYBOOK_ENV)) \
	$(MANALA_ANSIBLE_PLAYBOOK_BIN) \
		$(if $(MANALA_ANSIBLE_PLAYBOOK_INVENTORY),--inventory $(MANALA_ANSIBLE_PLAYBOOK_INVENTORY)) \
		$(if $(MANALA_ANSIBLE_PLAYBOOK_BECOME),--become) \
		$(if $(MANALA_ANSIBLE_PLAYBOOK_LIMIT),--limit $(MANALA_ANSIBLE_PLAYBOOK_LIMIT)) \
		$(if $(MANALA_ANSIBLE_PLAYBOOK_EXTRA_VARS),--extra-vars $(MANALA_ANSIBLE_PLAYBOOK_EXTRA_VARS)) \
		$(if $(MANALA_ANSIBLE_PLAYBOOK_TAGS),--tags $(MANALA_ANSIBLE_PLAYBOOK_TAGS)) \
		$(if $(MANALA_ANSIBLE_PLAYBOOK_CHECK),--check) \
		$(if $(MANALA_ANSIBLE_PLAYBOOK_DIFF),--diff) \
		$(if $(MANALA_ANSIBLE_PLAYBOOK_VERBOSE_MORE),-vvv)
endef
