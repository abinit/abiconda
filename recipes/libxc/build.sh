#!/usr/bin/env bash
CONFIGURE="./configure --prefix=$PREFIX"

# conda-installed gfortran on OSX: builds fail at runtime 
# https://github.com/ContinuumIO/anaconda-issues/issues/739
export LDFLAGS="$LDFLAGS -L$PREFIX/lib -Wl,-rpath,$PREFIX/lib"

$CONFIGURE
make -j${CPU_COUNT}
make install

# Test suite
make check

unset LDFLAGS