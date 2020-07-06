#!/usr/bin/env bash

set -e

rm -rf layer
docker build -t abiword -f DockerfileAbi .
CONTAINER=$(docker run -d abiword false)
docker cp $CONTAINER:/opt/build layer
docker rm $CONTAINER