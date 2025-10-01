#!/usr/bin/env bash                                                                                                                              

#SBATCH --partition=pibu_el8
#SBATCH --out=../logfiles/meryl_%j.out                                                                                                         
#SBATCH --error=../logfiles/meryl_%j.err                                                                                                                                                                                                                 
#SBATCH --mem=64G                                                                                                                        
#SBATCH --job-name=merqury_meryl                                                                                               
#SBATCH --time=05:00:00                              
#SBATCH --cpus-per-task=16

# This script runs merquery to find the best kmer size and to build kmer dbs with meryl

MERQURY_IMAGE="/containers/apptainer/merqury_1.3.sif"

# define variables
WORKDIR="/data/users/kweisensee/assembly"
OUTDIR="${WORKDIR}/output/merqury_meryl"
mkdir -p $OUTDIR

export MERQURY="/usr/local/share/merqury"

touch $OUTDIR/best_k.txt

# run container with merqury
# find best kmer size
apptainer exec \
    --bind $WORKDIR \
    $MERQURY_IMAGE \
    sh $MERQURY/best_k.sh 130000000 > $OUTDIR/best_k.txt

sleep 10s

best_k=$(sed -n '3p' $OUTDIR/best_k.txt | awk '{print int($1+0.5)}')

# apptainer exec \
#     --bind $WORKDIR \
#     $MERQURY_IMAGE \
#     meryl \
#     k=${best_k} \
#     count $WORKDIR/rawdata/No-0/ERR11437335.fastq.gz \
#     output $OUTDIR/genome.meryl \
#     memory=64G

# it is crucial to bind /data, otherwise meryl cannot find the input file due to the softlink
apptainer exec \
    --bind /data \
    $MERQURY_IMAGE \
    meryl count k=${best_k} \
    output $OUTDIR/genome.meryl \
    memory=64G \
    /data/users/kweisensee/assembly/rawdata/No-0/ERR11437335.fastq.gz