#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=quast
#SBATCH --output=../logfiles/quast_%j.out
#SBATCH --error=../logfiles/quast_%j.err
#SBATCH --partition=pibu_el8

# Define variables
QUAST_IMAGE="/containers/apptainer/quast_5.2.0.sif"  # Image for QUAST
WORKDIR="/data/users/kweisensee/assembly"
OUTDIR="${WORKDIR}/output/quast"
mkdir -p $OUTDIR

#Input assemblies
FLYE="${WORKDIR}/output/flye/assembly.fasta"
HIFIASM="${WORKDIR}/output/hifiasm/No-0.fa"
LJA="${WORKDIR}/output/LJA/No-0/assembly.fasta"

# Reference files
REF="${WORKDIR}/rawdata/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
REF_FEATURE="${WORKDIR}/rawdata/references/TAIR10_GFF3_genes.gff"

# With reference
apptainer exec --bind /data ${QUAST_IMAGE} \
  quast.py -o ${OUTDIR}/with_ref \
  --labels flye,hifiasm,LJA \
  -r $REF \
  --features $REF_FEATURE \
  --threads $SLURM_CPUS_PER_TASK \
  --eukaryote \
  $FLYE $HIFIASM $LJA

# Without reference
apptainer exec --bind /data ${QUAST_IMAGE} \
  quast.py -o ${OUTDIR}/no_ref \
  --labels flye,hifiasm,LJA \
  --threads $SLURM_CPUS_PER_TASK \
  --eukaryote \
  --est-ref-size 130000000 \
  $FLYE $HIFIASM $LJA