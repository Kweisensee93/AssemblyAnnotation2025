#!/usr/bin/env bash

#SBATCH --time=1-00:00:00                   # Assembly may need up to a full day
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=LJA
#SBATCH --output=../logfiles/LJA_%J.out      # Standard output
#SBATCH --error=../logfiles/LJA_%J.err       # Standard error
#SBATCH --partition=pibu_el8                # Partition for the course


LJA_IMAGE=/containers/apptainer/lja-0.2.sif  #Image for LJA

# Define variables
WORKDIR="/data/users/kweisensee/assembly"               # Project main folder
OUTDIR="${WORKDIR}/output/LJA"                          # Output for LJA
mkdir -p ${OUTDIR}
READDIR="${WORKDIR}/output/fastp"                       # use trimmed data from fastp

apptainer exec --bind /data ${LJA_IMAGE} \
    lja \
    -o ${OUTDIR}/No-0 \
    -t ${SLURM_CPUS_PER_TASK} \
    --reads ${READDIR}/ERR11437335.trimmed.fastq.gz