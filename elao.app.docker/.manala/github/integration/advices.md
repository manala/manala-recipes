# Advices & tips

The samples exposed are generic and must not be blindly copy/pasted to your project.
Please consider the following advices and example to adapt to your project needs.

## Draft and WIP PRs

Save your GitHub Actions quota and runners by avoiding running your workflow on draft PRs:

```yaml
# […]

jobs:
  my-job:
    runs-on: ubuntu-latest

    # Do not run Draft PRs:
    if: "!github.event.pull_request || github.event.pull_request.draft == false"
    # or per label:
    if: "!github.event.pull_request || !contains(github.event.pull_request.labels.*.name, 'WIP'"
    # or both:
    if: "!github.event.pull_request || !contains(github.event.pull_request.labels.*.name, 'WIP') && github.event.pull_request.draft == false)"
```

## Timeout

Avoid running your workflow indefinitely (might be a setup/runner issue) or detect abnormally long executions
by setting timeouts on your jobs and steps:

```yaml
# […]

jobs:
  my-job:
    runs-on: ubuntu-latest
    # Adapt the job timeout to your workflow
    timeout-minutes: 10

    steps:
      - name: Some heavy step
        timeout-minutes: 8
```

## Schedule

Properly identify when your workflow should be executed and schedule those than should only run periodically / on some file changes.
Typically, for dependencies checks (security/audit), limit your workflow to lock files changes and schedule a security check each week:

```yaml
on:
  # […]

  schedule:
    - cron: '0 0 * * 1' # At 00:00 on each Monday.

  # You can also allow to run this workflow manually using:
  workflow_dispatch: ~

# […]
```
