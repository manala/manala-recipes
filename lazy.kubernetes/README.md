---
title: Lazy - Kubernetes
tableOfContent: 3
---

## Requirements

* [Manala CLI](https://manala.github.io/manala/installation/) to update the recipe
* Make
* Docker Desktop 2.2.0+ or Docker Engine + Docker Compose

## Kubectl

Alias `k`
```
❯ kubectl version
Client Version: ...
❯ k version
Client Version: ...
```

Port forwarding to expose a service port on localhost:1234
```
$ make sh PORT=1234:4321
❯ kubectl --namespace [namespace] port-forward --address 0.0.0.0 svc/[service] 4321:[port]
```
