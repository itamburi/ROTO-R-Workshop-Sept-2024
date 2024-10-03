
# ROTO Coding Workshop
# Fall 2024
# 
# Session 3A - *** Data Visualization ***


#Install helpful packages
install.packages("tidyverse") #A meta-package that installs several data science packages
install.packages("tidyr") #Focused on reshaping and cleaning data
install.packages("dplyr") #For data manipulation (e.g., filtering, summarizing)
install.packages("ggplot2") #For data visualization (plots and graphs).
install.packages("ggrepel") #Adds non-overlapping text labels to ggplot2 plots
install.packages("pheatmap") #makes pretty heatmaps

#Load the installed libraries
library(tidyverse)
library(tidyr) 
library(dplyr) 
library(ggplot2) 
library(ggrepel) 
library(pheatmap) 




#### 1.0 - **** Caffeine Transcriptomic Study ****

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

getwd()
setwd( "/Volumes/GoogleDrive/My Drive/ROTO Summer Coding Workshop")

# Load the RNA-seq dataset: The dataset includes expression values for a variety of genes across both control and caffeine-treated groups. 

data <- read.csv("./data/caffeine study/rna_seq_gene_expression_extended.csv")


### 1. Bar Plot 

# A bar plot represents categorical data with rectangular bars, where the height (or length) reflects the value of each category

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
# A box plot displays the distribution of data based on the five-number summary (minimum, Q1, median, Q3, and maximum) and highlights outliers.

# Convert to long format for boxplot
data_long_bp2 <- data %>%
  pivot_longer(cols = starts_with("Sample"), names_to = "Sample", values_to = "Expression") %>%
  mutate(Condition = ifelse(grepl("Control", Sample), "Control", "Caffeine"))

#Earlier we used mutate, pivot_longer, and the %>% operator. Compare and contrast data_long_bp1 vs data_long_bp2.
#grepl has powerful functionality. What is it doing?

# Create the box plot
ggplot(data_long_bp2, aes(x = Condition, y = Expression, fill = Condition)) +
  geom_boxplot() + geom_jitter(width = .1)+
  labs(title = "Gene Expression Box Plot", y = "Expression", x = "Condition")

#Check your understanding!
#Compare and contrast the arguments used to make bar plots and box plots.

### 3. Heatmap

# A heatmap visualizes data in a matrix format, using color gradients to represent different values and reveal patterns or correlations

# Prepare matrix for heatmap
expression_matrix <- as.matrix(data[, 2:7])  # Columns with expression data only
rownames(expression_matrix) <- data$Gene

# Create heatmap
pheatmap(expression_matrix, 
         cluster_rows = TRUE,
         cluster_cols = TRUE, 
         scale = "row",
         main = "Gene Expression Heatmap",
         fontsize = 10,         # General font size
         fontsize_row = 6,      # Font size for row labels (genes)
         fontsize_col = 8)      # Font size for column labels (samples)

#Check your understanding!
#Is that comma a typo and what is that : doing there? data[, 2:7]
#How does the heatmap change if we set cluster_rows or cluster_cols to FALSE?
#How does the color bar legend change if we delete scale = "row",?


### 4. Violin Plot

# A violin plot combines a box plot with a density plot, showing both the summary statistics and the distribution shape of the data

ggplot(data_long_bp2, aes(x = Condition, y = Expression, fill = Condition)) +
  geom_violin(trim = FALSE) + 
  labs(title = "Gene Expression Violin Plot", y = "Expression", x = "Condition")

#Check your understanding!
#Compare and contrast the arguments used to make bar, box, and violin plots.


### 5. Volcano Plot

#A volcano plot is a scatter plot that displays the statistical significance (p-value) versus the magnitude of change (fold change) for each data point.

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




#### 2.0 - **** Youtube Statistics ****

getwd()
setwd( "/Volumes/GoogleDrive/My Drive/ROTO Summer Coding Workshop")


youtube = read.csv('data/youtube/Global YouTube Statistics.csv') # this time no fileEncoding argument bc it wasnt working with that call. Just a auirk of the data set!
head(youtube)
dim(youtube)
colnames(youtube)



#### 2.1 - **** ggplot() Practice - Plot Total Youtube views by Country ****

# First use group_by & summarise() to determine the total views in the last 30 days per country
views.by.country = youtube %>%
  group_by(Country) %>%
  summarise(
    total.views = sum(video_views_for_the_last_30_days)
  )

# Most basic bar plot of total views
ggplot(views.by.country, aes(x = Country, y = total.views)) +
  geom_bar(stat = "identity")
#... but we can't really ready the overlapping country names on the x axis




# So let's adjust the text angle with theme()
ggplot(views.by.country, aes(x = Country, y = total.views)) +
  geom_bar(stat = "identity") +
  theme(
    axis.text.x = element_text(angle = 90), 
  )
