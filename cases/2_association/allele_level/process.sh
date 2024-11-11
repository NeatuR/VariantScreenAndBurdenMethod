#!/bin/bash

#main directory:
path="/re_gecip/renal/rneatu/BurdenTests_FinalChapter/RuX_workflow_JS/2_associations/allele_level"
new_dir="/re_gecip/renal/rneatu/BurdenTests_FinalChapter/RuX_workflow_JS/2_associations/allele_level/"

#cases:
file1="${path}variant_counts_RARE.txt"
#controls:
file2="${path}variant_counts_RARE.txt"

#cases temp file:
counts_file1="${new_dir}count_cases.txt"
#controls temp file:
counts_file2="${new_dir}count_controls.txt"

#cases and controls formated for Fisher:
merged="${new_dir}merged_groups.txt"
prepFisher="${new_dir}prepFisher.txt"

grep '^chr' "$file1" | awk '{count[$1 "\t" $2]++} END {for (key in count) {split(key, fields, "\t"); print fields[1], fields[2], count[key]}}' | grep -v 'LowGQXHetSNP' | sort > "$counts_file1"

grep '^chr' "$file2" | awk '{count[$1 "\t" $2]++} END {for (key in count) {split(key, fields, "\t"); print fields[1], fields[2], count[key]}}' | grep -v 'LowGQXHetSNP' | sort > "$counts_file2"


# Condition 1: Entries matching in both files
awk 'NR==FNR{a[$1,$2]=$3; next} ($1,$2) in a {print $1, $2, a[$1,$2], $3}' "$counts_file2" "$counts_file1" > "$merged"

# Condition 2: Entries in file1 not found in file2
awk 'NR==FNR{a[$1,$2]=$3; next} !($1,$2) in a {print $1, $2, 0, $3}'  "$counts_file2" "$counts_file1" >> "$merged"

# Condition 3: Entries in file2 not found in file1
#awk 'NR==FNR{a[$1, $2]=$3; next} !($1, $2) in a {print $1, $2, $3, 0}' "$counts_file1" "$counts_file2" >> "$merged"


# Sort the output file
sort -o "$merged" "$merged"

echo "Comparison complete. Output saved to $new_dir"

# IMPORTANT: Replace `200` and `39` in the first awk command with your actual control and case totals.
# `200` = Total number of controls
# `39` = Total number of cases
awk '{print $1, $2, $3, $4, 200, 39}' "$merged" | awk '{print $1, $2, $3, $4, $5, $6, $5-$3, $6-$4}'> "$prepFisher"

echo "Processing complete. Output saved to $prepFisher"