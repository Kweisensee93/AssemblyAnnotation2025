#!/usr/bin/env bash
#SBATCH --time=00:02:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=CDS_Maker
#SBATCH --partition=pibu_el8
#SBATCH --output=../logfiles/CDS_Maker_%j.out
#SBATCH --error=../logfiles/CDS_Maker_%j.err

WORKDIR=/data/users/kweisensee/assembly/CDS_Maker
mkdir -p $WORKDIR
cd $WORKDIR


apptainer exec --bind $WORKDIR \
    /data/courses/assembly-annotation-course/CDS_annotation/containers/MAKER_3.01.03.sif maker -CTL