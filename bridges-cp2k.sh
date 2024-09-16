#!/bin/bash
#SBATCH --job-name="your-job-name"
#SBATCH --output="slurm.%A.out"
#SBATCH --partition=RM-shared
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --export=ALL
#SBATCH -t 48:00:00


module purge
module load CP2K/8.1-gcc10.2.0-openmpi4.0.5 gcc/10.2.0 openmpi/4.0.5-gcc10.2.0

mpirun -np 25 cp2k.popt -i *.inp -o runlog.log
