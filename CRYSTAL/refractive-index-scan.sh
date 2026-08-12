#!/bin/bash
#SBATCH --job-name=n_scan
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=32G
#SBATCH --time=48:00:00
#SBATCH --partition=compute
#SBATCH --output=stdout.%j
#SBATCH --error=stderr.%j

. /usr/share/Modules/init/bash
MPI=/usr/local/apps/openmpi/4.1.0-gcc9.3.0
source /usr/local/usrapps/ssp/CRYSTAL23/utils23/cry23.bashrc
export OMP_NUM_THREADS=1

BASEDIR="$(pwd)"
LOGFILE="${BASEDIR}/hpc_run_all.log"
NCORES=$SLURM_NTASKS

log() {
    echo "$1"
    echo "$1" >> "$LOGFILE"
}

DIRS=("00_static" "550nm" "600nm" "650nm" "700nm" "750nm" "800nm" "850nm" "900nm" "950nm" "1000nm" "1050nm" "1064nm" "1100nm" "1150nm" "1200nm")

> "$LOGFILE"

log "============================================"
log "Starting Refractive Index Scan: $(date)"
log "Allocated Cores: ${NCORES}"
log "============================================"

# STEP 1: Ground-State SCF in 'static' (restarts using static/input.f9)
BASE_DIR="${DIRS[0]}"
BASE_PATH="${BASEDIR}/${BASE_DIR}"
SCF_SOURCE="${BASE_PATH}/input.f9"

log "Step 1: Running primary SCF calculation in '${BASE_DIR}'..."

cd "${BASE_PATH}" || exit 1

if ! grep -q "T E R M" "input.out" 2>/dev/null; then
    runPcry23 ${NCORES} input input
fi

if grep -q "T E R M" "input.out" 2>/dev/null && [ -s "${SCF_SOURCE}" ]; then
    log "Primary SCF in '${BASE_DIR}' COMPLETED successfully."
else
    log "ERROR: Primary SCF in '${BASE_DIR}' failed or input.f9 missing! Aborting scan."
    exit 1
fi

# STEP 2: Fast CPHF restarts across remaining wavelengths
log "Step 2: Launching CPHF restarts..."

for dir in "${DIRS[@]:1}"; do
    JOB_DIR="${BASEDIR}/${dir}"

    if [ ! -d "${JOB_DIR}" ]; then
        log "WARNING: Directory ${JOB_DIR} does not exist. Skipping."
        continue
    fi

    cd "${JOB_DIR}" || continue

    if grep -q "T E R M" "input.out" 2>/dev/null; then
        log "${dir}: already complete — skipping"
        continue
    fi

    log "Running ${dir} at $(date)..."

    cp "${SCF_SOURCE}" "${JOB_DIR}/input.f9"
    runPcry23 ${NCORES} input input

    if grep -q "T E R M" "input.out" 2>/dev/null; then
        log "${dir}: COMPLETED successfully at $(date)"
    else
        log "${dir}: FAILED (no TERMINATION found) at $(date)"
    fi
done

log "============================================"
log "Refractive index scan completed at: $(date)"
log "============================================"
