#!/usr/bin/env bash

#SBATCH --time=12:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=2
#SBATCH --job-name=Genespace_debug
#SBATCH --partition=pibu_el8
#SBATCH --output=../logfiles/Genespace_debug_%j.out
#SBATCH --error=../logfiles/Genespace_debug_%j.err


WORKDIR="/data/users/kweisensee/assembly"

echo "=== Debugging GENESPACE prep ==="
echo ""

# Check if the GFF3 file exists
GFF_FILE="${WORKDIR}/output/Filtered_Annotations/filtered.genes.renamed.gff3"
echo "1. Checking GFF3 file:"
echo "   Path: ${GFF_FILE}"
if [ -f "${GFF_FILE}" ]; then
    echo "   ✓ File exists"
    echo "   Size: $(ls -lh ${GFF_FILE} | awk '{print $5}')"
    echo "   Lines: $(wc -l < ${GFF_FILE})"
else
    echo "   ✗ File NOT found!"
fi
echo ""

# Check the format
echo "2. First 5 lines of GFF3:"
head -n 5 ${GFF_FILE}
echo ""

# Check for gene features
echo "3. Looking for gene features:"
echo "   Method 1 - Standard grep:"
grep -c "	gene	" ${GFF_FILE} || echo "   No matches with tab"
echo ""
echo "   Method 2 - Perl regex:"
grep -P -c "\tgene\t" ${GFF_FILE} || echo "   No matches with \\t"
echo ""

# Show example gene lines
echo "4. Example gene lines (first 3):"
grep "gene" ${GFF_FILE} | head -n 3
echo ""

# Check column 3 values
echo "5. Unique feature types in column 3:"
awk '{print $3}' ${GFF_FILE} | sort -u | head -n 20
echo ""

# Check if protein file exists
PROTEIN_FILE="${WORKDIR}/output/Filtered_Annotations/assembly.all.maker.proteins.fasta.renamed.fasta"
echo "6. Checking protein file:"
echo "   Path: ${PROTEIN_FILE}"
if [ -f "${PROTEIN_FILE}" ]; then
    echo "   ✓ File exists"
    echo "   Size: $(ls -lh ${PROTEIN_FILE} | awk '{print $5}')"
    echo "   Sequences: $(grep -c '^>' ${PROTEIN_FILE})"
else
    echo "   ✗ File NOT found!"
fi