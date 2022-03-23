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
	npx concurrently "make serve.php" "make serve.assets" --names="Symfony,Webpack" --prefix=name --kill-others --kill-others-on-fail

## Start Symfony server
serve.php:
	symfony server:start --no-tls

## Start webpack dev server with HMR (Hot reload)
serve.assets:
	npx encore dev-server --mode=development

clear:
	rm -rf build public/build

#########
# Build #
#########

## Build assets
build.assets:
	npm run build

## Build static site
build.static: export APP_ENV = prod
build.static:
	symfony console cache:clear
	symfony console stenope:build

serve.static:
	open http://localhost:8001
	php -S localhost:8001 -t build

########
# Lint #
########

lint: lint.php-cs-fixer lint.twig lint.yaml lint.container lint.composer

lint.composer:
	symfony composer validate --no-check-publish

lint.container:
	symfony console lint:container

lint.php-cs-fixer:
	symfony php vendor/bin/php-cs-fixer fix

lint.twig:
	symfony console lint:twig templates --show-deprecations

lint.yaml:
	symfony console lint:yaml config --parse-tags
