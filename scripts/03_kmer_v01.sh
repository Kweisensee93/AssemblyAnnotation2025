#!/bin/bash

#SBATCH --time=01:00:00
#SBATCH --mem=40g
#SBATCH --cpus-per-task=4                   # 4 CPUs for speed up
#SBATCH --job-name=kmer_count
#SBATCH --output=../logfiles/kmer_%J.out      # Standard output
#SBATCH --error=../logfiles/kmer_%J.err       # Standard error
#SBATCH --partition=pibu_el8                # Partition for the course


JELLYFISH_IMAGE="/containers/apptainer/jellyfish-2.2.6--0.sif"     # Image for jellyfish

# Define variables
WORKDIR="/data/users/kweisensee/assembly"              # Project main folder
OUTDIR="${WORKDIR}/output/kmer"                        # Output for Jellyfish
mkdir -p ${OUTDIR}                                     # Create Output if it doesn't exist
READDIR="${WORKDIR}/output/fastp"                      # Input for Jellyfish

apptainer exec --bind /data ${JELLYFISH_IMAGE} \
    jellyfish count -C -m 21 -s 5G -t $SLURM_CPUS_PER_TASK \
    <(zcat "${READDIR}/ERR11437335.trimmed.fastq.gz") -o "${OUTDIR}/reads.jf"

apptainer exec --bind /data ${JELLYFISH_IMAGE} \
    jellyfish histo -t $SLURM_CPUS_PER_TASK "${OUTDIR}/reads.jf" \
    > "${OUTDIR}/reads.histo"