#!/bin/bash
#BSUB -n 16
#BSUB -R "span[hosts=1] select[ttc || stc] rusage[mem=2GB/task]"
#BSUB -M 2GB!
#BSUB -W 1:00
#BSUB -J your-job-name
#BSUB -q space
#BSUB -o stdout.%J
#BSUB -e stderr.%J

. /usr/share/Modules/init/bash
module load apptainer
apptainer run -B $PWD /usr/local/usrapps/ssp/cp2k_apptainer/cp2k_latest.sif mpiexec -n 8 -genv OMP_NUM_THREADS=2 cp2k -i *.inp -o runlog.log
