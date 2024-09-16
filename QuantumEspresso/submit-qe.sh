#!/bin/bash
#BSUB -n 20
#BSUB -R "span[hosts=1]"
#BSUB -W 1:00
#BSUB -J your-qe-job
#BSUB -o stdout.%J
#BSUB -e stderr.%J

. /usr/share/Modules/init/bash
module purge
module load gcc/10.2.0 openmpi-gcc/openmpi4.1.0-gcc10.2.0 mkl/2019
export PATH=$PATH:/usr/local/usrapps/ssp/qe

export OMP_NUM_THREADS=1

mpirun pw.x -i *.inp > runlog.log
