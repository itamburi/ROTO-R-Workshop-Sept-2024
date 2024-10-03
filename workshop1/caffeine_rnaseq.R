
'''
Objective: The objective of this experiment is to investigate the effect of caffeine on gene expression, particularly focusing on genes related to caffeine metabolism and response. The study aims to identify differentially expressed genes (DEGs) between control samples (untreated) and caffeine-treated samples using bulk RNA-seq analysis.

Experimental Groups:
1. Control Group: Samples in this group are untreated (water only), receiving no caffeine.
2. Caffeine-Treated Group:Samples in this group are treated with 200mg of caffeine once in a 24hour time period. Here we measure changes in gene expression as a response to caffeine exposure.


Sample Details:
Control: 3 biological replicates (Sample1_Control, Sample2_Control, Sample3_Control)
Caffeine: 3 biological replicates (Sample1_Caffeine, Sample2_Caffeine, Sample3_Caffeine)
Gene Expression Data:
  
Bulk RNA-seq was performed to measure the transcriptome profile for each sample.
  
'''



#Install helpful packages
install.packages("tidyverse")
install.packages("tidyr") #auto-installed with tidyverse
install.packages("dplyr") #auto-installed with tidyverse
install.packages("ggplot2") #auto-installed with tidyverse
install.packages("ggrepel") 
install.packages("pheatmap") 

#Load the installed libraries
library(tidyverse)
library(tidyr) #auto-loaded with tidyverse
library(dplyr) #auto-loaded with tidyverse
library(ggplot2) #auto-loaded with tidyverse
library(ggrepel) #enhances ggplot2 functionality
library(pheatmap) #makes pretty heatmaps!



# Load the RNA-seq dataset: The dataset includes expression values for a variety of genes across both control and caffeine-treated groups. 

data <- read.csv("rna_seq_gene_expression_extended.csv")


### 1. Bar Plot

# Calculate mean expression for each gene and save those values to new columns
data_mean <- data %>%
  rowwise() %>%
  mutate(Control = mean(c(Sample1_Control, Sample2_Control, Sample3_Control)),
         Caffeine = mean(c(Sample1_Caffeine, Sample2_Caffeine, Sample3_Caffeine)))

#Check your understanding!
#What is the %>% operator doing?
#What do rowwise(), and mutate(), mean() have in common? HINT: what do the ( ) mean in R?
#What is the c(...,...,...) operation doing?
#What kind of data structure is data_mean vs data? Does it still have rows and columns? HINT: str()
#Try to verbally explain or write down in your own words what the code chunk is doing! 

# Convert to long format for plotting
data_long_bp1 <- data_mean %>%
  select(Gene, Control, Caffeine) %>%
  pivot_longer(cols = c(Control, Caffeine), names_to = "Condition", values_to = "Expression")

#Check your understanding!
#What kind of data structure is data_long?
#What is the select function doing?
#What did pivot_longer do? Try View(data_mean) and View(data_long)
#How many mean expression values correspond to each gene in data_mean? 

