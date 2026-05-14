# Manala Recipes — Documentation app

The Symfony + [Stenope](https://github.com/StenopePHP/Stenope) app that builds the static documentation site from the recipe READMEs in the parent repository.

## Requirements

- PHP ≥ 8.2
- Node ≥ 20
- [Symfony CLI](https://symfony.com/download)

## Install

```shell
make install
```

## Run locally

```shell
make serve
```

Starts the Symfony server and Webpack in watch mode. Open http://127.0.0.1:8000.

## Build the static site

```shell
make build.static     # assets + content
make serve.static     # preview the build at http://localhost:8001
```

## Lint

```shell
make lint             # composer + container + php-cs-fixer + twig + yaml
```

## Layout

- `src/` — Symfony controllers and Stenope models
- `templates/` — Twig templates
- `assets/` — JS/SCSS sources (built by Webpack Encore)
- `config/` — Symfony configuration
- `../content/` — markdown content rendered by Stenope
