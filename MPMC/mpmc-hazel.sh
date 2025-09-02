#!/bin/bash
#BSUB -n 4
#BSUB -R "span[hosts=1] rusage[mem=2GB/task]"
#BSUB -M 2GB!
#BSUB -W 48:00
#BSUB -J your-mpmc-job
#BSUB -o stdout.%J
#BSUB -e stderr.%J
#BSUB -q space
##BSUB -q space_gpu
##BSUB -gpu "num=1:mode=shared:mps=no"

source /usr/share/Modules/init/bash
module purge
module load cuda/12.3 cmake/3.24.1 gcc/10.2.0 openmpi-gcc/openmpi4.1.0-gcc10.2.0

## export CC=/usr/local/apps/gcc/10.2.0/bin/gcc
## export CXX=/usr/local/apps/gcc/10.2.0/bin/g++
## export FC=/usr/local/apps/gcc/10.2.0/bin/gfortran

export LD_LIBRARY_PATH=/usr/local/usrapps/ssp/mpmc/install_dir:$LD_LIBRARY_PATH

module list

mpirun /usr/local/usrapps/ssp/mpmc/mpmc *.inp
