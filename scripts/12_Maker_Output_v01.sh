#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --mem=16G
#SBATCH --partition=pibu_el8
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=Maker_output
#SBATCH --output=../logfiles/Maker_output_%j.out
#SBATCH --error=../logfiles/Maker_output_%j.err

COURSEDIR="/data/courses/assembly-annotation-course/CDS_annotation"
WORKDIR="/data/users/kweisensee/assembly"
MAKERBIN="$COURSEDIR/softwares/Maker_v3.01.03/src/bin"
OUTPUT_DIR="${WORKDIR}/output/CDS_Maker"
mkdir -p ${OUTPUT_DIR}

# We need to go each time to OUTPUT_DIR (I don't know why it failed otherwise)
cd ${OUTPUT_DIR}
$MAKERBIN/gff3_merge -s -d \
    ${WORKDIR}/CDS_Maker/No-0.fa.maker.output/No-0.fa_master_datastore_index.log > \
    assembly.all.maker.gff

cd ${OUTPUT_DIR}
$MAKERBIN/gff3_merge -n -s -d \
    ${WORKDIR}/CDS_Maker/No-0.fa.maker.output/No-0.fa_master_datastore_index.log > \
    assembly.all.maker.noseq.gff

cd ${OUTPUT_DIR}
$MAKERBIN/fasta_merge -d \
    ${WORKDIR}/CDS_Maker/No-0.fa.maker.output/No-0.fa_master_datastore_index.log -o assembly