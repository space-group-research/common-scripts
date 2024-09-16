#!/bin/bash
#BSUB -n 20
#BSUB -R "select[avx2] span[hosts=1]"
#BSUB -W 1:00
#BSUB -J your-orca-job
#BSUB -o stdout.%J
#BSUB -e stderr.%J

. /usr/share/Modules/init/bash
module purge
module load gcc/10.2.0 openmpi-gcc/openmpi4.1.0-gcc10.2.0

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/usrapps/ssp/orca_5_0_1_linux_x86-64_shared_openmpi411

/usr/local/usrapps/ssp/orca_5_0_1_linux_x86-64_shared_openmpi411/orca *.inp > runlog.log
