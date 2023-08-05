FROM rust:1.70.0
WORKDIR /app

COPY . .

RUN echo "pub const VERSION: &str = \"$(git describe --tag)\";" > "crates/utils/src/version.rs"
RUN cargo build --release

RUN apt update
RUN apt -y install libpq5
RUN cp /app/target/release/lemmy_server /app/lemmy

CMD ["/app/lemmy"]