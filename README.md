# Genome Assembly and Annotation — Course Repository

This repository contains all scripts and resources used in the courses for Genome Assembly and Annotation.
The aim of the course is to perform de novo assembly of a whole genome using PacBio HiFi reads and Illumina RNA-seq reads, followed by transcriptome assembly, annotation, transposable element (TE) annotation, and comparative genomics.

# Data Sources

Raw data used in this course originates from:

PacBio HiFi data: Nature Genetics article

RNA-seq data: Nature Communications article

See original publications:

https://www.nature.com/articles/s41588-024-01715-9

https://www.nature.com/articles/s41467-020-14779-y

Within this repository the arapidopsis thaliana accession No-0 was used and worked upon.

S
# Workflow Overview

The pipeline consists of the following main stages:
### 1) Quality control of the reads:
  01_FastQC_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Quality control using FastQC version 0.12.1

### 2) Trimming of the reads:
  02_fastp_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Adapter trimming and filtering using fastp  version 0.23.2

### 3) kmer counting
  03_kmer_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; k-mer counting using jellyfish version 2.2.6

### 4) genome assembly
  04_a_assembly_flye_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Assembly using **fly** version 2.9.5
  
  04_b1_assembly_hifiasm_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Assembly using **hifiasm** version 0.25.0
  
  04_b2_rename_hifiasm_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Standardized renaming of the hifiasm files for later processing
  
  04_c_assembly_LJA_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Assembly using **LJA** version 0.2
  
  04_d_assembly_trinity_c01.sh &nbsp;&nbsp;&nbsp;&nbsp; Assembly (RNA-seq) using **trinity** version 2.15.1  

### 5) Quality control of the assembly
  05_a_QCassembly_BUSCO_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Completeness evaluation using **BUSCO** version 5.4.2
  
  05_b_QCassembly_QUAST_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Structural metrics using **QUAST** version 5.2.0
  
  05_c1_QCassembly_meryl.sh &nbsp;&nbsp;&nbsp;&nbsp; k-mer DB creation using **merqury** version 1.3
  
  05_c2_QCassembly_merqury.sh &nbsp;&nbsp;&nbsp;&nbsp; Assembly quality estimation using **merqury** version 1.3  

### 6) Comparison of the genomes
  06_a_CompareGenomenucmer_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Whole-genome alignment using **mummer4** (nucmer)
  
  06_b_CompareGenomemummer_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; **MUMmer4** downstream comparison
  
  06_c_CompareBetween_mummer_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Assembly-to-reference and assembly-to-assembly comparison
  
  06_c_CompareGenome_minimap2_v03	&nbsp;&nbsp;&nbsp;&nbsp; Comparative mapping using **minimap2**

### 7) Transposable Element Annotation
  07_EDTA_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Comprehensive TE annotation using **EDTA** version 2.2
  
  08_a_TEsorter_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; TE classification using **TEsorter** version 1.3.0
  
  08_b_TEsorter_refine_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Refinement of TEsorter output

### 8) Gene Prediction and Annotation
  09_LTRS.R &nbsp;&nbsp;&nbsp;&nbsp; LTR structural analysis (R)
  
  10_BioPerl_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Installation/setup of **BioPerl** modules
  
  10_CDS_Maker_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Preparing CDS/EST evidence for **MAKER** using **MAKER** version 3.01.03
  
  11_run_MAKER_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Running **MAKER** for structural annotation version using OpenMPI version 4.1.1 and AUGUSTUS version 3.4.0
  
  12_Maker_Output_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Post-processing MAKER output
  
  13_FilterAnnotations_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Filtering annotations
  
  14_InterProScan_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Protein domain annotation via **InterProScan** version 5.70
  
  15_AED_GFFfilter_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Filtering based on Annotation Edit Distance
  
  16_BLAST.sh and BLAST2.sh &nbsp;&nbsp;&nbsp;&nbsp; **BLAST**-based functional annotation using version BLAST+/2.15.0-gompi-2021a

### 9) Synteny and Pangenome Analysis
  17_a_BED_Genespace.sh &nbsp;&nbsp;&nbsp;&nbsp; Preparing BED files for **GENESPACE**
  
  17_b_run_Genespace.sh &nbsp;&nbsp;&nbsp;&nbsp; Running **GENESPACE** synteny pipeline
  
  18_ProcessPangenome.sh &nbsp;&nbsp;&nbsp;&nbsp; Pangenome post-processing (calls process_pangenome.R)
  
  process_pangenome.R &nbsp;&nbsp;&nbsp;&nbsp; R scripts for pangenome QC/plots

### 10) Additional Utility Scripts
  00_build_sif_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; Building Singularity/Apptainer SIF containers
  
  19_assembly_QC.sh &nbsp;&nbsp;&nbsp;&nbsp; General summary QC of all assemblies using gfastats 1.3.9
  
  blast_hits.sh &nbsp;&nbsp;&nbsp;&nbsp; BLAST parsing helper
  
  genespace.R Custom &nbsp;&nbsp;&nbsp;&nbsp; GENESPACE analysis functions

