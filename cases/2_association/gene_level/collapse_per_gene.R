# Load necessary libraries (or install)

#clear workspace before running
rm(list = ls())

library(dplyr)



setwd("/re_gecip/renal/rneatu/BurdenTests_FinalChapter/RuX_workflow_JS/2_associations/gene_level/")

# Define file paths
#main_file_path <- "/re_gecip/renal/rneatu/BurdenTests_FinalChapter/RuX_workflow_JS/variant_counts_HIGH_RARE.txt"

main_file_path <- "/re_gecip/renal/rneatu/BurdenTests_FinalChapter/controls3_ca_germ_200/variant_counts_HIGH.txt"

ranges_file_path <- "/re_gecip/renal/rneatu/BurdenTests_FinalChapter/RuX_workflow_JS/2_associations/gene_level/ranges_cilia_genes.txt"

ranges_df <- read.delim(ranges_file_path, header = FALSE, sep = "\t", col.names = c("chr", "pos_start", "pos_end"))

# Read the main file
lines <- readLines(main_file_path)

# Initialize a counter for total sections with matches
total_sections_with_matches <- 0

# Initialize an empty data frame to store results
results_df <- data.frame(chr = character(),
                         pos_start = numeric(),
                         count = numeric(),
                         stringsAsFactors = FALSE)

#####################################################
# Loop through each row in the ranges data frame
for (i in 1:nrow(ranges_df)) {
  # Extract the current chromosome and position range
  chr_range <- ranges_df$chr[i]
  pos_start <- ranges_df$pos_start[i]
  pos_end <- ranges_df$pos_end[i]
  
  # Initialize a counter for matches
  match_count <- 0
  total_sections_with_matches <- 0  # Counter for sections with matches
  section_has_match <- FALSE  # Flag to check if the section has any matches
  
  # Inner loop to check lines starting with "chr"
  for (line in lines) {
    
    # Check for dashed lines indicating section breaks
    if (line == "----------") {
      # If the section has any matches, increment the total section count
      if (section_has_match) {
        total_sections_with_matches <- total_sections_with_matches + 1
      } 
      
      # Reset the flag for the next section
      section_has_match <- FALSE 
    }
    
    if (grepl("^chr", line)) {
      # Split the line into components
      parts <- unlist(strsplit(line, "[\t ]"))
      
      chr_line <- parts[1]
      pos_line <- as.numeric(parts[2])  # Convert position to numeric
      
      # Compare with the current range
      if (chr_line == chr_range && pos_line >= pos_start && pos_line <= pos_end) {
        # Increment the match counter
        match_count <- match_count + 1
        
        # Mark that this section has at least one match
        section_has_match <- TRUE

      }
    }
  }
  
  # After processing all lines, check for matches in the last section
  if (section_has_match) {
    total_sections_with_matches <- total_sections_with_matches + 1
  }
  
  # Store the results in the data frame
  results_df <- rbind(results_df, 
                      data.frame(chr = chr_range,
                                 pos_start = pos_start,
                                 count = total_sections_with_matches,
                                 stringsAsFactors = FALSE))
}

# Print the final results data frame
# print(results_df)

#write.table(results_df, file = "count_cases.txt", sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

write.table(results_df, file = "count_controls.txt", sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

