###########
# Ansible #
###########

MANALA_ANSIBLE_GALAXY_BIN = ansible-galaxy
MANALA_ANSIBLE_PLAYBOOK_BIN = ansible-playbook

# Tags
ifdef TAGS
MANALA_ANSIBLE_PLAYBOOK_TAGS = $(TAGS)
endif

# Diff
ifdef DIFF
MANALA_ANSIBLE_PLAYBOOK_CHECK = 1
MANALA_ANSIBLE_PLAYBOOK_DIFF = 1
endif

# Verbose
ifdef VERBOSE
MANALA_ANSIBLE_PLAYBOOK_VERBOSE_MORE = 1
endif

# Limit
ifdef LIMIT
MANALA_ANSIBLE_PLAYBOOK_LIMIT = $(LIMIT)
else
MANALA_ANSIBLE_PLAYBOOK_LIMIT = development
endif

# Internal usage:
#   $(manala_ansible_galaxy_collection_install) [REQUIREMENTS]

define manala_ansible_galaxy_collection_install
	$(MANALA_ANSIBLE_GALAXY_BIN) collection install \
		--upgrade \
		--requirements-file
endef

# Internal usage:
#   $(manala_ansible_playbook) [PLAYBOOK]

define manala_ansible_playbook
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
