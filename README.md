# README.md

This project contains the sample docker implementation deribed from the openapi.yaml file.

# Getting started

```
## If the openapi-generator-cli has not been installed yet.
$ sudo npm install @openapitools/openapi-generator-cli -g
$ sudo openapi-generator-cli version

## to run the docker container
$ make gen-code
$ cd code
$ make docker-build
$ make docker-run

## to stop the docker container
$ make docker-stop
```
