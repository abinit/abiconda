[![Build Status](https://travis-ci.org/abinit/abiconda.svg?branch=master)](https://travis-ci.org/abinit/abiconda)
[![Anaconda-Server Badge](https://anaconda.org/abinit/abinit/badges/version.svg)](https://anaconda.org/abinit/abinit)

## abinit channel

This repository contains conda recipes to build Abinit-related packages.
The pre-compiled libraries and executables for Linux and MacOSx are available on the 
[abinit channel](https://anaconda.org/abinit).
The goal is to facilitate the installation of abinit to end-users who want to
run the code on their personal computers without having to pass through the compilation process.
This channel also provides conda packages for [AbiPy](https://github.com/abinit/abipy)
and can be used in conjunction with the [materials.sh](https://github.com/materialsvirtuallab/materials.sh) channel
to install a powerful Python + Fortran ecosystem for materials science research.

For a quick howto with the five commands required to install Abinit on your machine (Linux or MacOSx),
jump immediately to the [next section](#Abinit_in_five_steps).
A more detailed discussion about the installation with ``conda``, 
and the use of conda environments is given in [this section](#Getting_started).
For further information on the conda package manager, please consult the 
[official conda documentation](https://conda.io/docs/using/).

Note that these pre-compiled executables are useful if you want to try Abinit on your machine 
but they are not supposed to be used for high-performance calculations.

For examples of configuration files to configure/compile Abinit on clusters, please visit
the [abiconfig](https://github.com/abinit/abiconfig) repository.
If you need a **real package manager** able to support multiple versions 
and configurations of software, consider the following projects:

  * [spack](https://github.com/LLNL/spack)
  * [easybuild](https://github.com/hpcugent/easybuild)

Both projects are designed for large supercomputing centers and 
they already provide configuration files to build Abinit.

## How to install Abinit in five steps <a name="Abinit_in_five_steps"></a>

If you are a Linux user, download and install ``miniconda`` on your local machine with:

    wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh
    bash Miniconda2-latest-Linux-x86_64.sh

while for MacOSx use:

    curl -o https://repo.continuum.io/miniconda/Miniconda2-latest-MacOSX-x86_64.sh
    bash Miniconda2-latest-MacOSX-x86_64.sh

Answer ``yes`` to the question:

    Do you wish the installer to prepend the Miniconda2 install location
    to PATH in your /home/gmatteo/.bashrc ? [yes|no]
    [no] >>> yes

Source your ``.bashrc`` file to activate the changes done by ``miniconda`` to your ``$PATH``:

    source ~/.bashrc

Add ``conda-forge`` to the conda channels:

    conda config --add channels conda-forge

Install the parallel version of abinit from the ``abinit channel`` with:

    conda install abinit --channel abinit
    abinit -v

The [troubleshooting](#Troubleshooting) section discusses how to solve typical problems.
    
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

    conda create -n abienv

and activate it with:

    source activate abienv

It's always a good idea to install Abinit and its dependencies in a separate environment 
because installing one program at a time can lead to dependency conflicts.
For more information about conda environment, consult the 
[official documentation](https://conda.io/docs/using/envs.html#).

The most important (pre-compiled) libraries will be obtained by [conda-forge](https://conda-forge.github.io)
so we have to add ``conda-forge`` to the list of default channels with:

    conda config --add channels conda-forge

Now we can install abinit from the ``abinit channel`` with:

    conda install abinit --channel abinit

This command downloads and installs the last version of Abinit from the [abinit channel](https://anaconda.org/abinit).
The Abinit executables are placed inside the anaconda directory associated to the ``abienv`` environment:

    which abinit
    /Users/gmatteo/anaconda2/envs/abienv/bin/abinit

Linux users can use the shell command:

    ldd `which abinit`

to get the list of dynamic libraries linked to the application whereas macOSx can use:

    otool -L `which abinit`

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
environment variable ``OMP_NUM_THREADS``. 
We strongly suggest to add:

    export OMP_NUM_THREADS=1

to your ``.bash_profile`` because by default the OpenMP library uses all the available cores
if this variable is not defined.

Alternatively, one can install the **sequential** version (minimal dependencies, no parallelism) with: 

    conda install abinit_seq --channel abinit

To get the list of Abinit versions available in the [abinit channel](https://anaconda.org/abinit):

    conda search abinit --channel abinit

        Fetching package metadata ...........
        abinit                       8.0.8                         0  abinit
                                  *  8.2.2                         0  abinit
        abinit_seq                *  8.2.2                         0  abinit

To install a particular version of Abinit use:

    $ conda install abinit=8.2.0 --channel abinit


## Packages

abinit: 

Version with MPI support, libxc, fftw3, openblas and netcdf4 + hdf5

[![Anaconda-Server Badge](https://anaconda.org/abinit/abinit/badges/version.svg)](https://anaconda.org/abinit/abinit)

abinit\_seq: 

Sequential version with internal fallbacks for libxc and netcdf3 (statically linked).

[![Anaconda-Server Badge](https://anaconda.org/abinit/abinit_seq/badges/version.svg)](https://anaconda.org/abinit/abinit_seq)

oncvpsp:

Generator for norm-conserving pseudopotentials compiled with ``libxc`` support

[![Anaconda-Server Badge](https://anaconda.org/abinit/oncvpsp/badges/version.svg)](https://anaconda.org/abinit/oncvpsp)

atompaw:

Generator for PAW datasets compiled with ``libxc`` support

[![Anaconda-Server Badge](https://anaconda.org/abinit/atompaw/badges/version.svg)](https://anaconda.org/abinit/atompaw)

## Troubleshooting <a name="Troubleshooting"></a>

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

- If the parallel version of Abinit aborts with the following error:

    Fatal error in MPI_Init: Other MPI error, error stack:
    MPIR_Init_thread(474)..............: 
    MPID_Init(190).....................: channel initialization failed 
    MPIDI_CH3_Init(89).................:
    MPID_nem_init(320).................:
    MPID_nem_tcp_init(173).............:
    MPID_nem_tcp_get_business_card(420):
    MPID_nem_tcp_init(379).............: gethostbyname failed, gmac2 (errno 1)

  open ``/etc/hosts`` with e.g. ``sudo vi /etc/hosts`` and add a new entry mapping 
  the ``127.0.0.1`` ip address to the name of your machine e.g.:

        127.0.0.1       localhost
        127.0.0.1       gmac2      # Add this line. Replace gmac2 with the name of your machine.

- Most of the dependencies including ``libgcc`` and ``libgfortran`` are automatically installed 
  in your conda environment when you issue  ``conda install APPNAME -c abinit``.
  In principle, these libraries should be compatible with the abinit executables but incompatibilities may appear
  when the ``conda`` developers decided to upgrade the ``gcc`` version or if other **tricky** dependencies 
  such as the MPI library are upgraded upstream.
  In this case, contact us and we will try to provide new pre-compiled versions compatible with the 
  new anaconda software stack.
  Alternatively, you may try the sequential version ``abinit_seq`` in which the number of external dependencies 
  and therefore the probability of linkage problems is significantly reduced.

- All the dependencies are provided by conda with the exception of the C standard library
  (``libc`` on linux, ``libSystem.B.dylib`` on MacOsx).
  If the C library provided by your OS is too old, you will get error messages such as:

      abinit
      abinit: /lib64/libc.so.6: version `GLIBC_2.14' not found (required by abinit)

  when you try to execute the application from the terminal. 
  ``ldd`` indeed shows that our system uses ``libc 2.12`` 

      ldd --version
      ldd (GNU libc) 2.12

  This means that our executable requires a C library that is not compatible with 
  the one available on your system (this usually happens when your library is too old).
  At the time of writing, we build executables and libraries for linux with GNU libc 2.12
  while MacOsx applications are built with MacOS 10.11.2. 
  This should cover the most common cases but it your OS is too old you will have to compile from source.

  Note that supporting all the possible ``libc`` versions is not easy since
  we should set up a machines with the same C-library as the one used on your system,
  find a version of conda that works with this configuration and finally try to recompile 
  the application and the corresponding libraries)

For more info, please consult the [official conda documentation](https://conda.io/docs/troubleshooting.html)
