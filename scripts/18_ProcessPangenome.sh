#!/bin/bash
#SBATCH --job-name=pangenome_alignment
#SBATCH --output=../logfiles/pangenome_alignment_%j.out
#SBATCH --error=../logfiles/pangenome_alignment_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=32G
#SBATCH --partition=pibu_el8

# Load latest R module
module load R/4.3.2-foss-2021a

# Move to output directory of Genespace
cd /data/users/kweisensee/assembly/output/Genespace

# Run R script
Rscript /data/users/kweisensee/assembly/scripts/process_pangenome.R
