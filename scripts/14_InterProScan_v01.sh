#!/bin/bash
#SBATCH --time=01:20:00
#SBATCH --mem=16G
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=InterProScan
#SBATCH --output=../logfiles/InterProScan_%j.out
#SBATCH --error=../logfiles/InterProScan_%j.err

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

WORKDIR="/data/users/kweisensee/assembly"
CDS_MAKER="${WORKDIR}/output/CDS_Maker"
OUTPUT_DIR="${WORKDIR}/output/Filtered_Annotations"

protein="assembly.all.maker.proteins.fasta"
gff="assembly.all.maker.noseq.gff"

cd ${OUTPUT_DIR}
# Run InterProScan on the Protein File
apptainer exec \
    --bind $COURSEDIR/data/interproscan-5.70-102.0/data:/opt/interproscan/data \
    --bind $WORKDIR \
    --bind $COURSEDIR \
    --bind $SCRATCH:/temp \
    $COURSEDIR/containers/interproscan_latest.sif \
    /opt/interproscan/interproscan.sh \
    -appl pfam --disable-precalc -f TSV \
    --goterms --iprlookup --seqtype p \
    -i ${protein}.renamed.fasta -o output.iprscan

# Update GFF with InterProScan Results
cd ${OUTPUT_DIR}
$MAKERBIN/ipr_update_gff ${gff}.renamed.gff output.iprscan > \
    ${gff}.renamed.iprscan.gff