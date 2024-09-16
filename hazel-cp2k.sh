#!/bin/bash
#BSUB -n 32
#BSUB -R "span[hosts=1] select[ttc || stc]"
#BSUB -W 48:00
#BSUB -J your-job-name
#BSUB -q space
#BSUB -o stdout.%J
#BSUB -e stderr.%J

. /usr/share/Modules/init/bash
module purge
module load PrgEnv-intel/2022.1.0
source /usr/local/usrapps/ssp/cp2k-2023.2.intel/tools/toolchain/install/setup
export PATH=$PATH:/usr/local/usrapps/ssp/cp2k-2023.2.intel/exe/local
export CP2K_DATA_DIR=/usr/local/usrapps/ssp/cp2k-2023.2.intel/data

export OMP_NUM_THREADS=1

mpirun cp2k.psmp -i *.inp -o runlog.log
