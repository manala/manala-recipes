##########
# Colors #
##########

COLOR_RESET   := \033[0m
COLOR_ERROR   := \033[31m
COLOR_INFO    := \033[32m
COLOR_WARNING := \033[33m
COLOR_COMMENT := \033[36m

###########
# Helpers #
###########

# Usage:
#   $(if $(FOO), Foo$(,) bar) = Foo, bar

, := ,

###########
# Message #
###########

# Usage:
#   $(call message, Foo bar)         = Foo bar
#   $(call message_success, Foo bar) = (っ◕‿◕)っ Foo bar
#   $(call message_warning, Foo bar) = ¯\_(ツ)_/¯ Foo bar
#   $(call message_error, Foo bar)   = (╯°□°)╯︵ ┻━┻ Foo bar

define message
	printf "$(COLOR_INFO)$(strip $(1))$(COLOR_RESET)\n"
endef

define message_success
	printf "$(COLOR_INFO)(っ◕‿◕)っ $(strip $(1))$(COLOR_RESET)\n"
endef

define message_warning
	printf "$(COLOR_WARNING)¯\_(ツ)_/¯ $(strip $(1))$(COLOR_RESET)\n"
endef

define message_error
	printf "$(COLOR_ERROR)(╯°□°)╯︵ ┻━┻ $(strip $(1))$(COLOR_RESET)\n"
endef

###########
# Confirm #
###########

# Usage:
#   $(call confirm, Foo bar) = ༼ つ ◕_◕ ༽つ Foo bar (y/N):

define confirm
	$(if $(CONFIRM),, \
		printf "$(COLOR_INFO) ༼ つ ◕_◕ ༽つ $(COLOR_WARNING)$(strip $(1)) $(COLOR_RESET)$(COLOR_WARNING)(y/N)$(COLOR_RESET): "; \
		read CONFIRM ; if [ "$$CONFIRM" != "y" ]; then printf "\n"; exit 1; fi; \
	)
endef
