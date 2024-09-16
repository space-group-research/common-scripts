#!/bin/bash
#BSUB -n 20
#BSUB -R "span[hosts=1]"
#BSUB -W 1:00
#BSUB -J your-nwchem-job
#BSUB -o stdout.%J
#BSUB -e stderr.%J

. /usr/share/Modules/init/bash
module purge
module load gcc/9.3.0 openmpi-gcc/openmpi4.1.0-gcc9.3.0 conda
export NWCHEM_TOP=/usr/local/usrapps/ssp/nwchem-7.0.2-release
export NWCHEM_BASIS_LIBRARY=$NWCHEM_TOP/src/basis/libraries/
export PATH=$PATH:/usr/local/usrapps/ssp/nwchem-7.0.2-release/bin/LINUX64

export OMP_NUM_THREADS=1

mpirun nwchem *.nw > runlog.log
