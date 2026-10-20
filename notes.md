This project exists to expand my introduction to R programming.

A study carried out on tomatoes identified the `SlDof1` gene responsible for ripening. Researchers reduced the activity of the `SlDof1` transcription factor in tomato plants to investigate its biological function. They performed RNA sequencing to measure and compare gene expression between these modified plants and normal wild-type tomatoes.
- The comparison was conducted specifically at the breaker stage, which is the point when the fruit begins to ripen and change color.
    
- The study ultimately concluded that `SlDof1` is a necessary component for normal fruit ripening to occur. (Wang *et al*., 2021)
    <!--Wang, Y., Wang, P., Wang, W., Kong, L., Tian, S., & Qin, G. (2021). Genome-wide binding analysis of the tomato transcription factor SlDof1 reveals its regulatory impacts on fruit ripening. _Molecular Horticulture_, _1_(1), 9. https://doi.org/10.1186/s43897-021-00011-y--> 

---

This project re-analyses the published RNA-seq experiment focused on tomato fruit ripening.
- The original researchers reduced the activity of the `SlDof1` gene and compared those tomatoes to normal (wild-type) fruit at the breaker stage.
- Both the wild-type and the `SlDof1`-reduced groups have three biological replicates, with gene activity measured via RNA sequencing.
- The authors of the original study reported that the `SlDof1` gene is required for normal ripening.
- The role now is to process this gene activity data using the `DESeq2` package in R to conduct a differential expression analysis.
- This analysis will determine specifically which genes increase or decrease in activity when `SlDof1` is suppressed.

**Project Goals and Deliverables** 

- R scripts capable of reproducing every result from start to finish in a fresh R session.
    
- Four specific figures: a PCA plot, an MA plot, a volcano plot, and a heatmap of the top genes.
    
- A CSV results table listing every analyzed gene alongside its log2 fold change and its adjusted p-value.
    
- A short report written in R Markdown and knitted to HTML that explains process and findings.

---
#### Workflow
1. **Sequence retrieval on NCBI:** Accession number ==🔴GSE119493== 
    Page relating to the experiment was provided. On that page, the specific tags for wild type and modified samples were retrieved, as well as the raw supplementary file.
    |[GSM3375624](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM3375624)|WT_1|
    |[GSM3375625](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM3375625)|WT_2|
    |[GSM3375626](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM3375626)|WT_3|
    |[GSM3375627](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM3375627)|SlDof-8_1|
    |[GSM3375628](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM3375628)|SlDof-8_2|
    |[GSM3375629](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM3375629)|SlDof-8_3|
    3 Wild types [WT] and 3 modified samples. Extraction of the files yielded 6 individual datasets, as analysis was targeted towards one file, all six had to be merged. The merged file "count matrix" was used for subsequent analysis.

2. **Differential expression with DESeq2:** 