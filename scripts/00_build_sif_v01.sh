#!/bin/bash
#SBATCH --job-name=minidot_build
#SBATCH --output=../logfiles/minidot_build_%j.out
#SBATCH --error=../logfiles/minidot_build_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --partition=pibu_el8


# Build the miniasm container
apptainer build miniasm.sif docker://biocontainers/miniasm:v0.3-r179--h7132678_1

