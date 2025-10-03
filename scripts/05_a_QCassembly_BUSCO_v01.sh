#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --job-name=busco
#SBATCH --output=../logfiles/busco_%j.out
#SBATCH --error=../logfiles/busco_%j.err
#SBATCH --partition=pibu_el8

WORKDIR="/data/users/kweisensee/assembly"
OUTDIR="${WORKDIR}/output/busco"
mkdir -p $OUTDIR

FLYE="$WORKDIR/output/flye/assembly.fasta"
HIFIASM="$WORKDIR/output/hifiasm/No-0.fa"
LJA="$WORKDIR/output/LJA/No-0/assembly.fasta"
TRINITY="$WORKDIR/output/trinity.Trinity.fasta" # Trinity puts it one above

# issues with the busco .sif ; hence we use module
module load BUSCO/5.4.2-foss-2021a

#flye
busco -i $FLYE -o busco_flye \
    --out_path ${OUTDIR} \
    --mode genome \
    --lineage_dataset brassicales_odb10 \
    --cpu $SLURM_CPUS_PER_TASK \
    -f 

#hifiasm
busco -i $HIFIASM -o busco_hifiasm \
    --out_path ${OUTDIR} \
    --mode genome \
    --lineage_dataset brassicales_odb10 \
    --cpu $SLURM_CPUS_PER_TASK \
    -f

#lja
busco -i $LJA -o busco_LJA \
    --out_path ${OUTDIR} \
    --mode genome \
    --lineage_dataset brassicales_odb10 \
    --cpu $SLURM_CPUS_PER_TASK \
    -f 

#trinity (transcriptome)
busco -i $TRINITY -o busco_trinity \
    --out_path ${OUTDIR} \
    --mode transcriptome \
    --lineage_dataset brassicales_odb10 \
    --cpu $SLURM_CPUS_PER_TASK \
    -f
