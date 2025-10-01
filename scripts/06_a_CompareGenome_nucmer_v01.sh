#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=genome_comp
#SBATCH --output=../logfiles/nucmer_%j.out
#SBATCH --error=../logfiles/nucmer_%j.err
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/kweisensee/assembly"
REF=${WORKDIR}/rawdata/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
FLYE="${WORKDIR}/output/flye/assembly.fasta"
HIFIASM="$WORKDIR/output/hifiasm/No-0.fa"
LJA="$WORKDIR/output/LJA/No-0/assembly.fasta"
RESULTDIR="${WORKDIR}/output/genomes_comparison"
mkdir -p $RESULTDIR

#nucmer
apptainer exec --bind /data \
    /containers/apptainer/mummer4_gnuplot.sif nucmer \
    --prefix genome_flye \
    --breaklen 1000 \
    --mincluster 1000 \
    --threads $SLURM_CPUS_PER_TASK \
    $REF $FLYE 

apptainer exec --bind /data \
    /containers/apptainer/mummer4_gnuplot.sif nucmer \
    --prefix genome_hifiasm \
    --breaklen 1000 \
    --mincluster 1000 \
    --threads $SLURM_CPUS_PER_TASK \
    $REF $HIFIASM 

apptainer exec --bind /data \
    /containers/apptainer/mummer4_gnuplot.sif nucmer \
    --prefix genome_LJA \
    --breaklen 1000 \
    --mincluster 1000 \
    --threads $SLURM_CPUS_PER_TASK \
    $REF $LJA 
