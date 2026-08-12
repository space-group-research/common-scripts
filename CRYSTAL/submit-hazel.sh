#!/bin/bash
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=32G
#SBATCH --time=03:00:00
#SBATCH --job-name=your-crystal-job-name
#SBATCH --partition=compute
#SBATCH --output=stdout.%j
#SBATCH --error=stderr.%j

. /usr/share/Modules/init/bash

MPI=/usr/local/apps/openmpi/4.1.0-gcc9.3.0
source /usr/local/usrapps/ssp/CRYSTAL23/utils23/cry23.bashrc
export OMP_NUM_THREADS=1

JOBNAME=your-input      # expects ${JOBNAME}.d12 in current directory

# Create isolated scratch folder
SCRDIR=$CRY23_SCRDIR/${SLURM_JOB_ID}
mkdir -p $SCRDIR
cp ${JOBNAME}.d12 $SCRDIR/INPUT
cd $SCRDIR

# Execute CRYSTAL (Automatically matches core count requested in #SBATCH --ntasks)
$MPI/bin/mpirun -n $SLURM_NTASKS $CRY23_EXEDIR/$VERSION/Pcrystal < INPUT > $SLURM_SUBMIT_DIR/${JOBNAME}.out 2>&1

# Return home and retrieve restart / GUI files
cd $SLURM_SUBMIT_DIR
[ -e $SCRDIR/fort.9 ]  && cp $SCRDIR/fort.9  $SLURM_SUBMIT_DIR/${JOBNAME}.f9
[ -e $SCRDIR/fort.34 ] && cp $SCRDIR/fort.34 $SLURM_SUBMIT_DIR/${JOBNAME}.gui

# Safely clean up scratch directory
if [ -n "$SLURM_JOB_ID" ] && [ -d "$SCRDIR" ] && [[ "$SCRDIR" == *"$SLURM_JOB_ID"* ]]; then
    echo "Cleaning up scratch directory: $SCRDIR"
    rm -rf "$SCRDIR"
else
    echo "Warning: Safety check failed! $SCRDIR was not deleted automatically."
fi
