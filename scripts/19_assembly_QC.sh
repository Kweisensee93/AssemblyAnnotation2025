#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=2G
#SBATCH --time=01:00:00
#SBATCH --job-name=alignment_stats
#SBATCH --output=../logfiles/alignment_stats_%j.out
#SBATCH --error=../logfiles/alignment_stats_%j.err
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/kweisensee/assembly"
RESULTDIR="$WORKDIR/output/evaluation"
mkdir -p $RESULTDIR
ASSEMBLYDIR="$WORKDIR/output"
# cp /containers/apptainer/gfastats_1.3.9.sif /data/users/kweisensee/assembly/
#GFASTATS_IMAGE="${WORKDIR}/gfastats_1.3.9.sif"
GFASTATS_IMAGE="/containers/apptainer/gfastats_1.3.9.sif"

touch ${RESULTDIR}/hifiasm_stats.txt
touch ${RESULTDIR}/flye_stats.txt
touch ${RESULTDIR}/LJA_stats.txt

apptainer exec \
    --bind ${WORKDIR} \
    ${GFASTATS_IMAGE} gfastats \
    ${ASSEMBLYDIR}/hifiasm/No-0.fa > \
    ${RESULTDIR}/hifiasm_stats.txt

apptainer exec \
    --bind ${WORKDIR} \
    ${GFASTATS_IMAGE} gfastats \
    ${ASSEMBLYDIR}/flye/assembly.fasta > \
    ${RESULTDIR}/flye_stats.txt

apptainer exec --bind ${WORKDIR} \
    ${GFASTATS_IMAGE} gfastats\
    ${ASSEMBLYDIR}/LJA/No-0/assembly.fasta > \
    ${RESULTDIR}/LJA_stats.txt

