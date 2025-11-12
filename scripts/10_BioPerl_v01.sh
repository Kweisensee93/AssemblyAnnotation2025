#!/usr/bin/env bash
#SBATCH --time=01:00:00
#SBATCH --mem=50G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=BioPerl
#SBATCH --partition=pibu_el8
#SBATCH --output=../logfiles/BioPerl_%j.out
#SBATCH --error=../logfiles/BioPerl_%j.err

WORKDIR=/data/users/kweisensee/assembly/
INPUT_FILE=${WORKDIR}/output/EDTA/No-0.fa.mod.EDTA.anno/No-0.fa.mod.out
#FASTA_FILE=${WORKDIR}/output/EDTA/No-0.fa.mod.EDTA.TElib.fa
OUTPUT_DIR=${WORKDIR}/output/BioPerl
mkdir -p $OUTPUT_DIR
parseRM=/data/courses/assembly-annotation-course/CDS_annotation/scripts/04-parseRM.pl

module add BioPerl/1.7.8-GCCcore-10.3.0

cd "$OUTPUT_DIR"

perl $parseRM -i $INPUT_FILE -l 50,1 -v