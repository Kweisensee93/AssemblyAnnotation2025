#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=00:20:00
#SBATCH --job-name=TEsorter
#SBATCH --output=../logfiles/TEsorter_%j.out
#SBATCH --error=../logfiles/TEsorter_%j.err
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/kweisensee/assembly"
TE_SORTER_IMAGE="/data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif" # Image for TEsorter
EDTA="$WORKDIR/output/EDTA/No-0.fa.mod.EDTA.raw/No-0.fa.mod.LTR.raw.fa"  # We use the .raw.fa from EDTA (within the <samplename>.raw subfolder) for TEsorter
OUTDIR="$WORKDIR/output/TE_Sorter"
mkdir -p $OUTDIR

cd $OUTDIR

# Run TEsorter in apptainer
apptainer exec \
    --bind /data \
    ${TE_SORTER_IMAGE} TEsorter \
    ${EDTA} \
    -db \
    rexdb-plant
