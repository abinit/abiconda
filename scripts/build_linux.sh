#!/bin/bash
set -e

./getinfo.sh

conda build recipes/fftw
conda build recipes/libxc
#conda build recipes/oncvpsp
#conda build recipes/atompaw
conda build recipes/abinit
#conda build recipes/abinit_seq

#cd recipes
#for pkg in `ls -d *`
#do
#    cmd="conda build ${pkg}"
#    echo Executing ${cmd}
#    ${cmd}
#done
