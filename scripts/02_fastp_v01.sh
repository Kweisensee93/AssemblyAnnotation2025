#!/bin/bash

#SBATCH --time=02:00:00
#SBATCH --mem=1g
#SBATCH --cpus-per-task=4                   # 4 CPUs for speed up
#SBATCH --job-name=trimming_fastp
#SBATCH --output=../logfiles/Trim_%J.out      # Standard output
#SBATCH --error=../logfiles/Trim_%J.err       # Standard error
#SBATCH --partition=pibu_el8                # Partition for the course


FASTP_IMAGE="/containers/apptainer/fastp_0.23.2--h5f740d0_3.sif"     # Image for fastp

# Define variables
WORKDIR="/data/users/kweisensee/assembly"               # Project main folder
OUTDIR="${WORKDIR}/output/fastp"                        # Output for fastp
mkdir -p ${OUTDIR}                                      # Create Output if it doesn't exist

# Run fastp inside Singularity
# change folders as needed!
# Illumina RNA-seq (paired-end)
apptainer exec --bind /data ${FASTP_IMAGE} fastp \
  -i $DATADIR/RNAseq_Sha/ERR754081_1.fastq.gz \
  -I $DATADIR/RNAseq_Sha/ERR754081_2.fastq.gz \
  -o $OUTDIR/ERR754081_1.trimmed.fastq.gz \
  -O $OUTDIR/ERR754081_2.trimmed.fastq.gz \
  --thread $SLURM_CPUS_PER_TASK \
  --html $OUTDIR/fastp_RNA.html \
  --json $OUTDIR/fastp_RNA.json

# PacBio HiFi (single-end)
apptainer exec --bind /data ${FASTP_IMAGE} fastp \
  -i $DATADIR/Istisu-1/ERR11437352.fastq.gz \
  -o $OUTDIR/ERR11437352.fastq.gz \
  --thread $SLURM_CPUS_PER_TASK \
  --disable_quality_filtering \
  --disable_length_filtering \
  --disable_adapter_trimming \
  --html $OUTDIR/fastp_PacBio.html \
  --json $OUTDIR/fastp_PacBio.json