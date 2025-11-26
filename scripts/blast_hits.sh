#!/usr/bin/env bash
#SBATCH --job-name=count_blast_hits
#SBATCH --output=../logfiles/count_blast_hits_%j.out
#SBATCH --error=../logfiles/count_blast_hits_%j.err
#SBATCH --time=0-01:00:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1
#SBATCH --partition=pibu_el8

# Paths
WORKDIR="/data/users/kweisensee/assembly"
PROTEINS="$WORKDIR/output/CDS_Maker/assembly.all.maker.proteins.fasta"
BLASTDIR="$WORKDIR/output/BLAST2"

# UniProt
UNIPROT_BEST="${BLASTDIR}/maker_proteins_vs_uniprot_viridiplantae.blastp.besthits"

# TAIR10
TAIR_BEST="${BLASTDIR}/maker_proteins_vs_tair10.blastp.besthits"

# Create a temporary file for all genes (sorted)
ALL_GENES_FILE=$(mktemp)
grep ">" $PROTEINS | sed 's/>//' | sort > "$ALL_GENES_FILE"
TOTAL_GENES=$(wc -l < "$ALL_GENES_FILE")

# Function to count hits and no-hits
count_hits() {
    local BEST_HITS_FILE=$1
    local DB_NAME=$2
    
    WITH=$(cut -f1 "$BEST_HITS_FILE" | sort -u | wc -l)
    WITHOUT=$(comm -23 "$ALL_GENES_FILE" <(cut -f1 "$BEST_HITS_FILE" | sort -u) | wc -l)
    
    printf "%s - Total genes: %s\n" "$DB_NAME" "$TOTAL_GENES"
    printf "%s - Genes with hits: %s\n" "$DB_NAME" "$WITH"
    printf "%s - Genes without hits: %s\n\n" "$DB_NAME" "$WITHOUT"
}

# Run for UniProt
count_hits "$UNIPROT_BEST" "UniProt"

# Run for TAIR10
count_hits "$TAIR_BEST" "TAIR10"

# Cleanup
rm "$ALL_GENES_FILE"