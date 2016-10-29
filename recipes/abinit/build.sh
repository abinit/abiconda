#!/usr/bin/env bash
#https://github.com/conda-forge/fftw-feedstock/blob/ad8bc8c5661447db646ff3c48fed3dd4a23edc5a/recipe/build.sh

# Depending on our platform, shared libraries end with either .so or .dylib
if [[ `uname` == 'Darwin' ]]; then
    # Use homebrew
    export CC=gcc-5
    export FC=gfortran-5
    #export CC=gcc
    #export FC=gfortran
else
    export CC=gcc
    export FC=gfortran
fi


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

#LIBGFORTRAN_DIR=~/anaconda2/lib
LIBGFORTRAN_DIR=/usr/local/opt/gcc/lib/gcc/5
LIBGFORTRAN_NAME=libgfortran.3.dylib

#LIBGCC_S_DIR=~/anaconda2/lib
LIBGCC_S_DIR=/usr/local/lib/gcc/5
LIBGCC_S_NAME=libgcc_s.1.dylib 

#LIBQUADMATH_DIR=~/anaconda2/lib
LIBQUADMATH_DIR=/usr/local/opt/gcc/lib/gcc/5
LIBQUADMATH_NAME=libquadmath.0.dylib

LIBGFORTRAN_PATH=${LIBGFORTRAN_DIR}/${LIBGFORTRAN_NAME}
LIBGCC_S_PATH=${LIBGCC_S_DIR}/${LIBGCC_S_NAME}
LIBQUADMATH_PATH=${LIBQUADMATH_DIR}/${LIBQUADMATH_NAME}

if [[ `uname` == 'Darwin' ]]; then
    mkdir -p ${PREFIX}/lib
    cp ~/anaconda2/lib/${LIBGFORTRAN_NAME} ${PREFIX}/lib/${LIBGFORTRAN_NAME}
    cp ~/anaconda2/lib/${LIBQUADMATH_NAME} ${PREFIX}/lib/${LIBQUADMATH_NAME}
    cp ~/anaconda2/lib/${LIBGCC_S_NAME}    ${PREFIX}/lib/${LIBGCC_S_NAME}
fi

# https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor
# Linux-GCC with MKL dynamically
#export LINALG_LIBS="-Wl,--no-as-needed -L${MKLROOT}/lib/intel64 \
#-lmkl_gf_lp64 -lmkl_core -lmkl_sequential -lpthread -lm -ldl"
#FCFLAS="${FCFLAS} -m64 -I${MKLROOT}/include"
#FFT_INCS=${LINALG_INCS}
#FFT_LIBS=${LINALG_INCS}

# FFTW3
FFT_FLAVOR="none"
FFT_INCS="-I$PREFIX/include"
FFT_LIBS="-L$PREFIX/lib -lfftw3f -lfftw3"

# Open BLAS
LINALG_FLAVOR="none"
LINALG_LIBS="-L$PREFIX/lib -lopenblas -lpthread"

./configure --prefix=${PREFIX} \
--enable-mpi=no \
--with-linalg-flavor=none \
--with-fft-flavor=none \
--with-trio-flavor=netcdf \
--with-dft-flavor=libxc
#--with-fft-flavor="${FFT_FLAVOR} --with-fft-incs="${FFT_INCS}" --with-fft-libs="${FFT_LIBS}" \
#--with-linalg-flavor=${LINALG_FLAVOR} --with-linalg-libs="${LINALG_LIBS}" \
      
make -j${CPU_COUNT}

# Test suite
# tests are performed during building as they are not available in the installed package.
#make check

# Install binaries (don't copy test files to reduce size of the package)
make install-exec

declare -a ABINIT_BINARIES=(
	"abinit" "band2eps" "cut3d" "ioprof" "mrgdv" "ujdet"
	"bsepostproc" "lapackprof" "mrggkk" "vdw_kernelgen"
	"aim" "fftprof" "macroave" "mrgscr" 
	"anaddb" "conducti" "fold2Bloch" "mrgddb" "optic"
)

if [[ `uname` == 'Darwin' ]]; then
    for bname in "${ABINIT_BINARIES[@]}" 
    do
        otool -L ${PREFIX}/bin/${bname}
        install_name_tool \
          -change ${LIBGCC_S_PATH} ${CONDA_PREFIX}/lib/${LIBGCC_S_NAME} \
          -change ${LIBQUADMATH_PATH} ${CONDA_PREFIX}/lib/${LIBQUADMATH_NAME} \
          -change ${LIBGFORTRAN_PATH} ${CONDA_PREFIX}/lib/${LIBGFORTRAN_NAME} \
          ${PREFIX}/bin/${bname}
        otool -L ${PREFIX}/bin/${bname}
    done 
fi 


unset FC
unset CC
unset CFLAGS
unset FCFLAGS
unset LDFLAGS
unset FC_LDFLAGS_EXTRA