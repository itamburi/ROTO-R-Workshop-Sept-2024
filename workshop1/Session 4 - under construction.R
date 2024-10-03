# ROTO Coding Workshop
# Fall 2024
# Session 4 - *** ***


library(tidyverse) # this is a widely used library of functions for manipulating data frames
library(ggplot2) # this is a widely used library of functions developed to make graphs, plots and charts




#### 1.0 - **** Merging data frames ****

getwd()
setwd("")

# import the results we collected from our experiment
results = read.csv( 'data/pig experiment/exp_results.csv', fileEncoding = 'UTF-8-BOM')
# ROWS are compounds, COLUMNS are sample IDs. Values are concentrations from our experiment

metadata = read.csv( 'data/pig experiment/sample_metadata.csv', fileEncoding = 'UTF-8-BOM')
# ROWS are sample IDs, COLUMNS are parameters from our experiment.

compounds = read.csv( 'data/pig experiment/molecular_categories.csv', fileEncoding = 'UTF-8-BOM')
# ROWS are compounds, with one column for the category of that molecule

