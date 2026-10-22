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