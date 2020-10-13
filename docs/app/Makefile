.SILENT:
.PHONY: build

###########
# Install #
###########

## Install dependencies
install:
	composer install
	npm install

###############
# Development #
###############

## Start dev server
start:
	symfony server:start

## Watch assets
watch:
	npm run watch

clear:
	rm -rf build public/build

#########
# Build #
#########

## Build assets
build:
	npm run build

## Build static site
build-docs: export APP_ENV = prod
build-docs:
	bin/console cache:clear
	bin/console content:build

serve-docs:
	open http://localhost:8001
	php -S localhost:8001 -t build
