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
export CXXFLAGS="-g -O2 -fPIC -I$PREFIX/include $CXXFLAGS"
#export CFLAGS="$CFLAGS -g -O2 -fPIC -I$PREFIX/include"
#export FCFLAGS="-O2 -g -ffree-line-length-none -Wl,-rpath,${CONDA_PREFIX}/lib" 
# -fPIC or -fpic
# see https://gcc.gnu.org/onlinedocs/gcc-4.8.3/gcc/Code-Gen-Options.html#Code-Gen-Options

echo "CXX",  $CXX

cd "$(dirname "$0")"

qmake qAgate.pro

#./configure --prefix=${PREFIX} \
#    --enable-mpi="yes" --enable-mpi-io="yes" \
#    --with-linalg-flavor=${LINALG_FLAVOR} --with-linalg-libs="${LINALG_LIBS}" \
#    --with-trio-flavor=netcdf \
#    --with-netcdf-incs="${NC_INCS}" --with-netcdf-libs="${NC_LIBS}" \
#    --with-dft-flavor="wannier90-fallback" \
#    --enable-gw-dpc="yes" \
#    --with-libxc-incs="${XC_INCS}" --with-libxc-libs="${XC_LIBS}"
#    # --with-mpi-prefix=${PREFIX} \
#    # --with-fft-flavor=${FFT_FLAVOR} --with-fft-incs="${FFT_INCS}" --with-fft-libs="${FFT_LIBS}" \

make -j${CPU_COUNT} > make.stdout 2> >(tee make.stderr >&2)

# Test suite 
#make check 

# Install binaries
make install

#unset CFLAGS
#unset CXXFLAGS
#unset FCFLAGS
#unset LDFLAGS
#unset FC_LDFLAGS_EXTRA
#unset FC
#unset CC
