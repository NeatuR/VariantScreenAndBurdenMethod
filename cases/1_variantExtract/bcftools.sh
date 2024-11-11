#!/bin/bash

#BSUB -P re_gecip_renal
#BSUB -q inter
#BSUB -J bcftools
#BSUB -o bcftools_%J.stdout
#BSUB -e bcftools_%J.stderr

module load bcftools/1.16

# Extract chromosome and position ranges from gene_list.txt and create a temporary BED file
awk -F '_' '{print $2"\t"$3"\t"$4}' gene_list.txt > gene_list.bed

while IFS= read -r VCF_FILE; do
# Extract the name of the VCF file without the path
    out=$(basename "$VCF_FILE")
    out="${out%.vcf.gz}"  # Remove the .vcf.gz extension

# Use bcftools view to filter VCF_example.vcf.gz based on the BED file
bcftools view -R gene_list.bed -f PASS -o ../1_results/"${out}.vcf" "$VCF_FILE"

done < vcf_list.txt
