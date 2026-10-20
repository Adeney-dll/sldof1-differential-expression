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

# In case any genes have no reads, this will change the 'NA' to 0 so to not break the deseq2 function
counts[is.na(counts)] <- 0

# 1. Combine your numbers and your map into one official DESeq2 object
dds <- DESeqDataSetFromMatrix(countData = counts,
                              colData   = coldata,
                              design    = ~ condition)

# 2. Filter out genes that are basically inactive (less than 10 reads)
keep <- rowSums(counts(dds) >= 10) >= 3
dds  <- dds[keep, ]

# 3. Run the core DESeq2 algorithm
dds <- DESeq(dds)

# 4. Extract the statistical results comparing RNAi to WT
res <- results(dds, contrast = c("condition", "RNAi", "WT"), alpha = 0.05)
summary(res)

# Result images 1
vsd <- vst(dds, blind = TRUE)
pca <- plotPCA(vsd, intgroup = "condition")
pca
ggsave("figures/pca.png", pca, width = 6, height = 5, dpi = 300)