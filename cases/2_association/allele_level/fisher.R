#Install and load the qqman package if not already installed
#install.packages("readr")

#clear the workspace if necessary
rm(list = ls())


library(readr)

setwd("/re_gecip/renal/rneatu/BurdenTests_FinalChapter/RuX_workflow_JS/2_associations/gene_level")



print('Rscript starts')

chr <- read.delim("prepFisher.txt", header = FALSE, sep=" ")

print('the table is in')

names(chr) <- c("chr","pos","cons","cases","total_cons","total_cases","diff_cons","diff_cases")

# Prepare an empty data frame for final results
final <- data.frame(matrix(ncol = 1, nrow = 0))
colnames(final) <- c("SNP", "P")

print('the variables have been assigned')
#####
for (i in 1:nrow(chr)) {
  
  row <- chr[i,]

  # Skip the row if any of the specified columns contain negative values
  if (any(row[c("cases", "cons", "diff_cases", "diff_cons")] < 0)) {
    next
  }
  
  row_select <- row[, c('cases', 'cons', 'diff_cases', 'diff_cons')]
  
  matrix <- matrix(unlist(row_select),nrow=2,ncol=2,byrow=TRUE)
  
  results <- fisher.test(matrix)
  p <- results$p.value
  
 # Create an SNP identifier from chr and pos
  snp_id <- paste(row$chr, row$pos, sep=":")
  
  # Append the SNP and p-value to the final data frame
  final <- rbind(final, data.frame(SNP = snp_id, P = p))
  
}
####

print('the loop ended')

write.csv(final, "p_values.csv", row.names = FALSE)

print('the table has been created')