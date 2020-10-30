#!/usr/bin/env bash

set -e

rm -rf layer
docker build -t abiword -f Abi.Dockerfile .
CONTAINER=$(docker run -d abiword false)
docker cp $CONTAINER:/opt layer
docker rm $CONTAINER
