# Prerequisites:
#   - Mandatory include docker.mk
#   - Mandatory .manala/docker/compose/mutagen.yaml

###########
# Mutagen #
###########

# See: https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2020882.html
MANALA_MUTAGEN_COMPOSE_BIN = $(shell command -v mutagen-compose 2>/dev/null)

MANALA_DOCKER_COMPOSE_BIN = $(if $(MANALA_MUTAGEN_COMPOSE_BIN), \
	$(MANALA_MUTAGEN_COMPOSE_BIN), \
	$(MANALA_DOCKER_COMPOSE_BIN_DEFAULT) \
)

MANALA_DOCKER_COMPOSE_FILE_MUTAGEN = $(MANALA_DIR)/.manala/docker/compose/mutagen.yaml
MANALA_DOCKER_COMPOSE_FILE += $(if $(MANALA_MUTAGEN_COMPOSE_BIN), $(MANALA_DOCKER_COMPOSE_FILE_MUTAGEN))
