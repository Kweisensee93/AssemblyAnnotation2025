#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=100M
#SBATCH --time=00:10:00
#SBATCH --job-name=awk_hifiasm
#SBATCH --output=../logfiles/awk_%j.o
#SBATCH --error=../logfiles/awk_%j.e
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/kweisensee/assembly"
RESULTDIR="$WORKDIR/output/hifiasm"

awk '/^S/{print ">"$2;print $3}' $RESULTDIR/No-0.bp.p_ctg.gfa > $RESULTDIR/No-0.fa