#!/bin/bash
set -e  # exit on first error

gcc_info=`gcc --version | head -n 1`
gfortran_info=`gfortran --version | head -n 1`

if [[ `uname` == "Darwin" ]]; then
    libc_info=`otool --version | head -n 1`
else
    libc_info=`ldd --version | head -n 1`
fi

echo "*********************"
echo "*** builder Info ***"
echo "*********************"
echo "gcc_info:" ${gcc_info}
echo "gfortran_info:" ${gfortran_info}
echo "libc_info:" ${libc_info}
conda info
