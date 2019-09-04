#!/bin/bash

## Follow https://www.youtube.com/watch?v=xvUuBT0iFSo

# Load module
# module load icc_19-impi_2019

# Configure
# ./configure MPIF90=mpiifort CC=mpiicc F90=ifort F77=mpiifort -enable-openmp

# Edit make.inc
sed -i -e 's/# TOPDIR =/TOPDIR=/g' make.inc

# MPI
sed -i -e 's/FFLAGS         = -O2 -assume byterecl -g -traceback -qopenmp/FFLAGS         = -O3 -assume byterecl -g -traceback -qopenmp/g' make.inc
sed -i -e 's/BLAS_LIBS      =   -lmkl_intel_lp64  -lmkl_sequential -lmkl_core/BLAS_LIBS       = -L${MKLROOT}\/lib\/intel64 -lmkl_scalapack_ilp64 -lmkl_intel_ilp64 -lmkl_sequential -lmkl_core -lmkl_blacs_intelmpi_ilp64 -lpthread -lm -ldl/g' make.inc
sed -i -e 's/LAPACK_LIBS    =/LAPACK_LIBS       = -L${MKLROOT}\/lib\/intel64 -lmkl_scalapack_ilp64 -lmkl_intel_ilp64 -lmkl_sequential -lmkl_core -lmkl_blacs_intelmpi_ilp64 -lpthread -lm -ldl/g' make.inc
sed -i -e 's/SCALAPACK_LIBS =/SCALAPACK_LIBS       = -L${MKLROOT}\/lib\/intel64 -lmkl_scalapack_ilp64 -lmkl_intel_ilp64 -lmkl_sequential -lmkl_core -lmkl_blacs_intelmpi_ilp64 -lpthread -lm -ldl/g' make.inc
sed -i -e 's/FFT_LIBS       =/FFT_LIBS       = -L${MKLROOT}\/lib\/intel64 -lmkl_scalapack_ilp64 -lmkl_intel_ilp64 -lmkl_sequential -lmkl_core -lmkl_blacs_intelmpi_ilp64 -lpthread -lm -ldl/g' make.inc
sed -i -e 's/MPI_LIBS       =/MPI_LIBS       = -L\/gscratch\/sw\/intel-2019\/impi\/2019.0.117\/intel64\/lib\/ -lmpi/g' make.inc

# OPEN-MP
#sed -i -e 's/FFLAGS         = -O2 -assume byterecl -g -traceback -qopenmp/FFLAGS         = -O3 -assume byterecl -g -traceback -qopenmp/g' make.inc
#sed -i -e 's/BLAS_LIBS      =   -lmkl_intel_lp64  -lmkl_intel_thread -lmkl_core/BLAS_LIBS       = -L${MKLROOT}\/lib\/intel64 -lmkl_scalapack_ilp64 -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -lmkl_blacs_intelmpi_ilp64 -liomp5 -lpthread -lm -ldl/g' make.inc
#sed -i -e 's/LAPACK_LIBS    =/LAPACK_LIBS       = -L${MKLROOT}\/lib\/intel64 -lmkl_scalapack_ilp64 -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -lmkl_blacs_intelmpi_ilp64 -liomp5 -lpthread -lm -ldl/g' make.inc
#sed -i -e 's/SCALAPACK_LIBS =/SCALAPACK_LIBS       = -L${MKLROOT}\/lib\/intel64 -lmkl_scalapack_ilp64 -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -lmkl_blacs_intelmpi_ilp64 -liomp5 -lpthread -lm -ldl/g' make.inc
#sed -i -e 's/FFT_LIBS       =/FFT_LIBS       = -L${MKLROOT}\/lib\/intel64 -lmkl_scalapack_ilp64 -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -lmkl_blacs_intelmpi_ilp64 -liomp5 -lpthread -lm -ldl/g' make.inc
#sed -i -e 's/MPI_LIBS       =/MPI_LIBS       = -L\/gscratch\/sw\/intel-2019\/impi\/2019.0.117\/intel64\/lib\//g' make.inc
