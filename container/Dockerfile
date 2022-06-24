ARG STACK_VERSION
FROM heroku/heroku:$STACK_VERSION

ENV DEBIAN_FRONTEND noninteractive

# useful build tools
RUN apt-get update && apt-get install -y \
  build-essential \
  autoconf \
  automake \
  cmake \
  libtool \
  intltool \
  unzip \
  wget \
  git \
  pkg-config

# build our stack to this prefix
ARG OPENSSL_PREFIX=/usr/local/openssl
ENV OPENSSL_CHECKSUM="bf61b62aaa66c7c7639942a94de4c9ae8280c08f17d4eac2e44644d9fc8ace6f"

# ld and pkg-config need to pick up packages from this area
ENV LD_LIBRARY_PATH=$OPENSSL_PREFIX/lib
ENV PKG_CONFIG_PATH=$OPENSSL_PREFIX/lib/pkgconfig

# build area
WORKDIR /usr/local/src

ARG OPENSSL_VERSION=1.1.1p
ARG OPENSSL_URL=https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz

RUN wget ${OPENSSL_URL}
RUN echo "$OPENSSL_CHECKSUM  openssl-${OPENSSL_VERSION}.tar.gz" | sha256sum --check
RUN tar xzf openssl-${OPENSSL_VERSION}.tar.gz

# configure and compile the library files
WORKDIR "openssl-${OPENSSL_VERSION}"

RUN ./config --prefix=$OPENSSL_PREFIX --openssldir=$OPENSSL_PREFIX/lib
RUN make
RUN make install

# clean the build area ready for packaging
WORKDIR "$OPENSSL_PREFIX"

RUN strip lib/*.a lib/lib*.so*
RUN rm -rf doc

# I don't know why, but I have to bring this in again. Maybe "FROM" resets it?
ARG STACK_VERSION
RUN rm -rf build
RUN mkdir build
RUN tar czf "build/heroku-${STACK_VERSION}.tar.gz" bin include lib
