# Elao - App

* [Requirements](#requirements)
* [Overview](#overview)
* [Init](#init)
* [Quick start](#quick-start)
* [System](#system)
* [Integration](#integration)
    * [Jenkins](#jenkins)
    * [Github Actions](#github-actions)
    * [Common Integration Tasks](#common-integration-tasks)
* [Releases](#releases)
* [Makefile](#makefile)
* [Secrets](#secrets)
* [Tips, Tricks, and Tweaks](#tips-tricks-and-tweaks)

## Requirements

* Make
* Vagrant 2.2.10+
* Landrush 1.3.2+
* VirtualBox 6.1.12+
* Docker Desktop 2.2.0+

## Overview

This recipe contains some helpful scripts in the context of a php/nodejs app, such as Makefile tasks in order to release and deploy your app.


## Init

```
$ cd [workspace]
$ manala init -i elao.app [project]
```

## Quick start

In a shell terminal, change directory to your app, and run the following commands:

```shell
cd /path/to/my/app
manala init
Select the "elao.app" recipe
```

Edit the `Makefile` at the root directory of your project and add the following lines at the beginning of the file:

```makefile
.SILENT:

-include .manala/Makefile
```

Then update the `.manala.yaml` file (see [the releases example](#releases) below) and then run the `manala up` command:

```shell
manala up
```

!!! Warning
    Don't forget to run the `manala up` command each time you update the 
    `.manala.yaml` file to actually apply your changes !!!

From now on, if you execute the `make help` command in your console, you should obtain the following output:

```shell
Usage: make [target]

Help:
  help This help

Docker:
  docker Run docker container

App:
```

## VM interaction

In your app directory.

Initialise your app:
```bash
make setup
```

Start VM:
```bash
make up
```

Stop VM:
```bash
make halt
```

VM shell:
```bash
make ssh
```


## System

Here is an example of a system configuration in `.manala.yaml`:

```yaml
##########
# System #
##########

system:
    version: 10
    hostname: app.vm
    #memory: 4096 # Optional
    #cpus: 2 # Optional
    #motd: # Optional
    #    template: motd/cow.j2
    #    message: Foo bar
    #timezone: Etc/UTC # Optional
    #locales: # Optional
    #    default: C.UTF-8
    #    codes: []
    #env: # Optional
    #    FOO: bar
    apt:
        #repositories: [] # Optional
        #preferences: [] # Optional
        packages:
          - pdftk
          - https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.stretch_amd64.deb
    files:
      - path: /srv/app/var/log
        src: /srv/log
        state: link_directory
      - path: /srv/app/var/cache
        src: /srv/cache
        state: link_directory
      #- path: /srv/app/var/sessions
      #  src: /srv/sessions
      #  state: link_directory
      ## Api
      #- path: /srv/app/api/var/log
      #  src: /srv/log/api
      #  state: link_directory
      #- path: /srv/app/api/var/cache
      #  src: /srv/cache/api
      #  state: link_directory
    #network: # Optional
    #    hosts:
    #        127.0.0.1: foo.fr foobar.fr
    nginx:
        configs: []
        # configs:
        #     - template: nginx/gzip.j2
        #     #- template: nginx/cors.j2
        #     #- template: nginx/no_index.j2
        #     - template: nginx/php_fpm_app.j2
        #     # App
        #     - file: app.conf
        #       config: |
        #           server {
        #               server_name ~.;
        #               root /srv/app/public;
        #               access_log /srv/log/nginx.access.log;
        #               error_log /srv/log/nginx.error.log;
        #               include conf.d/gzip;
        #               location / {
        #                   try_files $uri /index.php$is_args$args;
        #               }
        #               location ~ ^/index\.php(/|$) {
        #                   include conf.d/php_fpm_app;
        #                   internal;
        #               }
        #           }
    php:
        version: "8.0"
        # composer:
        #   version: 1 # Optional
        extensions:
          # Symfony
          - intl
          - curl
          - mbstring
          - xml
          # App
          - mysql
        configs:
          - template: php/opcache.ini.j2
          - template: php/app.ini.j2
            config:
                date.timezone: UTC
                upload_max_filesize: 16M
                post_max_size: 16M
    nodejs:
        version: 14
        # packages:
        #   - package: mjml
        #     version: 4.6.3
    # cron:
    #     files:
    #       - file: app
    #         env:
    #           HOME: /srv/app
    #         jobs:
    #           # Foo - Bar
    #           - command: php bin/console app:foo:bar --no-interaction -vv >> /srv/log/cron.foo-bar.log 2>&1
    #             minute: 0
    #             # Dev
    #             state: absent
    # supervisor:
    #     configs:
    #       - file: app.conf
    #         #groups:
    #         #    acme:
    #         #        programs:
    #         #          - foo
    #         #          - bar
    #         programs:
    #             foo:
    #                 command: php bin/console app:acme:foo --no-interaction -vv
    #                 directory: /srv/app
    #                 stdout_logfile: /srv/log/supervisor.acme-foo.log
    #             bar:
    #                 command: php bin/console app:acme:bar --no-interaction -vv
    #                 directory: /srv/app
    #                 stdout_logfile: /srv/log/supervisor.acme-bar.log
    #             foo-bar:
    #                 command: php bin/console app:foo:bar --no-interaction -vv
    #                 directory: /srv/app
    #                 stdout_logfile: /srv/log/supervisor.foo-bar.log
    #       - file: app_foo.conf
    #         config: |
    #             [program:foo]
    #             command=/bin/foo
    # MariaDB
    mariadb:
        version: 10.5
    # ...*OR* MySQL...
    mysql:
        version: "8.0"
    # redis:
    #     version: "*"
    #     # config:
    #     #     save: '""' # Disable persistence
    elasticsearch:
        version: 7
        plugins:
          - analysis-icu
    # influxdb:
    #     version: "*"
    #     config:
    #       reporting-disabled: true
    #     databases:
    #       - app
    #     users:
    #       - database: app
    #         name: app
    #         password: app
    #     privileges:
    #       - database: app
    #         user: app
    #         grant: ALL
    # mongodb:
    #     version: 4.4
    ssh:
        client:
            config: |
                Host *.elao.run
                    User app
                    ForwardAgent yes
```


## Integration

### Jenkins

Here are some examples of integration configurations in `.manala.yaml` for Jenkins:

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
                # artifacts:
                #   - var/log/foo.log
                #   - var/log/bar.log
                # env:
                #     DATABASE_URL: mysql://root@127.0.0.1:3306/app
```

In this example we have two parallel stages: `api` and `mobile`, corresponding to two different sub-apps.

```yaml
###############
# Integration #
###############

integration:
    tasks:
      - label: Integration # Optional
        parallel: true # ! Careful ! Could *NOT* be nested !
        junit: report/junit/*.xml
        artifacts: var/log/*.log
        warn: true # Turn errors into warnings (recursively applied)
        tasks:
          - app: api # Optional
            tasks:
              - shell: make install@integration
              - shell: make build@integration
              - shell: make lint.php-cs-fixer@integration
              - shell: make security.symfony@integration
              - shell: make test.phpunit@integration
                artifacts: var/log/*.log
                # env:
                #     DATABASE_URL: mysql://root@127.0.0.1:3306/app
          - app: mobile
            tasks:
              - shell: make install@integration
              - shell: make build@integration
              - shell: make lint.eslint@integration
              - shell: make test.jest@integration
```

### Github Actions

The recipes generates a `Dockerfile` and a `docker-compose.yaml` file that can 
be used to provide a fully-fledged environnement according to your project needs.

The [Elao/manala-ci-action](https://github.com/Elao/manala-ci-action) rely on 
this to allow you running any CLI command in this environnement, 
using Github Action workflows.

### Common integration tasks

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
	npm install --color=always --no-progress --no-audit
	# Yarn
	yarn install --color=always --no-progress

###########
# Build #
###########

...

build@integration:
	# Webpack Encore
	npx encore production --color=always --no-progress

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
    #app: api # Optional
    mode: production
    repo: git@git.elao.com:<vendor>/<app>-release.git
    #ref: master # Based on app/mode by default
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
    #deploy_removed:
    #  - web/app_dev.php
    deploy_post_tasks:
      - shell: sudo /bin/systemctl reload php8.0-fpm
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

```makefile
foo: SHELL := $(or $(DOCKER_SHELL),$(SHELL))
foo:
	# Do something really foo...
```

Ssh
```makefile
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
```makefile
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

This recipe contains some git helpers such as the [`git_diff`](./.manala/make/git.mk) function.

This function is useful for example to apply `php-cs`, `php-cs-fix` or `PHPStan` checks only on the subset of updated PHP files and not on any PHP file of your project.

Usage (in your `Makefile`):

```makefile
lint.php-cs-fixer: DIFF = $(call git_diff, php, src tests)
lint.php-cs-fixer:
	$(if $(DIFF), \
		vendor/bin/php-cs-fixer fix --config=.php_cs.dist --path-mode=intersection --diff --dry-run $(DIFF), \
		printf "You have made no change in PHP files\n" \
	)
```

### Try tools

This recipe contains some try helpers such as the [`try_finally`](./.manala/make/try.mk) function.

This function is useful for example to run `phpunit` tests needing a started symfony server, and to stop this server regardless of the tests retur code.

Usage (in your `Makefile`):

```makefile
test.phpunit@integration:
	symfony server:start --ansi --no-humanize --daemon --no-tls --port=8000
	$(call try_finally, \
		bin/phpunit --colors=always --log-junit report/junit/phpunit.xml, \
		symfony server:stop --ansi \
	)
```

## Secrets

In order to generate secrets, use [Gomplate](https://docs.gomplate.ca), called by a make task.
Gomplate takes a template, queries its values from a Vault server and renders a file.

Add the following tasks in the `Makefile`:

```makefile
###########
# Secrets #
###########

secrets@production:
	gomplate --input-dir=secrets/production --output-map='{{ .in | replaceAll ".gohtml" "" }}'

secrets@staging:
	gomplate --input-dir=secrets/staging --output-map='{{ .in | replaceAll ".gohtml" "" }}'
```

Put your templates in `.gohtml` files inside a `secrets/[production|staging]` directory at the root of the project.  
Respect destination file names, extensions, and paths:

```treeview
secrets/
├── production/
|   ├── .env.gohtml
|   └── config/
|       └── parameters.yaml.gohtml
└── staging/
    ├── .env.gohtml
    └── config/
        └── parameters.yaml.gohtml
```

Here are some template examples:

`production/.env.gohtml`:

```twig
# This file was generated by Gomplate from Vault secrets for production
{{- range $key, $value := (datasource "vault:///foo_bar/data/env").data }}
{{ $key }}={{ $value | quote }}
{{- end }}
```

`staging/.env.gohtml`:

```twig
# This file was generated by Gomplate from Vault secrets for staging
{{- range $key, $value := (datasource (print "vault:///foo_bar/data/env" (has .Env "STAGE" | ternary (printf "-%s" (getenv "STAGE")) ""))).data }}
{{ $key }}={{ $value | quote }}
{{- end }}
```

Note the `STAGE` environnement variable usage, allowing to switch from `env` to `env-${STAGE}` vault secret, calling `make secrets@staging STAGE=foo`.

`production/config/parameters.yaml.gohtml`:

```twig
# This file was generated by Gomplate from Vault secrets for production
parameters:
{{ (datasource "vault:///foo_bar/data/parameters").data | toYAML | indent 4 -}}
```

!!! Note
    Note that the path to the secret will slightly differ from what the Vault server will display:    
    if the path is `MyApp/production/env` on the Vault server, 
    it will become `MyApp/data/production/env` in the template

See [Go Template syntax](https://docs.gomplate.ca/syntax/) for more info.

!!! Warning
    Make sure to include the `secrets` directory into your release, using the `release_add` entry.

## Tips, Tricks, and Tweaks

* [Vagrant root privilege requirement](https://www.vagrantup.com/docs/synced-folders/nfs.html#root-privilege-requirement)
* Debug ansible provisioning:

  ```shell
  ansible-galaxy collection install manala.roles --collections-path /vagrant/ansible/collections
  ```
* Update vagrant boxes
  ```
  vagrant box outdated --global
  vagrant box update --box bento/debian-10
  ```
