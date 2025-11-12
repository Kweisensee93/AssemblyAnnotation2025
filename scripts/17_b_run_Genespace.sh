#!/usr/bin/env bash

#SBATCH --time=02:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=24
#SBATCH --job-name=Genespace_run
#SBATCH --partition=pibu_el8
#SBATCH --output=../logfiles/Genespace_run_%j.out
#SBATCH --error=../logfiles/Genespace_run_%j.err

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/kweisensee/assembly"
GENESPACE="${WORKDIR}/output/Genespace"

# Prepare names (no - allowed)
# BED files
cd ${WORKDIR}/output/Genespace/bed
for f in *.bed; do mv "$f" "${f//-/_}"; done

# Peptide (FASTA) files
cd ${WORKDIR}/output/Genespace/peptide
for f in *.fa; do mv "$f" "${f//-/_}"; done

# We added Isoform previously, which causes errors now!
# Remove isoform designations
sed -i 's/-R[A-Z]*$//' /data/users/kweisensee/assembly/output/Genespace/peptide/No_0.fa
sed -i 's/-R[A-Z]*$//' /data/users/kweisensee/assembly/output/Genespace/peptide/Ice_1.fa
sed -i 's/-R[A-Z]*$//' /data/users/kweisensee/assembly/output/Genespace/peptide/Kar_1.fa
sed -i 's/-R[A-Z]*$//' /data/users/kweisensee/assembly/output/Genespace/peptide/Est_0.fa


apptainer exec \
    --bind $COURSEDIR \
    --bind $WORKDIR \
    --bind $SCRATCH:/temp \
    $COURSEDIR/containers/genespace_latest.sif \
    Rscript ${WORKDIR}/scripts/genespace.R \
    "${GENESPACE}"