#!/usr/bin/env bash

#SBATCH --time=12:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=Genespace_prep
#SBATCH --partition=pibu_el8
#SBATCH --output=../logfiles/Genespace_prep_%j.out
#SBATCH --error=../logfiles/Genespace_prep_%j.err

# Exit on error
set -e

WORKDIR="/data/users/kweisensee/assembly"
OUTDIR=$WORKDIR/output/Genespace
COURSE_DIR="/data/courses/assembly-annotation-course/CDS_annotation"
Accession="No-0"
#/data/users/kweisensee/assembly/output/Filtered_Annotations/assembly.all.maker.proteins.fasta.renamed.fasta
PROTEIN_FILE="/data/users/kweisensee/assembly/output/Filtered_Annotations/assembly.all.maker.proteins.fasta.renamed.fasta"

# Create output directories
mkdir -p $OUTDIR
mkdir -p ${OUTDIR}/peptide
mkdir -p ${OUTDIR}/bed

## 1/4 create BED

# Check if input file exists
if [ ! -f "${WORKDIR}/output/Filtered_Annotations/filtered.genes.renamed.gff3" ]; then
    echo "ERROR: GFF3 file not found!"
    exit 1
fi
# command to extract gene features from GFF3
# /data/users/kweisensee/assembly/output/Filtered_Annotations/filtered.genes.renamed.gff3
grep -P "\tgene\t" /data/users/kweisensee/assembly/output/Filtered_Annotations/filtered.genes.renamed.gff3 \
    > ${OUTDIR}/temp_genes.gff3

# Convert GFF3 to BED format
# No need to keep it inside a bash command, since we have #!/usr/bin/env bash
awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' \
    ${OUTDIR}/temp_genes.gff3 > ${OUTDIR}/${Accession}.bed


## 2/4 Extract longest protein sequence
module load Biopython/1.79-foss-2021a

python3 << PYTHON_SCRIPT
from Bio import SeqIO
from collections import defaultdict
import sys

def extract_longest_isoforms(input_fasta, output_fasta):
    """
    Extract longest protein sequence for each gene.
    Handles isoforms like gene.1, gene.2, etc.
    """
    gene_sequences = {}
    gene_count = defaultdict(int)
    
    print(f"Reading sequences from: {input_fasta}")
    
    # Read all sequences
    for record in SeqIO.parse(input_fasta, "fasta"):
        # Extract gene name (remove isoform suffix if present)
        # e.g., "AT1G01010.1" -> "AT1G01010"
        gene_name = record.id.split('.')[0]
        seq_length = len(record.seq)
        
        gene_count[gene_name] += 1
        
        # Keep longest sequence for each gene
        if gene_name not in gene_sequences:
            gene_sequences[gene_name] = record
            gene_sequences[gene_name].id = gene_name
            gene_sequences[gene_name].description = ""
        elif seq_length > len(gene_sequences[gene_name].seq):
            # Update to longer sequence
            gene_sequences[gene_name] = record
            gene_sequences[gene_name].id = gene_name
            gene_sequences[gene_name].description = ""
    
    # Report statistics
    total_isoforms = sum(gene_count.values())
    genes_with_isoforms = sum(1 for count in gene_count.values() if count > 1)
    
    print(f"Total sequences read: {total_isoforms}")
    print(f"Unique genes: {len(gene_sequences)}")
    print(f"Genes with multiple isoforms: {genes_with_isoforms}")
    
    # Show examples of genes with most isoforms
    top_genes = sorted(gene_count.items(), key=lambda x: x[1], reverse=True)[:5]
    if top_genes[0][1] > 1:
        print("\nGenes with most isoforms:")
        for gene, count in top_genes:
            if count > 1:
                print(f"  {gene}: {count} isoforms")
    
    # Write longest sequences
    written = SeqIO.write(gene_sequences.values(), output_fasta, "fasta")
    print(f"\nWrote {written} longest protein sequences to: {output_fasta}")
    
    return len(gene_sequences)

# Run the function
try:
    num_genes = extract_longest_isoforms(
        "${PROTEIN_FILE}",
        "${OUTDIR}/${Accession}.fa"
    )
    sys.exit(0)
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)

