# Tomato Fruit Ripening: RNA-seq Differential Expression Analysis

## What the project is

This project is a complete bioinformatics pipeline for differential gene expression analysis. It re-analyses an RNA-sequencing experiment to determine the regulatory impact of the _SlDof1_ transcription factor on tomato fruit ripening. The analysis is conducted entirely in R, utilizing the DESeq2 package to identify genes that significantly change activity levels when _SlDof1_ is reduced, alongside custom data wrangling and visualization using the tidyverse and ggplot2.

## The dataset and where it came from

The dataset consists of RNA-seq read counts from six tomato samples: three wild-type (WT) replicates and three _SlDof1_-RNAi knockdown replicates, all harvested at the breaker stage of ripening.

The raw data was provided by the original authors and downloaded from the NCBI Gene Expression Omnibus (GEO).

- **GEO Accession:** [GSE119493](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE119493 "null")
    
- **BioProject:** PRJNA489385
    

## How to run it

To reproduce this analysis locally, clone this repository and open the R project file (`Tomato-ripening-deseq2.Rproj`) in RStudio.

**1. Install required packages** Ensure you have the following packages installed in your R environment:

```
install.packages(c("tidyverse", "BiocManager", "pheatmap", "rmarkdown"))
BiocManager::install("DESeq2")
```

**2. Run the scripts in order**

- Execute `scripts/file-merge.R` (or your specific data prep script) to merge the raw individual sample files into a single `counts.txt` matrix.
    
- Execute `scripts/deseq2_analysis.R` to run the statistical pipeline and generate the data visualizations (PCA, MA, Volcano, and Heatmap) as well as the CSV results table.
    

**3. Knit the report** Open `Report.Rmd` in RStudio and click the **Knit** button to compile the final HTML report containing the methodology, figures, and session information.

## What the results show

The analysis successfully isolated 1,973 statistically significant differentially expressed genes between the wild-type and _SlDof1_-RNAi tomatoes. The Principal Component Analysis (PCA) confirms distinct biological separation between the two groups, supporting the experimental knockdown. Furthermore, filtering (adjusted p-value < 0.05 and absolute log2 fold change >= 1) highlights 651 genes that underwent massive shifts in expression, highlighting the original study's conclusion that _SlDof1_ is a critical regulatory component in the tomato ripening process.

## References

- **Original Study:** Wang, Y., Wang, P., Wang, W., Kong, L., Tian, S., & Qin, G. (2021). Genome-wide binding analysis of the tomato transcription factor SlDof1 reveals its regulatory impacts on fruit ripening. _Molecular Horticulture_, _1_(1), 9. https://doi.org/10.1186/s43897-021-00011-y
    
- **Dataset:** NCBI BioProject PRJNA489385 (GEO series GSE119493). RNA sequencing reveals the differentially expressed genes between wild-type and SlDof1-RNAi fruits (tomato).
    
- **Software Tools:** Love MI, Huber W, Anders S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. _Genome Biol_. 2014;15:550. doi: 10.1186/s13059-014-0550-8.
