#!/usr/bin/env bash

# conda-installed gfortran on OSX: builds fail at runtime 
# https://github.com/ContinuumIO/anaconda-issues/issues/739
export LDFLAGS="-L$PREFIX/lib -Wl,-rpath,$PREFIX/lib $LDFLAGS "

# See https://github.com/Homebrew/legacy-homebrew/issues/20233
# For install_name_tool to work when the install names are larger the binary should be built with 
# the ld(1) -headerpad_max_install_names option.
#export FC_LDFLAGS_EXTRA="-Wl,-headerpad_max_install_names"


# Max
#export CXXFLAGS="-g -O2 -fPIC -std=c++11 -isysroot ${CONDA_BUILD_SYSROOT} -I$PREFIX/include $CXXFLAGS"
export CXXFLAGS="-g -O2 -fPIC -I$PREFIX/include" # $CXXFLAGS"
#export CFLAGS="$CFLAGS -g -O2 -fPIC -I$PREFIX/include"
#export FCFLAGS="-O2 -g -ffree-line-length-none -Wl,-rpath,${CONDA_PREFIX}/lib" 
# -fPIC or -fpic
# see https://gcc.gnu.org/onlinedocs/gcc-4.8.3/gcc/Code-Gen-Options.html#Code-Gen-Options

# FFTW3
#FFT_FLAVOR="fftw3"
#FFT_INCS="-I${PREFIX}/include"
#FFT_LIBS="-L${PREFIX}/lib -lfftw3f -lfftw3"
#FFT_FLAVOR="none"

# Open BLAS
#LINALG_FLAVOR="custom"
#LINALG_LIBS="-L${PREFIX}/lib -lopenblas -lpthread"

#NC_INCS="-I${PREFIX}/include"
#NC_LIBS="-L${PREFIX}/lib -lnetcdff -lnetcdf -lhdf5_hl -lhdf5"

# LibXC library
#XC_INCS="-I${PREFIX}/include"
#XC_LIBS="-L${PREFIX}/lib -lxcf90 -lxc"

echo "using CXX", $CXX
echo `$CXX -v`
echo `$CXX --version`

cd "$(dirname "$0")"

./autogen.sh

./configure --prefix=${PREFIX} \
    --with-eigen="${PREFIX}/include/" \
    --with-spglib="${PREFIX}"

make -j${CPU_COUNT} > make.stdout 2> >(tee make.stderr >&2)

# Test suite 
make check 

# Install binaries
make install
make clean

#unset CFLAGS
#unset CXXFLAGS
#unset FCFLAGS
#unset LDFLAGS
#unset FC_LDFLAGS_EXTRA
#unset FC
#unset CC
