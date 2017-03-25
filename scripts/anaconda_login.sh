#!/bin/bash
set -ev  # exit on first error, print each command

conda install anaconda-client
anaconda login
conda config --set anaconda_upload yes