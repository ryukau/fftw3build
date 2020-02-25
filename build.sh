#!/bin/bash

set -e

tar -xf fftw-3.3.8.tar.gz
cd fftw-3.3.8 || exit

mkdir build
cd build || exit

installDir="$GITHUB_WORKSPACE/install"
mkdir -p "$installDir"

../configure \
  --with-pic=yes \
  --enable-single \
  --enable-sse2 \
  --enable-avx \
  --enable-avx2 \
  --enable-avx512 \
  --enable-fma \
  --enable-avx-128-fma \
  --prefix="$installDir"
make -j
make install
