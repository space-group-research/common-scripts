#!/bin/bash
#BSUB -n 1
#BSUB -R "span[hosts=1]"
#BSUB -W 1:00
#BSUB -J your-crystal-job
##BSUB -q space
#BSUB -o stdout.%J
#BSUB -e stderr.%J

source /usr/share/Modules/init/bash
module purge
module load cmake/3.24.1 gcc/9.3.0 openmpi-gcc/openmpi4.1.0-gcc9.3.0

source /usr/local/usrapps/ssp/CRYSTAL23/utils23/cry23.bashrc

export OMP_NUM_THREADS=1

#export CRY23_INP=$CRY23_ROOT/test_cases/inputs
#export CRY23_PROP=$CRY23_ROOT/test_cases/inputs

runcry23 test_cryst
