#!/bin/bash

#SBATCH --time=01:15:00                     # For Pacbio 1h 15 min is needed
#SBATCH --mem=1g
#SBATCH --cpus-per-task=4                   # 4 CPUs for speed up
#SBATCH --job-name=quality_control
#SBATCH --output=../logfiles/QC_%J.out      # Standard output
#SBATCH --error=../logfiles/QC_%J.err       # Standard error
#SBATCH --partition=pibu_el8                # Partition for the course

FASTQC_IMAGE="/containers/apptainer/fastqc-0.12.1.sif"  # Image for FastQC

# Define variables
WORKDIR="/data/users/kweisensee/assembly"               # Project main folder
OUTDIR="${WORKDIR}/output/fastqc"                       # Output for QC

# Run FastQC inside Singularity
# change folders as needed!
# for PacBio only 1 file, for Illumina 2 files (forward & backward); see arguments for -f
apptainer exec --bind /data ${FASTQC_IMAGE} fastqc \
    -t $SLURM_CPUS_PER_TASK \
    -o "$OUTDIR" \
    -f fastq "${WORKDIR}/rawdata/RNAseq_Sha/ERR754081_1.fastq.gz" "${WORKDIR}/rawdata/RNAseq_Sha/ERR754081_2.fastq.gz"

# for the -f argument:
# for PacBio data use: -f fastq "${WORKDIR}/rawdata/No-0/ERR11437335.fastq.gz"
# for Illumina data: -f fastq "${WORKDIR}/rawdata/RNAseq_Sha/ERR754081_1.fastq.gz" "${WORKDIR}/rawdata/RNAseq_Sha/ERR754081_2.fastq.gz"


# if and only if singularity/apptainer is not working (N.B.: It is another version!):
# module load FastQC/0.11.9-Java-11
# run with module:
# fastqc -t $SLURM_CPUS_PER_TASK -o "$OUTDIR" -f fastq "${WORKDIR}/rawdata/" "${WORKDIR}/rawdata/"