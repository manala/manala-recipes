# Migration - 2021-04

## Jenkins

- remove `.manala/jenkins` directory

## Nginx configs

### Cors

Before
```
# Cors
- file: app_cors
  template: nginx/app_cors.j2
```

After
```
- template: nginx/cors.j2
```

### Gzip

Before
```
# Gzip
- file: app_gzip
  template: nginx/app_gzip.j2
```

After
```
- template: nginx/gzip.j2
```

### No index

Before
```
# Gzip
- file: app_no_index
  template: nginx/app_no_index.j2
```

After
```
- template: nginx/no_index.j2
```

### Php fpm

Before
```
# Php fpm
- file: app_php_fpm
  template: nginx/app_php_fpm.j2
```

After
```
- template: nginx/php_fpm_app.j2
```

### Ssl

Before
```
# Ssl
- file: app_ssl.conf
  template: nginx/app_ssl_offloading.conf.j2
```

After
```
```

Notes:
  - Ssl is now part of default nginx configuration

### App

Before
```
# App
- file: app.conf
  config:
    - server:
      - server_name: ~.
      - root: /srv/app/public
      - access_log: /srv/log/nginx.access.log
      - error_log: /srv/log/nginx.error.log
      - include: conf.d/app_gzip
      - location /:
        - try_files: $uri /index.php$is_args$args
      - location ~ ^/index\.php(/|$):
        - include: conf.d/app_php_fpm
        - internal;
```

After
```
# App
- file: app.conf
  config: |
      server {
          server_name ~.;
          root /srv/app/public;
          access_log /srv/log/nginx.access.log;
          error_log /srv/log/nginx.error.log;
          include conf.d/gzip;
          location / {
              try_files $uri /index.php$is_args$args;
          }
          location ~ ^/index\.php(/|$) {
              include conf.d/php_fpm_app;
              internal;
          }
      }
```

Notes:
  - `make provision TAGS=nginx DIFF=1`
  - indentation 4 spaces
  - includes
    - `conf.d/app_cors` -> `conf.d/cors`
    - `conf.d/app_gzip` -> `conf.d/gzip`
    - `conf.d/app_no_index` -> `conf.d/no_index`
    - `conf.d/app_php_fpm` -> `conf.d/php_fpm_app`

### Content

Before
```
- file: foo.conf
  content: |
    ...
```

After
```
- file: foo.conf
  config: |
    ...
```

## Php configs

### Opcache

Before
```
- file: app_opcache.ini
  template: configs/app_opcache.dev.j2
```

After
```
- template: php/opcache.ini.j2
```

### App

Before
```
- file: app.ini
  template: configs/app.dev.j2
  config:
    - date.timezone: UTC
```

After
```
- template: php/app.ini.j2
  config:
    date.timezone: UTC
```

Notes:
  - config switch from array to dict

## Ssh client config

Before
```
config:
  - Host *.elao.run:
    - User: app
    - ForwardAgent: true
```

After
```
config: |
    Host *.elao.run
        User app
        ForwardAgent yes
```

## Redis config

Before
```
config:
    - save: '""'
```

After
```
config:
    save: '""'
```

## Influxdb config

Before
```
config:
    - reporting-disabled: true
```

After
```
config:
    reporting-disabled: true
```

## Cron files

Before
```
- file: app
  env:
      SHELL: /bin/zsh
      ZDOTDIR: /home/vagrant
      HOME: /srv/app
  jobs:
      - name: foo-bar
        job: bin/console app:foo:bar --no-interaction -vv >> /srv/log/cron.foo-bar.log 2>&1
        minute: 0
        hour: 3
        # Dev
        state: absent
```

After
```
- file: app
  env:
      HOME: /srv/app
  jobs:
      # Foo - Bar
      - command: php bin/console app:foo:bar --no-interaction -vv >> /srv/log/cron.foo-bar.log 2>&1
        minute: 0
        hour: 3
        # Dev
        state: absent
```

## Supervisor configs programs

Before
```
foo-bar:
  command: zsh -c "bin/console app:foo:bar --no-interaction -vv"
```

After
```
foo-bar:
  command: php bin/console app:foo:bar --no-interaction -vv
```
