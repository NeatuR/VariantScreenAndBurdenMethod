 Welcome to:
# RuX - Regions Under eXploraton - Workflow 

# GenomicsEngland-VariantScreenAndBurdenMethod
This dual method is designed to work within the Genomics England environment, offering a flexible and efficient approach for variant analysis. It leverages the Variant Effect Predictor (VEP) to annotate variants, with the user providing a list of individual VCF files, as well as user-defined genomic regions for memory efficiency. 

The method includes two key components: variant screening and burden testing. 
* The first part filters variants based on user-defined VEP filters, providing a list of variants of interest for each individual.
* The second part assesses the accumulation of pathogenic or rare variants across the selected genomic regions, enabling the identification of common alleles within a cohort.

This tool is intended to support genetic research and clinical diagnostics, allowing for targeted analysis without the need for pre-filtered variant lists.

<hr>

### !!! Before starting:
This is a demontration on how this workflow can be used. The directories `cases` and `controls` contain the scripts without results to showcase their organisation.

<hr>

# USE CASE 1: Filter variants

Make sure there is a folder called `1_results` in the working directory. Here is where the outputs will be stored. Create custom `vcf_list.txt` and `gene_list.txt` for individuals and regions of interest.

### STEP 1.
Go into `1_variantExtract`
Based on the `vcf_list.txt` and `gene_list.txt`, this extracts the variants within the desired genomic ranges for the custom cohort in the `1_results` directory.
```
bsub < bcftools.sh
```
### STEP 2.
It divides the variants by chromosome, preparing them for VEP. This is essential for VEP to be able to process multiple files in parallel making it more efficient.
```
bsub < cut_chrom.sh
```

### STEP 3.
This is the step with the longest running time; if you have something else to get done, use this time.
Probably due to singularity I can't run it from the `1_variantExtract`  directory
* go a folder back (just outside `1_variantExtract`)
* VEP needs .SIF file (if Singularity is used)

```
bsub < VEPjobs.sh
```

### STEP 4.
This final step filters the variants and generates a list with only variants of interest per individual
* the script that needs to be changed, more specifically depending on the analysis the parameters of `filter_VEP`
* similarly this script will be ran from outside 
`1_variantExtract`
* if parameter `SYMBOL` is used, `gene_filterVEP.txt` might be needed; modify the txt file by the goal of the experiment
* for more options/info please read: https://www.ensembl.org/info/docs/tools/vep/script/vep_filter.html#filter_run
* as long as `output_file` name is changed, this can be run different times for different parameters; if the `output_file` is not changed the results will be overwritten
```
bsub < filter_VEP.sh
```


# USE CASE 2: Single-variant Analysis
This evaluates the accumulation, or burden, of rare or pathogenic variants within specified genomic regions. It requires a `control` cohort. 

### STEP 1.
Create a `control` and a `cases` directory with a similar organisation as specified in the `USE CASE 1`. Run `USECASE 1` twice: for a `cases` cohort and a `controls` cohort.

 
### STEP 2.
This makes use of the final output of the `USECASE 1` from both cases and controls to generate a file counting the number of cases and controls that carry pathogenic variants at allele level. Then it prepares it for Fisher Test.
* directory: cases/2_association/allele_level
* the HPC is not needed for this script but it is recommended
* make sure to change the variables accoridingly
```
bash process.sh
```

### STEP 3. 
Calculate p-values.
* change the working directory (setwd)
* open R Studio and run this
```
Fisher.R
```

### STEP 4.
Visualise the results (manhatan plot).
* change the main directory (setwd)
* open R Studio to create the graphs
``` 
qqman.R
```

# USE CASE 3: Multiple-Variant Analysis - collapse by gene

### STEP 1.
Create a `control` and a `cases` directory with a similar organisation as specified in the `USE CASE 1`. Run `USECASE 1` twice: for a `cases` cohort and a `controls` cohort.

### STEP 2. 
It uses the output of `USE CASE 1` to count the number of cases and controls with pathogenic/rare variants wihtin user-defined genomic regions.
* directory: cases/2_association/gene_level
* this can run in R Studio
* needs to run two times: one for cases and one for controls
* change the input and ouput as desired for every run
* this generates `count_cases.txt` and `count_controls.txt`
* if the number of variants/individuals is high, it can be a bit of a wait time but don't panic, the scrip is not frozen :) 
* it takes as input a specific list of genomic regions, an example file is `ranges_cilia_genes.txt`, these regions can be coding or non-coding
``` 
collapse_per_gene.R
``` 


### STEP 3. 
It prepares the file for Fisher test.
* the HPC is not needed for this script but it is recommended
* make sure to change the variables accoridingly
``` 
process_countGenes.sh
``` 

### STEP 4. 
Calculate p-values.
* change the working directory (setwd)
* open R Studio and run this
```
Fisher.R
```

### STEP 5.
Visualise the results (manhatan plot).
* change the main directory (setwd)
* open R Studio to create the graphs
``` 
qqman.R
```
