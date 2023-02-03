# Wrapper for nostr-rs-relay

nostr-rs-relay is a [nostr protocol](https://github.com/nostr-protocol/nostr) relay written in Rust.

As of 3 Feb 2023, there has been limited testing for this wrapper. The relay works well and is used by [Damus](https://github.com/damus-io/damus) at this time.

## Dependencies

Install the system dependencies below to build this project by following the instructions in the provided links. You can also find detailed steps to setup your environment in the service packaging [documentation](https://github.com/Start9Labs/service-pipeline#development-environment).

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [deno](https://deno.land/)
- [make](https://www.gnu.org/software/make/)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/tree/master/backend)
- [rust](https://www.rust-lang.org/tools/install)

## Build environment

Prepare your embassyOS build environment. In this example we are using Ubuntu 20.04.

1. Install docker

```
curl -fsSL https://get.docker.com -o- | bash
sudo usermod -aG docker "$USER"
exec sudo su -l $USER
```

2. Set buildx as the default builder

```
docker buildx install
docker buildx create --use
```

3. Enable cross-arch emulated builds in docker

```
docker run --privileged --rm linuxkit/binfmt:v0.8
```

4. Install yq

```
sudo snap install yq
```

5. Install deno

```
sudo snap install deno
```

6. Install essentials build packages

```
sudo apt-get install -y build-essential openssl libssl-dev libc6-dev clang libclang-dev ca-certificates
```

7. Install Rust

```
curl https://sh.rustup.rs -sSf | sh
# Choose nr 1 (default install)
source $HOME/.cargo/env
```

8. Build and install embassy-sdk

```
cd ~/ && git clone --recursive https://github.com/Start9Labs/embassy-os.git
cd embassy-os/backend/
./install-sdk.sh
embassy-sdk init
```

Now you are ready to build the `nostr-rs-relay` package!

## Cloning

Clone the project locally:

```
git clone https://github.com/garyray-k/nostr-rs-relay-wrapper.git
cd nostr-rs-relay-wrapper
git submodule update --init --recursive
```

## Building

To build the `nostr-rs-relay` package for all platforms using embassy-sdk version >=0.3.3, run the following command:

```
./build.sh
```

This wrapper is for nostr-rs-relay found [here](https://git.sr.ht/~gheartsfield/nostr-rs-relay).

## Installing (on embassyOS)

Run the following commands to determine successful install:

> :information_source: Change embassy-server-name.local to your Embassy address

```
embassy-cli auth login
# Enter your embassy password
embassy-cli --host https://embassy-server-name.local package install hello-world.s9pk
```

If you already have your `embassy-cli` config file setup with a default `host`, you can install simply by running:

```
make install
```

> **Tip:** You can also install the nostr-rs-relay.s9pk using **Sideload Service** under the **System > Manage** section.

### Verify Install

Check the logs of tyhe service to see events populate.

> **Tip:** Check out https://github.com/fiatjaf/noscl for an easy testing client

