# On an M1 and needed to build the docker images not using make for whatever reason
echo "Building docker images, go make some tea."
mkdir ./docker-images
docker buildx build --tag start9/nostr-rs-relay/main:0.0.1 --build-arg ARCH=x86_64 --platform=linux/amd64 -o type=docker,dest=docker-images/x86_64.tar .
docker buildx build --tag start9/nostr-rs-relay/main:0.0.1 --build-arg ARCH=aarch64 --platform=linux/arm64 -o type=docker,dest=docker-images/aarch64.tar .

make