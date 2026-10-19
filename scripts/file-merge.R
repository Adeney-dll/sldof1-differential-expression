# library(tidyverse)
# file_paths <- list.files("data/Gene-id", full.names = TRUE)
# data_list <- lapply(file_paths, function(file) {
#   data <- read.delim(file, header = FALSE)
#   colnames(data) <- c("gene", basename(file))
#   return(data)
# })
# count_matrix <- reduce(data_list, full_join, by = "gene")
# count_matrix <- column_to_rownames(count_matrix, var = "gene")
# write.table(count_matrix, "data/counts.txt", sep = "\t", quote = FALSE)
# 
# counts <- read.delim("data/counts.txt", row.names = 1)
# dim(counts)                  
# head(counts)
# colnames(counts)             
# summary(colSums(counts))     
# all(counts == round(counts))
# 
# read.delim(file_paths[1], header = FALSE, nrows = 5)

library(tidyverse)

file_paths <- list.files("data/Gene-id", full.names = TRUE)

data_list <- lapply(file_paths, function(file) {
  # Read the file and tell R that the first row contains column headers
  data <- read.delim(file, header = TRUE)
  
  # Keep only the gene_id and expected_count columns, discarding length and FPKM
  data <- data %>% select(gene_id, expected_count)
  
  # Rename the columns to 'gene' and the specific file name
  colnames(data) <- c("gene", basename(file))
  return(data)
})

# Merge the 6 tables and set the gene column as the structural row names
count_matrix <- reduce(data_list, full_join, by = "gene")
count_matrix <- column_to_rownames(count_matrix, var = "gene")

# Save the finished matrix
write.table(count_matrix, "data/counts.txt", sep = "\t", quote = FALSE)