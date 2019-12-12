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
  nodejs:
    version: 12
  ssh:
    config: |
      Host *.elao.run
        User         app
        ForwardAgent yes
      Host *.elao.local
        User         app
        ForwardAgent yes
        ProxyCommand ssh gateway@bastion.elao.com -W %h:%p
  apt:
    packages:
      - pdftk
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
  stages:
    - label: Integration
      tracks:
        - #label: MyApi # Optionnal
          #app: api # Optionnal
          #app_dir: api # Optionnal, <app> by default
          steps:
            - label: Install
              tasks:
                - make install@integration
            - label: Lint
              tasks:
                - make lint@integration
            - label: Test
              tasks:
                - make test@integration
        - app: mobile
          steps:
            - label: Install
              tasks:
                - make install@integration
            - label: Lint
              tasks:
                - make lint@integration
            - label: Test
              tasks:
                - make test@integration
```

Add in your `api/Makefile`:

```makefile
###########
# Install #
###########
#...

install@integration: export SYMFONY_ENV = test
install@integration:
	# Composer
	composer install --verbose --no-progress --no-interaction --no-scripts

########
# Lint #
########
# ...

lint@integration:
	mkdir --parents report/junit
	vendor/bin/php-cs-fixer fix --dry-run --diff --format=junit > report/junit/php-cs-fixer.xml

########
# Test #
########
# ...

test@integration: export SYMFONY_ENV = test
test@integration:
	# Update DB if schema differs:
	APP_DEBUG=1 bin/console doctrine:schema:update -q 2> /dev/null || \
	(\
		(bin/console doctrine:database:drop --ansi --force --if-exists 2> /dev/null || true) && \
		bin/console doctrine:database:create --ansi --if-not-exists && \
		bin/console doctrine:schema:update --ansi --force \
	)
	# PHPUnit
	mkdir --parents report/junit
	bin/phpunit --log-junit report/junit/phpunit.xml
```

Add in your `mobile/Makefile`:

```makefile
###########
# Install #
###########
#...

install@integration: export NODE_ENV = development
install@integration:
	yarn install

########
# Lint #
########
# ...

lint@integration: export ESLINT_JUNIT_OUTPUT=report/junit/eslint.xml
lint@integration:
	npx eslint src/* --ext .js,.json -f ./node_modules/eslint-junit/index.js

########
# Test #
########
# ...

test@integration: export JEST_JUNIT_OUTPUT_DIR=report/junit
test@integration: export JEST_JUNIT_OUTPUT_NAME=jest.xml
test@integration:
	npx jest --ci --reporters=default --reporters=jest-junit
```

_Note:_ You'll need `jest-junit` and `eslint-junit` packages :  `yarn --dev add eslint-junit jest-junit`.

## Releases

Here is an example of a production/staging release configuration in `.manala.yaml`:

```yaml
############
# Releases #
############

releases:

  - &release
    #app: api # Optionnal
    #app_dir: api # Optionnal, <app> by default
    env: production
    #env_branch: api/production # Optionnal, <app>/<env> by default
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
    env: staging
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
	mkdir --parents var
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
## Show code style errors in updated PHP files
cs:
ifeq ($(call git_diff, php, src tests),)
    echo "You have made no change in PHP files"
else
    vendor/bin/php-cs-fixer fix --config=.php_cs.dist --path-mode=intersection --dry-run --diff $(call git_diff, php, src tests)
endif
```
