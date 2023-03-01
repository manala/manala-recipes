---
title: Lazy - Ansible
tableOfContent: 3
---

## Requirements

* [Manala CLI](https://manala.github.io/manala/installation/) to update the recipe
* Make
* Docker Desktop 2.2.0+ or Docker Engine + Docker Compose

## Usage

Open a shell to local system
```shell
make sh
```

Run commands through local system
```shell
make sh <<< command
make sh << 'EOF'
command 1
command 2
...
EOF
```
