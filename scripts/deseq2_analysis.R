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

# Result image 2
png("figures/ma_plot.png", width = 1800, height = 1500, res = 300)
plotMA(res, ylim = c(-4, 4))
dev.off()

# Results 3 and 4
res_df <- as.data.frame(res) %>%
  rownames_to_column("gene") %>%
  filter(!is.na(padj)) %>%
  mutate(status = case_when(
    padj < 0.05 & log2FoldChange >=  1 ~ "Up in RNAi",
    padj < 0.05 & log2FoldChange <= -1 ~ "Down in RNAi",
    TRUE ~ "Not significant"))

volcano <- ggplot(res_df, aes(log2FoldChange, -log10(padj), colour = status)) +
  geom_point(alpha = 0.5, size = 1) +
  geom_vline(xintercept = c(-1, 1), linetype = "dashed") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed") +
  scale_colour_manual(values = c("Down in RNAi" = "#2166ac",
                                 "Not significant" = "grey70",
                                 "Up in RNAi" = "#b2182b")) +
  labs(x = "log2 fold change (RNAi vs WT)",
       y = "-log10 adjusted p-value", colour = NULL) +
  theme_bw()

volcano
ggsave("figures/volcano.png", volcano, width = 7, height = 5, dpi = 300)

write.csv(arrange(res_df, padj),
          "results/deseq2_results_RNAi_vs_WT.csv", row.names = FALSE)

# Result 5
library(pheatmap)
top_genes <- res_df %>% arrange(padj) %>% slice_head(n = 30) %>% pull(gene)
mat <- assay(vsd)[top_genes, ]
mat <- mat - rowMeans(mat)     # centre each gene so patterns stand out
pheatmap(mat, annotation_col = coldata["condition"],
         filename = "figures/heatmap_top30.png")