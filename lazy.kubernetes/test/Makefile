.SILENT:

-include .manala/Makefile

_HADOLINT_VERSION = 2.12.0
_HADOLINT_IGNORE  = DL3008,SC1091

.manala:
	$(error Please, run "manala up" before)

########
# Lint #
########

## Lint - Hadolint validation (VERBOSE)
lint: .manala
	printf "\033[36mLint\033[0m [hadolint]\n"
	docker run \
		--rm \
		--interactive \
		$(if $(VERBOSE), --env HADOLINT_VERBOSE=1) \
		$(if $(_HADOLINT_IGNORE), --env HADOLINT_IGNORE=$(_HADOLINT_IGNORE)) \
		hadolint/hadolint:$(_HADOLINT_VERSION) \
			< .manala/docker/Dockerfile

########
# Test #
########

## Test - Gomplate validation
test: .manala
	printf "\033[36mTest\033[0m [gomplate]\n"
	$(call manala_docker_shell, goss \
		--vars .manala.yaml \
		validate \
		--color \
	)
