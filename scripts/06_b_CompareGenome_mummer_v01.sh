#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=genome_comp
#SBATCH --output=../logfiles/mummer_%j.out
#SBATCH --error=../logfiles/mummer_%j.err
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/kweisensee/assembly"
REF=${WORKDIR}/rawdata/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
FLYE="${WORKDIR}/output/flye/assembly.fasta"
HIFIASM="$WORKDIR/output/hifiasm/No-0.fa"
LJA="$WORKDIR/output/LJA/No-0/assembly.fasta"
RESULTDIR="${WORKDIR}/output/genomes_comparison"
mkdir -p $RESULTDIR

#mummer
apptainer exec --bind /data \
    /containers/apptainer/mummer4_gnuplot.sif mummerplot \
    -R $REF -Q $FLYE \
    -breaklen 1000 \
    --filter \
    -t png --large --layout --fat \
    -p $RESULTDIR/flye \
    genome_flye.delta

apptainer exec --bind /data \
    /containers/apptainer/mummer4_gnuplot.sif mummerplot \
    -R $REF -Q $HIFIASM \
    -breaklen 1000 \
    --filter \
    -t png --large --layout --fat \
    -p $RESULTDIR/hifiasm \
    genome_hifiasm.delta

apptainer exec --bind /data \
    /containers/apptainer/mummer4_gnuplot.sif mummerplot \
    -R $REF -Q $LJA \
    -breaklen 1000 \
    --filter \
    -t png --large --layout --fat \
    -p $RESULTDIR/LJA \
    genome_LJA.delta


