#!/usr/bin/env bash

CONFIGURE="./configure --prefix=$PREFIX"

$CONFIGURE
make -j${CPU_COUNT}
make install

# Test suite
make check