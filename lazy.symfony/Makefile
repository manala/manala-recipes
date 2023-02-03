.SILENT:
.PHONY: lint test

_DOCKER_IMAGE = manala-recipes/$(notdir $(CURDIR))

_HADOLINT_VERSION = 2.12.0
_HADOLINT_IGNORE  = DL3008,SC1091

_DGOSS_VERSION = 0.3.21

########
# Lint #
########

## Lint (VERBOSE)
lint:
	printf "\033[36mLINT\033[0m [manala update]\n"
	manala update test/fixtures
	printf "\033[36mLINT\033[0m [hadolint]\n"
	docker run \
		--rm \
		--interactive \
		$(if $(VERBOSE), --env HADOLINT_VERBOSE=1) \
		$(if $(_HADOLINT_IGNORE), --env HADOLINT_IGNORE=$(_HADOLINT_IGNORE)) \
		hadolint/hadolint:$(_HADOLINT_VERSION) \
			< test/fixtures/.manala/docker/Dockerfile

########
# Test #
########

## Test
test:
	printf "\033[36mTEST\033[0m [manala update]\n"
	manala update test/fixtures
	printf "\033[36mTEST\033[0m [docker build]\n"
	docker build \
		--tag $(_DOCKER_IMAGE) \
		--file test/fixtures/.manala/docker/Dockerfile \
		test/fixtures/.manala
	printf "\033[36mTEST\033[0m [dgoss run]\n"
	docker run \
		--rm \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		--volume $(CURDIR)/test/goss.yaml:/goss/goss.yaml \
		--volume $(CURDIR)/test/fixtures/.manala.yaml:/goss/.manala.yaml \
		--env GOSS_FILES_PATH=/goss \
		--env GOSS_FILES_STRATEGY=cp \
		--env GOSS_VARS=.manala.yaml \
		--env GOSS_SLEEP=0.2 \
		chatwork/dgoss:$(_DGOSS_VERSION) \
			run \
				$(_DOCKER_IMAGE) tail -f /dev/null
