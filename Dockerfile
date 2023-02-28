# Rust 1.67.1 is latest as of Feb 24, 2023
FROM rust:1.67.1 as base

# *-unknown-linux-musl is the target to use for statically-linked images
RUN rustup target add $(arch)-unknown-linux-musl

WORKDIR /app

COPY Cargo.toml Cargo.lock ./

COPY src ./src

RUN cargo build --release --target $(arch)-unknown-linux-musl && strip ./target/$(arch)-unknown-linux-musl/release/httpget -o httpget

FROM gcr.io/distroless/static:nonroot as rootless

COPY --from=base /app/httpget /httpget

ENTRYPOINT ["/httpget"]

FROM gcr.io/distroless/static:latest as rooted

COPY --from=base /app/httpget /httpget

ENTRYPOINT ["/httpget"]
