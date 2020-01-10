# Elao - App

* [Overview](#overview)
* [Quick start](#quick-start)
* [System](#system)
* [Integration](#integration)
* [Releases](#releases)
* [Makefile](#makefile)
* [Git tools](#git-tools)

## Overview

This recipe contains some helpful scripts in the context of a php/nodejs app, such as Makefile tasks in order to release and deploy your app.

## Quick start

In a shell terminal, change directory to your app, and run the following commands:

```shell
    $ cd /path/to/my/app
    $ manala init
    # Select the "elao.app" recipe
```

Edit the `Makefile` at the root directory of your project and add the following lines at the beginning of the file:

```
.SILENT:

-include .manala/make/Makefile
```

Then update the `.manala.yaml` file (see [the releases example](#releases) below) and then run the `manala up` command:

```
    $ manala up
```

> :warning: don't forget to run the `manala up` command each time you update the `.manala.yaml` file to actually apply your changes !!!

From now on, if you execute the `make help` command in your console, you should obtain the following output:

```shell
Usage: make [target]

Help:
  help This help

Docker:
  docker Run docker container

App:
```

## System

Here is an example of a system configuration in `.manala.yaml`:

```yaml
##########
# System #
##########

system:
    version: 9
    hostname: app.vm
    php:
        version: 7.3
        extensions:
          # Symfony
          - intl
          - curl
          - mbstring
          - xml
          # App
          - mysql
    symfony:
        version: "*"
    nodejs:
        version: 12
    # MySQL...
    mysql:
        version: 5.7
    # ...*OR* MariaDB
    mariadb:
        version: 10.3
    apt:
        packages:
          - pdftk
          - https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb
    ssh:
        config: |
            Host *.elao.run
                User         app
                ForwardAgent yes
            Host *.elao.local
                User         app
                ForwardAgent yes
                ProxyCommand ssh gateway@bastion.elao.com -W %h:%p
```


## Integration

Here is an example of an integration configuration in `.manala.yaml`:

In this example we have two tracks : `/api` and `/mobile`, corresponding to two different sub-projects.
On each sub-project we have _install_, _lint_ and _test_ stages.

```yaml
###############
# Integration #
###############

integration:
    tasks:
      - label: Integration # Optionnal
        parallel: true # ! Careful ! Could *NOT* be nested !
        junit: report/junit/*.xml # Optionnal
        tasks:
          - app: api # Optionnal
            tasks:
              - shell: make install@integration
              - shell: make lint@integration
              - shell: make test@integration
                warn: true # Errors will be treated as warnings
                env:
                    DATABASE_URL: mysql://root@127.0.0.1:3306/app
          - app: mobile
            tasks:
              - shell: make install@integration  
              - shell: make lint@integration
              - shell: make test@integration
                warn: true
```

Add in your `Makefile`:

```makefile
###########
# Install #
###########

...

install@integration: export APP_ENV = test
install@integration:
	# Composer
	composer install --ansi --verbose --no-interaction --no-progress --prefer-dist --optimize-autoloader --no-scripts --ignore-platform-reqs
	#composer run-script symfony-scripts --ansi --verbose --no-interaction
	# Npm
	npm install --no-progress --color=always
	# Yarn
	yarn install --no-progress --color=always

###########
# Build #
###########

...

build@integration:
	# Webpack Encore
	npx encore production --no-progress --color=always

########
# Lint #
########

...

lint.php-cs-fixer@integration:
	mkdir -p report/junit
	vendor/bin/php-cs-fixer fix --dry-run --diff --format=junit > report/junit/php-cs-fixer.xml

lint.phpstan@integration:
	mkdir -p report/junit
	vendor/bin/phpstan --error-format=junit --no-progress --no-interaction analyse > report/junit/phpstan.xml

lint.twig@integration:
	bin/console lint:twig templates --ansi --no-interaction

lint.yaml@integration:
	bin/console lint:yaml translations config --ansi --no-interaction

lint.eslint@integration: export ESLINT_JUNIT_OUTPUT=report/junit/eslint.xml
lint.eslint@integration:
	npx eslint src/* --ext .js,.json -f ./node_modules/eslint-junit/index.js

lint.stylelint@integration:
	mkdir -p report/junit
	npx stylelint "assets/styles/**/*.scss" \
		--syntax scss \
		--custom-formatter "node_modules/stylelint-junit-formatter" \
		> report/junit/stylelint.xml

lint.flow@integration:
	mkdir -p report/junit
	npx flow check --json | npx flow-junit-transformer > report/junit/flow.xml

############
# Security #
############

...

security.symfony@integration:
	symfony check:security

########
# Test #
########

...

test.phpunit@integration: export APP_ENV = test
test.phpunit@integration:
	# Db
	bin/console doctrine:database:drop --ansi --if-exists --force
	bin/console doctrine:database:create --ansi
	bin/console doctrine:schema:create --ansi
	# PHPUnit
	mkdir -p report/junit
	bin/phpunit --log-junit report/junit/phpunit.xml

test.jest@integration: export JEST_JUNIT_OUTPUT_DIR=report/junit
test.jest@integration: export JEST_JUNIT_OUTPUT_NAME=jest.xml
test.jest@integration:
	npx jest --ci --reporters=default --reporters=jest-junit

```

## Releases

Here is an example of a production/staging release configuration in `.manala.yaml`:

```yaml
############
# Releases #
############

releases:

  - &release
    #app: api # Optionnal
    mode: production
    repo: git@git.elao.com:<vendor>/<app>-release.git
    # Release
    release_tasks:
      - shell: make install@production
      - shell: make build@production
    # You can either explicitly list all the paths you want to include
    release_add:
      - bin
      - config
      - public
      - src
      - templates
      - translations
      - vendor
      - composer.* # Composer.json required by src/Kernel.php to determine project root dir
                   # Composer.lock required by composer on post-install (warmup)
      - Makefile

    # Or you can include all by default and only list the paths you want to exclude
    # release_removed:
    #   - ansible
    #   - build
    #   - doc
    #   - node_modules
    #   - tests
    #   - .env.test
    #   - .php_cs.dist
    #   - .manala*
    #   - package.json
    #   - phpunit.xml.dist
    #   - README.md
    #   - Vagrantfile
    #   - webpack.config.js
    #   - yarn.lock

    # Deploy
    deploy_hosts:
      - ssh_host: foo-01.bar.elao.local
        #master: true # Any custom variable are welcomed
      - ssh_host: foo-02.bar.elao.local
    deploy_dir: /srv/app
    deploy_shared_files:
      - config/parameters.yml
    deploy_shared_dirs:
      - var/log
    deploy_tasks:
      - shell: make warmup@production
      #- shell: make migration@production
      #  when: master | default # Conditions on custom host variables (jinja2 format)
    deploy_post_tasks:
      - shell: sudo systemctl reload php7.3-fpm

  - << : *release
    mode: staging
    tasks:
      - shell: make install@staging
      - shell: make build@staging
    # Deploy
    deploy_hosts:
      - ssh_host: foo.bar.elao.ninja.local
    deploy_tasks:
      - shell: make warmup@staging
```

## Makefile

Makefile targets that are supposed to be runned via docker must be prefixed.

```
foo: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
foo:
	# Do something really foo...
```

Ssh
```
#######
# Ssh #
#######

## Ssh to staging server
ssh@staging: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
ssh@staging:
	ssh app@foo.staging.elao.run

# Single host...

ssh@production: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
ssh@production:
	...

# Multi host...

ssh@production-01: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
ssh@production-01:
	...
```

Sync
```
sync@staging: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
sync@staging:
	mkdir -p var
	rsync --archive --compress --verbose --delete-after \
		app@foo.staging.elao.run:/srv/app/current/var/files/ \
		var/files/

# Multi targets...
sync-uploads@staging: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
sync-uploads@staging:
  ...

# Multi apps...
sync.api-uploads@staging: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
sync.api-uploads@staging:
  ...
```

## Git tools

The `elao.app` recipe contains some git helpers such as the [`git_diff`](./make/make.git.mk) task.

This task is useful for example to apply `php-cs`, `php-cs-fix` or `PHPStan` checks only on the subset of updated PHP files and not on any PHP file of your project.

Usage (in your `Makefile`):

```shell
lint.php-cs-fixer: DIFF = $(call git_diff, php, src tests)
lint.php-cs-fixer:
	$(if $(DIFF), \
		vendor/bin/php-cs-fixer fix --config=.php_cs.dist --path-mode=intersection --diff --dry-run $(DIFF), \
		printf "You have made no change in PHP files\n" \
	)
```
