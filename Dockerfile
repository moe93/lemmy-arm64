# From https://raw.githubusercontent.com/LemmyNet/lemmy/main/docker/Dockerfile

FROM rust:1.70-slim-buster as builder
WORKDIR /app
# ARG CARGO_BUILD_TARGET=x86_64-unknown-linux-musl
ARG CARGO_BUILD_TARGET=aarch64-unknown-linux-gnu

# comma-seperated list of features to enable
ARG CARGO_BUILD_FEATURES=default

# This can be set to release using --build-arg
ARG RUST_RELEASE_MODE="debug"

# Install compilation dependencies
RUN apt-get update \
  && apt-get -y install --no-install-recommends libssl-dev pkg-config libpq-dev git musl-tools \
  && rm -rf /var/lib/apt/lists/*

# Install the x86_64 Linux target
# (or whatever architecture we are building this on)
# RUN rustup target add x86_64-unknown-linux-musl
# RUN rustup target add aarch64-unknown-linux-gnu
RUN rustup target add ${CARGO_BUILD_TARGET}


COPY . .

# Build the project
    
# Debug mode build
RUN --mount=type=cache,target=/app/target \
  if [ "$RUST_RELEASE_MODE" = "debug" ] ; then \
    echo "pub const VERSION: &str = \"$(git describe --tag)\";" > "crates/utils/src/version.rs" \
    && cargo build --target ${CARGO_BUILD_TARGET} --features ${CARGO_BUILD_FEATURES} \
    && cp ./target/$CARGO_BUILD_TARGET/$RUST_RELEASE_MODE/lemmy_server /app/lemmy_server; \
  fi

# Release mode build
RUN \
  if [ "$RUST_RELEASE_MODE" = "release" ] ; then \
    echo "pub const VERSION: &str = \"$(git describe --tag)\";" > "crates/utils/src/version.rs" \
    && cargo build --target ${CARGO_BUILD_TARGET} --features ${CARGO_BUILD_FEATURES} --release \
    && cp ./target/$CARGO_BUILD_TARGET/$RUST_RELEASE_MODE/lemmy_server /app/lemmy_server; \
  fi

# The alpine runner
FROM alpine:3 as lemmy

# Install libpq for postgres
RUN apk add --no-cache libpq

# Copy resources
COPY --from=builder /app/lemmy_server /app/lemmy

# Create non-privileged user
RUN adduser -h /app -s sh -S -u 1000 lemmy
RUN chown -R lemmy /app
USER lemmy

CMD ["/app/lemmy"]
