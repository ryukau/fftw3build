#!/bin/bash

set -e

tar -xf fftw-3.3.8.tar.gz
cd fftw-3.3.8 || exit

mkdir build
cd build || exit

installDir="$GITHUB_WORKSPACE/install"
mkdir -p "$installDir"

# AVX512 is disabled.
../configure \
  CFLAGS="-arch arm64 -arch x86_64 -mmacosx-version-min=11.0" \
  --with-pic=yes \
  --enable-single \
  --prefix="$installDir"
make -j
make install
