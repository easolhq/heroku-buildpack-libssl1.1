#!/usr/bin/env bash

# set -x
set -e

OPENSSL_VERSION=1.1.1p
STACK_VERSIONS=(22)

for stack_version in "${STACK_VERSIONS[@]}"; do
  image_name=libssl1.1-heroku-$stack_version:$OPENSSL_VERSION

  docker build \
    --build-arg OPENSSL_VERSION="$OPENSSL_VERSION" \
    --build-arg STACK_VERSION="$stack_version" \
    --tag "$image_name" \
    container

  mkdir -p build

  docker run --rm -t -v "$PWD"/build:/build "$image_name" sh -c 'cp -f /usr/local/openssl/build/*.tar.gz /build'
done

