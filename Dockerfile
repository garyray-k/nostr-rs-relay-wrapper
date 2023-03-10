FROM docker.io/library/rust:1.66.0 as builder

RUN USER=root cargo install cargo-auditable
RUN USER=root cargo new --bin nostr-rs-relay
WORKDIR ./nostr-rs-relay
COPY ./nostr-rs-relay/Cargo.toml ./Cargo.toml
COPY ./nostr-rs-relay/Cargo.lock ./Cargo.lock
# build dependencies only (caching)
RUN cargo auditable build --release --locked
# get rid of starter project code
RUN rm src/*.rs

# copy project source code
COPY ./nostr-rs-relay/src ./src

# build auditable release using locked deps
RUN rm ./target/release/deps/nostr*relay*
RUN cargo auditable build --release --locked

FROM docker.io/library/debian:bullseye-slim

ARG APP=/usr/src/app
ARG APP_DATA=/usr/src/app/data/db
RUN apt-get update \
    && apt-get install -y ca-certificates tzdata sqlite3 libc6 wget curl sudo bash tini libssl-dev  \
    && wget https://github.com/mikefarah/yq/releases/download/v4.25.1/yq_linux_arm.tar.gz -O - |\
    tar xz && mv yq_linux_arm /usr/bin/yq \
    && rm -rf /var/lib/apt/lists/*

ADD ./docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/*.sh
RUN chmod a+x *.sh

EXPOSE 8080

ENV TZ=Etc/UTC \
    APP_USER=root

RUN mkdir -p ${APP} \
    && mkdir -p ${APP_DATA}

COPY --from=builder /nostr-rs-relay/target/release/nostr-rs-relay ${APP}/nostr-rs-relay

RUN chown -R $APP_USER:$APP_USER ${APP}

USER $APP_USER
WORKDIR ${APP}

# COPY ./config.toml ${APP_DATA}/config/config.toml 
COPY ./config.toml ${APP_DATA}
ENV RUST_LOG=info,nostr_rs_relay=info
ENV APP_DATA=${APP_DATA}
