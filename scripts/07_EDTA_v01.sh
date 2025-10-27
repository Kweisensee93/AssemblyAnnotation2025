#!/usr/bin/env bash

#SBATCH --cpus-per-task=21
#SBATCH --mem=80G
#SBATCH --time=2-12:00:00
#SBATCH --job-name=edta
#SBATCH --output=../logfiles/edta_%j.out
#SBATCH --error=../logfiles/edta_%j.err
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/kweisensee/assembly"
EDTA_IMAGE="/data/courses/assembly-annotation-course/CDS_annotation/containers/EDTA2.2.sif" # Image for EDTA
HIFIASM="$WORKDIR/output/hifiasm/No-0.fa"  # We use HiFiASM assembly for annotation
OUTDIR="$WORKDIR/output/EDTA"
mkdir -p $OUTDIR

cd $OUTDIR

# Note the CDS file is copied from:
# /data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_cds_20110103_representative_gene_model_updated

# Run EDTA in apptainer
# Use one CPU less than requested - just in case
apptainer exec \
    --bind ${WORKDIR} \
    ${EDTA_IMAGE} \
    EDTA.pl \
    --genome ${HIFIASM} \
    --species others \
    --step all \
    --sensitive 1 \
    --cds "/data/users/kweisensee/assembly/rawdata/TAIR10_cds_20110103" \
    --anno 1 \
    --threads 20