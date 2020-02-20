# Manala directory
_MANALA_DIR := $(realpath $(patsubst %/make/common.mk,%,$(filter %.manala/make/common.mk,$(MAKEFILE_LIST))))

include $(_MANALA_DIR)/make/_text.mk
include $(_MANALA_DIR)/make/_help.mk
include $(_MANALA_DIR)/make/_os.mk
include $(_MANALA_DIR)/make/_try.mk
include $(_MANALA_DIR)/make/_git.mk
include $(_MANALA_DIR)/make/_semver.mk

#######
# App #
#######

HELP_SUFFIX += $(call help_section,App)
