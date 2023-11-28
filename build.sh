#!/bin/bash
set -e

export LEMMY_VERSION="0.19.0-rc.8";
export TRANSLATION_COMMIT="a36865ee8ca3658fea31ba948b67b75a812e84fc";

# Check if we already cloned the lemmy git
DIRECTORY="lemmy";
if [ ! -d "$DIRECTORY" ]; then
  echo "$DIRECTORY does not exist, cloning."
  git clone https://github.com/LemmyNet/lemmy.git || exit 1;
else
  echo "$DIRECTORY does not exist, Updating."
fi

# Make sure repo is up to date
cd lemmy;
git fetch --tags;
git submodule init;
git submodule update --recursive --remote;

# Manual updates
cd crates/utils/translations/;
git checkout "$TRANSLATION_COMMIT" || exit 1;
cd ../../../;
git checkout "$LEMMY_VERSION";

rm -f ./docker/Dockerfile && cp ../Dockerfile ./docker/ || exit 1;

# docker build . --build-arg RUST_RELEASE_MODE=release --build-arg CARGO_BUILD_TARGET=aarch64-unknown-linux-gnu --platform linux/arm64 --file ./docker/Dockerfile --tag="modeh93/lemmy:$LEMMY_VERSION-linux-arm64" || exit 1;
docker buildx build . --output type=docker --build-arg RUST_RELEASE_MODE=release --platform linux/arm64 --file ./docker/Dockerfile --tag="modeh93/lemmy:$LEMMY_VERSION-linux-arm64" || exit 1;

echo "Successfully built lemmy backend. Release.";

docker push "modeh93/lemmy:$LEMMY_VERSION-linux-arm64" || exit 1;

echo "Successfully pushed $LEMMY_VERSION. Build UI";

# Move on to building the UI
cd ../;
./build_ui.sh;
