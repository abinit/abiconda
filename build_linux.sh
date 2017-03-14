set -e

#conda build recipes/fftw
#conda build recipes/libxc
conda build recipes/abinit

#cd recipes
#for pkg in `ls -d *`
#do
#    cmd="conda build ${pkg}"
#    echo Executing ${cmd}
#    ${cmd}
#done
