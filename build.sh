# On an M1 and needed to build the docker images not using make for whatever reason
mkdir ./docker-images
echo "Building docker image  using cargo-auditable, go make some tea."
docker buildx build --tag start9/nostr-rs-relay/main:0.8.2 --build-arg ARCH=x86_64 --platform=linux/amd64 -o type=docker,dest=docker-images/x86_64.tar .
echo "Building another docker image using cargo-auditable, go make some tea."
docker buildx build --tag start9/nostr-rs-relay/main:0.8.2 --build-arg ARCH=aarch64 --platform=linux/arm64 -o type=docker,dest=docker-images/aarch64.tar .

make