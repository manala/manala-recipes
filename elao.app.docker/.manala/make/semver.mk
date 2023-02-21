# Prerequisites:
#   - Mandatory include git.mk

##########
# Semver #
##########

define manala_semver_bump
	VERSION=$(2) ; \
	if [ -z "$${VERSION}" ]; then \
		printf "$(MANALA_COLOR_INFO)What's the version number? (current: $(MANALA_COLOR_COMMENT)`cat $(firstword $(1))`$(MANALA_COLOR_INFO))$(MANALA_COLOR_RESET)\n" ; \
		read VERSION ; \
		if [ -z $${VERSION} ]; then \
        printf "$(MANALA_COLOR_ERROR) ❌ Version cannot be empty. Aborting$(MANALA_COLOR_RESET)\n" ; \
        exit 128 ; \
    fi ; \
	fi ; \
	printf "$(MANALA_COLOR_INFO)Bumping version $(MANALA_COLOR_COMMENT)$${VERSION}$(MANALA_COLOR_INFO)…$(MANALA_COLOR_RESET)\n" ; \
	for file in $(1) ; \
	do \
		echo $${VERSION} > $${file} ; \
	done ; \
	$(MANALA_GIT_BIN) add $(1) ; \
	$(MANALA_GIT_BIN) commit -m "Bump version $${VERSION}" ; \
	$(MANALA_GIT_BIN) diff HEAD^ HEAD --color | cat
endef
