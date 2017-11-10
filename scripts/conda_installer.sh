#!/bin/bash
set -ev  # exit on first error, print each command

# Install conda with travis: https://conda.io/docs/travis.html
if [[ "${TRAVIS_OS_NAME}" == "osx" ]]; then
    if [[ "${PYTHON_VERSION}" == "2.7" ]]; then
        curl -o miniconda.sh https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh;
    else
        curl -o miniconda.sh https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh;
    fi
else
    if [[ "${PYTHON_VERSION}" == "2.7" ]]; then
        wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh;
    else
        wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
    fi
fi

bash miniconda.sh -b -p ${HOME}/miniconda
export PATH="${HOME}/miniconda/bin:${PATH}"

hash -r

conda config --set always_yes yes --set changeps1 no
conda update conda
conda install conda-build
conda update -n root conda-build
conda install anaconda-client
# Useful for debugging any issues with conda
conda info -a
# Replace dep1 dep2 ... with your dependencies
#conda create -q -n test-environment python=${PYTHON_VERSION}
#source activate test-environment
