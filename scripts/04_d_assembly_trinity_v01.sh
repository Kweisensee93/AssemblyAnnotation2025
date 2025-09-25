#!/usr/bin/env bash

#SBATCH --time=1-00:00:00                   # Assembly may need up to a full day
#SBATCH --mem=84G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=trinity
#SBATCH --output=../logfiles/trinity_%J.out      # Standard output
#SBATCH --error=../logfiles/trinity_%J.err       # Standard error
#SBATCH --partition=pibu_el8                # Partition for the course

# Load Trinity module
module load Trinity/2.15.1-foss-2021a

# Define variables
WORKDIR="/data/users/kweisensee/assembly"               # Project main folder
OUTDIR="${WORKDIR}/output/trinity"                      # Output for trinity
mkdir -p ${OUTDIR}
READDIR="${WORKDIR}/output/fastp"                       # use trimmed data from fastp

# Run Trinity - using trimmed Illumina data
Trinity \
  --seqType fq \
  --left ${READDIR}/ERR754081_1.trimmed.fastq.gz \
  --right ${READDIR}/ERR754081_2.trimmed.fastq.gz \
  --CPU $SLURM_CPUS_PER_TASK \
  --max_memory 80G \
  --output $OUTDIR