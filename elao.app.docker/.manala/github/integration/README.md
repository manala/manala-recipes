# Integration

## Advices

Please consult [advices.md](./advices.md) for some advices & tips beforehand.

## Usage

### Setup the container

In order to execute commands in the CI in a similar environment as your local one,
you need to setup a container in your workflows, using the `./.manala/github/integration/setup` action:

```yaml
# […]

jobs:

  my-job:
    # […]

    steps:

      # […]

      - name: 'Setup container with Manala'
        uses: ./.manala/github/integration/setup
        timeout-minutes: 8
        with:
          services: mariadb
```

> **Note**
> By default, no service is started in the integration container.
> Specify explicitly the `services` option to start required ones.
> For instance, if you need to use a database for functional testing, you can start a `mariadb` service.

### Execute commands

Once your container is setup, you can execute commands in it using the `./.manala/github/integration/run` action:

```yaml
# […]

jobs:

  my-job:
    # […]

    steps:

      # […]

      - name: 'Install dependencies & setup project'
        uses: ./.manala/github/integration/run
        timeout-minutes: 3
        with:
          app: back
          run: make install@integration
```

## Exposing secrets

Consult [env.md](./env.md) for exposing secrets through env vars

#### Examples

### Test workflow

`.github/workflows/test.yaml`:

```yaml
on:
  push:
    branches: [master]
    #branches: [master, staging]
    # On specific apps changes in a monorepo:
    #paths: [.github/**, .manala/**, back/**, front/**]
    # Only on dependencies changes:
    #paths: ['**/composer.lock', '**/package-lock.json', '**/yarn.lock', '.github/**', '.manala/**']
  pull_request:
    types: [opened, synchronize, reopened, ready_for_review]
  #schedule:
  #  - cron: 0 0 * * 1 # Every Monday 00:00
  #workflow_dispatch: ~

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:

  test-back:
    name: 'Test'
    runs-on: ubuntu-latest
    timeout-minutes: 25
    # Do not run Draft PRs:
    if: "!github.event.pull_request || github.event.pull_request.draft == false"

    steps:

      - name: 'Checkout'
        uses: actions/checkout@v4

      - name: 'Setup container with Manala'
        uses: ./.manala/github/integration/setup
        timeout-minutes: 8
        with:
          services: mariadb

      - name: 'Install dependencies & setup project'
        uses: ./.manala/github/integration/run
        timeout-minutes: 3
        with:
          app: back
          run: make install@integration

      - name: 'Run tests'
        uses: ./.manala/github/integration/run
        timeout-minutes: 12
        with:
          app: back
          run: make test.phpunit@integration
```
