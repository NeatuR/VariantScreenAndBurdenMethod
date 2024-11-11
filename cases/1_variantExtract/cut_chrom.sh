#!/bin/bash

#BSUB -P re_gecip_renal
#BSUB -q inter
#BSUB -J cutChrom
#BSUB -o cutChrom_%J.stdout
#BSUB -e cutChrom_%J.stderr

# Directory contning your VCF files
vcf_dir="../1_results"

# Create an array of chromosome names
chromosomes=("chr1" "chr2" "chr3" "chr4" "chr5" "chr6" "chr7" "chr8" "chr9" "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18" "chr19" "chr20" "chr21" "chr22" "chrX" "chrY")

# Loop through each VCF file in the directory
for vcf_file in "$vcf_dir"/*.vcf; do
        # Extract the filename without the path and extension
        vcf_base=$(basename "$vcf_file")
        vcf_name="${vcf_base%.*}"

        # Create a directory based on the VCF file's name
        mkdir -p "$vcf_dir/$vcf_name"
        echo "Created directory: $vcf_name"

        # Loop through each chromosome
        for chrom in "${chromosomes[@]}"; do
            # Use grep to filter the VCF file by chromosome and save the result
            grep -P "^${chrom}\t" "$vcf_file" > "$vcf_dir/$vcf_name/${vcf_name}_${chrom}.vcf"
            echo "Processed $chrom for $vcf_name"
        done
done

