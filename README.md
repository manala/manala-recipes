# Manala - Recipes

Read the [documentation](https://manala.github.io/manala-recipes)

## Renovate

Test on local:
```shell
docker run --rm \
  -v $(pwd):/usr/src/app \
  -e RENOVATE_PLATFORM=local \
  -e GITHUB_COM_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \
  -e LOG_LEVEL=debug \
  renovate/renovate --dry-run=full
```
