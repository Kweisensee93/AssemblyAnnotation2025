#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --mem=16G
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=AED_GFFfilter
#SBATCH --output=../logfiles/AED_GFFfilter_%j.out
#SBATCH --error=../logfiles/AED_GFFfilter_%j.err

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

WORKDIR="/data/users/kweisensee/assembly"
CDS_MAKER="${WORKDIR}/output/CDS_Maker"
OUTPUT_DIR="${WORKDIR}/output/Filtered_Annotations"

protein="assembly.all.maker.proteins.fasta"
gff="assembly.all.maker.noseq.gff"

cd ${OUTPUT_DIR}
echo "Step 4: AED"
perl $MAKERBIN/AED_cdf_generator.pl -b 0.025 ${gff}.renamed.gff > \
    assembly.all.maker.renamed.gff.AED.txt

cd ${OUTPUT_DIR}
echo "Step 5: GFF filter"
perl $MAKERBIN/quality_filter.pl -s ${gff}.renamed.iprscan.gff > \
    ${gff}_iprscan_quality_filtered.gff
# In the above command: -s Prints transcripts with an AED <1 and/or Pfam domain if in gff3

cd ${OUTPUT_DIR}
echo "Step 6: Filter for gene features"
# We only want to keep gene features in the third column of the gff file
grep -P \
 "\tgene\t|\tCDS\t|\texon\t|\tfive_prime_UTR\t|\tthree_prime_UTR\t|\tmRNA\t" \
 ${gff}_iprscan_quality_filtered.gff > filtered.genes.renamed.gff3
# Check
cut -f3 filtered.genes.renamed.gff3 | sort | uniq