# Theme is a huge function for editing lots of ggplot2 aesthetics
# If you are ever trying to achieve a certain look in ggplot, google is your friend.
#      - for example, I just searched "ggplot make x axis labels vertical" and got this code!
# Usually someone online already has code for what look/theme parameters you are going for!


# We can really go all out on the theme parameters to change the look
ggplot(views.by.country, aes(x = Country, y = total.views)) +
  geom_bar(stat = "identity") +
  theme(
    axis.text.x = element_text(angle = 90), 
    # more theme parameters"
    panel.background = element_rect(fill = "white", colour = "black"), 
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )


# Now I'd like to reorder the countries by greatest to least
# We would use the reorder function to reorder the Country column

views.by.country$Country <- reorder(views.by.country$Country, -views.by.country$total.views) # -views.by.country tells reorder to do descending order, greatest to least views
# same code as before:
ggplot(views.by.country, aes(x = Country, y = total.views)) +
  geom_bar(stat = "identity") +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )
#... That looks nice!!




# We can also reorder within the ggplot aes() call for the x variable. It actually is a little bit easier to read this way!
ggplot(views.by.country, aes(x = reorder( Country, -total.views), y = total.views)) +
  geom_bar(stat = "identity") +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )



# Theres lots of ways to add labels and edit text in our plots
# labs() is the most straightforward.
ggplot(views.by.country, aes(x = reorder( Country, -total.views), y = total.views)) +
  geom_bar(stat = "identity") +
  # set x, y and title text with labs()
  labs(
    x = "Country", # x axis label
    y = "Total Views", # y axis label
    title = "Youtube views in last 30 days per country" # title
  ) +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )






# There are lots of ways to customize colors in ggplot. There are actually too many, its crazy
# Basically anything you can think of color-wise can somehow be achieved in ggplot if you're willing to work hard enough
# Here I want to just make a simple scheme where dark blue is the most # of views, and light blue is the least # of views

# need to tell ggplot to make the color scheme based off of fill with fill == total views
# also worth pointing out that the fill argument lives inside of the aes() parentheses

ggplot(views.by.country, aes(x = reorder( Country, -total.views), y = total.views, fill = total.views)) + 
  geom_bar(stat = "identity") +
  # function to assing our color scheme to total.views
  scale_fill_gradient(high = "darkblue", low = "lightblue") +
  labs(
    x = "Country", 
    y = "Total Views", 
    title = "Youtube Views by Country"
  ) +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )

# Looking good now!




# Last thing id like to do is remove the countries that have very few total views.
# I will arbitrarily filter for views > 100 million
views.by.country %>%
  filter(total.views >= 100000000) %>%
  ggplot(., aes(x = reorder( Country, -total.views), y = total.views, fill = total.views)) +
  geom_bar(stat = "identity") +
  scale_fill_gradient(high = "darkblue", low = "lightblue") +
  labs(
    x = "Country", # x axis label
    y = "Total Views", # y axis label
    title = "Countries with more than 100 million Youtube views" # title
  ) +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )


#### For fun, lets look at where we started again:

ggplot(views.by.country, aes(x = Country, y = total.views)) +
  geom_bar(stat = "identity")

### .... versus where we finished

views.by.country %>%
  filter(total.views >= 100000000) %>%
  ggplot(., aes(x = reorder( Country, -total.views), y = total.views, fill = total.views)) +
  geom_bar(stat = "identity") +
  scale_fill_gradient(high = "darkblue", low = "lightblue") +
  labs(
    x = "Country", # x axis label
    y = "Total Views", # y axis label
    title = "Countries with more than 100 million Youtube views" # title
  ) +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )


# I like this graph. Let's save it. ggsave() saves the current plot

ggsave("youtube views by country.jpg", width = 10, height = 8)




### **** Exercise - Plot the total views in the last 30 days by category

# first execute the following to make a data frame for our plot
views.by.category = youtube %>%
  group_by(category) %>%
  summarise(
    views = sum(video_views_for_the_last_30_days)
  )


plot.data = subset(views.by.category, views > 1000000)



# Now, fill in the missing parts of the following block of code to plot Category (x axis) against views(y axis)
ggplot(plot.data, aes(x = reorder(    ,    ), y =      , fill =     )) +
  geom_bar(stat = "identity") +
  scale_fill_gradient(    ) +
  labs(
    x = "",
    y = "",
    title = "",
  ) +
  theme(
    axis.text.x = element_text(angle = 90), 
    panel.background = element_rect(fill = "white", colour = "black"),
    panel.grid.major.y = element_line(colour = "grey"), 
    panel.grid.major.x = element_blank()
  )






# What would you like to plot! Try anything, instructors are happy to help!













