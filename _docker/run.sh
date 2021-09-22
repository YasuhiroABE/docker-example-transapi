#!/bin/bash -x

export SINATRA_PORT=${SINATRA_PORT:-8080}
bundle exec rackup --host 0.0.0.0 --port $SINATRA_PORT
