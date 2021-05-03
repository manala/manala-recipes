###########
# Vagrant #
###########

define VAGRANT_SSH
	vagrant ssh -- cd /srv/app/$(_CURRENT_DIR) \&\&
endef

ifneq ($(container),vagrant)
VAGRANT_MAKE = $(VAGRANT_SSH) make
else
VAGRANT_MAKE = $(MAKE)
endif
