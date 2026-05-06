.SILENT:
.PHONY: build

###########
# Install #
###########

## Install dependencies
install:
	symfony composer install
	npm install

###############
# Development #
###############

## Start the whole application for development purposes (local only)
serve:
	# https://www.npmjs.com/package/concurrently
	npx concurrently "make start" "make watch" --names="Symfony,Webpack" --prefix=name --kill-others --kill-others-on-fail

## Start Symfony server
start:
	symfony server:start --no-tls

## Start webpack watcher
watch:
	npx encore dev --watch

clear:
	rm -rf build public/build

#########
# Build #
#########

## Build assets
build.assets:
	npm run build

## Build static site content
build.content: export APP_ENV = prod
build.content:
	symfony console cache:clear
	symfony console stenope:build

## Build static site content and assets
build.static: build.assets build.content

serve.static:
	open http://localhost:8001
	php -S localhost:8001 -t build

########
# Lint #
########

lint: lint.php-cs-fixer lint.twig lint.yaml lint.container lint.composer lint.styles

lint.styles:
	npx stylelint 'assets/**/*.scss'

lint.composer:
	symfony composer validate --no-check-publish

lint.container:
	symfony console lint:container

lint.php-cs-fixer:
	rm ./config/reference.php
	symfony php vendor/bin/php-cs-fixer fix

lint.twig:
	symfony console lint:twig templates --show-deprecations

lint.yaml:
	symfony console lint:yaml config --parse-tags
