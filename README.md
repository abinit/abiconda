[![Build Status](https://travis-ci.org/gmatteo/abiconda.svg?branch=master)](https://travis-ci.org/gmatteo/abiconda)

## abiconda channel

[abiconda channel](https://anaconda.org/abiconda) is a Conda channel with recipes for Abinit-related packages. 
The goal is to facilitate the installation of Abinit-related applications to end-users.
This channel is somewhat complementary to the packages provided by the
[materials.sh](https://github.com/materialsvirtuallab/materials.sh) channel.

For a quick howto with the five commands required to install Abinit on your machine (Linux or MacOSx)
jump immediately to the [next section](#Abinit_in_five_steps).
A more detailed discussion about the installation with ``conda``, 
and the use of conda environments is given in [this section](#Getting_started).

Note that the ``abiconda`` executables are useful if you want to try Abinit on your machine 
but they are not supposed to be used for high-performance calculations.

For examples of configuration files to configure/compile Abinit on clusters, please visit the  
the [abiconfig](https://github.com/abinit/abiconfig) repository.
If you need a **real package manager** able to support multiple versions 
and configurations of software, consider the following projects:

  * [spack](https://github.com/LLNL/spack)
  * [easybuild](https://github.com/hpcugent/easybuild)

Both projects are designed for large supercomputing centers and 
they already provide configuration files to build Abinit.

## How to install Abinit in five steps <a name="Abinit_in_five_steps"></a>

If you are a Linux user, download and install ``miniconda`` on your local machine with:

    $ wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
    $ bash Miniconda2-latest-Linux-x86_64.sh

while for MacOSx use:

    $ wget https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh
    $ bash Miniconda2-latest-MacOSX-x86_64.sh

Answer ``yes`` to the question:

    Do you wish the installer to prepend the Miniconda2 install location
    to PATH in your /home/gmatteo/.bashrc ? [yes|no]
    [no] >>> yes

Source your ``.bashrc`` file to activate the changes done by ``miniconda`` to your ``$PATH``:

    $ source ~/.bashrc

Add ``conda-forge`` to the conda channels:

    $ conda config --add channels conda-forge

Install the parallel version of abinit with:

    $ conda install abinit -c gmatteo
    $ abinit -v
    
## Getting started <a name="Getting_started"></a>

Download ``anaconda`` for your operating system from [https://www.continuum.io/downloads](https://www.continuum.io/downloads).
``anaconda`` is a distribution with the most popular Python packages for data science and includes ``conda`` 
the cross-platform, language-agnostic package-manager required to install Abinit.
If you don't need the entire ``anaconda`` distribution, 
start with [miniconda](http://conda.pydata.org/miniconda.html) which contains only ``conda`` and Python.

By default, the installer adds the following line to your ``.bash_profile``:

    export PATH="/Users/gmatteo/anaconda2/bin:$PATH"

so we have to ``source ~/.bash_profile`` before continuing in order to have the ``conda`` executable in our ``$PATH``. 

Create a new conda environment (let's call it ``abienv``) with:

    $ conda create -n abienv

and activate it with:

    $ source activate abienv

For further information on conda, please consult the [official conda documentation](https://conda.io/docs/using/).

The most important (pre-compiled) libraries will be obtained by [conda-forge](https://conda-forge.github.io)
so we have to add ``conda-forge`` to the list of default channels with:

    $ conda config --add channels conda-forge

Now we can install the ``abiconda`` applications e.g. ``abinit`` with:

    $ conda install abinit -c gmatteo

This command will download and install the last version of Abinit from the [gmatteo channel](https://anaconda.org/gmatteo).
The Abinit executables are placed inside the anaconda directory associated to the ``abienv`` environment:

    $ which abinit
    /Users/gmatteo/anaconda2/envs/abienv/bin/abinit

Linux users can use the shell command:

    $ ldd `which abinit`

to get the list of dynamic libraries linked to the application whereas macOSx can use:

    $ otool -L `which abinit`
    /Users/gmatteo/anaconda2/envs/abinit/bin/abinit:
            /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 307.4.0)
            @rpath/libnetcdff.6.dylib (compatibility version 6.0.0, current version 6.1.1)
            @rpath/libnetcdf.11.dylib (compatibility version 11.0.0, current version 11.4.0)
            @rpath/libhdf5_hl.10.dylib (compatibility version 12.0.0, current version 12.0.0)
            @rpath/libhdf5.10.dylib (compatibility version 13.0.0, current version 13.0.0)
            @rpath/libfftw3f.3.dylib (compatibility version 9.0.0, current version 9.6.0)
            @rpath/libfftw3.3.dylib (compatibility version 9.0.0, current version 9.6.0)
            @rpath/libopenblasp-r0.2.19.dylib (compatibility version 0.0.0, current version 0.0.0)
            @rpath/libmpifort.12.dylib (compatibility version 14.0.0, current version 14.0.0)
            @rpath/libmpi.12.dylib (compatibility version 14.0.0, current version 14.0.0)
            @rpath/libpmpi.12.dylib (compatibility version 14.0.0, current version 14.0.0)
            @rpath/./libgfortran.3.dylib (compatibility version 4.0.0, current version 4.0.0)
            /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1238.0.0)
            @rpath/./libquadmath.0.dylib (compatibility version 1.0.0, current version 1.0.0)

The output of ``otool`` indicates that this executable is linked against ``openblas``, 
``MPI`` (mpich), ``FFTW`` and ``netcdf4+hdf5``.
The BLAS library is threaded and the number of threads used at runtime is defined by the
environment variable ``OMP_NUM_THREADS``. We suggest to add:

    export OMP_NUM_THREADS=1

to your ``.bash_profile`` because by default the OpenMP library uses all the available cores
if this variable is not defined.

Alternatively, one can install the **sequential** version (minimal dependencies, no parallelism) with: 

    $ conda install abinit_seq -c gmatteo

To get the list of Abinit versions available in the [gmatteo channel](https://anaconda.org/gmatteo):

    $ conda search abinit -c gmatteo

        Fetching package metadata ...........
        abinit                       8.0.8                         0  gmatteo
                                  *  8.2.2                         0  gmatteo
        abinit_seq                *  8.2.2                         0  gmatteo

To install a particular version of Abinit use:

    $ conda install abinit=8.2.0 -c gmatteo

## Troubleshooting

- All the conda applications should use libraries installed inside the conda environment. 
  As a consequence, the use of the ``$LD_LIBRARY_PATH`` (linux) or 
  ``$DYLD_LIBRARY_PATH`` (MacOsx) environment variables is strongly discouraged 
  as it can lead to runtime errors and malfunctioning.
  So it is recommended to unset them if they are set, unless you know what you are doing
  (use ``conda info -a`` to get info on your environment).

- The parallel version of Abinit should be launched with the ``mpirun`` executable provided by conda so
  make sure that the bin directory of anaconda comes before the other directories and use:

      $ which mpirun
      ~/anaconda2/envs/abienv/bin/mpirun

- The majority of the libraries required by the ``abiconda`` applications (including ``libgcc``
  and ``libgfortran``) are automatically installed in your conda environment when you issue 
  ``conda install APPNAME -c gmatteo``.
  In principle, these libraries should be compatible with the abiconda executables but incompatibilities may appear
  when the ``conda`` developers decided to upgrade the ``gcc`` version or if other **tricky** dependencies 
  such as the MPI library are upgraded upstream.
  In this case, contact us and we will try to provide new pre-compiled versions compatible with the 
  new anaconda software stack.
  Alternatively, you may try the sequential version ``abinit_seq`` in which the number of external dependencies 
  and therefore the probability of linkage problems is significantly reduced.

- All the dependencies are provided by conda with the exception of the C standard library
  (``libc`` on linux, ``libSystem.B.dylib`` on MacOsx).
  If the C library provided by your OS is too old, you will get error messages such as:

      $ abinit
      abinit: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by abinit)

  when you try to execute the application from the terminal. 
  ``ldd`` indeed shows that our system uses ``libc 2.12`` 

      $ ldd --version
      ldd (GNU libc) 2.12

  This means that our abiconda executable requires a C library that is not compatible with 
  the one available on your system (this usually happens when your library is too old).
  At the time of writing, we build executables and libraries for linux with GNU libc 2.12
  while MacOsx applications are built with MacOS 10.11.2. 
  This should cover the most common cases but it your OS is too old you will have to compile from source.

  Note that supporting all the possible libc versions is not easy since
  we should set up a machines with the same C-library as the one used on your system,
  find a version of conda that works with this configuration and finally try to recompile 
  the application and the corresponding libraries)

For more info, please consult the [official conda documentation](https://conda.io/docs/troubleshooting.html)
