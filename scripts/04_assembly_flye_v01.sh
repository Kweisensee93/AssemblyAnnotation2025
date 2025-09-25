#!/usr/bin/env bash

#SBATCH --time=1-00:00:00                   # Assembly may need up to a full day
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=flye
#SBATCH --output=../logfiles/QC_%J.out      # Standard output
#SBATCH --error=../logfiles/QC_%J.err       # Standard error
#SBATCH --partition=pibu_el8                # Partition for the course

FLYE_IMAGE=/containers/apptainer/flye_2.9.5.sif  #Image for Flye

# Define variables
WORKDIR="/data/users/kweisensee/assembly"               # Project main folder
OUTDIR="${WORKDIR}/output/flye"                         # Output for flye
mkdir -p ${OUTDIR}
READDIR="${WORKDIR}/output/fastp"                       # use trimmed data from fastp

apptainer exec --bind /data ${FLYE_IMAGE} \
    flye --pacbio-hifi \
    ${READDIR}/ERR11437335.trimmed.fastq.gz \
    -o ${OUTDIR} \
    -t ${SLURM_CPUS_PER_TASK}
