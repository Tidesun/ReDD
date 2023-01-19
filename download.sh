#! /bin/bash

#Download required test data: 3959 reads randomly selected from stem cell H1-DE after basecalling

#Fast5 files:
wget https://reddexamples.s3.us-east-2.amazonaws.com/fast5_pass.zip
unzip fast5_pass.zip
#Fastq files:
wget https://reddexamples.s3.us-east-2.amazonaws.com/fastq_pass.zip
unzip fastq_pass.zip
rm -rf *.zip
#Sequencing summary:
wget https://reddexamples.s3.us-east-2.amazonaws.com/sequencing_summary_FAP47598_07e34f33.txt
#Required reference:
#If choose to map to genome, download the refence genome sequences.
wget https://reddexamples.s3.us-east-2.amazonaws.com/genome.fa
#If choose to map to transcriptome, download our denovo reference transcriptome for stem cell and its corresponding annotation.
wget https://reddexamples.s3.us-east-2.amazonaws.com/Stem_cell_talon.flt.bam_flt.gtf.fa
wget https://reddexamples.s3.us-east-2.amazonaws.com/Stem_cell_talon.flt.bam_flt.gpd

#Download other reference transcriptome and annotation

#Gencode release 31 (GRCh38.p12)
wget https://reddexamples.s3.us-east-2.amazonaws.com/gencode.v31.annotation.gpd
#Our denovo reference transcriptome and annotation for GM12878 cells:
wget https://reddexamples.s3.us-east-2.amazonaws.com/GM12878_talon.flt.bam_flt.gtf.fa
wget https://reddexamples.s3.us-east-2.amazonaws.com/GM12878_talon.flt.bam_flt.gpd
#Our denovo reference transcriptome and annotation for HEK293T cells:
wget https://reddexamples.s3.us-east-2.amazonaws.com/HEK293T_talon.flt.bam_flt.gtf.fa
wget https://reddexamples.s3.us-east-2.amazonaws.com/HEK293T_talon.flt.bam_flt.gpd
#To download some optional reference files
#Reference ALUs for human hg38. If provided, the site-level results will be filtered based on ALU regions:
wget https://reddexamples.s3.us-east-2.amazonaws.com/Hg38_Alu.merge.bed
#Reference SNPs for human hg38. If provided the SNP information will be added to the site-level results and filtering by SNPs is available.
wget https://reddexamples.s3.us-east-2.amazonaws.com/hg38_snp151.bed
#Reference REDIportal for human hg38,if provided the annotation in REDIportal will be added to the site-level results.
wget https://reddexamples.s3.us-east-2.amazonaws.com/REDIportal_hg38.txt
#Candidate sites detected by bulk data
wget https://reddexamples.s3.us-east-2.amazonaws.com/DE-H1_directRNA.candidate_sites.tab