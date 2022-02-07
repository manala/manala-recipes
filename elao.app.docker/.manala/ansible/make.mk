###########
# Ansible #
###########

# Tags
ifdef TAGS
_ANSIBLE_PLAYBOOK_TAGS = $(TAGS)
endif

# Diff
ifdef DIFF
_ANSIBLE_PLAYBOOK_CHECK = 1
_ANSIBLE_PLAYBOOK_DIFF = 1
endif

# Verbose
ifdef VERBOSE
_ANSIBLE_PLAYBOOK_VERBOSE_MORE = 1
endif

# Limit
ifdef LIMIT
_ANSIBLE_PLAYBOOK_LIMIT = $(LIMIT)
else
_ANSIBLE_PLAYBOOK_LIMIT = development
endif

# Internal usage:
#   $(_ansible_galaxy_collection_install) [REQUIREMENTS]

define _ansible_galaxy_collection_install
	ansible-galaxy collection install \
		--upgrade \
		--requirements-file
endef

# Internal usage:
#   $(_ansible_playbook) [PLAYBOOK]

define _ansible_playbook
	ansible-playbook \
		$(if $(_ANSIBLE_PLAYBOOK_INVENTORY),--inventory $(_ANSIBLE_PLAYBOOK_INVENTORY)) \
		$(if $(_ANSIBLE_PLAYBOOK_BECOME),--become) \
		$(if $(_ANSIBLE_PLAYBOOK_LIMIT),--limit $(_ANSIBLE_PLAYBOOK_LIMIT)) \
		$(if $(_ANSIBLE_PLAYBOOK_EXTRA_VARS),--extra-vars $(_ANSIBLE_PLAYBOOK_EXTRA_VARS)) \
		$(if $(_ANSIBLE_PLAYBOOK_TAGS),--tags $(_ANSIBLE_PLAYBOOK_TAGS)) \
		$(if $(_ANSIBLE_PLAYBOOK_CHECK),--check) \
		$(if $(_ANSIBLE_PLAYBOOK_DIFF),--diff) \
		$(if $(_ANSIBLE_PLAYBOOK_VERBOSE_MORE),-vvv)
endef
