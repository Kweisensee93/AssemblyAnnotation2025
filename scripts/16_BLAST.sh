#!/usr/bin/env bash

#SBATCH --time=1-10:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=10
#SBATCH --job-name=blast
#SBATCH --partition=pibu_el8
#SBATCH --output=../logfiles/blast_%j.out
#SBATCH --error=../logfiles/blast_%j.err


WORKDIR="/data/users/kweisensee/assembly"
PROTEINS=$WORKDIR/output/Filtered_Annotations/assembly.all.maker.proteins.fasta.renamed.fasta
OUTDIR=$WORKDIR/output/BLAST
mkdir -p $OUTDIR
BLAST_OUT=${OUTDIR}/maker_proteins_vs_uniprot_viridiplantae.blastp

module load BLAST+/2.15.0-gompi-2021a

blastp -query $PROTEINS -db /data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa -num_threads 10 -outfmt 6 -evalue 1e-10 -out $OUTDIR/blastp

# this step is already done, so we use the file provided by the course
# makeblastb -in /data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa -dbtype prot

#run BLAST
blastp -query ${PROTEINS} \
    -db /data/courses/assembly-annotation-course/CDS_annotation/data/uniprot/uniprot_viridiplantae_reviewed.fa \
    -num_threads 10 -outfmt 6 -evalue 1e-5 -max_target_seqs 10 -out \
    ${BLAST_OUT}

# Now sort the blast output to keep only the best hit per query sequence
sort -k1,1 -k12,12g ${BLAST_OUT} | sort -u -k1,1 --merge > ${BLAST_OUT}.besthits