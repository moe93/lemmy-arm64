#!/bin/bash
set -e

export DOCKER_BUILDKIT=1;
docker buildx create --use;

# Execute the build script
./build.sh;
