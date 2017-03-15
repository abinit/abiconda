#!/usr/bin/env bash

LINALG_LIBS="-L${PREFIX}/lib -lopenblas -lpthread"

# LibXC library 
XC_INCS="-I${PREFIX}/include"
XC_LIBS="-L${PREFIX}/lib -lxcf90 -lxc"

# Patch blas section
sed -i".bkp" "s|-L/usr/local/lapack/lib -llapack -lrefblas|${LINALG_LIBS} |" make.inc

# Activate libxc support
sed -i".bkp" 's|exc_libxc_stub.o|functionals.o exc_libxc.o|' make.inc
echo "LIBS += ${XC_LIBS}" >> make.inc
echo "FFLAGS += ${XC_INCS}" >> make.inc

cat make.inc

make -j1  # parallel make does not work

# We have to install manually
cp src/*.x ${PREFIX}/bin

#make install

# Test suite (already done in all)
#make test
