#!/bin/bash
#BSUB -n 8
#BSUB -R "span[hosts=1] rusage[mem=4GB/task]"
#BSUB -M 4GB!
#BSUB -W 1:00
#BSUB -J your-job-name
#BSUB -q space_gpu
#BSUB -gpu "num=1:mode=shared:mps=no"
#BSUB -o stdout.%J
#BSUB -e stderr.%J

. /usr/share/Modules/init/bash
module load apptainer cuda/12.3

echo "Host nvidia-smi"
echo "---------------"
nvidia-smi

echo ""
echo "Container nvidia-smi"
echo "--------------------"
apptainer run --nv  /usr/local/usrapps/ssp/cp2k_apptainer/cp2k_2025.1_openmpi_generic_cuda_P100_psmp.sif nvidia-smi

apptainer run --nv -B $PWD /usr/local/usrapps/ssp/cp2k_apptainer/cp2k_2025.1_openmpi_generic_cuda_P100_psmp.sif mpiexec -n 8 -x OMP_NUM_THREADS=1 cp2k -i *.inp -o runlog.log
