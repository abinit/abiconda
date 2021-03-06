#!/usr/bin/env bash

# conda-installed gfortran on OSX: builds fail at runtime 
# https://github.com/ContinuumIO/anaconda-issues/issues/739
export LDFLAGS="$LDFLAGS -L$PREFIX/lib -Wl,-rpath,$PREFIX/lib"

# See https://github.com/Homebrew/legacy-homebrew/issues/20233
# For install_name_tool to work when the install names are larger the binary should be built with 
# the ld(1) -headerpad_max_install_names option.
export FC_LDFLAGS_EXTRA="-Wl,-headerpad_max_install_names"

export CFLAGS="$CFLAGS -g -O2 -fPIC -I$PREFIX/include"
export FCFLAGS="-O2 -g -ffree-line-length-none -Wl,-rpath,${CONDA_PREFIX}/lib" 
# -fPIC or -fpic
# see https://gcc.gnu.org/onlinedocs/gcc-4.8.3/gcc/Code-Gen-Options.html#Code-Gen-Options

cd "$(dirname "$0")"
./config/scripts/makemake

# Version with internal fallbacks (static linkage)
./configure --prefix=${PREFIX} --enable-mpi=no \
    --with-linalg-flavor="none" \
    --with-fft-flavor="none" \
    --with-dft-flavor="libxc-fallback" \
    --with-trio-flavor=netcdf-fallback

make -j${CPU_COUNT} > make.stdout 2> >(tee make.stderr >&2)

# Test suite
make check 
./tests/runtests.py v1 -j${CPU_COUNT} -o1 -n1
#./tests/runtests.py paral -n2 -o1

# Install binaries (don't copy test files to reduce size of the package)
make install-exec

unset CFLAGS
unset FCFLAGS
unset LDFLAGS
unset FC_LDFLAGS_EXTRA
