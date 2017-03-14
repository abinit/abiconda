#!/usr/bin/env bash

# LibXC library 
XC_INCS="-I${PREFIX}/include"
XC_LIBS="-L${PREFIX}/lib -lxcf90 -lxc"

./configure --prefix=$PREFIX \
   --enable-libxc --with-libxc-incs="${XC_INCS}" --with-libxc-libs="${XC_LIBS}"

make -j1  # parallel make does not work
make install

# Test suite
make check
