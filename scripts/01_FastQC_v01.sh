#!/bin/bash

#SBATCH --time=00:30:00
#SBATCH --mem=1g
#SBATCH --cpus-per-task=4
#SBATCH --job-name=quality_control
#SBATCH --output=../logfiles/QC_%J.out   # Standard output
#SBATCH --error=../logfiles/QC_%J.err    # Standard error
#SBATCH --partition=pibu_el8

# if and only if singularity/apptainer is not working (N.B.: It is another version!):
# module load FastQC/0.11.9-Java-11

FASTQC_IMAGE="/containers/apptainer/fastqc-0.12.1.sif"

# Define variables
WORKDIR="/data/users/kweisensee/assembly"
OUTDIR="${WORKDIR}/output/fastqc"

# run with module:
#fastqc -o "$OUTDIR" -f fastq "${WORKDIR}/rawdata/${READ1}" "${WORKDIR}/rawdata/${READ2}"

# Run FastQC inside Singularity
# change folders as needed!
# no forward and backward reads - we use PacBio data not Illumina
apptainer exec --bind /data ${FASTQC_IMAGE} fastqc \
    -t $SLURM_CPUS_PER_TASK \
    -o "$OUTDIR" \
    -f fastq "${WORKDIR}/rawdata/No-0/ERR11437335.fastq.gz"