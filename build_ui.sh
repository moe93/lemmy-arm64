#!/bin/bash
set -e

# ------------ TODO ------------
# Check if environment variables exist, if not, define them here!
#

# Check if we already cloned the lemmy git
DIRECTORY="lemmy-ui";
if [ ! -d "$DIRECTORY" ]; then
  echo "$DIRECTORY does not exist, cloning."
  git clone https://github.com/LemmyNet/lemmy-ui.git || exit 1;
else
  echo "$DIRECTORY does not exist, Updating."
fi

# Make sure repo is up to date
cd lemmy-ui;
git fetch --tags;
git submodule init;
git submodule update --recursive --remote;

# manual updates
cd lemmy-translations/;
git checkout "$TRANSLATION_COMMIT" || exit 1;
cd ../;
git checkout "$LEMMY_VERSION";

# bug fix: https://github.com/nodejs/docker-node/issues/1912
sed -i 's/node:alpine/node:20-alpine3.16/g' Dockerfile;

# docker build . --platform linux/arm64 --tag="modeh93/lemmy-ui:$LEMMY_VERSION-linux-arm64" || exit 1;
docker buildx build . --output type=docker --platform linux/arm64 --tag="modeh93/lemmy-ui:$LEMMY_VERSION-linux-arm64" || exit 1;

echo "Release UI";
docker push "modeh93/lemmy-ui:$LEMMY_VERSION-linux-arm64" || exit 1;
echo "Successfully pushed lemmy-ui $LEMMY_VERSION";