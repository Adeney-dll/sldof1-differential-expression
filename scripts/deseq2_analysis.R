library(tidyverse)
library(DESeq2)

# Load the matrix
counts <- read.delim("data/counts.txt", row.names = 1)

# Round the estimated counts into whole numbers for DESeq2
counts <- round(counts)   

# Define the sample groups, ensuring the order match
coldata <- data.frame(
  sample    = colnames(counts),
  condition = factor(c("RNAi", "RNAi", "RNAi", "WT", "WT", "WT"),
                     levels = c("WT", "RNAi"))
)
rownames(coldata) <- coldata$sample

# validation check MUST print TRUE in console
all(rownames(coldata) == colnames(counts))