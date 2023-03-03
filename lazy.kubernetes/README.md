---
title: Lazy - Kubernetes
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
# From file
make sh < file
# Multilines, using heredoc
make sh << 'EOF'
command 1
command 2
...
EOF
# Single line
make sh <<< command
```

Specify working dir
```shell
make sh DIR=/etc <<< pwd
/etc
```

Expose a container port 4321 on localhost:1234
```shell
make sh PORT=1234:4321
kubectl --namespace [namespace] port-forward --address 0.0.0.0 svc/[service] 4321:[port]
```

### Kubectl

Alias `k`
```shell
kubectl version
Client Version: ...
k version
Client Version: ...
```
