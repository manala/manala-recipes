.SILENT:

-include .manala/Makefile

define setup
	$(VAGRANT_MAKE) install build
endef

###########
# Install #
###########

## Install application
install:
	# # Composer
	# composer install --ansi --verbose
	# # Doctrine
	# bin/console doctrine:database:create --ansi --if-not-exists
	# # Npm
	# npm install --color=always
	# # Yarn
	# yarn install --color=always

install@production: export APP_ENV = prod
install@production:
	# # Composer
	# composer install --ansi --verbose --no-interaction --no-progress --prefer-dist --optimize-autoloader --no-scripts --no-dev
	# # Npm
	# npm install --color=always --no-progress --no-audit
	# # Yarn
	# yarn install --color=always --no-progress

install@staging: export APP_ENV = prod
install@staging:
	# # Composer
	# composer install --ansi --verbose --no-interaction --no-progress --prefer-dist --optimize-autoloader --no-scripts
	# # Npm
	# npm install --color=always --no-progress --no-audit
	# # Yarn
	# yarn install --color=always --no-progress

#########
# Build #
#########

## Build application
build:
	# npx encore dev --color=always

build@production:
	# npx encore production --color=always --no-progress

build@staging:
	# npx encore production --color=always --no-progress

#########
# Watch #
#########

## Watch application
watch:
	# npx encore dev --color=always --watch --watch-poll

#######
# App #
#######

# ...
