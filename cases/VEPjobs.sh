#!/bin/bash

#BSUB -P re_gecip_renal
#BSUB -q inter
#BSUB -J vep

module load singularity/4.1.1

parent_dir="1_results"

# Create an array of chromosome names
chromosomes=("chr1" "chr2" "chr3" "chr4" "chr5" "chr6" "chr7" "chr8" "chr9" "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18" "chr19" "chr20" "chr21" "chr22" "chrX" "chrY")

# Loop through each directory
for dir in "$parent_dir"/*; do
    if [ -d "$dir" ]; then
        # Get the directory name (assuming it's the VCF file's name)
        vcf_name=$(basename "$dir")

        # Loop through each chromosome
        for chrom in "${chromosomes[@]}"; do
            bsub -P re_gecip_renal -q inter -J "vep_${vcf_name}_${chrom}" -o "$dir/vep_${vcf_name}_${chrom}.out" -e "$dir/vep_${vcf_name}_${chrom}.err" singularity exec -B /nas/weka.gel.zone/re_gecip:/nas/weka.gel.zone/re_gecip/ vep_with_tabix.sif vep --dir /nas/weka.gel.zone/re_gecip/re_gecip/shared_allGeCIPs/jeascripts/databases/VEP112 --assembly GRCh38 --offline --database -vcf -i "${dir}/${vcf_name}_${chrom}.vcf" --registry ensembl.registry --force_overwrite --everything -o "${dir}/vep_${vcf_name}_${chrom}_output.vcf"
        done
	
	
	wait
	echo "All jobs for $vcf_name submitted. Waiting for them to finish."
    fi
done
