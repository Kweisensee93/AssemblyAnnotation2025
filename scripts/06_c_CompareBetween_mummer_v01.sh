#!/usr/bin/env bash
#SBATCH --time=12:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=mummer
#SBATCH --output=../logfiles/mummer_%j.out
#SBATCH --error=../logfiles/mummer_%j.err
#SBATCH --partition=pibu_el8


# -----------------------
# Paths
# -----------------------
WORKDIR="/data/users/kweisensee/assembly"
OUTDIR=$WORKDIR/output/mummer
mkdir -p $OUTDIR

# Assemblies
FLYE=$WORKDIR/output/flye/assembly.fasta
HIFIASM=$WORKDIR/output/hifiasm/No-0.fa
LJA=$WORKDIR/output/LJA/No-0/assembly.fasta

# Reference
REF=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa

# Container
CONTAINER=/containers/apptainer/mummer4_gnuplot.sif

# -----------------------
# Helper function
# -----------------------
run_mummer () {
    PREFIX=$1
    REFSEQ=$2
    QRYSEQ=$3

    echo "Running nucmer: $QRYSEQ vs $REFSEQ"
    apptainer exec --bind /data $CONTAINER \
        nucmer --prefix=$PREFIX --breaklen 1000 --mincluster 1000 $REFSEQ $QRYSEQ

    echo "Filtering delta for $PREFIX..."
    apptainer exec --bind /data $CONTAINER \
        delta-filter -1 ${PREFIX}.delta > ${PREFIX}.filter.delta

    echo "Plotting with mummerplot for $PREFIX..."
    apptainer exec --bind /data $CONTAINER \
        mummerplot --prefix=$PREFIX --filter -t png --large --layout --fat \
          -R $REFSEQ -Q $QRYSEQ ${PREFIX}.filter.delta
}

# -----------------------
# 1. Assemblies vs reference
# -----------------------
run_mummer $OUTDIR/flye_vs_ref $REF $FLYE
run_mummer $OUTDIR/hifiasm_vs_ref $REF $HIFIASM
run_mummer $OUTDIR/lja_vs_ref $REF $LJA

# -----------------------
# 2. Pairwise assembly comparisons
# -----------------------
run_mummer $OUTDIR/flye_vs_hifiasm $FLYE $HIFIASM
run_mummer $OUTDIR/flye_vs_lja $FLYE $LJA
run_mummer $OUTDIR/hifiasm_vs_lja $HIFIASM $LJA