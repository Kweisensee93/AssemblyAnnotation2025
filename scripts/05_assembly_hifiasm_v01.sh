#!/usr/bin/env bash

#SBATCH --time=1-00:00:00                   # Assembly may need up to a full day
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=hifiasm
#SBATCH --output=../logfiles/hifiasm_%J.out      # Standard output
#SBATCH --error=../logfiles/hifiasm_%J.err       # Standard error
#SBATCH --partition=pibu_el8                # Partition for the course

HIFIASM_IMAGE=/containers/apptainer/hifiasm_0.19.8.sif  #Image for Flye

# Define variables
WORKDIR="/data/users/kweisensee/assembly"               # Project main folder
OUTDIR="${WORKDIR}/output/hifiasm"                      # Output for hifiasm
mkdir -p ${OUTDIR}
READDIR="${WORKDIR}/output/fastp"                       # use trimmed data from fastp

apptainer exec --bind /data ${HIFIASM_IMAGE} \
    hifiasm \
    -o ${OUTDIR}/No-0 \
    -t ${SLURM_CPUS_PER_TASK} \
    ${READDIR}/ERR11437335.trimmed.fastq.gz
