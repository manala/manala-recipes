###########
# Vagrant #
###########

define VAGRANT_SSH
	vagrant ssh -- cd /srv/app/$(_CURRENT_DIR) \&\&
endef

ifeq ($(container),vagrant)
VAGRANT = 1
VAGRANT_MAKE = $(MAKE)
else
VAGRANT_MAKE = $(VAGRANT_SSH) make
endif
