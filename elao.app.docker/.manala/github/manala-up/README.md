# Check .manala.yaml changes applied

## Usage

You can create a workflow to automatically check whether the `.manala.yaml` file changes were properly applied
with the `manala update` command whenever a PR modifies it:

`.github/workflows/manala-update.yaml`

```yaml
name: Manala update

on:
  push:
    branches: [master]
    paths: [.manala.yaml]
  pull_request:
    types: [opened, synchronize, ready_for_review]
    paths: [.manala.yaml]

jobs:
  manala-update:
    runs-on: ubuntu-latest
    timeout-minutes: 2
    steps:

      - name: 'Checkout'
        uses: actions/checkout@v2

      - name: 'Check .manala changes are up-to-date'
        uses: manala/setup-manala-action@master
        with:
          checks: '["update"]'
```

If the PR modifies the `.manala.yaml` file without applying the changes, you'll be notified with a failing check on the PR.

> **Note**: 
> it uses the [`manala/setup-manala-action`](https://github.com/manala/setup-manala-action) action to install
> and execute the `manala` CLI.
