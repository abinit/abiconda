#!/usr/bin/env bash
CONFIGURE="./configure --prefix=$PREFIX"

$CONFIGURE
make
make install

# Test suite
make check