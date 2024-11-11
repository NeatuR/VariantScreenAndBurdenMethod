#!/bin/bash

#BSUB -P re_gecip_renal
#BSUB -q inter
#BSUB -J filterVEP
#BSUB -o filterVEP_%J.stdout
#BSUB -e filterVEP_%J.stderr


module load singularity/4.1.1

parent_dir="1_results"

# Create an array of chromosome names
chromosomes=("chr1" "chr2" "chr3" "chr4" "chr5" "chr6" "chr7" "chr8" "chr9" "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18" "chr19" "chr20" "chr21" "chr22" "chrX" "chrY")

# Output file
output_file="variant_counts_HIGH_RARE.txt"

# Iterate through directories and count variants
echo -e "Participant\tTotal Variants" > "$output_file"

    for dir in "$parent_dir"/*/; do
    if [ -d "$dir" ]; then
        # Get the directory name (assuming it's the VCF file's name)
        vcf_name=$(basename "$dir")
	#echo "$dir"
   echo -e "----------" >> "$output_file"
# Loop through each chromosome
    for chrom in "${chromosomes[@]}"; do
    #echo "start chrom"
 # Use filter_vep tool to get the counts       
    awk -F'\t' '$10 !~ /^0\/0/ && $10 !~ /^(0:|1:)/' ${dir}vep_${vcf_name}_${chrom}_output.vcf | singularity exec -B /nas/weka.gel.zone/re_gecip:/nas/weka.gel.zone/re_gecip/ vep_with_tabix.sif filter_vep -filter "IMPACT is HIGH and (AF < 0.01 or not AF) and SYMBOL in gene_filterVEP.txt" -force_overwrite -o ${dir}count_${vcf_name}_${chrom}.txt  -only_matched
    
     # Append directory name and total variants to the output file
    total_variants=$(<${dir}count_${vcf_name}_${chrom}.txt)
    echo -e "$vcf_name\t$total_variants" >> "$output_file"
    done
    
    rm ${dir}count_*
    fi
    done 
