#!/bin/bash
#SBATCH --ntasks=64
#SBATCH --nodes=1
#SBATCH --mem=128G
#SBATCH --time=60:00:00
#SBATCH --job-name=your-job
#SBATCH --partition=compute_partners
#SBATCH --output=stdout.%j
#SBATCH --error=stderr.%j

. /usr/share/Modules/init/bash

TC=/usr/local/usrapps/ssp/cp2k-2023.2
MPI=/usr/local/apps/openmpi/4.1.0-gcc9.3.0

source $TC/tools/toolchain/install/setup
export CP2K_DATA_DIR=$TC/data
export OMP_NUM_THREADS=1

$MPI/bin/mpirun -n $SLURM_NTASKS $TC/exe/local/cp2k.psmp -i *.inp -o runlog.log
