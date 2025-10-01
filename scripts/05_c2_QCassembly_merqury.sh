#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=merqury
#SBATCH --output=../logfiles/merqury_%j.out
#SBATCH --error=../logfiles/merqury_%j.err
#SBATCH --partition=pibu_el8

MERQURY_IMAGE="/containers/apptainer/merqury_1.3.sif"

WORKDIR="/data/users/kweisensee/assembly"
OUTDIR="${WORKDIR}/output/merqury"
mkdir -p $OUTDIR

FLYE="$WORKDIR/output/flye/assembly.fasta"
HIFIASM="$WORKDIR/output/hifiasm/No-0.fa"
LJA="$WORKDIR/output/LJA/assembly.fasta"
READDIR="$WORKDIR/rawdata/No-0/ERR11437335.fastq.gz"
MERYL="$OUTDIR/meryl.meryl"
FLYERES="$OUTDIR/flye"
HIFIRES="$OUTDIR/hifiasm"
LJARES="$OUTDIR/LJA"

mkdir -p $MERYL $FLYERES $HIFIRES $LJARES

export MERQURY="/usr/local/share/merqury"

#run merqury
#flye
cd $FLYERES
apptainer exec --bind /data $MERQURY_IMAGE\
 merqury.sh $MERYL $FLYE eval_flye  

#hifiasm
cd $HIFIRES
apptainer exec --bind /data $MERQURY_IMAGE\
 merqury.sh $MERYL $HIFIASM eval_hifiasm  

#lja
cd $LJARES
apptainer exec --bind /data $MERQURY_IMAGE\
 merqury.sh $MERYL $LJA eval_lja  