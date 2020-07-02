###########
# Vagrant #
###########

define vagrant_ssh
	vagrant ssh --command "cd /srv/app/$(_DIR) && $(if $(strip $(1)),$(strip $(1)),exec $${SHELL})"
endef
