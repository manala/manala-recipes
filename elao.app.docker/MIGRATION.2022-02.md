# Migration - 2022-01

How to migrate from `elao.app` recipe, and basically from a vagrant to a docker stack.

## On a per-machine basis

These are the tasks required to cleanup local environments for each `elao.app` based project, before switching to `elao.app.docker`.

:warning: Ensure you're currently on a vagrant based git branch!

```shell
# Properly destroy vagrant machine
make destroy
# Remove local vagrant stuff
rm -Rf .manala/.vagrant
# Remove local cache
rm -Rf .manala/.cache
# Delete broken symlinks
find -L . -type l -exec rm -i {} \;
```

Once all of your local environment are clean, you can proudly uninstall vagrant, landrush and virtualbox if not needed elsewhere.

## On a per-project basis

These are the steps to migrate a project

### Manala

Change recipe name

```diff
  manala:
-     recipe: elao.app
+     recipe: elao.app.docker
```

### Project

Replace system.hostname by project.name in `.manala.yaml`, without forgetting to remove the `.vm` extension!

Set project.ports, multiple of 100, minimum 2000, maximum 65400

```
###########
# Project #
###########

project:
    name: foo-bar  # <-- Yep! That's it!
    ports: XXX00  # 20 < XXX < 654

...

system:
    ...
    hostname: foo-bar.vm  # <-- So 2021...
```

### System

In `.manala.yaml` system:
- `version` 8 (jessie) is no more available (time to upgrade dude, debian jessie is no more maintained)
- `version` 11 (bullseye) is now available \o/
- `memory` is no more available (vagrant related)
- `cpus` is no more available (vagrant related)

```diff
system:
    ...
-    version: 8  # <-- No...
+    version: 10  # <-- Yes!
-    memory: 4096 # <-- Please, no...
-    cpus: 2 # <-- No, no, no...
```

### Motd

Sorry, `motd` is no more supported in `.manala.yaml`... It was tightly coupled to `ssh`, which became useless using docker instead of vagrant.

```diff
system:
    ...
-    motd:  # <-- So long, farewell...
        ...
```

### Vagrant

- remove `.manala/Vagrantfile` file
- remove `.manala/vagrant` directory

### Apt packages

You can remove `tcpdump` from system.apt.packages in `.manala.yaml` as it's now available by default in the recipe

```diff
system:
    ...
    apt:
        ...
        packages:
            ...
-            - tcpdump <--- Kill! Kill! Kill!
```

### Docker

Remove `.manala/Dockerfile` file

Replace system.docker.containers entry in `.manala.yaml` by system.docker.services

```diff
  system:
      ...
      docker:
-         containers:
-             - name: statsd-exporter
-               image: prom/statsd-exporter
-               state: started
-               restart_policy: unless-stopped
-               env:
-                   FOO: BAR
-               ports:
-                   - 9102:9102
-                   - 9125:9125
-                   - 9125:9125/udp
+         services:
+             # statsd for metrics
+             statsd-exporter:
+                 image: prom/statsd-exporter:v0.22.4
+                 network_mode: service:app
+                 environment:
+                     FOO: BAR
+                 profiles:
+                     - development
+             app:
+                 ports:
+                     # statsd-exporter
+                     - 59402:9102
```

### Multi architecture

The recipe is now supposed to support both `amd64` and `arm64` architectures, but sometime, we needed to use apt packages having such architectures defined in their names.
An `apt_architecture` ansible variable is now available to automatically switch between them:

```diff
system:
    ...
    apt:
        ...
        packages:
            ...
-            - https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_amd64.deb
+            - https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.buster_{{ apt_architecture }}.deb
```

### Files

You can remove a lot of system.files entries in `.manala.yaml`, especially the ones related to previous vagrant symlink tricks with app cache & logs.

Don't forget to remove the related symlinks on host!

Single app (remove all of them)
```diff
  system:
      ...
      files:
-         - path: /srv/app/var/log
-           src: /srv/log
-           state: link_directory
-           force: true
-         - path: /srv/app/var/cache
-           src: /srv/cache
-           state: link_directory
-           force: true
```

Multi app (just keep the log directories themselves)
```diff
  system:
      ...
      files:
-         - path: /srv/app/foo/var/log
-           src: /srv/log/foo
-           state: link_directory
-           force: true
-         - path: /srv/app/foo/var/cache
-           src: /srv/cache/foo
-           state: link_directory
-           force: true
+         - path: /srv/log/foo
+           state: directory
```

### Urls

Replace in your project any references to `.vm` development url, and replace them by `ela.ooo` references.

For instance:
- `http://foo.vm` -> `http://foo.ela.ooo:12345`

### Makefile

Replace `VAGRANT_MAKE` by `DOCKER_MAKE`
```diff
  define setup
- 	$(VAGRANT_MAKE) --directory foo install build
+  	$(DOCKER_MAKE) --directory foo install build
  endef
```

### Certificates

Regenerate certificates if necessary

```shell
make provision.certificates
```
