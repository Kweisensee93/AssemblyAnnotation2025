This is the GitHub repository for the course Genome Assembly and Annotation
The aim of this course is to make a denovo assembly of a whole genome sequence with PacBio HiFi reads as well as Illumina reads from RNA Sequencing.

Data is available at https://www.nature.com/articles/s41588-024-01715-9 and https://www.nature.com/articles/s41467-020-14779-y.

The data is processed as follows:
### 1) Quality control of the reads:
  01_FastQC_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; using FastQC version 0.12.1

### 2) Trimming of the reads:
  02_fastp_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; using fastp  version 0.23.2

### 3) kmer counting
  03_kmer_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; using jellyfish version 2.2.6

### 4) genome assembly
  04_a_assembly_flye_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; using fly version 2.9.5  
  04_b1_assembly_hifiasm_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; using hifiasm version 0.25.0  
  04_b2_rename_hifiasm_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; renaming of the hifiasm files for later processing  
  04_c_assembly_LJA_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; using LJA version 0.2  
  04_d_assembly_trinity_c01.sh &nbsp;&nbsp;&nbsp;&nbsp; using trinity version 2.15.1  

### 5) Quality control of the assembly
  05_a_QCassembly_BUSCO_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; using BUSCO version 5.4.2  
  05_b_QCassembly_QUAST_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; using QUAST version 5.2.0  
  05_c1_QCassembly_meryl.sh &nbsp;&nbsp;&nbsp;&nbsp; using merqury version 1.3  
  05_c2_QCassembly_merqury.sh &nbsp;&nbsp;&nbsp;&nbsp; using merqury version 1.3  

### 6) Comparison of the genomes
  06_a_CompareGenomenucmer_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; using mummer4  
  06_b_CompareGenomemummer_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; using mummer4  
  06_c_CompareBetween_mummer_v01.sh &nbsp;&nbsp;&nbsp;&nbsp; using mummer4  #This script compares assemblies to reference as well as between each other.  