# Create the bar plot
ggplot(data_long_bp1, aes(x = Gene, y = Expression, fill = Condition)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(title = "Gene Expression Bar Plot", y = "Mean Expression", x = "Gene")

#Check your understanding!
#What does ggplot take as input?
#What arguments does aes() take?
#What changes should we make if we wanted a different title for the plot? What if we wanted to relabel the axes?

### 2. Box Plot

# Convert to long format for boxplot
data_long_bp2 <- data %>%
  pivot_longer(cols = starts_with("Sample"), names_to = "Sample", values_to = "Expression") %>%
  mutate(Condition = ifelse(grepl("Control", Sample), "Control", "Caffeine"))

#Earlier we used mutate, pivot_longer, and the %>% operator. Compare and contrast data_long_bp1 vs data_long_bp2.
#grepl has powerful functionality. What is it doing?

# Create the box plot
ggplot(data_long_bp2, aes(x = Condition, y = Expression, fill = Condition)) +
  geom_boxplot() +
  labs(title = "Gene Expression Box Plot", y = "Expression", x = "Condition")

#Check your understanding!
#Compare and contrast the arguments used to make bar plots and box plots.

### 3. Heatmap

# Prepare matrix for heatmap
expression_matrix <- as.matrix(data[, 2:7])  # Columns with expression data only
rownames(expression_matrix) <- data$Gene

# Create heatmap
pheatmap(expression_matrix, 
         cluster_rows = TRUE,
         cluster_cols = TRUE, 
         scale = "row",
         main = "Gene Expression Heatmap")
 
#Check your understanding!
#Is that comma a typo and what is that : doing there? data[, 2:7]
#How does the heatmap change if we set cluster_rows or cluster_cols to FALSE?
#How does the color bar legend change if we delete scale = "row",?


### 4. Violin Plot

ggplot(data_long_bp2, aes(x = Condition, y = Expression, fill = Condition)) +
  geom_violin(trim = FALSE) +
  labs(title = "Gene Expression Violin Plot", y = "Expression", x = "Condition")

#Check your understanding!
#Compare and contrast the arguments used to make bar, box, and violin plots.


### 5. Volcano Plot

# Perform t-test on the data to identify DEGs
t_test_results <- data %>%
  rowwise() %>%
  mutate(p_value = t.test(c(Sample1_Control, Sample2_Control, Sample3_Control), 
                          c(Sample1_Caffeine, Sample2_Caffeine, Sample3_Caffeine))$p.value,
         log2FC = log2(mean(c(Sample1_Caffeine, Sample2_Caffeine, Sample3_Caffeine)) /
                         mean(c(Sample1_Control, Sample2_Control, Sample3_Control))))

#Check your understanding!
#What is a p value?
#What is a log? 
#What is the purpose of the 2 in log2?
#What is $p.value doing outside the parentheses?


# Adjust p-values for multiple testing
t_test_results <- t_test_results %>%
  mutate(p_adj = p.adjust(p_value, method = "BH"))

#Check your understanding!
#Why might we need to adjust the p value? 

# Define thresholds
log2fc_threshold <- 1    # Threshold for log2 fold change
p_value_threshold <- 0.05 # Threshold for adjusted p-value

# Classify genes as upregulated, downregulated, or not significant
t_test_results <- t_test_results %>%
  mutate(Significance = case_when(
    p_adj < p_value_threshold & log2FC > log2fc_threshold ~ "Upregulated",
    p_adj < p_value_threshold & log2FC < -log2fc_threshold ~ "Downregulated",
    TRUE ~ "Not Significant"
  ))

# Create volcano plot with ggrepel to avoid overlapping labels
ggplot(t_test_results, aes(x = log2FC, y = -log10(p_adj))) +
  geom_point(aes(color = Significance), size = 2) +
  scale_color_manual(values = c("Upregulated" = "red", "Downregulated" = "blue", "Not Significant" = "grey")) +
  geom_hline(yintercept = -log10(p_value_threshold), linetype = "dashed", color = "black") +  # P-value threshold line
  geom_vline(xintercept = c(-log2fc_threshold, log2fc_threshold), linetype = "dashed", color = "black") +  # Fold change threshold lines
  geom_text_repel(data = subset(t_test_results, p_adj < p_value_threshold & abs(log2FC) > log2fc_threshold), 
                  aes(label = Gene), size = 3, box.padding = 0.5, point.padding = 0.2) +  # Use ggrepel to avoid label overlap
  labs(title = "Volcano Plot with Gene Labels", x = "Log2 Fold Change", y = "-Log10 Adjusted P-Value") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.margin = margin(10, 20, 10, 20),  # Increase plot margins
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 10)
  ) +
  coord_cartesian(clip = "off")  # Prevent clipping of text labels

#Check your understanding!
#How many different 'bins' or possibilities are there for genes to be categorized into by a volcano plot?
#Why might it be useful to plot things on a log axis?
#How might we make changes to colors, titles, superimposed horizontal/vertical lines? 