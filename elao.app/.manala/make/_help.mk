########
# Help #
########

HELP_INDENT ?= 20

HELP = \
	\nUsage: make [$(MANALA_COLOR_INFO)target$(MANALA_COLOR_RESET)]\n \
	$(call help_section,Help) \
	$(call help,help,This help) \
	\n

define help_section
	\n$(COLOR_COMMENT)$(1):$(COLOR_RESET)
endef

define help
  \n  $(COLOR_INFO)$(1)$(COLOR_RESET) $(2)
endef

help:
	@printf "$(HELP)$(HELP_SUFFIX)"
	awk '/^[a-zA-Z\-\_0-9\.@%\/]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "\n  $(COLOR_INFO)%-$(HELP_INDENT)s$(COLOR_RESET) %s", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@printf "\n\n"

.PHONY: help
