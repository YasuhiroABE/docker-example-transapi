# README.md

This project contains the sample docker implementation deribed from the openapi.yaml file.

# Original

* https://github.com/YasuhiroABE/docker-sccp-sinatra-sample

# Getting started

Now, the podman command is the default container engine.
If you woule like to use the docker command, please modify the DOCKER_CMD variable of Makefile file.

If you also enable the selinux, please make sure setting the "--security-opt" option appropriately.

```
## to run the docker container
$ make gen-code
$ cd code
$ make docker-build
$ make docker-run

## to stop the docker container
$ make docker-stop
```