PYTHON_SCRIPT

if [ $? -ne 0 ]; then
    echo "Error: Python script failed"
    exit 1
fi

## 3/4 Extract longest sequences
# Setup folder structure
#mkdir -p ${OUTDIR}/peptide
#mkdir -p ${OUTDIR}/bed
# I added mkdir to beginning of script
# Get course data
cp ${COURSE_DIR}/data/TAIR10.fa ${OUTDIR}/peptide/TAIR10.fa
cp ${COURSE_DIR}/data/TAIR10.bed ${OUTDIR}/bed/TAIR10.bed

# Move files to correct directories
mv ${OUTDIR}/${Accession}.bed ${OUTDIR}/bed/${Accession}.bed
mv ${OUTDIR}/${Accession}.fa ${OUTDIR}/peptide/${Accession}.fa

# 4/4 Add Accessions for comparison
# CORRECTED PATHS - files are in 'selected' subdirectories
PROTEIN_DIR="${COURSE_DIR}/data/Lian_et_al/protein/selected"
GFF_DIR="${COURSE_DIR}/data/Lian_et_al/gene_gff/selected"

# Array of accessions to include (choose 3 from available)
# Available: Altai-5, Are-6, Est-0, Etna-2, Ice-1, Kar-1, Taz-0
OTHER_ACCESSIONS=("Est-0" "Ice-1" "Kar-1")
for acc in "${OTHER_ACCESSIONS[@]}"; do
    echo "Processing accession: ${acc}"
    
    # Check and copy protein file
    PROTEIN_SOURCE="${PROTEIN_DIR}/${acc}.protein.faa"
    if [ -f "${PROTEIN_SOURCE}" ]; then
        cp ${PROTEIN_SOURCE} ${OUTDIR}/peptide/${acc}.fa
        echo "  - Copied protein file ($(grep -c '^>' ${OUTDIR}/peptide/${acc}.fa) sequences)"
    else
        echo "  - Warning: Protein file not found at ${PROTEIN_SOURCE}"
    fi
    
    # Create BED file from GFF3
    GFF_SOURCE="${GFF_DIR}/${acc}.EVM.v3.5.ann.protein_coding_genes.gff"
    if [ -f "${GFF_SOURCE}" ]; then
        echo "  - Creating BED file from GFF3..."
        grep -P "\tgene\t" ${GFF_SOURCE} | \
        awk 'BEGIN{OFS="\t"} {split($9,a,";"); split(a[1],b,"="); print $1, $4-1, $5, b[2]}' \
        > ${OUTDIR}/bed/${acc}.bed
        echo "  - Created BED file ($(wc -l < ${OUTDIR}/bed/${acc}.bed) genes)"
    else
        echo "  - Warning: GFF3 file not found at ${GFF_SOURCE}"
    fi
done

# Clean up temporary files
rm -f ${OUTDIR}/temp_genes.gff3

echo ""
echo "======================================"
echo "Setup complete!"
echo "======================================"
echo ""
echo "Directory structure:"
echo "Peptide files:"
ls -lh ${OUTDIR}/peptide/
echo ""
echo "BED files:"
ls -lh ${OUTDIR}/bed/
echo ""
echo "Summary:"
echo "- Your accession: ${Accession}"
echo "- Reference: TAIR10"
echo "- Additional accessions: ${OTHER_ACCESSIONS[@]}"
echo ""
echo "Total genomes for GENESPACE: $(ls ${OUTDIR}/peptide/*.fa 2>/dev/null | wc -l)"
echo ""
echo "Files ready for GENESPACE analysis in: ${OUTDIR}"
echo ""

echo "Verification - Gene counts (BED vs FASTA):"
for bed in ${OUTDIR}/bed/*.bed; do
    base=$(basename $bed .bed)
    bed_count=$(wc -l < $bed)
    fa_count=$(grep -c '^>' ${OUTDIR}/peptide/${base}.fa 2>/dev/null || echo "0")
    echo "  ${base}: BED=${bed_count}, FASTA=${fa_count}"
done
