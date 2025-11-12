#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=04:00:00
#SBATCH --job-name=TEsorter_refine
#SBATCH --output=../logfiles/TEsorter_refine_%j.out
#SBATCH --error=../logfiles/TEsorter_refine_%j.err
#SBATCH --partition=pibu_el8

module load SeqKit/2.6.1

WORKDIR="/data/users/kweisensee/assembly"
genome="${WORKDIR}/output/EDTA/No-0.fa.mod.EDTA.TElib.fa"
output_dir="/data/users/kweisensee/assembly/output/TEsorter_refine"
mkdir -p $output_dir

# Extract Copia sequences
seqkit grep -r -p "Copia" $genome > ${output_dir}/Copia_sequences.fa
# Extract Gypsy sequences
seqkit grep -r -p "Gypsy" $genome > ${output_dir}/Gypsy_sequences.fa

apptainer exec --bind $WORKDIR /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif TEsorter \
    ${output_dir}/Copia_sequences.fa -db rexdb-plant

apptainer exec --bind $WORKDIR /data/courses/assembly-annotation-course/CDS_annotation/containers/TEsorter_1.3.0.sif TEsorter \
    ${output_dir}/Gypsy_sequences.fa -db rexdb-plant