#!/usr/bin/env bash

# conda-installed gfortran on OSX: builds fail at runtime 
# https://github.com/ContinuumIO/anaconda-issues/issues/739
export LDFLAGS="$LDFLAGS -L$PREFIX/lib -Wl,-rpath,$PREFIX/lib"

# LibXC library 
XC_INCS="-I${PREFIX}/include"
XC_LIBS="-L${PREFIX}/lib -lxcf90 -lxc"

# Open BLAS
LINALG_LIBS="-L${PREFIX}/lib -lopenblas -lpthread"

./configure --prefix=$PREFIX \
   --enable-libxc --with-libxc-incs="${XC_INCS}" --with-libxc-libs="${XC_LIBS}" \
   --with-linalg-libs="${LINALG_LIBS}"

make -j1  # parallel make does not work
make install

# Test suite
make check

unset LDFLAGS
