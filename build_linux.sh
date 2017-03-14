set -e
cd recipes

for pkg in `ls -d *`
do
    cmd="conda build ${pkg}"
    echo Executing ${cmd}
    ${cmd}
done
