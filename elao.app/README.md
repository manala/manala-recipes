# Elao - App

* [Requirements](#requirements)
* [Overview](#overview)
* [Quick start](#quick-start)
* [System](#system)
* [Integration](#integration)
* [Releases](#releases)
* [Makefile](#makefile)
* [Secrets](#secrets)

## Requirements

* Docker Desktop 2.2.0+

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
    # MariaDB
    mariadb:
        version: 10.4
    # ...*OR* MySQL...
    mysql:
        version: 5.7
    elasticsearch:
        version: 7
        plugins:
          - analysis-icu
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

Here are some examples of integration configurations in `.manala.yaml`:

```yaml
###############
# Integration #
###############

integration:
    tasks:
      - shell: make install@integration
      - label: Integration
        junit: report/junit/*.xml
        parallel: true
        warn: true
        tasks:
          - label: Lint
            tasks:
              - shell: make lint.php-cs-fixer@integration
              - shell: make lint.twig@integration
              - shell: make lint.yaml@integration
              - shell: make lint.eslint@integration
          - label: Security
            tasks:
              - shell: make security.symfony@integration
              - shell: make security.yarn@integration
          - label: Test
            tasks:
              - shell: make test.phpunit@integration
                artifacts: var/log/*.log
                env:
                    DATABASE_URL: mysql://root@127.0.0.1:3306/app
```

In this example we have two parallel stages: `api` and `mobile`, corresponding to two different sub-apps.

```yaml
###############
# Integration #
###############

integration:
    tasks:
      - label: Integration # Optionnal
        parallel: true # ! Careful ! Could *NOT* be nested !
        junit: report/junit/*.xml
        artifacts: var/log/*.log
        warn: true # Turn errors into warnings (recursively applied)
        tasks:
          - app: api # Optionnal
            tasks:
              - shell: make install@integration
              - shell: make build@integration
              - shell: make lint.php-cs-fixer@integration
              - shell: make security.symfony@integration
              - shell: make test.phpunit@integration
                artifacts: var/log/*.log
                env:
                    DATABASE_URL: mysql://root@127.0.0.1:3306/app
          - app: mobile
            tasks:
              - shell: make install@integration
              - shell: make build@integration
              - shell: make lint.eslint@integration
              - shell: make test.jest@integration
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
	npm install --no-audit --no-progress --color=always
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
	bin/console lint:yaml config translations --ansi --no-interaction

lint.eslint@integration:
	npx eslint src --format junit --output-file report/junit/eslint.xml

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

security.yarn@integration:
	yarn audit ; RC=$${?} ; [ $${RC} -gt 2 ] && exit $${RC} || exit 0

security.npm@integration:
	npm audit --audit-level moderate

########
# Test #
########

...

test.phpunit@integration: export APP_ENV = test
test.phpunit@integration:
	# Db
	bin/console doctrine:database:create --ansi
	bin/console doctrine:schema:create --ansi
	# PHPUnit
	bin/phpunit --colors=always --log-junit report/junit/phpunit.xml

test.jest@integration: export JEST_JUNIT_OUTPUT_DIR = report/junit
test.jest@integration: export JEST_JUNIT_OUTPUT_NAME = jest.xml
test.jest@integration:
	npx jest --ci --color --reporters=default --reporters=jest-junit

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
      - shell: sudo /bin/systemctl reload php7.4-fpm
      #- shell: sudo /bin/systemctl restart supervisor

  - << : *release
    mode: staging
    release_tasks:
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

### Git tools

This recipe contains some git helpers such as the [`git_diff`](./make/make.git.mk) function.

This function is useful for example to apply `php-cs`, `php-cs-fix` or `PHPStan` checks only on the subset of updated PHP files and not on any PHP file of your project.

Usage (in your `Makefile`):

```shell
lint.php-cs-fixer: DIFF = $(call git_diff, php, src tests)
lint.php-cs-fixer:
	$(if $(DIFF), \
		vendor/bin/php-cs-fixer fix --config=.php_cs.dist --path-mode=intersection --diff --dry-run $(DIFF), \
		printf "You have made no change in PHP files\n" \
	)
```

### Try tools

This recipe contains some try helpers such as the [`try_finally`](./make/make.try.mk) function.

This function is useful for example to run `phpunit` tests needing a started symfony server, and to stop this server regardless of the tests retur code.

Usage (in your `Makefile`):

```shell
test.phpunit@integration:
	symfony server:start --ansi --no-humanize --daemon --no-tls --port=8000
	$(call try_finally, \
		bin/phpunit --colors=always --log-junit report/junit/phpunit.xml, \
		symfony server:stop --ansi \
	)
```

## Secrets

In order to deploy secrets, you can use [Gomplate](https://docs.gomplate.ca), called by a make task.
Gomplate takes a template, queries its values from a Vault server and renders a file.

Add the following task in the `Makefile`:

```
###########
# Secrets #
###########

secrets/%: _secrets
	gomplate --config=secrets/$(*)
_secrets:
```

Put templates in a `secrets` directory at the root of the project.

Here is an example of template:

```.env.prod
%YAML 1.1
---

datasources:
  vault:
    url: vault+https://my-vault-server.com

outputFiles:
  - /path/to/rendered/file

in: |
  Loop on all values of the secret:
    {{ range $key, $value := (datasource "vault" "MyApp/data/env").data -}}
    {{ $key }} = {{ $value | quote }}
    {{ end -}}

  Query only one value of the secret:
    {{ (datasource "vault" "MyApp/data/env").data.value1 -}}
```

/!\ Note that the path to the secret will slightly differ from what the Vault server will display \
/!\ If the path is `MyApp/production/env` on the Vault server, it will become `MyApp/data/production/env` in the template

Gomplate uses [Go Template syntax](https://docs.gomplate.ca/syntax/)

To render the file, call the template with the `make secrets/%` task, where `%` is the name of the template.

```shell
make secrets/.env.prod
```
