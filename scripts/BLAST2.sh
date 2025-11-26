#!/usr/bin/env bash

#SBATCH --time=1-10:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=blast
#SBATCH --partition=pibu_el8
#SBATCH --output=../logfiles/blast_%j.out
#SBATCH --error=../logfiles/blast_%j.err

# Paths
WORKDIR="/data/users/kweisensee/assembly"
PROTEINS="$WORKDIR/output/Filtered_Annotations/assembly.all.maker.proteins.fasta.renamed.fasta"
OUTDIR="$WORKDIR/output/BLAST2"
mkdir -p $OUTDIR

# Databases
UNIPROT_DB="/data/courses/assembly-annotation-course/CDS_annotation/data/uniprot_viridiplantae_reviewed.fa"
TAIR10_DB="/data/courses/assembly-annotation-course/CDS_annotation/data/TAIR10_pep_20110103_representative_gene_model"

module load BLAST+/2.15.0-gompi-2021a

#############################################
# 1) BLAST AGAINST UNIPROT
#############################################

UNIPROT_OUT="${OUTDIR}/maker_proteins_vs_uniprot_viridiplantae.blastp"

blastp \
    -query $PROTEINS \
    -db $UNIPROT_DB \
    -num_threads 16 \
    -outfmt 6 \
    -evalue 1e-5 \
    -max_target_seqs 10 \
    -out ${UNIPROT_OUT}

# Best hit extraction (UniProt)
sort -k1,1 -k12,12g ${UNIPROT_OUT} \
    | sort -u -k1,1 --merge \
    > ${UNIPROT_OUT}.besthits


#############################################
# 2) BLAST AGAINST TAIR10
#############################################

TAIR_OUT="${OUTDIR}/maker_proteins_vs_tair10.blastp"

blastp \
    -query $PROTEINS \
    -db $TAIR10_DB \
    -num_threads 16 \
    -outfmt 6 \
    -evalue 1e-5 \
    -max_target_seqs 10 \
    -out ${TAIR_OUT}

# Best hit extraction (TAIR10)
sort -k1,1 -k12,12g ${TAIR_OUT} \
    | sort -u -k1,1 --merge \
    > ${TAIR_OUT}.besthits

echo "BLAST searches completed."
echo "Outputs:"
echo "  - UniProt best hits: ${UNIPROT_OUT}.besthits"
echo "  - TAIR10 best hits:  ${TAIR_OUT}.besthits"
