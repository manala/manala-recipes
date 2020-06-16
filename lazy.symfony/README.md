# Lazy - Symfony

* [Requirements](#requirements)

## Requirements

* Docker Desktop 2.2.0+

## Setup

Ok, let's create a `foo` symfony demo application, based on demo skeleton.

Create a `foo` directory and access it
```
$ mkdir -p foo
$ cd foo
```

Init the `lazy.symfony` recipe
```
$ manala init
```

Up the environment and shell into it into another terminal
```
$ make up
$ make sh
```

Create the `foo` symfony demo application into `/tmp` and move files into your project (symfony can't create application in an non empty dir)
```
$ symfony new /tmp/foo --no-git --demo
$ rsync -a /tmp/foo/ ./
```

Browse to http://localhost:8080 and enjoy :)
