#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --mem=16G
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=FilterAnnotations
#SBATCH --output=../logfiles/FilterAnnotations_%j.out
#SBATCH --error=../logfiles/FilterAnnotations_%j.err

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"

prefix="No-0"

WORKDIR="/data/users/kweisensee/assembly"
CDS_MAKER="${WORKDIR}/output/CDS_Maker"
OUTPUT_DIR="${WORKDIR}/output/Filtered_Annotations"
mkdir -p ${OUTPUT_DIR}
cd ${OUTPUT_DIR}

## fetch all files
# define filenames
protein="assembly.all.maker.proteins.fasta"
transcript="assembly.all.maker.transcripts.fasta"
gff="assembly.all.maker.noseq.gff"
# copy from CDS_MAKER to OUTPUT_DIR
cp ${CDS_MAKER}/${gff} ${OUTPUT_DIR}/${gff}.renamed.gff
cp ${CDS_MAKER}/${protein} ${OUTPUT_DIR}/${protein}.renamed.fasta
cp ${CDS_MAKER}/${transcript} ${OUTPUT_DIR}/${transcript}.renamed.fasta

# just in case
sleep 2s

$MAKERBIN/maker_map_ids --prefix $prefix --justify 7 ${gff}.renamed.gff > id.map
$MAKERBIN/map_gff_ids id.map ${gff}.renamed.gff
$MAKERBIN/map_fasta_ids id.map ${protein}.renamed.fasta
$MAKERBIN/map_fasta_ids id.map ${transcript}.renamed.fasta