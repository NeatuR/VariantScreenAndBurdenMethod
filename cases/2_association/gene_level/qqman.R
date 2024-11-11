# Install and load the required package
install.packages("qqman")
library(qqman)

# Step 1: Read the p_values.csv file
data <- read.csv("p_values.csv", header = FALSE)
colnames(data) <- c("SNP", "P")

# Step 2: Remove the 'chr' prefix and extract chromosome and position
# Convert X and Y to numbers (X -> 23, Y -> 24) and handle numeric chromosomes (1-22) as numbers
data$CHR <- sapply(sapply(strsplit(as.character(data$SNP), ":"), "[", 1), function(chr) {
  chr <- gsub("chr", "", chr)  # Remove the 'chr' prefix
  if (chr == "X") {
    return(23)  # Convert X to 23
  } else if (chr == "Y") {
    return(24)  # Convert Y to 24
  } else {
    return(as.numeric(chr))  # Convert numeric chromosomes to numbers
  }
})

data$BP <- as.numeric(sapply(strsplit(as.character(data$SNP), ":"), "[", 2))   # Extract position from SNP

# Step 3: Check the structure of your data
head(data)
# Example output:
#      SNP         P  CHR     BP
# 1  chr3:8984  0.0005  3  8984
# 2  chr1:12345 0.02   1  12345
# 3  chr2:67890 0.01   2  67890

# Step 4: Create the Manhattan plot
manhattan(data, 
          main = "Manhattan Plot",       # Title
          ylim = c(0, 10),               # Adjust y-axis range
          col = c("blue4", "orange3"),   # Alternate chromosome colours
          suggestiveline = -log10(1e-5), # Suggestive line (optional)
          genomewideline = -log10(5e-8)  # Genome-wide significance line (optional)
)